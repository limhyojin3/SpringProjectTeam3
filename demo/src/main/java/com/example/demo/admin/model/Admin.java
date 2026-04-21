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

	// 결제목록
	String saleMonth;
	Long totalRevenue;
	int orderCount;

	// 회원목록
	String userMonth;
	int userCount;
	
	// 패스목록
	int passNo;
	String passName;
	int price;
	int reviewCnt;
	int isActive;
	
}
