package com.example.marryview.company.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.marryview.company.dao.CompanyService;
import com.example.marryview.company.model.Company;
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

	/* 🎯 [신규 추가] 마운트 시점 업체 유저 등록 여부 실시간 판별 API 단자 */
	@RequestMapping(value = "/checkCompanyUser.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkCompanyUser(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			String userId = String.valueOf(map.get("userId"));
			Company info = companyService.getCompanyInfo(userId);
			
			// 수혈받은 기존 서비스 자산의 결과물이 유효하게 존재한다면 업체 회원(true)으로 최종 증명!
			if (info != null) {
				resultMap.put("isCompany", true);
			} else {
				resultMap.put("isCompany", false);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("isCompany", false);
			resultMap.put("result", "fail");
		}
		return new Gson().toJson(resultMap);
	}
}