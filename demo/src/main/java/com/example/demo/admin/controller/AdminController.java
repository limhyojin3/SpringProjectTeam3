package com.example.demo.admin.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.admin.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {

	@Autowired
	AdminService adminService;

	@RequestMapping("/adminMain.do")
	public String main(Model model) throws Exception {
		return "admin/adminMain";
	}

	@RequestMapping("/adminReviewWait.do")
	public String Review(Model model) throws Exception {
		return "admin/adminReviewWait";
	}

	@RequestMapping("/adminStatistics.do")
	public String Statistics(Model model) throws Exception {
		return "admin/adminStatistics";
	}
	
	@RequestMapping("/adminReport.do")
	public String adminReport(Model model) throws Exception {
		return "admin/adminReport";
	}
	
	@RequestMapping("/adminPass.do")
	public String adminPass(Model model) throws Exception {
		return "admin/adminPass";
	}


	@RequestMapping(value = "/sales.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sales(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getSalesList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/clients.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String clients(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getclientsList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/viewReview.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String viewReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getReviewList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/viewReport.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String viewReport(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getReportList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/pass.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pass(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getPassList(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/passCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String passCheck(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getPassInfo(map);

		return new Gson().toJson(resultMap);
	}
}