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
	public String main(Model model) throws Exception{
		return "/adminMain";
	}
	
	@RequestMapping("/adminStatistics.do")
	public String Statistics(Model model) throws Exception{
		return "/adminStatistics";
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
	
}