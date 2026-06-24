package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ProductMapper;
import com.example.demo.company.model.Product;

@Service
public class ProductService {

	@Autowired
	private ProductMapper productMapper;

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			if (map.get("tags") != null && !map.get("tags").toString().trim().isEmpty()) {
				String tagsStr = map.get("tags").toString();
				tagsStr = tagsStr.replace("[", "").replace("]", "").replace("\"", "");
				
				if (!tagsStr.trim().isEmpty()) {
					String[] tagsArray = tagsStr.split(",");
					List<String> tagList = new java.util.ArrayList<>();
					for (String t : tagsArray) {
						if (!t.trim().isEmpty()) {
							tagList.add(t.trim());
						}
					}
					if (!tagList.isEmpty()) {
						map.put("tagList", tagList);
						map.put("tagSize", tagList.size());
					}
				}
			}

			// 💡 데이터 관로 체크: 프론트엔드에서 성실하게 쏴준 userid 파라미터가 map에 담겨 마이바티스로 직통 전달됩니다.
			List<Product> list = productMapper.selectProductList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Product info = productMapper.selectProduct(map);

			// 🎯 [신규 이식] 이 상품 고유의 태그 문자열("태그1,태그2")만 정밀 정제해서 전송 그릇에 적재
			List<String> currentProductTags = new java.util.ArrayList<>();
			if (info != null && info.getTag() != null && !info.getTag().trim().isEmpty()) {
				String[] tags = info.getTag().split(",");
				for (String t : tags) {
					currentProductTags.add(t.trim());
				}
			}
						
			resultMap.put("tagList", currentProductTags);
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) { 
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 🎯 [디버깅 고도화] 수정하기 비즈니스 로직 연쇄 매핑 관로 정비 완료
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> editProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 1. 기존 상품 기본 정보 업데이트 실행
			int result = productMapper.updateProduct(product);

			if (result > 0) {
				// 2. [수정 연동 핵심] 기존에 product_tag_map에 연결되어 있던 매핑 관계선을 깔끔하게 폭파 청소
				productMapper.deleteProductTagMap(product.getProductNo());
				
				// 3. 유저가 칩으로 새로 찍어 올린 태그 문자열 리스트가 존재한다면 다리 재정립 착수
				if (product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
					// 글자 리스트를 던져 마스터 테이블의 실제 등록된 ID 넘버링 수급
					List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
					
					if (tagIds != null && !tagIds.isEmpty()) {
						Map<String, Object> mapParam = new HashMap<String, Object>();
						mapParam.put("productNo", product.getProductNo());
						mapParam.put("tagIds", tagIds);
						
						// 매핑 다리 테이블에 최종 이식 배정
						productMapper.insertProductTagMap(mapParam);
					}
				}
				
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "변경 대상 상품이 존재하지 않습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 🎯 [디버깅 고도화] 등록하기 비즈니스 로직 연쇄 매핑 관로 정비 완료
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 1. 상품 기본 정보 인서트 집행 (성공 시useGeneratedKeys에 의해 product 객체 내부에 신규 productNo 자동 꽂힘)
			int result = productMapper.insertProduct(product);

			// 2. 인서트가 완벽히 성공했고, 유저가 찍은 태그 칩 문자열 리스트가 존재한다면 맵 매핑 구역 가동
			if (result > 0 && product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
				// 프론트에서 날아온 ["내추럴한", "러블리한"] 글자 주머니로 기존 마스터 태그 테이블의 진짜 ID 리스트([15, 16]) 수급
				List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
				
				if (tagIds != null && !tagIds.isEmpty()) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("productNo", product.getProductNo()); // 따끈따끈한 신규 생성 상품 PK 번호 매핑
					mapParam.put("tagIds", tagIds);
					
					// 3. 엉뚱한 마스터 인서트를 차단하고, 진짜 원하던 연결 테이블인 product_tag_map에 정석 배정 인서트!
					productMapper.insertProductTagMap(mapParam);
				}
			}

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_ADD);
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품 등록 처리에 실패했습니다.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> removeProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.deleteProduct(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getTagAndProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<String> taglist = productMapper.selectTagList(map);
			List<Product> productListForTag = productMapper.selectProductListForTag(map);

			resultMap.put("productListForTag", productListForTag);
			resultMap.put("taglist", taglist);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getTagList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<String> tagList = productMapper.selectTagList(map);

			resultMap.put("tagList", tagList);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 💡 탭 순서 꼬임 버그 개량: HashMap 대신 인서트 정렬 순서를 보장하는 LinkedHashMap 구조로 전면 교체 완료
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getCategoryTree() {
		LinkedHashMap<String, Object> categoryTree = new LinkedHashMap<String, Object>();
		try {
			List<HashMap<String, Object>> categories = productMapper.selectDistinctCategories();
			List<HashMap<String, Object>> tagsWithMedium = productMapper.selectAllTagsWithMedium();

			HashMap<String, List<String>> tagMapByMedium = new HashMap<String, List<String>>();
			for (HashMap<String, Object> row : tagsWithMedium) {
				String medium = (String) row.get("medium_category");
				String tag = (String) row.get("tag");
				if (medium != null && tag != null) {
					if (!tagMapByMedium.containsKey(medium)) {
						tagMapByMedium.put(medium, new java.util.ArrayList<String>());
					}
					tagMapByMedium.get(medium).add(tag);
				}
			}

			for (HashMap<String, Object> row : categories) {
				String large = (String) row.get("large_category");
				String medium = (String) row.get("medium_category");
				if (large == null || medium == null) continue;

				if (!categoryTree.containsKey(large)) {
					HashMap<String, Object> largeNode = new HashMap<String, Object>();
					largeNode.put("mediums", new java.util.ArrayList<String>());
					largeNode.put("tags", new HashMap<String, List<String>>());
					categoryTree.put(large, largeNode);
				}

				HashMap<String, Object> largeNode = (HashMap<String, Object>) categoryTree.get(large);
				List<String> mediumsList = (List<String>) largeNode.get("mediums");
				if (!mediumsList.contains(medium)) {
					mediumsList.add(medium);
				}

				HashMap<String, List<String>> tagsNode = (HashMap<String, List<String>>) largeNode.get("tags");
				List<String> tagsForThisMedium = tagMapByMedium.get(medium);
				if (tagsForThisMedium == null) {
					tagsForThisMedium = new java.util.ArrayList<String>();
				}
				tagsNode.put(medium, tagsForThisMedium);
			}
		} catch (Exception e) {
			System.out.println("동적 카테고리 트리 가공 예외 발생: " + e.getMessage());
		}
		return categoryTree;
	}
}