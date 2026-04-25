package com.example.demo.company.model;

import lombok.Data;

@Data
public class Company {
	String companyNo;
	String userId;
	String comName;
	String comType;
	String comIntro;
	String comAddress;
	String Status;
	String bizNo;
	String ceoName;
	String comTel;
	String registrationFee;


	String comEmail;
	String usePeriod;
	String grade;
	String lastPayment;
	
	String productNo;
	String productName;
	String productDetails;
	String originalPrice;
	String isActive;
	String imgUrl;
	String proType;
	String tag;
	
	String resNo;
	String resDate;
	String resTime;
	String resStatus;
	String resContent;
	String useDate;
	String useTime;
	String deposit;
	
	String resUserId;  //실제 예약한 유저의 아이디
	String tel;
	String newResCnt;
	
   
  // 통계용 필드 (DB 테이블엔 없지만 화면에 뿌릴 때 필요)
  private Double avgRating;
  private Integer reviewCount;
}
