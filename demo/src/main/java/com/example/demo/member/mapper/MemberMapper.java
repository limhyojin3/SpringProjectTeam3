package com.example.demo.member.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.member.model.ChatLog;
import com.example.demo.member.model.Member;

@Mapper
public interface MemberMapper {
	// *일반 회원*
	// 회원 검색
	public Member selectMember(HashMap<String, Object> map);
	// 일반 회원 가입(member 삽입) 
	public int insertMember(HashMap<String, Object> map);
	// 일반 회원 상세정보(user detail) 삽입
	public int insertUserDetail(HashMap<String, Object> map);
	// 아이디 중복 체크
	int selectUserId(HashMap<String, Object> map);
	// 이메일 중복 체크
	int selectUserEmail(HashMap<String, Object> map);
	// 유저 상세 정보 조회 (내 정보 수정)
	Member selectMemberInfo(String userId);
	// 유저 내 정보 수정(멤버 테이블)
	public int updateMember(HashMap<String, Object> map);
	// 유저 내 정보 수정(유저 디테일 테이블)
	public int updateUserDetail(HashMap<String, Object> map);
	// 유저 탈퇴 (status 상태를 WITHDRAWN로 변경)
	public int updateUserStatus(HashMap<String, Object> map);
	// 유저 쿠폰 조회
	List<HashMap<String, Object>> selectUserCouponList(Map<String, Object> param);
	// 유저 쿠폰 개수
	int selectUserCouponCount(String userId);
	// 쿠폰 유효성 조회
	Map<String, Object> checkValidCoupon(HashMap<String, Object> map);
	// 쿠폰 중복 발급 조회
	int checkDuplicateCoupon(HashMap<String, Object> map);
	// 쿠폰 등록
	int insertUserCoupon(HashMap<String, Object> map);
	// 기프트콘 조회
	List<HashMap<String, Object>> selectUserGiftconList(String userId);
	int checkGiftconByReview(HashMap<String, Object> map);
	int insertGiftcon(HashMap<String, Object> map);
	// 열람권 잔여 횟수 조회
	Member selectPassWallet(String userId);
	// 멤버십 결제 내역 조회
	List<Member> selectPassWalletList(Map<String, Object> param);
	int selectPassWalletCount(String userId);
	// 내 예약 목록 조회
	List<Member> selectMyReservationList(Map<String, Object> param);
	// 내 예약 목록 갯수
	int selectMyReservationCount(String userId);
	// 유료 리뷰 조회
	List<Member> selectMyPaidReviewList(HashMap<String, Object> map);
	int selectMyPaidReviewCount(String userId);
	// 무료 리뷰 조회
	List<Member> selectMyFreeReviewList(HashMap<String, Object> map);
	int selectMyFreeReviewCount(String userId);
	// 내가 쓴 글 조회
	List<Member> selectMyPostList(HashMap<String, Object> map);
	int selectMyPostCount(String userId);
	// 내가 쓴 리뷰 조회
	List<Member> selectMyReviewList(HashMap<String, Object> map);
	int selectMyReviewCount(String userId);
	// 내가 쓴 댓글 조회
	List<Member> selectMyCommentList(HashMap<String, Object> map);
	int selectMyCommentCount(String userId);
	// 업체 좋아요 조회
	List<Member> selectMyCompanyLikeList(HashMap<String, Object> map);
	int selectMyCompanyLikeCount(String userId);
	// 글 좋아요 조회
	List<Member> selectMyPostLikeList(HashMap<String, Object> map);
	int selectMyPostLikeCount(String userId);
	// 리뷰 좋아요 조회
	List<Member> selectMyReviewLikeList(HashMap<String, Object> map);
	int selectMyReviewLikeCount(String userId);
	// 내가 쓴 글 삭제
	int deleteMyPost(HashMap<String, Object> map);
	// 내가 쓴 리뷰 삭제
	int deleteMyReview(HashMap<String, Object> map);
	// 내가 쓴 댓글 삭제
	int deleteMyComment(HashMap<String, Object> map);
	// 업체 좋아요 취소
	int deleteMyCompanyLike(HashMap<String, Object> map);
	// 글 좋아요 취소
	int deleteMyPostLike(HashMap<String, Object> map);
	// 리뷰 좋아요 취소
	int deleteMyReviewLike(HashMap<String, Object> map);
	// 내 문의 내역 조회
	List<Member> selectMyInquiryList(Map<String, Object> param);
	// 내 문의 내역 개수
	int selectMyInquiryCount(String userId);
	// 내 신고 내역 조회
	List<Member> selectMyReportList(Map<String, Object> param);
	// 내 신고 개수
	int selectMyReportCount(String userId);
	//결혼 기념일 확인
	String selectAnniversaryDate(String userId);
	int checkAnniversaryGiftcon(HashMap<String, Object> map);
			
	// * 유료리뷰 열람 시 *
	// 열람 기록 확인
	int selectUsageLog(HashMap<String, Object> map);
	// 열람권 차감
	int updateRemainingCount(String userId);
	// 열람 로그 INSERT
	int insertUsageLog(HashMap<String, Object> map);
	
	// *업체*
	// 업체 검색
	public String selectCompany(HashMap<String, Object> map);
	// 업체 회원 가입(member 삽입) 
	public int insertCompanyMember(HashMap<String, Object> map);
	// 업체 상세정보(company ) 삽입
	public int insertCompany(HashMap<String, Object> map);
	// 업체명 검색
	int selectComName(HashMap<String, Object> map);
	
	// *아이디/비밀번호 찾기*
	// 이름+번호 인증을 통해 해당 id가 있는 지 조회
	String findUserId(Map<String, Object> map);
	// 아이디+번호 인증을 통해 해당 pwd가 있는 지 조회
	int checkUserForPw(Map<String, Object> map);
	// 비밀 번호 업데이트
	int updatePassword(Map<String, Object> map);
	
	// *메인 홈 출력* 
	// 최근 리뷰 4개
	List<Member> selectMainReviewList(String userId);
	// 인기글 3개
	List<Member> selectMainPostList();
	
	// *챗봇 로그* 
	int insertChatLog(ChatLog chatLog);
	
	// 카카오 로그인
	Member selectMemberByKakaoId(String kakaoId);
	void insertKakaoMember(HashMap<String, Object> map);
	void insertKakaoMemberDetail(HashMap<String, Object> map);
	
}
