package com.example.marryview.admin.model;

import java.time.LocalDate;

import lombok.Data;

@Data
public class Admin {
	
	// 게시글목록
	int postNo;
	String category;
	int viewCnt;
	int likeCnt;
	int isDeleted;
	int commentCnt;
	
	// 리뷰목록
	int reviewNo;
	String userId;
	String approvalStatus;
	boolean isPaid;
	String title;
	String content;
	String regDate;
	String postDay;
	int reviewWait;

	// 신고목록
	int reportNo;
	String reporterId;
	String targetType;
	String uniTargetId;
	String reportTitle;
	String reportContent;
	int answerStatus;
	int actionStatus;
	String reg_date;
	String reportDay;
	int reportWait;
	int reportCount;
	String targetUserId; 			//신고테이블. 회원 상세 신고 이력
	String rejectReason;
	int killCount;
	
	// 문의목록
	int inquiryNo; 			//문의 번호
	String answerContent;
	String inquiryType;
	
	// 결제목록
	String saleMonth;
	Long totalRevenue;
	int orderCount;
	int amount;           	//결제 금액
	String status;			//결제 상태
	int payNo;
	String payStatus;
	String payDate;
	int productNo;
	String productName;
	int originalPrice;

	String couponCode;
	String couponName;
	int discountRate;

	int resNo;
	String refund;
	String refundDate;

	int companyNo;
	//환불
	String impUid;
	int chargeCount;
	
	//예약
	String useDate;

	// 회원목록
	String userMonth;
	int userCount;
	String userName;		
	String nickName;
	String userEmail;
	String name;            // 전체 회원목록. 멤버테이블 컬럼명
	String role;
	String tel;
	String lastLogin;
	String weddingDate;
	String gender;
	int count;						//전체 회원목록 페이지 + 신고수  member, user_detail테이블 조인
	String maritalStatus;
	String anniversaryDate;
	
	// 업체 목록
	String companyName;
	String companyEmail;
	String comType;
	String comTel;
	String comAddress;
	String memberStatus;
	String companyStatus;
	String grade;			// 제휴업체인지 일반업체인지 나눔
	String ceoName;
	String bizNo;
	String registrationFee;
	String comName;
	String resStatus;
	String comIntro;
	String comEmail;
	
	// 상품 목록
//	int productNo;
//	int companyNo;
//	String productName;
	String productDetails;
//	int originalPrice;
	String isActive;
	String imgUrl;
	String proType;
	String tag;
	int deposit;
	String largeCategory;
	String mediumCategory;

	// 쿠폰
//	String couponCode;
//	String couponName;
//	int discountRate;
	String issueType;
	int maxIssueCnt;
	int remainingCount;  //패스 지갑에 남은 열람권 횟수
	String giftconImage;
	String couponType;
	
	// 패스

	// 패스목록
	int passNo;
	String passName;
	int price;
	int reviewCnt;
	int soldCount; // 정상 결제된 패스 판매 건수
//	int isActive;
	String description;
	String itemName;
	
	// ===== 정지/해제 관련 =====
	String targetId;     // user_id or company_id
	String actionType;   // BAN / UNBAN
	String reason;       // 정지 사유
	String adminId;      // 관리자 아이디
	String banRegDate;   // 이력 날짜

	// 리뷰 참여 분석 통계
	int reviewUserCount;              // 일반 회원 수
	int reviewWriterCount;            // 리뷰 작성 회원 수
	int noReviewUserCount;            // 리뷰 미작성 회원 수
	double reviewParticipationRate;   // 리뷰 작성 참여율

	int internalReviewCount;          // 내부업체 리뷰 수
	int externalReviewCount;          // 외부업체 리뷰 수
	double externalReviewRate;        // 외부업체 리뷰 비율
	
}
