package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.company.model.Company;
import com.example.demo.company.model.Review;

@Mapper
public interface CompanyMapper {
	/*
	 * // 여러개 리턴 -> selectXXXList public List<Company>
	 * selectUserList(HashMap<String, Object> map); // 한개 리턴 -> selectXXX public
	 * Company selectUser(HashMap<String, Object> map); // 삭제 public int
	 * deleteUser(HashMap<String, Object> map); // 수정 public int
	 * updateUser(HashMap<String, Object> map); // 삽입 public int
	 * insertUser(HashMap<String, Object> map);
	 */
	//updateProduct
	//selectCompanyByUserId
	
	//<select id="selectInquiryProductList" parameterType="map"
//	resultType="com.example.demo.company.model.Company">
	
	
	/* 내가 문의한 내역 불러오는 쿼리 */
	List<Company> selectMyInquiryList(HashMap<String, Object> map);
	
	/* inquiry_ans 가 1이상인 경우(수정하는 상황) answer를 업데이트만 하는경우 */
	int updateProductInquiryAnswer(HashMap<String, Object> map);
	
	/* 넘어온 inquiry_no = 6으로 문의 번호, 문의에 답변여부, 답변번호, 답변컨텐츠, 답변자명을 조회하기. */
	Company selectInquiryAnsYn(HashMap<String, Object> map);
	
	/* 문의에 답변하면 답변테이블에 insert 됨*/
	int insertProductInquiryAnswer(HashMap<String, Object> map);

	/* 답변했으니까 inquiry_ans 업데이트해준다 */
	int updateInquiryAnsStatus(HashMap<String, Object> map);
	
	List<Company> selectInquiryProductList(HashMap<String, Object> map);
	
	int insertInquiryProduct(HashMap<String, Object> map);
	
	int insertUniqueNewTagsOnly(Company product);
	
	int insertPaymentFinal(HashMap<String, Object> map);
	
	int updatePaymentFinal(HashMap<String, Object> map);
	
	//List<String> tagList = companyMapper.selectTagList(map);
	
	//<update id="checkOver30minute" parameterType="map">
	int checkOver30minute(HashMap<String, Object> map);
	
	List<Company> selectMyReservationList(HashMap<String, Object> map);
	
	int insertReservation(HashMap<String, Object> map);
	
	List<String> selectBookedTimes(HashMap<String, Object> map);
	
	String selectNewResCnt(HashMap<String, Object> map);
	
	List<Company> selectProductListForTag(HashMap<String, Object> map);
	
	List<String> selectTagList(HashMap<String, Object> map);
	
	List<Review> selectSimpleReviewDetails3(HashMap<String, Object> map);
	
	List<Review> selectReviewDetails3(HashMap<String, Object> map);
	
	Company selectNewSimpleReviewCnt(HashMap<String, Object> map);
	
	Company selectNewReviewCnt(HashMap<String, Object> map);
	
	List<Company> selectSimpleReviewCnt(HashMap<String, Object> map);
	
	List<Company> selectReviewCnt(HashMap<String, Object> map);
	
	List<Company> selectReservation(HashMap<String, Object> map);
	
	
	List<Review> selectPaidReviewList(HashMap<String, Object> map); //이부분 //#{companyNo}
	
	int deleteProduct(HashMap<String, Object> map);
	
	Company selectCompanyByUserId(String userId);
	
	int insertProduct(Company product);
	
	int updateProduct(Company product);
	
	Company selectProduct(HashMap<String, Object> map);
	
	Company selectCompany(HashMap<String, Object> map);

	public List<Company> selectProductList(HashMap<String, Object> map);
}