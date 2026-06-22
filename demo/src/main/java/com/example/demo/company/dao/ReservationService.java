package com.example.demo.company.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.company.mapper.ReservationMapper;
import com.example.demo.company.model.Reservation;

@Service
public class ReservationService {

	@Autowired
	private ReservationMapper reservationMapper;

	public HashMap<String, Object> getReservation(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Reservation> list = reservationMapper.selectReservation(map);
			String newResCnt = reservationMapper.selectNewResCnt(map);
			
			/* resNoList(예약내역리스트 중에 resNo 리스트)를 가져온다. (업체유저가 로그인했을때) */
			List<Integer> resNoList = reservationMapper.selectResNoListForCompanyUser(map);
			
			/* DB에서 가져온 리스트를 map에 담는다. */
			map.put("resNoList", resNoList);
			
			/* 업체 입장에서 예약내역 리스트로 갈때 예약상태를 업데이트 해보자. DONE 또는 CANCEL이 보이도록 */
			if (resNoList != null && !resNoList.isEmpty()) {
				reservationMapper.updateReservationStatusForCompany(map);
			}
			resultMap.put("resNoList", resNoList);
			resultMap.put("newResCnt", newResCnt);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getBookedTimes(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<String> list = reservationMapper.selectBookedTimes(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> addReservation(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = reservationMapper.insertReservation(map);
			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	public HashMap<String, Object> getMyReservationList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			/* 기존 비즈니스 로직 주석 조건 그대로 유지 */
			// int result30 = reservationMapper.checkOver30minute(map);

			List<Reservation> list = reservationMapper.selectMyReservationList(map);
			
			/* resNoList를 가져온다. Integer타입으로 이루어진 리스트 */
			List<Integer> resNoList = reservationMapper.selectResNoList(map);
			map.put("resNoList", resNoList);

			/* 나의 예약내역리스트로 갈때 내 예약상태를 업데이트한다. DONE 또는 CANCEL이 보이도록 */
			if (resNoList != null && !resNoList.isEmpty()) {
				reservationMapper.updateReservationStatus(map);	
			}
			resultMap.put("resNoList", resNoList);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addAndEditPaymentFinal(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String impUid = map.get("imp_uid").toString();
			String merchantUid = map.get("merchant_uid").toString();
			map.put("impUid", impUid);
			map.put("merchantUid", merchantUid);
			
			int result1 = reservationMapper.insertPaymentFinal(map);
			int result2 = reservationMapper.updatePaymentFinal(map);

			if (result1 > 0 && result2 > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", Message.MSG_REMOVE);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}