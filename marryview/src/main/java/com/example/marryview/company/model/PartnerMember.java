package com.example.marryview.company.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class PartnerMember {
	
	private String userId;
	private String password;
	private String role; // NPARTNER, PARTNER 권한 제어 코어
	private String status;
	private String tel;
	private String regDate;
	private String lastLogin;
	private String previousPayment;
	private String outDate;
	
	// 회사 테이블 조인 데이터용 업체명 필드
	private String comName;
}