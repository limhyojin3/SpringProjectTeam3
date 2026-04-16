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
	String tel; //전화번호
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
	//
	// company table에 있는 컬럼입니다.
	String comName;
	//
}
