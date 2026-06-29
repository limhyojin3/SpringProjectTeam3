package com.example.marryview.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.marryview.admin.dao.AdminService;
import com.example.marryview.admin.dao.PaymentService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

//PaymentController.java
@Controller
public class PaymentController {

	@Autowired
	PaymentService paymentService;

	@RequestMapping("/history.do")
	public String history1(Model model) throws Exception {
		return "admin/history";
	}

	@RequestMapping("/payment.do")
	public String adminPass(Model model) throws Exception {
		return "admin/payment";
	}
	
	@PostMapping("/verifyPayment.dox")
	@ResponseBody
	public HashMap<String, Object> verifyPayment(@RequestParam HashMap<String, Object> map) {

		String type = String.valueOf(map.get("type"));
		
		int reviewCnt = 0;
		
		if("RES".equals(type)) {
	        Object obj = map.get("reviewCnt");
	        if(obj != null && !obj.toString().equals("")) {

		reviewCnt = Integer.parseInt((String) map.get("reviewCnt"));

		map.put("reviewCnt", reviewCnt);
	        }
		}
		return paymentService.verifyPayment(map);
	}
	@PostMapping("/verifyPayment2.dox")
	@ResponseBody
	public HashMap<String, Object> verifyPayment2(@RequestParam HashMap<String, Object> map) {

		String type = String.valueOf(map.get("type"));
		
		return paymentService.verifyPayment2(map);
	}
	
	@PostMapping("/verifyPayment3.dox")
	@ResponseBody
	public HashMap<String, Object> verifyPayment3(@RequestParam HashMap<String, Object> map) {
		
		return paymentService.verifyPayment3(map);
	}
	
	// 패스 환불
	@RequestMapping(value="/refundPass.dox", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String refundPass(@RequestParam HashMap<String, Object> map){

	    HashMap<String, Object> resultMap = paymentService.refundPass(map);

	    return new Gson().toJson(resultMap);
	}
	
	// 예약 환불
		@RequestMapping(value="/refundAdminReservation.dox", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
		@ResponseBody
		public String refundAdminReservation(@RequestParam HashMap<String, Object> map){

		    HashMap<String, Object> resultMap = paymentService.refundAdminReservation(map);

		    return new Gson().toJson(resultMap);
		}
	
	// 쿠폰 조회
	@RequestMapping(value="/couponUseList.dox", method=RequestMethod.POST)
	@ResponseBody
	public String couponUseList(@RequestParam HashMap<String,Object> map){
		map.put("pageSize", Integer.parseInt(map.get("pageSize").toString()));
		map.put("offSet", Integer.parseInt(map.get("offSet").toString()));
	    return new Gson().toJson(paymentService.getCouponUseList(map));
	}
	
	
}