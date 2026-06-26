package com.example.marryview.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.marryview.common.Message;
import com.example.marryview.company.mapper.ProductMapper;
import com.example.marryview.company.model.Product;

@Service
public class ProductCommandService {

	@Autowired
	private ProductMapper productMapper;

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> editProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.updateProduct(product);
			if (result > 0) {
				productMapper.deleteProductTagMap(product.getProductNo());
				if (product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
					List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
					if (tagIds != null && !tagIds.isEmpty()) {
						Map<String, Object> mapParam = new HashMap<String, Object>();
						mapParam.put("productNo", product.getProductNo());
						mapParam.put("tagIds", tagIds);
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

	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addProduct(Product product) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = productMapper.insertProduct(product);
			if (result > 0 && product.getUniqueNewTagsOnly() != null && !product.getUniqueNewTagsOnly().isEmpty()) {
				List<Integer> tagIds = productMapper.selectTagIdsByNames(product.getUniqueNewTagsOnly());
				if (tagIds != null && !tagIds.isEmpty()) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("productNo", product.getProductNo()); 
					mapParam.put("tagIds", tagIds);
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

	/* 💡 company_like 단선 제어 전용 실시간 하트 온오프 비즈니스 스위치 */
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> toggleCompanyLike(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = productMapper.checkCompanyLike(map);
			if (count > 0) {
				productMapper.deleteCompanyLike(map);
				resultMap.put("status", "unliked");
			} else {
				productMapper.insertCompanyLike(map);
				resultMap.put("status", "liked");
			}
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	/* 💡 [신규 개통] 2번 트랙: product_like 테이블 제어 전용 실시간 패키지 하트 독립 스위치 */
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> toggleProductLike(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = productMapper.checkProductLike(map);
			if (count > 0) {
				productMapper.deleteProductLike(map);
				resultMap.put("status", "unliked");
			} else {
				productMapper.insertProductLike(map);
				resultMap.put("status", "liked");
			}
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}