package com.example.marryview.member.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.example.marryview.admin.dao.NotificationService;
import com.example.marryview.common.Message;
import com.example.marryview.member.mapper.MemberMapper;
import com.example.marryview.member.model.ChatLog;
import com.example.marryview.member.model.Member;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	
	@Autowired
	private NotificationService notificationService;
	
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
	        
	        // 2-1. 계정 상태 체크
	        if("WITHDRAWN".equals(member.getStatus())) { 
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
	        if("user".equals(tab)) {
	            if(!member.getRole().equals("USER")) {
	                resultMap.put("loginResult", false);
	                if(member.getRole().equals("ADMIN")) {
	                    resultMap.put("message", "관리자 전용 페이지에서 로그인해주세요.");
	                } else {
	                    resultMap.put("message", "업체 로그인을 이용해주세요.");
	                }
	                return resultMap;
	            }
	        } else if("company".equals(tab)) {
	            if(!member.getRole().equals("PARTNER") && !member.getRole().equals("NPARTNER")) {
	                resultMap.put("loginResult", false);
	                if(member.getRole().equals("ADMIN")) {
	                    resultMap.put("message", "관리자 전용 페이지에서 로그인해주세요.");
	                } else {
	                    resultMap.put("message", "일반 로그인을 이용해주세요.");
	                }
	                return resultMap;
	            }
	        } else if("admin".equals(tab)) { 
	            if(!member.getRole().equals("ADMIN")) {
	                resultMap.put("loginResult", false);
	                resultMap.put("message", "관리자 권한이 없는 계정입니다.");
	                return resultMap;
	            }
	        }
	        
	        // 4. 비밀번호 비교 (중복되던 이중 구조 및 변수 선언 깔끔하게 통합)
	        if(passwordEncoder.matches((String)map.get("password"), member.getPassword())) { 
	            resultMap.put("loginResult", true);
	            
	            String displayName = ""; 
	            if(tab.equals("company")) {
	                map.put("userId", member.getUserId());
	                displayName = memberMapper.selectCompany(map);
	                resultMap.put("message", displayName + "님 환영합니다.");
	            } else {
	                displayName = member.getName();
	                resultMap.put("message", displayName + "님 환영합니다.");
	            }
	              
	            // url 분기
	            if(member.getRole().equals("ADMIN")) { 
	                resultMap.put("url", "/admin/main.do"); 
	            } else if(member.getRole().equals("NPARTNER")) { 
	                resultMap.put("url", "/company10.do"); 
	            } else {
	                resultMap.put("url", "/merryViewHome.do");
	            }	            
	            
	            // 세션 저장
	            session.setAttribute("sessionId", member.getUserId());
	            session.setAttribute("sessionName", displayName);
	            session.setAttribute("sessionRole", member.getRole());
	            
	            // 결혼 기념일 기프트콘 체크 (일반 유저만)
	            if (member.getRole().equals("USER")) {
	                giveAnniversaryGiftcon(member.getUserId());
	            }
	        } else {
	            resultMap.put("loginResult", false);
	            resultMap.put("message", "비밀번호가 일치하지 않습니다."); 
	        }
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        resultMap.put("loginResult", false);
	        resultMap.put("message", "로그인 중 오류가 발생했습니다."); 
	    }
	    
	    return resultMap;
	}
	//
	// *결혼 기념일 기프트콘 발급*
	private void giveAnniversaryGiftcon(String userId) {
	    try {
	        // 기념일 조회
	        String anniversary = memberMapper.selectAnniversaryDate(userId);
	        if (anniversary == null) return;

	        // 오늘 날짜와 월/일 비교
	        LocalDate today = LocalDate.now();
	        LocalDate anniversaryDate = LocalDate.parse(anniversary);

	        if (today.getMonthValue() != anniversaryDate.getMonthValue() ||
	            today.getDayOfMonth() != anniversaryDate.getDayOfMonth()) return;

	        // 올해 이미 발급됐는지 체크
	        HashMap<String, Object> checkMap = new HashMap<>();
	        checkMap.put("userId", userId);
	        checkMap.put("couponCode", "GIFT001");
	        checkMap.put("year", String.valueOf(today.getYear()));

	        int duplicate = memberMapper.checkAnniversaryGiftcon(checkMap);
	        if (duplicate > 0) return;

	        // 스타벅스 기프트콘 발급
	        HashMap<String, Object> couponMap = new HashMap<>();
	        couponMap.put("userId",         userId);
	        couponMap.put("couponCode",     "GIFT001");
	        couponMap.put("giftconCode",    "GC-ANNI-" + System.currentTimeMillis());
	        couponMap.put("giftconBarcode", String.valueOf((long)(Math.random() * 9000000000000L) + 1000000000000L));
	        couponMap.put("sourceReviewNo", null);

	        memberMapper.insertGiftcon(couponMap);
	        System.out.println("기념일 기프트콘 발급 완료 → " + userId);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
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
	    if(map.get("anniversaryDate") != null && map.get("anniversaryDate").toString().isEmpty()) {
	        map.put("anniversaryDate", null);
	    }
	    
	    // 탈퇴 이력 조회 (7일 체크 + 재활성화 분기에 재활용)
	    String withdrawnDate = memberMapper.selectWithdrawnDate(map);
	    if (withdrawnDate != null) {
	        LocalDate outDate = LocalDate.parse(withdrawnDate.substring(0, 10));
	        if (LocalDate.now().isBefore(outDate.plusDays(7))) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "탈퇴 후 7일간 재가입이 불가합니다.");
	            return resultMap;
	        }
	    }
	    
	    // 구현은 해놓지만, 같은 번호로 가입 테스트 하려면 주석 처리해야함.
	    // [전화번호 중복 가입 방지 - 테스트 완료 후 주석]
//	     int phoneCount = memberMapper.selectUserPhone(map);
//	     if (phoneCount > 0) {
//	         resultMap.put("result", "fail");
//	         resultMap.put("message", "이미 가입된 전화번호입니다.");
//	         return resultMap;
//	     }
	    
		try {
			map.put("password", passwordEncoder.encode((String)map.get("password")));
			// ✅ 탈퇴 이력 있으면 UPDATE(재활성화), 없으면 INSERT
	        if (withdrawnDate != null) {
	            memberMapper.reactivateMember(map);
	            memberMapper.reactivateUserDetail(map);
	        } else {
	            memberMapper.insertMember(map);
	            memberMapper.insertUserDetail(map);
	        }
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
			throw new RuntimeException(e);
		}
		return resultMap;
	}
	// 전화번호 중복체크
	public int checkPhoneDuplicate(HashMap<String, Object> map) {
	    return memberMapper.selectUserPhone(map);
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
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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
	// 프로필 이미지 변경
	public HashMap<String, Object> saveProfileImg(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        memberMapper.updateProfileImg(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	// 내 정보 수정 - 비밀번호 확인
	public HashMap<String, Object> checkPassword(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        // 카카오 유저 체크 먼저! (selectMember 호출 전에)
	        String userId = (String) map.get("userId");
	        if (userId != null && (userId.startsWith("kakao_") || userId.startsWith("naver_"))) {
	            resultMap.put("result", "success");
	            return resultMap;
	        }

	        // 일반 유저만 아래 로직 실행
	        Member member = memberMapper.selectMember(map);
	        if (member != null) {
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
	    	// 추가: 비밀번호 검증
	        Member member = memberMapper.selectMember(map); // 기존 유저 조회 mapper 사용
	        if (member == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "사용자를 찾을 수 없습니다.");
	            return resultMap;
	        }
	        if (!passwordEncoder.matches((String) map.get("password"), member.getPassword())) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "비밀번호가 일치하지 않습니다.");
	            return resultMap;
	        }
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
	public List<HashMap<String, Object>> getUserCouponList(Map<String, Object> param) {
	    return memberMapper.selectUserCouponList(param);
	}
	// 회원 쿠폰 개수
	public int getUserCouponCount(String userId) {
	    return memberMapper.selectUserCouponCount(userId);
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

        if (result > 0) {
            notificationService.createCouponIssued(
                String.valueOf(map.get("userId")),
                String.valueOf(map.get("couponCode"))
            );
            return "SUCCESS";
        }

        return "FAIL";
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
	        
	        notificationService.createCouponIssued(userId, couponCode);
	    }
	}
	// 기프트콘 조회
	public List<HashMap<String, Object>> getUserGiftconList(String userId) {
	    return memberMapper.selectUserGiftconList(userId);
	}
	// 열람권 잔회 횟수 조회
	public Member getPassWallet(String userId) {
		Member result = memberMapper.selectPassWallet(userId);
//	    System.out.println("getPassWallet result: " + result);  // ✅ 추가
	    return result;
	}
	// 멤버십 결제 내역 조회
	public List<Member> getPassWalletList(Map<String, Object> param) {
	    return memberMapper.selectPassWalletList(param);
	}
	// 멤버십 결제 내역 개수
	public int getPassWalletCount(String userId) {
	    return memberMapper.selectPassWalletCount(userId);
	}
	// 내 예약 목록 조회
	public List<Member> getMyReservationList(Map<String, Object> param) {
	    return memberMapper.selectMyReservationList(param);
	}
	// 내 예약 전체 개수
	public int getMyReservationCount(String userId) {
	    return memberMapper.selectMyReservationCount(userId);
	}
	// 내가 산 리뷰 (구매 : 유료/무료) 조회 
	// 유료
	public List<Member> getMyPaidReviewList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 6);
	    map.put("offset", (page - 1) * 6);
	    return memberMapper.selectMyPaidReviewList(map);
	}
	// 페이지 사이징
	public int getMyPaidReviewCount(String userId) {
	    return memberMapper.selectMyPaidReviewCount(userId);
	}
	// 무료
	public List<Member> getMyFreeReviewList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 6);
	    map.put("offset", (page - 1) * 6);
	    return memberMapper.selectMyFreeReviewList(map);
	}  
	// 페이지 사이징
	public int getMyFreeReviewCount(String userId) {
	    return memberMapper.selectMyFreeReviewCount(userId);
	}
	// 내가 쓴 글 조회
	public List<Member> getMyPostList(String userId, int page) {
		 HashMap<String, Object> map = new HashMap<>();
		 map.put("userId", userId);
		 map.put("pageSize", 5);
		 map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyPostList(map);
	}
	// 페이지 사이징
	public int getMyPostCount(String userId) {
	    return memberMapper.selectMyPostCount(userId);
	}
	// 내가 쓴 리뷰 조회
	public List<Member> getMyReviewList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("pageSize", 5);
		map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyReviewList(map);
	}
	// 페이지 사이징
	public int getMyReviewCount(String userId) {
	    return memberMapper.selectMyReviewCount(userId);
	}
	// 내가 쓴 댓글 조회
	public List<Member> getMyCommentList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("pageSize", 5);
		map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyCommentList(map);
	}
	// 페이지 사이징
	public int getMyCommentCount(String userId) {
	    return memberMapper.selectMyCommentCount(userId);
	}
	
	// 업체 좋아요 조회
	public List<Member> getMyCompanyLikeList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyCompanyLikeList(map);
	}
	// 페이지 사이징
	public int getMyCompanyLikeCount(String userId) {
	    return memberMapper.selectMyCompanyLikeCount(userId);
	}
	// 상품 좋아요 조회
	public List<HashMap<String, Object>> getMyProductLikeList(String userId, int page) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyProductLikeList(map);
	}

	public int getMyProductLikeCount(String userId) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    return memberMapper.selectMyProductLikeCount(map);
	}
	// 글 좋아요 조회
	public List<Member> getMyPostLikeList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
//	    System.out.println("userId: " + userId);
	    return memberMapper.selectMyPostLikeList(map);
	}
	// 페이지 사이징
	public int getMyPostLikeCount(String userId) {
	    return memberMapper.selectMyPostLikeCount(userId);
	}
	// 리뷰 좋아요 조회
	public List<Member> getMyReviewLikeList(String userId, int page) {
		HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectMyReviewLikeList(map);
	}// 페이지 사이징
	public int getMyReviewLikeCount(String userId) {
	    return memberMapper.selectMyReviewLikeCount(userId);
	}
	// 내가 쓴 글 삭제
	public int removeMyPost(String userId, String postNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("postNo", postNo);
	    return memberMapper.deleteMyPost(map);
	}
	// 내가 쓴 리뷰 삭제
	public int removeMyReview(String userId, String reviewNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("reviewNo", reviewNo);
	    return memberMapper.deleteMyReview(map);
	}
	// 내가 쓴 댓글 삭제
	public int removeMyComment(String userId, String commentNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("commentNo", commentNo);
	    return memberMapper.deleteMyComment(map);
	}
	// 업체 좋아요 취소
	public int deleteMyCompanyLike(String userId, String likeNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("likeNo", likeNo);
	    return memberMapper.deleteMyCompanyLike(map);
	}
	// 상품 좋아요 취소
	public void deleteMyProductLike(String likeNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("likeNo", likeNo);
	    memberMapper.deleteMyProductLike(map);
	}
	// 글 좋아요 취소
	public int deleteMyPostLike(String userId, String likeNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("likeNo", likeNo);
	    return memberMapper.deleteMyPostLike(map);
	}
	// 리뷰 좋아요 취소
	public int deleteMyReviewLike(String userId, String likeNo) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("likeNo", likeNo);
	    return memberMapper.deleteMyReviewLike(map);
	}
	
	// 내 문의 내역 조회
	public List<Member> getMyInquiryList(Map<String, Object> param) {
	    return memberMapper.selectMyInquiryList(param);
	}

	// 내 문의 내역 개수
	public int getMyInquiryCount(String userId) {
	    return memberMapper.selectMyInquiryCount(userId);
	}
	// 내 신고 내역 조회
	public List<Member> getMyReportList(Map<String, Object> param) {
	    return memberMapper.selectMyReportList(param);
	}

	// 내 신고 개수
	public int getMyReportCount(String userId) {
	    return memberMapper.selectMyReportCount(userId);
	}
	
	// * 유료 리뷰 열람 시 열람권 차감 *
	@Transactional
	public HashMap<String, Object> decreasePass(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        // 1. 재열람 확인
	        int logCount = memberMapper.selectUsageLog(map);
	        if (logCount > 0) {
	            resultMap.put("result", "success");
	            resultMap.put("message", "재열람입니다.");
	            return resultMap;
	        }
	        // 2. 잔여 횟수 확인 후 차감
	        int updateResult = memberMapper.updateRemainingCount((String) map.get("userId"));
	        if (updateResult == 0) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "잔여 열람권이 없습니다.");
	            return resultMap;
	        }
	        // 3. 로그 INSERT
	        memberMapper.insertUsageLog(map);
	        resultMap.put("result", "success");
	        resultMap.put("message", "열람권이 사용되었습니다.");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 오류가 발생했습니다.");
	    }
	    return resultMap;
	}
	
	// *아이디/비밀번호 찾기*
	// 아이디 찾기
	public String findUserId(Map<String, Object> map) {
        return memberMapper.findUserId(map);
    }
	public int checkUser(Map<String, Object> map) {
	    return memberMapper.checkUserForPw(map);
	}
	// 비밀 번호 변경
	@Transactional
	public int changePassword(Map<String, Object> map) {
	    String encodedPw = passwordEncoder.encode((String) map.get("newPw"));
	    map.put("newPw", encodedPw);
	    return memberMapper.updatePassword(map);
	}
	
	// 사용자 프로필 조회
	public Member getUserProfile(String userId) {
	    return memberMapper.selectUserProfile(userId);
	}
	// 사용자가 쓴 리뷰
	public List<Member> getUserReviewList(String userId, int page) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectUserReviewList(map);
	}
	// 사용자가 쓴 게시글
	public List<Member> getUserPostList(String userId, int page) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectUserPostList(map);
	}
	// 사용자가 쓴 댓글
	public List<Member> getUserCommentList(String userId, int page) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", userId);
	    map.put("pageSize", 5);
	    map.put("offset", (page - 1) * 5);
	    return memberMapper.selectUserCommentList(map);
	}
	// 페이징
	public int getUserReviewCount(String userId) {
	    return memberMapper.selectUserReviewCount(userId);
	}
	public int getUserPostCount(String userId) {
	    return memberMapper.selectUserPostCount(userId);
	}
	public int getUserCommentCount(String userId) {
	    return memberMapper.selectUserCommentCount(userId);
	}
	
	// *메인 홈 출력* 
	// 최근 리뷰
	public List<Member> getMainReviewList(String userId) {
		return memberMapper.selectMainReviewList(userId);
	}
	// 인기 글
	public List<Member> getMainPostList() {
	    return memberMapper.selectMainPostList();
	}
	
	// *챗봇 로그*
	public void saveChatLog(String userId, String question, String answer, String type) {
	    ChatLog log = new ChatLog();
	    log.setUserId(userId != null ? userId : "guest");
	    log.setQuestion(question);
	    log.setAnswer(answer);
	    log.setChatType(type);
	    
	    memberMapper.insertChatLog(log);
	}
	// 챗봇 추천
	public List<HashMap<String, Object>> getTopReviewedProducts() {
	    return memberMapper.getTopReviewedProducts();
	}
	// 챗봇 평균 비용
	public List<HashMap<String, Object>> getAverageProductPrice() {
	    return memberMapper.getAverageProductPrice();
	}
	// 가장 저렴한 상품
	public List<HashMap<String, Object>> getCheapestProducts(String category) {
	    return memberMapper.getCheapestProducts(category);
	}
	// 리뷰 갯수와 카테고리 조회
	public List<HashMap<String, Object>> getMostReviewedProductsByCategory(String category) {
	    return memberMapper.getMostReviewedProductsByCategory(category);
	}
}
