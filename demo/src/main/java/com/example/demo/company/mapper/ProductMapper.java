package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import com.example.demo.company.model.Product;

@Mapper
public interface ProductMapper {

	// 1. 카테고리/태그 동적 다중 필터링 상품 리스트 조회
	List<Product> selectProductList(HashMap<String, Object> map);

	// 2. 상품 단건 상세 정보 조회
	Product selectProduct(HashMap<String, Object> map);

	// 3. 기등록 상품 정보 수정 업데이트
	int updateProduct(Product product);

	// 4. 신규 상품 최초 등록 인서트
	int insertProduct(Product product);

	// 5. 상품 정보 삭제
	int deleteProduct(HashMap<String, Object> map);

	// 6. 순수 태그 마스터 리스트 조회
	List<String> selectTagList(HashMap<String, Object> map);

	// 7. 특정 카테고리 상품 추출 (기본 호환용)
	List<Product> selectProductListForTag(HashMap<String, Object> map);

	// 8. 신규 고유 태그 데이터 추가
	int insertUniqueNewTagsOnly(Map<String, Object> tagParamMap);

	// 9. 동적 트리를 구축하기 위한 실제 등록된 대/중분류 카테고리 추출 단자
	List<HashMap<String, Object>> selectDistinctCategories();

	// 10. 동적 트리를 구축하기 위한 테이블의 전체 태그-중분류 사전 추출 단자
	List<HashMap<String, Object>> selectAllTagsWithMedium();
	
	// 11. 선택된 태그 글자들로 마스터 테이블의 진짜 고유 ID 리스트를 추출하는 단자
	List<Integer> selectTagIdsByNames(List<String> tagNames);

	// 12. 추출된 태그 ID들과 신규 상품 번호를 product_tag_map 테이블에 적재하는 단자
	int insertProductTagMap(Map<String, Object> map);

	// 13. 상품 수정 시 기존에 맵 테이블에 연결되어 있던 구형 다리들을 끊어내는 단자
	int deleteProductTagMap(Long productNo);

	// 💡 [신규 추가] 특정 업체의 좋아요 상태를 확인하는 단자
	int checkCompanyLike(HashMap<String, Object> map);

	// 💡 [신규 추가] 특정 업체의 좋아요(찜)를 추가하는 단자
	int insertCompanyLike(HashMap<String, Object> map);

	// 💡 [신규 추가] 특정 업체의 좋아요(찜)를 취소하는 단자
	int deleteCompanyLike(HashMap<String, Object> map);
}