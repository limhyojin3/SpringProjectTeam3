package com.example.demo.admin.controller;

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

import com.example.demo.admin.dao.AdminService;
import com.example.demo.admin.dao.PaymentService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

//PaymentController.java
@Controller
public class PaymentController {

	@Autowired
	PaymentService paymentService;

	@RequestMapping("/payment.do")
	public String adminPass(Model model) throws Exception {
		return "admin/payment";
	}
	
//	@ResponseBody
//	@RequestMapping("/payment.do")
//	public String test(){
//	    return "ok";
//	}
//	
	@PostMapping("/verifyPayment.dox")
	@ResponseBody
	public HashMap<String, Object> verifyPayment(@RequestParam HashMap<String, Object> map) {

		int reviewCnt = Integer.parseInt((String) map.get("reviewCnt"));

		map.put("reviewCnt", reviewCnt);
		
		return paymentService.verifyPayment(map);
	}
}