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

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CompanyController {

	@Autowired
	CompanyService companyService;
	
	@RequestMapping("/company10.do")
	public String test2(Model model) throws Exception{
		return "/company/company10";
	}

	
}
