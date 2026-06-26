package com.example.marryview.company.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.marryview.company.dao.ReservationService;
import com.google.gson.Gson;

@Controller
public class ReservationController {

	@Autowired
	private ReservationService reservationService;

	/* 파트너 업체용 수신 예약 리스트 로드 */
	@RequestMapping(value = "/ReservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ReservationList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reservationService.getReservation(map);
		
		// 🎯 [이 구역 기존 return문 삭제 후 딱 2줄로 교체] 날짜 포맷(yyyy-MM-dd HH:mm)이 강제 지정된 빌더 가동
		Gson gson = new com.google.gson.GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").create();
		return gson.toJson(resultMap);
	}
	
	/* 특정 날짜에 선점 완료된 시간대 체크 */
	@RequestMapping(value = "/getBookedTimes.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBookedTimes(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reservationService.getBookedTimes(map);
		return new Gson().toJson(resultMap);
	}
	 
	/* 일반 고객의 신규 예약 신청 데이터 인서트 */
	@RequestMapping(value = "/addReservation.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addReservation(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reservationService.addReservation(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 소비자 본인의 예약 내역 히스토리 리스트 로드 */
	@RequestMapping(value = "/getMyReservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMyReservationList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reservationService.getMyReservationList(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 결제 모듈 콜백 성공에 따른 영수증 발행 및 예약 확정 트랜잭션 */
	@RequestMapping(value = "/addAndEditPaymentFinal.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addAndEditPaymentFinal(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = reservationService.addAndEditPaymentFinal(map);
		return new Gson().toJson(resultMap);
	}
}