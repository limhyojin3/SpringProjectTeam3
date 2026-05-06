package com.example.demo.admin.model;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Payment {
	
	String userId;
	
	// 쿠폰
	String couponCode;
	String couponName;
	int discountRate;
	String issuedAt;
	Timestamp expiredAt;
	String dday;
	String status;
	
	Integer passNo;
	
	String registrationFee;
}
