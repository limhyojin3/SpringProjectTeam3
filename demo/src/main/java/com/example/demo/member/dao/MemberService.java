package com.example.demo.member.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	        // 2-1. 계정 상태 체크 (추가!)
	        if("WITHDRAWN".equals(member.getStatus())) { // 탈퇴 상태값에 맞춰 수정하세요
	            resultMap.put("loginResult", false);
	            resultMap.put("message", "탈퇴 처리된 계정입니다.");
	            return resultMap;
	        } else if("STOP".equals(member.getStatus())) {
	            resultMap.put("loginResult", false);
	            resultMap.put("message", "이용이 정지된 계정입니다.");
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
		    if(passwordEncoder.matches((String)map.get("password"), member.getPassword())) { // 암호화
	            resultMap.put("loginResult", true);
	            
	         // tab은 위에서 이미 선언했으니까 그냥 사용 가능합니다.
	         String displayName= ""; // 화면에 표시할 이름을 담을 변수
	         if(tab.equals("company")) {
//	        	System.out.println("DB에서 가져온 Member ID: " + member.getUserId()); // DB 객체 값
	        	map.put("userId", member.getUserId());
//	        	System.out.println(map.get("userId"));
	        	displayName = memberMapper.selectCompany(map);
	        	System.out.println("조회된 업체명: " + displayName);
	            resultMap.put("message", displayName + "님 환영합니다.");
	    
	         } else {
	        	displayName = member.getName();
	            resultMap.put("message", displayName + "님 환영합니다.");
	            
	          }
	          
	         // url 분기
	         if(member.getRole().equals("ADMIN")) { // 관리자 role
	            resultMap.put("url", "/admin/main.do"); 
	            // 임시페이지 없어서 404 뜨는데 머지->pull 받고 만드신 주소로 수정하겠습니다.
	         } else if(member.getRole().equals("NPARTNER")) { // 업체롤 role
	            resultMap.put("url", "/company10.do"); 
	            // 임시페이지 없어서 404 뜨는데 머지->pull 받고 만드신 주소로 수정하겠습니다.
	         } else {
	                resultMap.put("url", "/merryViewHome.do"); // 임시로 /home.jsp 생성했습니다.
	         }	            
	            session.setAttribute("sessionId", member.getUserId());
	            session.setAttribute("sessionName", displayName);
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
//		System.out.println("weddingDate 값: " + map.get("weddingDate")); // ← 추가
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
	        
	        // --- [쿠폰 지급 로직 추가] ---
	     	String userId = (String) map.get("userId");	
	     	// [A] 회원가입 축하 쿠폰 지급
	     	this.giveCoupon(userId, "WELCOME15"); // DB에 등록된 가입쿠폰 코드
	     	// [B] 가입 시 예정일을 입력했다면 예정일 쿠폰도 지급
	     	if (map.get("weddingDate") != null) {
	     		this.giveCoupon(userId, "WEDDING10"); // DB에 등록된 예정일쿠폰 코드
	     	}
	        
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
	
	// * 유저 마이페이지 *
	// 내 정보 수정 - 비밀번호 확인
	public HashMap<String, Object> checkPassword(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        Member member = memberMapper.selectMember(map); 
	        
	        if (member != null) {
	            // 2. 암호화된 비밀번호 비교
	            boolean isMatch = passwordEncoder.matches((String)map.get("password"), member.getPassword());
	            resultMap.put("result", isMatch ? "success" : "fail");
	        } else {
	            resultMap.put("result", "fail");
	        }
	    } catch(Exception e) {
	        System.out.println("비밀번호 확인 에러: " + e.getMessage());
	        resultMap.put("result", "error");
	    }
	    return resultMap;
	}
	// 내 정보 수정 - 상세 정보 가져오기
	public Member getMemberInfo(String userId) {
	    try {
	        // 아까 XML에 만드신 selectMemberInfo를 호출합니다.
	        return memberMapper.selectMemberInfo(userId);
	    } catch (Exception e) {
	        System.out.println("회원정보 조회 에러: " + e.getMessage());
	        return null;
	    }
	}
	// 내 정보 수정 - 수정 업데이트
	@Transactional // 하나라도 실패할 경우 둘 다 취소
	public HashMap<String, Object> EditMemberInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
	    
	    try {
	        // 1. MEMBER 테이블 수정 (전화번호 등)
	        int memberResult = memberMapper.updateMember(map);
	        // 2. USER_DETAIL 테이블 수정 (이름, 이메일, 성별 등)
	        int detailResult = memberMapper.updateUserDetail(map);
//	        System.out.println("MEMBER 수정 결과: " + memberResult); // 1이 나와야 성공
//	        System.out.println("DETAIL 수정 결과: " + detailResult);
	        // 3. 두 테이블 모두 성공했는지 확인
	        if (memberResult > 0 && detailResult > 0) {
	            resultMap.put("result", "success");
		         // --- [쿠폰 지급 로직 추가] ---
	             // map에 weddingDate가 포함되어 넘어오는지 확인
	             if (map.get("weddingDate") != null && !map.get("weddingDate").toString().isEmpty()) {
	                 String userId = (String) map.get("userId");       
	             // 결혼 예정일 등록 쿠폰 지급 (이미 받은 경우 giveCoupon 내부에서 걸러짐)
	                this.giveCoupon(userId, "WEDDING10");
	                resultMap.put("couponMsg", "결혼 예정일 등록 축하 쿠폰이 발급되었습니다! 🎉");
	             }else {
		            resultMap.put("result", "fail");
		        }
	        }
	    } catch (Exception e) {
	        // 에러 발생 시 로그 찍기
	        System.out.println("수정 에러 발생: " + e.getMessage());
	        resultMap.put("result", "error");
	    }
	    return resultMap;
	}
	// 회원 탈퇴 기능
	public HashMap<String, Object> editUserStatus(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        // DB 업데이트 실행 (성공 시 1, 실패 시 0)
	        int result = memberMapper.updateUserStatus(map);
	        
	        if (result > 0) {
	            resultMap.put("result", "success");
	        } else {
	            resultMap.put("result", "fail");
	        }
	    } catch (Exception e) {
	        // 에러 발생 시 로그를 찍고 fail 결과 담기
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "DB 에러 발생");
	    }
	    return resultMap;
    }
	// 회원 쿠폰 조회
	public List<HashMap<String, Object>> getUserCouponList(String userId) {
	    return memberMapper.selectUserCouponList(userId);
	}
	// 쿠폰 유효성 조회 & 쿠폰 중복 발급 여부 조회 & 쿠폰 등록
	@Transactional
	public String registerCouponService(HashMap<String, Object> map) {
        
        // [1] 쿠폰 유효성 조회
        // Coupon 테이블에 해당 코드가 있고, issue_type이 'CODE'인지 확인합니다.
        Map<String, Object> validCoupon = memberMapper.checkValidCoupon(map);
        
        if (validCoupon == null) {
            // 존재하지 않는 코드거나 직접 등록할 수 없는 타입일 때
            return "INVALID_CODE"; 
        }

        // [2] 쿠폰 중복 발급 여부 조회
        // User_Coupon 테이블에 이미 해당 유저-쿠폰 조합이 있는지 확인합니다.
        int duplicateCount = memberMapper.checkDuplicateCoupon(map);
        
        if (duplicateCount > 0) {
            // 이미 등록된 쿠폰인 경우 (중복 방지)
            return "DUPLICATED";
        }

        // [3] 쿠폰 등록 실행
        // 모든 검증을 통과하면 유저 보유 쿠폰 목록에 인서트합니다.
        // status는 'UNUSED'로, 발급일은 현재 시간으로 저장됩니다.
        int result = memberMapper.insertUserCoupon(map);

        return (result > 0) ? "SUCCESS" : "FAIL";
    }
	// 쿠폰 발급 (회원가입 쿠폰, 결혼에정일 입력 시 지급 쿠폰)
	@Transactional
	public void giveCoupon(String userId, String couponCode) {
	    HashMap<String, Object> couponMap = new HashMap<>();
	    couponMap.put("userId", userId);
	    couponMap.put("couponCode", couponCode);

	    // 이미 받았는지 확인 (중복 지급 방지)
	    int duplicate = memberMapper.checkDuplicateCoupon(couponMap);
	    if (duplicate == 0) {
	        memberMapper.insertUserCoupon(couponMap);
	    }
	}
	
	// *아이디/비밀번호 찾기*
	// 비밀 번호 변경
	@Transactional
	public int changePassword(HashMap<String, Object> map) {
	    // 1. 본인 확인 (유저+업체 통합 쿼리)
	    int count = memberMapper.checkUserForPw(map);
	    if (count > 0) {
	        // 2. 일치하면 비밀번호 암호화 후 업데이트
	        String encodedPw = passwordEncoder.encode((String) map.get("newPw"));
	        map.put("newPw", encodedPw);
	        return memberMapper.updatePassword(map);
	    }
	    return 0; // 정보 불일치
	}
	
	
}
