package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.CompanyService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CompanyController {

	@Autowired
	CompanyService companyService;
	
	@RequestMapping("/company.do")
	public String test0(Model model) throws Exception{
		return "/company/company";
	}
	@RequestMapping("/company1.do")
	public String test(Model model) throws Exception{
		return "/company/company1";
	}
	
	@RequestMapping("/company2.do")
	public String test1(Model model) throws Exception{
		return "/company/company2";
	}
	
	@RequestMapping("/company3.do")
	public String test2(Model model) throws Exception{
		return "/company/company3";
	}
	

	
}
