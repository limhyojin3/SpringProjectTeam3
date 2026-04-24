package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.admin.model.Admin;
import java.util.Map;

@Mapper
public interface AdminMapper {
	public List<Admin> selectSalesList(HashMap<String, Object> map);

	public List<Admin> selectClientsList(HashMap<String, Object> map);

	public List<Admin> selectReviewList(HashMap<String, Object> map);

	public List<Admin> selectReportList(HashMap<String, Object> map);
	
	public List<Admin> selectPassList(HashMap<String, Object> map);
	
	public Admin selectPassInfo(HashMap<String, Object> map);
	
	int selectPriceInfo(int passNo);    //결과가 행 전체가 아니라 Admin 아니고 int
	
	int insertPayment2(HashMap<String, Object> map);
	
	int insertPaymentPass(HashMap<String, Object> map);

	int insertPayment(Map<String, Object> map);
	
	public List<Admin> selectInquiryList(Map<String, Object> map);
	
	int checkAnswer(Map<String, Object> map);

	int insertAnswer(Map<String, Object> map);

	void updateAnswer(Map<String, Object> map);

	void updateInquiryStatus(Map<String, Object> map);

	// 관리자 전체 회원목록 페이지
	public List<Admin> selectUserList(HashMap<String, Object> map);
	
	// 관리자 전체 업체목록 페이지
	public List<Admin> selectCompanyList(HashMap<String, Object> map);
	
	// ====== 관리자 전체 회원/업체 정지/해제 기능 ======

	public int updateMemberStatus(HashMap<String, Object> map);

	// 정지 이력 추가
	public int insertBanHistory(HashMap<String, Object> map);
	
	// 정지 이력 조회
	public List<Admin> selectBanHistory(HashMap<String, Object> map);
	
}