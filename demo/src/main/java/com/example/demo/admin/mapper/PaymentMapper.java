package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.admin.model.Admin;
import java.util.Map;

//PaymentMapper.java
@Mapper
public interface PaymentMapper {

	int insertPayment(HashMap<String, Object> map);

	int insertPaymentPass(HashMap<String, Object> map);
	
	//int insertPaymentReservation(HashMap<String, Object> map);
	
	int insertPaymentRegistration(HashMap<String, Object> map);
	
	int selectWalletCnt(HashMap<String, Object> map);
	
	int updateWalletCnt(HashMap<String, Object> map);
	
	int insertWalletCnt(HashMap<String, Object> map);
}