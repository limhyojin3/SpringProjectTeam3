package com.example.demo.member.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.member.dao.MemberService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

	@Autowired
	MemberService memberService; //서비스 객체 선언
	
	// 0. 메인 홈 *로그인 후 연결하려고 임시로 주소만 생성했어요* 주소 변경 시 수정 예정
	@RequestMapping("/merryViewHome.do") // 주소 
	public String home(Model model) throws Exception{
		return "/home"; // 파일명
	}
	//
	//*1. login (로그인)*
	@RequestMapping("/login.do") // 주소 
	public String login(Model model) throws Exception{
		return "/member/login"; // 파일명
	}
	
	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.login(map, session);
		return new Gson().toJson(resultMap); 
	}
	//
	//*2. join (회원가입)*
	@RequestMapping("/join.do") // 주소 
	public String join(Model model) throws Exception{
		return "/member/join"; // 파일명
	}
	
	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String join(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		return new Gson().toJson(resultMap); 
	}
	// 2-1. join-user(유저 회원가입)
	@RequestMapping("/joinUser.do") // 주소 
	public String userJoin(Model model) throws Exception{
		return "/member/join-user"; // 파일명
	}
	@RequestMapping(value = "/joinUser.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinUser(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = memberService.addMember(map);
	    return new Gson().toJson(resultMap);
	}
	// 아이디 중복체크
	@RequestMapping(value = "/checkUserId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkUserId(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = memberService.getUserIdCount(map);
	    return new Gson().toJson(resultMap);
	}
	// 이메일 중복체크
		@RequestMapping(value = "/checkEmail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
		@ResponseBody
		public String getUserEmailCount(@RequestParam HashMap<String, Object> map) throws Exception {
		    HashMap<String, Object> resultMap = memberService.getUserIdCount(map);
		    return new Gson().toJson(resultMap);
		}
	
	// 2-2. join-company(업체 회원가입)
	@RequestMapping("/joinCompany.do") // 주소 
	public String companyJoin(Model model) throws Exception{
		return "/member/join-company"; // 파일명
	}
	@RequestMapping(value = "/joinCompany.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String joinCompany(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = memberService.addCompany(map);
	    return new Gson().toJson(resultMap);
	}
	// 업체명 중복 확인
	@RequestMapping(value = "/checkComName.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkComName(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = memberService.checkComName(map);
	    return new Gson().toJson(resultMap);
	}
	// 3.마이페이지
	// 3-1. 마이페이지 메인
	@RequestMapping("/userMyPage.do") // 주소 
	public String userMyPage(Model model) throws Exception{
		return "/member/user-mypage"; // 파일명
	}
	// 3-2. 마이페이지 결제 멤버십 내역
	@RequestMapping("/userMyPage-pay.do") // 주소 
	public String userMyPagePay(Model model) throws Exception{
		return "/member/user-mypage-pay"; // 파일명
	}
	// 3-3. 마이페이지 리뷰 조회 내역
	@RequestMapping("/userMyPage-review.do") // 주소 
	public String userMyPageReview(Model model) throws Exception{
		return "/member/user-mypage-review"; // 파일명
	}
	
}
