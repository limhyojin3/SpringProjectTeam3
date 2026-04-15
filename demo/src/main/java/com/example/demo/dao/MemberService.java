package com.example.demo.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.MemberMapper;
import com.example.demo.model.Member;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	
//	PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//	
//	
//	public HashMap<String, Object> login(HashMap<String, Object> map, HttpSession session){
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		
//		Member member = memberMapper.selectMember(map);
//		resultMap.put("loginResult",false);
//		if(member != null) {
//			//ooo님 환영합니다.
//			if(passwordEncoder.matches((String) map.get("pwd"), member.getPassword())) {
//				resultMap.put("message", member.getName() + "님 환영합니다.");
//				resultMap.put("loginResult",true);
//				session.setAttribute("sessionId", member.getUserId());
//				session.setAttribute("sessionName", member.getName());
//				session.setAttribute("sessionRole", member.getRole());
//				
////				if(user.getRole().equals("A")) {
////					resultMap.put("url","/prof/list.do");
////				}else {
////					resultMap.put("url","/stu/list.do");
////				}  
//				resultMap.put("url","/board/list.do");
////				session.invalidate(); 세션 모든 정보 삭제(로그아웃 버튼)
//			}else {
//				resultMap.put("message", "비밀번호를 확인해주세요.");
//			}
//			resultMap.put("message", "로그인 성공!");
//		}else {
//			resultMap.put("message", "존재하지 않는 아이디 입니다.");
//		}
//		resultMap.put("result", "success");
//		
//		return resultMap;
//	}
	
	
}
