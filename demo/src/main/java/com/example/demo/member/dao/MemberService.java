package com.example.demo.member.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.common.Message;
import com.example.demo.member.mapper.MemberMapper;
import com.example.demo.member.model.Member;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	
	PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	// *로그인 (일반,업체,관리자)*
	public HashMap<String, Object> login(HashMap<String, Object> map, HttpSession session) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    
	    try {
	        // 1. 아이디로 조회
	        Member member = memberMapper.selectMember(map);
	        
	        // 2. 아이디 없으면 실패
	        if(member == null) {
	            resultMap.put("loginResult", false);
	            resultMap.put("message", "아이디가 존재하지 않습니다.");
	            return resultMap;
	        }
		     // 3. role 체크 (비밀번호 비교 전에!)
		        String tab = (String) map.get("tab");
		    if(tab.equals("user")) {
		        if(!member.getRole().equals("USER") && !member.getRole().equals("ADMIN")) {
		          resultMap.put("loginResult", false);
		          resultMap.put("message", "업체 로그인을 이용해주세요.");
		          return resultMap;
		        }
		    } else if(tab.equals("company")) {
		        if(!member.getRole().equals("PARTNER")) {
		           resultMap.put("loginResult", false);
		           resultMap.put("message", "일반 로그인을 이용해주세요.");
		           return resultMap;
		        }
		    }
	        
	        // 4. 비밀번호 비교
//	        if(passwordEncoder.matches((String)map.get("password"), member.getPassword())) { //암호화 비교 추후 변경
		    if(passwordEncoder.matches((String)map.get("password"), member.getPassword())) { // 암호화
	            resultMap.put("loginResult", true);
	            
	         // tab은 위에서 이미 선언했으니까 그냥 사용 가능합니다.
	         if(tab.equals("company")) {
	            String companyName = memberMapper.selectCompany(map);
	            resultMap.put("message", companyName + "님 환영합니다.");
	         } else {
	            resultMap.put("message", member.getName() + "님 환영합니다.");
	          }
	          
	         // url 분기
	         if(member.getRole().equals("ADMIN")) { // 관리자 role
	            resultMap.put("url", "/admin/main.do"); 
	            // 임시페이지 없어서 404 뜨는데 머지->pull 받고 만드신 주소로 수정하겠습니다.
	         } else if(member.getRole().equals("PARTNER")) { // 업체롤 role
	            resultMap.put("url", "/company10.do"); 
	            // 임시페이지 없어서 404 뜨는데 머지->pull 받고 만드신 주소로 수정하겠습니다.
	         } else {
	                resultMap.put("url", "/merryViewHome.do"); // 임시로 /home.jsp 생성했습니다.
	         }	            
	            session.setAttribute("sessionId", member.getUserId());
	            session.setAttribute("sessionName", member.getName());
	            session.setAttribute("sessionRole", member.getRole());
	         }else {
	            resultMap.put("loginResult", false);
	            resultMap.put("message", "비밀번호가 일치하지 않습니다."); // *메세지 부분은 일단 하드코딩 했지만 공용 메세지에 추가 후 변경 예정
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        resultMap.put("loginResult", false);
	        resultMap.put("message", "로그인 중 오류가 발생했습니다."); // *공용 메세지 추가 후 변경 예정
	    }
	    return resultMap;
	}
	//
	// * 아이디 중복체크 *
	public HashMap<String, Object> getUserIdCount(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        int count = memberMapper.selectUserId(map);
	        resultMap.put("available", count == 0);
	    } catch(Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("available", false);
	    }
	    return resultMap;
	}
	// * 이메일 중복체크 *
	public HashMap<String, Object> getUserEmailCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
		     int count = memberMapper.selectUserEmail(map);
		     resultMap.put("available", count == 0);
		} catch(Exception e) {
		     System.out.println(e.getMessage());
		     resultMap.put("available", false);
		}
		return resultMap;
	}
	
	// * 일반 회원 가입 *
	@Transactional
	public HashMap<String, Object> addMember(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println("weddingDate 값: " + map.get("weddingDate")); // ← 추가
		// weddingDate 빈 문자열이면 null로 변환
	    if(map.get("weddingDate") != null && map.get("weddingDate").toString().isEmpty()) {
	        map.put("weddingDate", null);
	    }
		try {
			map.put("password", passwordEncoder.encode((String)map.get("password")));
			// member 테이블 INSERT
	        memberMapper.insertMember(map);
	        // user_detail 테이블 INSERT
	        memberMapper.insertUserDetail(map);
			
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	// * 업체 회원 가입 *
	@Transactional
	public HashMap<String, Object> addCompany(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	    	map.put("password", passwordEncoder.encode((String)map.get("password")));
	    	// member 테이블 INSERT
	        memberMapper.insertCompanyMember(map);
	        System.out.println("member INSERT 성공");
	        // company 테이블 INSERT
	        memberMapper.insertCompany(map);
	        System.out.println("company INSERT 성공");
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_ADD);
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }
	    return resultMap;
	}
	// 업체명 검색
	public HashMap<String, Object> checkComName(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        int count = memberMapper.selectComName(map);
	        resultMap.put("available", count == 0);
	    } catch(Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("available", false);
	    }
	    return resultMap;
	}
	
}
