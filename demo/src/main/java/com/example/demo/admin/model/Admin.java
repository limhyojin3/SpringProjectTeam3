package com.example.demo.admin.model;

import java.time.LocalDate;

import lombok.Data;

@Data
public class Admin {

	
	//결제목록
	String saleMonth;
	Long totalRevenue;
	int orderCount;
	
	//회원목록
	String userMonth;
	int userCount;
	
}
