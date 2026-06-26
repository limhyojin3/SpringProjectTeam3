package com.example.demo.company.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.company.dao.PartnerReviewService;
import com.google.gson.Gson;

@Controller
public class PartnerReviewController {

	@Autowired
	private PartnerReviewService partnerReviewService;

	/* 일반 결제 기반 리뷰 통계 및 카운트 조회 */
	@RequestMapping(value = "/getReviewCnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewCnt(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = partnerReviewService.getReviewCnt(map);
		return new Gson().toJson(resultMap);
	}
	
	/* 간이 결제 기반 리뷰 통계 및 카운트 조회 */
	@RequestMapping(value = "/getSimpleReviewCnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getSimpleReviewCnt(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = partnerReviewService.getSimpleReviewCnt(map);
		return new Gson().toJson(resultMap);
	}
		
	/* 일반 결제 리뷰 상세 내역 리스트 조회 */
	@RequestMapping(value = "/ReviewDetails3.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String ReviewDetails3(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = partnerReviewService.getReviewDetails3(map);
		return new Gson().toJson(resultMap);
	}

	/* 간이 결제 리뷰 상세 내역 리스트 조회 */
	@RequestMapping(value = "/SimpleReviewDetails3.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String SimpleReviewDetails3(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = partnerReviewService.getSimpleReviewDetails3(map);
		return new Gson().toJson(resultMap);
	}
}