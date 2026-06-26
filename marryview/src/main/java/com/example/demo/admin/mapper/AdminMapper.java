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

	public int selectAllClientsCount(HashMap<String, Object> map);

	public int selectAllPartnersCount(HashMap<String, Object> map);

	public List<Admin> selectReviewList(HashMap<String, Object> map);

	public HashMap<String, Object> selectReceiptReviewDetail(HashMap<String, Object> map);

	public int updateReviewApprove(HashMap<String, Object> map);

	public int updateReviewReject(HashMap<String, Object> map);

	public List<Admin> selectBoardList(HashMap<String, Object> map);

	public int updateBoardApprove(HashMap<String, Object> map);

	public Admin selectPostDetail(HashMap<String, Object> map);

	// 신고 게시판 검색어 필터
	public List<Admin> selectReportList(HashMap<String, Object> map);

	// 페이지네이션
	int selectReportCount(HashMap<String, Object> map);

	int selectReviewCount(HashMap<String, Object> map);

	int selectUserCount(HashMap<String, Object> map);

	int selectCompanyCount(HashMap<String, Object> map);

	int selectBoardCount(HashMap<String, Object> map);

	public List<Admin> selectPassList(HashMap<String, Object> map);

	public Admin selectPassInfo(HashMap<String, Object> map);

	Integer selectPriceInfo(int passNo); // 결과가 행 전체가 아니라 Admin 아니고 int

	int insertPayment2(HashMap<String, Object> map);

	int insertPayment1(Map<String, Object> map);

	public List<Admin> selectInquiryList(HashMap<String, Object> map);

	int selectInquiryCount(HashMap<String, Object> map);

	int checkAnswer(HashMap<String, Object> map);

	int insertAnswer(HashMap<String, Object> map);

	int updateAnswer(HashMap<String, Object> map);

	void updateInquiryStatus(HashMap<String, Object> map);

	// 관리자 전체 회원목록 페이지
	public List<Admin> selectUserList(HashMap<String, Object> map);

	// 회원 상세조회
	public Admin selectUserDetail(HashMap<String, Object> map);

	// 회원 상세조회 신고이력
	public List<Admin> selectReportInfoList(HashMap<String, Object> map);

	// 관리자 전체 업체목록 페이지
	public List<Admin> selectCompanyList(HashMap<String, Object> map);

	// 업체 상세조회
	public Admin selectCompanyDetail(HashMap<String, Object> map);

	// ====== 관리자 전체 회원/업체 정지/해제 기능 ======

	public int updateMemberStatus(HashMap<String, Object> map);

	// 정지 이력 추가
	public int insertBanHistory(HashMap<String, Object> map);

	// 정지 이력 조회
	public List<Admin> selectBanHistory(HashMap<String, Object> map);

	// 일괄 신고
	public void batchApproveReport(HashMap<String, Object> map);

	public void batchReject(HashMap<String, Object> map);

	// 단일 신고
	public int updateReportApprove(HashMap<String, Object> map);

	// 신고 상세 조회
	public Admin selectReportDetail(HashMap<String, Object> map);

	// 신고 반려
	public int updateReportReject(HashMap<String, Object> map);

	// 신고자 알림 전송 성공 처리
	int updateReportAnswerStatus(HashMap<String, Object> map);
	
	// 신고 누적 횟수
	public int selectReportHistory(HashMap<String, Object> map);

	// 전체 회원 신고 3회이상 검색
	public List<Admin> selectKillHistory(HashMap<String, Object> map);

	// 댓글로 게시판 추적
	Integer selectCommentPostNo(HashMap<String, Object> map);

	Integer selectComentReviewNo(HashMap<String, Object> map);

	Integer selectParentCommentPostNo(HashMap<String, Object> map);

	// 결제 관리
	public List<Admin> selectPaymentList(HashMap<String, Object> map);

	public List<Admin> selectPassPaymentList(HashMap<String, Object> map);

	public List<Admin> selectReservationPaymentList(HashMap<String, Object> map);

	public List<Admin> selectRegistrationPaymentList(HashMap<String, Object> map);

	int selectPaymentCount(HashMap<String, Object> map);

	int selectPassPaymentCount(HashMap<String, Object> map);

	int selectReservationPaymentCount(HashMap<String, Object> map);

	int selectRegistrationPaymentCount(HashMap<String, Object> map);

// 상품관리
	// 상품
	public List<Admin> selectAdminProductList(HashMap<String, Object> map);

	int selectAdminProductCount(HashMap<String, Object> map);

	// 상품 상태 변경
	int updateProductStatus(HashMap<String, Object> map);

	// 상품 삭제
	int deleteProduct(HashMap<String, Object> map);

	// 상품 상세
	Admin selectProductInfo(HashMap<String, Object> map);

	// 쿠폰
	public List<Admin> selectCouponList(HashMap<String, Object> map);

	int selectCouponCount(HashMap<String, Object> map);

	// 쿠폰 등록
	int insertCoupon(HashMap<String, Object> map);

	// 쿠폰 삭제
	int deleteCoupon(HashMap<String, Object> map);

	// 패스
	public List<Admin> selectAllPassList(HashMap<String, Object> map);

	int selectPassCount(HashMap<String, Object> map);

	// 패스 상태변경
	int updatePassStatus(HashMap<String, Object> map);

	// 패스 등록
	int insertPass(HashMap<String, Object> map);

	// 패스 삭제
	int deletePass(HashMap<String, Object> map);

	// 결제완료페이지에서 조회
	HashMap<String, Object> selectPaymentByPayNo(int payNo);

	HashMap<String, Object> selectPassPayment(HashMap<String, Object> map);

	HashMap<String, Object> selectReservationPayment(HashMap<String, Object> map);

	HashMap<String, Object> selectRegistrationPayment(HashMap<String, Object> map);

	// 마이 패스 페이지
	List<Admin> selectMyPassList(HashMap<String, Object> map);

	int selectMyPassCount(HashMap<String, Object> map);

	Integer selectMyWallet(HashMap<String, Object> map);

	// 제휴 등록
	int updateCompanyReg(HashMap<String, Object> map);

	int updateCompanyRegPaid(HashMap<String, Object> map);
}