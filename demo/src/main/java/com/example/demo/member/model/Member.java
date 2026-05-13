package com.example.demo.member.model;

import lombok.Data;

@Data // getter, setter method
public class Member {
	//컬럼명이랑 같기만 하면 됨(대소문자 구분x)
	//User model이 있는데 브랜치랑 controller~xml을 member로 만들어서 member model을 생성했어요.
	//이걸로 작업할 생각합니다.
	
	// member table에 있는 컬럼들 입니다.
	String userId; //로그인 아이디
	String password; //비밀번호
	String role; // 권한
	String status; // 상태
	String tel; //전화번호(일반회원,업체 둘다)
	String regDate; //가입 일시
	String lastLogin; //마지막 로그인 시간
	String previousPayment; //마지막 결제 수단
	//
	// user_detail table에 있는 컬럼들 입니다.
	String name; //이름 
	String nickname; //닉네임
	String gender; //성별
	String email; //이메일 주소
	String weddingDate; //결혼 예정일
	String anniversaryDate ; //결혼 기념일
	String maritalStatus; // 미혼/기혼 구분
	//
	//user_pass_wallet table에 있는 컬럼들 입니다.
	int remainingCount;
	int totalPurchased;
	long passNo;
	// Pass_Usage_Log table에 있는 컬럼들 입니다.
	String reviewNo;
	String usedAt;
	// Pass_product table에 있는 컬럼들 입니다.
	String passName;
	// payment_pass table에 있는 컬럼들 입니다.
	String itemName;
	// payment table에 있는 컬럼들 입니다.
	String payDate;
	String payStatus;
	//  Reservation table에 있는 컬럼들 입니다.
	String resNo;
	String resDate;
	String resTime;
	String resStatus;
	//  product table에 있는 컬럼들 입니다.
	String productName;
	long originalPrice;
	// Review table에 있는 컬럼들 입니다.
	String title;
	double rating;
	int isPaid;
	String imgUrl;
	String thumbnailUrl;
	String approvalStatus;
	//
	int isPurchased; // 추가
	
	// Community_Post table에 있는 컬럼들 입니다.
	String postNo;
	String category;
	int viewCnt;
	int likeCnt;
	// Comment table에 있는 컬럼들 입니다.
	String commentNo;
	String content;
	// like table에 있는 컬럼들 입니다.
	String likeNo; // 세 테이블 다 있음
	String companyNo; // company_like에만 있음
	
	// company table에 있는 컬럼입니다.
	String comName;
	String comType; 
	//
}
