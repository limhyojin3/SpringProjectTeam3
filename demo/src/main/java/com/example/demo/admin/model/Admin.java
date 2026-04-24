package com.example.demo.admin.model;

import java.time.LocalDate;

import lombok.Data;

@Data
public class Admin {

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

	// 문의목록
	int inquiryNo; 			//문의 번호
	
	// 결제목록
	String saleMonth;
	Long totalRevenue;
	int orderCount;
	int amount;           	//결제 금액
	String status;			//결제 상태

	// 회원목록
	String userMonth;
	int userCount;
	String userName;		
	String userEmail;
	String name;            // 전체 회원목록. 멤버테이블 컬럼명
	String role;
	
	// 업체 목록
	String companyName;
	String companyEmail;
	String memberStatus;
	String companyStatus;
	String grade;			// 제휴업체인지 일반업체인지 나눔
	
	// 패스목록
	int passNo;
	String passName;
	int price;
	int reviewCnt;
	int isActive;
	
	// ===== 정지/해제 관련 =====
	String targetId;     // user_id or company_id
	String actionType;   // BAN / UNBAN
	String reason;       // 정지 사유
	String adminId;      // 관리자 아이디
	String banRegDate;   // 이력 날짜
	String ceoName;
	String bizName;

}
