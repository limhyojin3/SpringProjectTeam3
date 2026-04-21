package com.example.demo.company.model;

import lombok.Data;


//@Data => get set메소드가 포함된거임(lombok)
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
}
