package com.example.demo.admin.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.admin.model.Admin;
import com.example.demo.admin.model.Payment;

import java.util.Map;

//PaymentMapper.java
@Mapper
public interface PaymentMapper {

	int insertPayment(HashMap<String, Object> map);

	int insertPaymentPass(HashMap<String, Object> map);
	
	//int insertPaymentReservation(HashMap<String, Object> map);
	HashMap<String, Object> selectRefundPassInfo(HashMap<String, Object> map);

	int minusWallet(HashMap<String,Object> map);

    int updateRefundPayment(HashMap<String, Object> map);

    int updateRefundPass(HashMap<String, Object> map);

	int updateReservationCancel(HashMap<String, Object> map);
	
	int insertPaymentRegistration(HashMap<String, Object> map);
	
	int selectWalletCnt(HashMap<String, Object> map);
	
	int updateWalletCnt(HashMap<String, Object> map);
	
	int insertWalletCnt(HashMap<String, Object> map);
	
	// 쿠폰 조회
	List<Payment> selectCouponUseList(HashMap<String, Object> map);
	int selectMyCouponCount(HashMap<String, Object> map);

	int updateExpiredCoupon(HashMap<String, Object> map);
	// 쿠폰 검증
	Payment selectCouponInfo(HashMap<String, Object> map);
	// 서버 가격 조회
	int selectPassPrice(int passNo);
	// 쿠폰 사용 수정
	int updateUsedCoupon(HashMap<String, Object> map);
	
	int selectCompanyInfo(HashMap<String, Object> map);
	
	//예약 환불 조회
	HashMap<String, Object> selectAdminReservation(HashMap<String, Object> map);
	int updateRefundReservation(HashMap<String, Object> map);
	int updateRefundReservation2(HashMap<String, Object> map);
}