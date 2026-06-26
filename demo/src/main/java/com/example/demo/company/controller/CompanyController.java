package com.example.demo.company.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.company.dao.CompanyService;
import com.google.gson.Gson;

@Controller
public class CompanyController {

	@Autowired
	private CompanyService companyService;

	/* 업체 관리 마스터 페이지 이동 */
	@RequestMapping("/partnerManagement.do")
	public String partnerManagement(Model model) throws Exception {
		return "/company/partnerManagement";
	}
	
	/* 단건 업체 기본 프로필 및 회원 정보 조회 */
	@RequestMapping(value = "/company.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String company(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = companyService.getCompany(map);
		return new Gson().toJson(resultMap);
	}
}