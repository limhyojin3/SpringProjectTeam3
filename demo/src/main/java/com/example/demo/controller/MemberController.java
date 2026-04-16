package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestMethod;
import com.example.demo.dao.MemberService;
import com.google.gson.Gson;
import ch.qos.logback.core.model.Model;

@Controller
public class MemberController {

	@Autowired
	MemberService memberService; //서비스 객체 선언
	
	//1. login (로그인)
	@RequestMapping("/login.do") // 주소 
	public String login(Model model) throws Exception{
		return "/login"; // 파일명
	}
	
	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		return new Gson().toJson(resultMap); 
	}
	//
	// 2. join (회원가입)
	@RequestMapping("/join.do") // 주소 
	public String join(Model model) throws Exception{
		return "/join"; // 파일명
	}
	
	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		return new Gson().toJson(resultMap); 
	}
	// 2-1. join-user(유저 회원가입)
	@RequestMapping("/userJoin.do") // 주소 
	public String userJoin(Model model) throws Exception{
		return "/join-user"; // 파일명
	}
	// 2-2. join-company(업체 회원가입)
	@RequestMapping("/companyJoin.do") // 주소 
	public String companyJoin(Model model) throws Exception{
		return "/join-company"; // 파일명
	}
	//
	
	
	
}
