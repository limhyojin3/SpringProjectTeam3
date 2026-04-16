package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {

	@RequestMapping("/adminMain.do")
	public String main(Model model) throws Exception{
		return "/adminMain";
	}
	
	@RequestMapping(value = "", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		return new Gson().toJson(resultMap); 
	}
}
