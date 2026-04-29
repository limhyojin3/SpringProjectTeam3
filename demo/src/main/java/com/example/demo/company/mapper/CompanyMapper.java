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
	
	//int result = companyMapper.deleteProduct(map);
	//selectSimpleReviewCnt
	
	//selectNewReviewCnt
	
	//<insert id="insertPaymentFinal" parameterType="map">
//	<update id="updatePaymentFinal" parameterType="map">
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