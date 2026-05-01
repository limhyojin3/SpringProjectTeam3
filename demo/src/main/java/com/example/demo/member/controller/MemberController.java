package com.example.demo.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.member.dao.GeminiService;
import com.example.demo.member.dao.MemberService;
import com.example.demo.member.dao.SmsService;
import com.example.demo.member.model.Member;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

	@Autowired
	MemberService memberService; //서비스 객체 선언
	@Autowired
	SmsService smsService; //서비스 객체 선언
	@Autowired
    private GeminiService geminiService;
	
	// 0. 대문
	@RequestMapping("/marryIntro.do") // 주소 
	public String first(Model model) throws Exception{
		return "/Intro_home"; // 파일명
	}
	
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
	// * 아이디/비밀번호 변경 * 
	// 아이디 찾기
	@RequestMapping("/find-id.do") // 주소 
	public String FindId(Model model) throws Exception{
		return "/member/find-id"; // 파일명
	}
	@PostMapping("/find-id-result.dox")
	@ResponseBody
	public Map<String, Object> findIdResult(@RequestBody Map<String, Object> map) {
		System.out.println("userName: " + map.get("userName"));
	    System.out.println("userTel: " + map.get("userTel"));
	    Map<String, Object> resultMap = new HashMap<>();
	    String userId = memberService.findUserId(map);
	    if (userId != null) {
	        resultMap.put("result", "success");
	        resultMap.put("userId", userId);
	    } else {
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	// 비밀 번호 변경
	@RequestMapping("/find-pwd.do") // 주소 
	public String changePwd(Model model) throws Exception{
		return "/member/find-pwd"; // 파일명
	}
	// 1. 본인 확인 및 비밀번호 변경 권한 부여
	@PostMapping("/check-user.dox")
	@ResponseBody
	public Map<String, Object> checkUser(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> resultMap = new HashMap<>();
	    int count = memberService.checkUser(map);
	    resultMap.put("count", count);
	    if (count > 0) {
	       // 인증 성공 시 세션에 저장 (change-pw.dox에서 검증용)
	       session.setAttribute("authUserId", map.get("userId"));
	       session.setAttribute("isVerified", true);
	    }    
	    return resultMap;
	}

    // 2. 실제 비밀번호 업데이트
    @PostMapping("/change-pw.dox")
    @ResponseBody
    public Map<String, Object> changePw(@RequestBody Map<String, Object> map, HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        
        // 세션에서 인증 정보 확인 (접근 제어)
        String authUserId = (String) session.getAttribute("authUserId");
        Boolean isVerified = (Boolean) session.getAttribute("isVerified");

        System.out.println("세션 authUserId: " + authUserId);
        System.out.println("세션 isVerified: " + isVerified);
        System.out.println("요청 userId: " + map.get("userId"));
        
        // 세션에 저장된 ID와 요청온 ID가 일치하고, 인증된 상태여야 함
        if (isVerified != null && isVerified && authUserId.equals(map.get("userId"))) {
            // XML의 updatePassword 호출
            int result = memberService.changePassword(map);
            
            if(result > 0) {
                session.invalidate(); // 변경 완료 후 세션 초기화 (보안)
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
            }
        } else {
            resultMap.put("result", "fail");
            resultMap.put("message", "비정상적인 접근입니다.");
        }
        return resultMap;
    }
	//
	// 1-3. *로그아웃*
	@RequestMapping("/logout.do")
	public String logout(HttpSession session) {
	    session.invalidate();  // 세션 전체 삭제
	    return "redirect:/merryViewHome.do";  // 로그인 페이지로 이동
	}
	
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
	public String userMyPage(HttpSession session,Model model) throws Exception{
		// 1. 세션에서 로그인한 사용자 정보 가져오기
		String userId = (String) session.getAttribute("sessionId");
		// 2. 만약 세션이 만료되었다면 로그인 페이지로 리다이렉트 (안전장치)
	    if (userId == null) {
	        return "redirect:/login.do"; 
	    }
	    Member member = memberService.getMemberInfo(userId);
//	    System.out.println("로그 - 내 정보 확인: " + member.toString());
	    // 3. JSP에서 "${member}"로 부를 수 있도록 모델에 담기
	    model.addAttribute("member", member);
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
	// 3-4. 내가 쓴 리뷰 조회 내역
	@RequestMapping("/userMyPage-write.do") // 주소 
	public String userMyPageWrite(Model model) throws Exception{
		return "/member/user-mypage-write"; // 파일명
	}
	// 3-5. 좋아요 목록
	@RequestMapping("/userMyPage-like.do") // 주소 
	public String userMyPageLike(Model model) throws Exception{
		return "/member/user-mypage-like"; // 파일명
	}
	// 3-6. 고객 센터 홈
	@RequestMapping("/userMyPage-cs.do") // 주소 
	public String userMyPageCs(Model model) throws Exception{
		return "/member/user-mypage-cs"; // 파일명
	}
	// 3-7. 고객 센터-문의 리스트
	@RequestMapping("/userMyPage-cs-list.do") // 주소 
	public String userMyPageCsList(Model model) throws Exception{
		return "/member/user-mypage-cs-list"; // 파일명
	}
	// 3-8. 고객 센터-문의 작성
	@RequestMapping("/userMyPage-cs-write.do") // 주소 
	public String userMyPageCsWrite(Model model) throws Exception{
		return "/member/user-mypage-cs-write"; // 파일명
	}
	// 3-9. 고객 센터-신고 작성
	@RequestMapping("/userMyPage-cs-report.do") // 주소 
	public String userMyPageCsReport(Model model) throws Exception{
		return "/member/user-mypage-cs-report"; // 파일명
	}
	// 3-10. 내 정보 수정(수정을 위한 비밀번호 입력)
	@RequestMapping("/userMyPage-confirmPw.do") // 주소 
	public String userMyPageConfirmPw(Model model) throws Exception{
		return "/member/user-mypage-confirmPw"; // 파일명
	}
	// 3-11. 내 정보 수정(비밀번호 확인페이지)
	@PostMapping("/myPage-checkPw.do")
	@ResponseBody
	public String checkPassword(@RequestParam Map<String, Object> map) {
	    HashMap<String, Object> serviceResult = memberService.checkPassword((HashMap<String, Object>) map); 
	    String result = (String) serviceResult.get("result");
	 
	    return result;
	}
	// 3-12. 비밀번호 확인 성공 후 이동할 정보 수정 화면
	@RequestMapping("/myPage-updateForm.do")
	public String myPageUpdateForm(HttpSession session, Model model) throws Exception {
		// 1. 세션에서 로그인한 사용자의 아이디를 가져옵니다.
	    String sessionId = (String) session.getAttribute("sessionId");
	    System.out.println("세션에서 꺼낸 ID: " + sessionId); // <-- 여기가 null이면 로그인이 안 된 상태입니다.
	    if (sessionId != null) {
	        Member member = memberService.getMemberInfo(sessionId); 
	        
//	        System.out.println("================================");
//	        System.out.println("마이페이지 조회 ID: " + sessionId);
//	        System.out.println("DB 조회 전체 결과: " + member);
//	        System.out.println("================================");
	        
	        // 2. JSP로 전달
	        model.addAttribute("member", member);
	    }
	    // 3. 정보를 수정할 수 있는 JSP 파일의 경로를 리턴합니다.
	    return "/member/user-mypage-update"; // 실제 JSP 파일명이 있는 경로로 적어주세요!
	}
	// 3-13 내 정보 수정 업데이트
	@RequestMapping(value = "/updateMemberInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editMypage(@RequestParam HashMap<String, Object> map) throws Exception {
		System.out.println("프론트에서 넘어온 데이터 전체: " + map);
		HashMap<String, Object> resultMap = memberService.EditMemberInfo(map);
	    return new Gson().toJson(resultMap);
	}
	// 3-14. 회원 탈퇴 (상태 변경)
	@RequestMapping(value = "/leaveMember.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String leaveMember(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = memberService.editUserStatus(map);
	    // 탈퇴 성공 시 세션 무효화
	    if ("success".equals(resultMap.get("result"))) {
	        session.invalidate();
	    }
	    return new Gson().toJson(resultMap);
	}
	// 3-15. 회원 쿠폰 조회
	@RequestMapping("/myCouponPage.do")
	public String myCouponPage() {
	    return "/member/user-mypage-coupon"; // 쿠폰 조회를 위한 JSP 파일 경로
	}
	@ResponseBody
	@GetMapping("/api/myCoupons.do")
	public List<HashMap<String, Object>> getMyCoupons(HttpSession session) {
	    // 세션에서 로그인한 아이디 가져오기
	    String userId = (String) session.getAttribute("sessionId");
	    
	    if (userId == null) {
	        return null; // 또는 에러 처리
	    }
	    
	    return memberService.getUserCouponList(userId);
	}
	// 3-16. 쿠폰 등록
	    @PostMapping("/coupon/register.do")
	    @ResponseBody // JSON 반환
	    public HashMap<String, Object> registerCoupon(@RequestBody HashMap<String, Object> map, HttpSession session) {
	        HashMap<String, Object> resultMap = new HashMap<>();
	        
	        // 1. 세션에서 현재 로그인한 유저 ID 확인
	        String userId = (String) session.getAttribute("sessionId");
	        
	        if (userId == null) {
	            // 로그인이 안 되어 있는 경우
	            resultMap.put("result", "fail");
	            resultMap.put("message", "로그인 후 이용 가능합니다.");
	            return resultMap;
	        }

	        // 2. 서비스 단에 전달할 데이터 세팅 (유저 ID 추가)
	        map.put("userId", userId);

	        try {
	            // 3. 서비스 호출 및 결과 확인
	            // 서비스에서 리턴하는 문자열(SUCCESS, DUPLICATED, INVALID_CODE 등)에 따라 분기 처리
	            String serviceResult = memberService.registerCouponService(map);
	            
	            if ("SUCCESS".equals(serviceResult)) {
	                resultMap.put("result", "success");
	                resultMap.put("message", "쿠폰이 성공적으로 등록되었습니다! 🎉");
	            } else if ("DUPLICATED".equals(serviceResult)) {
	                resultMap.put("result", "fail");
	                resultMap.put("message", "이미 등록된 쿠폰입니다.");
	            } else if ("INVALID_CODE".equals(serviceResult)) {
	                resultMap.put("result", "fail");
	                resultMap.put("message", "유효하지 않은 쿠폰 번호입니다.");
	            } else {
	                resultMap.put("result", "fail");
	                resultMap.put("message", "등록 중 오류가 발생했습니다.");
	            }
	        } catch (Exception e) {
	            // 예외 발생 시 로그 출력 및 실패 메시지 전달
	            e.printStackTrace();
	            resultMap.put("result", "error");
	            resultMap.put("message", "서버 오류가 발생했습니다. 관리자에게 문의하세요.");
	        }
	        return resultMap;
	    }
	// 3-17. 열람권 잔여 횟수 조회
	@GetMapping("/myPassWallet.dox")
	@ResponseBody
	public Member getPassWallet(HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
//	    System.out.println("세션 userId: " + userId);
	    return memberService.getPassWallet(userId);
	}
	// 3-18. 멤버십 결제 내역 조회
	@GetMapping("/myPassWalletList.dox")
	@ResponseBody
	public List<Member> getPassWalletList(HttpSession session) {
		String userId = (String) session.getAttribute("sessionId");
		return memberService.getPassWalletList(userId);
	}
	// 3-19. 내 예약 목록 조회
	@GetMapping("/myReservation.do")
	public String myReservation(HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    if(userId == null) return "redirect:/login.do";
	    return "/member/user-mypage-res-list";
	}
	@GetMapping("/myReservationList.dox")
	@ResponseBody
	public List<Member> getMyReservationList(HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    return memberService.getMyReservationList(userId);
	}
	// 3-20. 내가 구매한 리뷰 목록 조회(유료/무료)
	@GetMapping("/myPaidReviewList.dox")
	@ResponseBody
	public Map<String, Object> getMyPaidReviewList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    
//	    List<Member> list = memberService.getMyPaidReviewList(userId, page);
//	    System.out.println("리뷰 목록: " + list); // 추가
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyPaidReviewList(userId, page));
	    result.put("totalCount", memberService.getMyPaidReviewCount(userId));
	    result.put("pageSize", 6);
	    result.put("currentPage", page);
	    return result;
	}
	// 무료
	@GetMapping("/myFreeReviewList.dox")
	@ResponseBody
	public Map<String, Object> getMyFreeReviewList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    
//	    List<Member> list = memberService.getMyPaidReviewList(userId, page);
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyFreeReviewList(userId, page));
	    result.put("totalCount", memberService.getMyFreeReviewCount(userId));
	    result.put("pageSize", 6);
	    result.put("currentPage", page);
	    return result;
	}
	// 내가 쓴 글 조회
	@GetMapping("/myPostList.dox")
	@ResponseBody
	public Map<String, Object> getMyPostList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyPostList(userId, page));
	    result.put("totalCount", memberService.getMyPostCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 내가 쓴 글 리뷰
	@GetMapping("/myReviewList.dox")
	@ResponseBody
	public Map<String, Object> getMyReviewList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyReviewList(userId, page));
	    result.put("totalCount", memberService.getMyReviewCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 내가 쓴 댓글 조회
	@GetMapping("/myCommentList.dox")
	@ResponseBody
	public Map<String, Object> getMyCommentList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyCommentList(userId, page));
	    result.put("totalCount", memberService.getMyCommentCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 업체 좋아요 조회
	@GetMapping("/myCompanyLikeList.dox")
	@ResponseBody
	public Map<String, Object> getMyCompanyLikeList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyCompanyLikeList(userId, page));
	    result.put("totalCount", memberService.getMyCompanyLikeCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 글 좋아요 조회
	@GetMapping("/myPostLikeList.dox")
	@ResponseBody
	public Map<String, Object> getMyPostLikeList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyPostLikeList(userId, page));
	    result.put("totalCount", memberService.getMyPostLikeCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 리뷰 좋아요 조회
	@GetMapping("/myReviewLikeList.dox")
	@ResponseBody
	public Map<String, Object> getMyReviewLikeList(
	        @RequestParam(defaultValue = "1") int page,
	        HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberService.getMyReviewLikeList(userId, page));
	    result.put("totalCount", memberService.getMyReviewLikeCount(userId));
	    result.put("pageSize", 5);
	    result.put("currentPage", page);
	    return result;
	}
	// 내가 쓴 글 삭제
	@PostMapping("/deleteMyPost.dox")
	@ResponseBody
	public Map<String, Object> deleteMyPost(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    map.put("userId", userId);
	    int res = memberService.removeMyPost(userId, (String) map.get("postNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 내가 쓴 리뷰 삭제
	@PostMapping("/deleteMyReview.dox")
	@ResponseBody
	public Map<String, Object> deleteMyReview(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    int res = memberService.removeMyReview(userId, (String) map.get("reviewNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 내가 쓴 댓글 삭제
	@PostMapping("/deleteMyComment.dox")
	@ResponseBody
	public Map<String, Object> deleteMyComment(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    int res = memberService.removeMyComment(userId, (String) map.get("commentNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 업체 좋아요 취소
	@PostMapping("/deleteMyCompanyLike.dox")
	@ResponseBody
	public Map<String, Object> deleteMyCompanyLike(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    int res = memberService.deleteMyCompanyLike(userId, (String) map.get("likeNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 글 좋아요 취소
	@PostMapping("/deleteMyPostLike.dox")
	@ResponseBody
	public Map<String, Object> deleteMyPostLike(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    int res = memberService.deleteMyPostLike(userId, (String) map.get("likeNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 리뷰 좋아요 취소
	@PostMapping("/deleteMyReviewLike.dox")
	@ResponseBody
	public Map<String, Object> deleteMyReviewLike(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    String userId = (String) session.getAttribute("sessionId");
	    int res = memberService.deleteMyReviewLike(userId, (String) map.get("likeNo"));
	    result.put("result", res > 0 ? "success" : "fail");
	    return result;
	}
	// 내 문의 내역 조회
	@GetMapping("/myInquiryList.dox")
	@ResponseBody
	public List<Member> getMyInquiryList(HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    return memberService.getMyInquiryList(userId);
	}
	// 내 신고 내역 조회
	@GetMapping("/myReportList.dox")
	@ResponseBody
	public List<Member> getMyReportList(HttpSession session) {
	    String userId = (String) session.getAttribute("sessionId");
	    return memberService.getMyReportList(userId);
	}
	
	
	
	// * 휴대전화 번호 인증 * 
	// 인증번호 발송
	@RequestMapping(value = "/sendSms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendSms(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = smsService.sendSms(map);
	    return new Gson().toJson(resultMap);
	}

	// 인증번호 확인
	@RequestMapping(value = "/checkSms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkSms(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
	    HashMap<String, Object> resultMap = smsService.checkSms(map);
	    // userId가 있을 때만 세션 저장 (비밀번호 찾기 용도)
	    if ("success".equals(resultMap.get("result")) && map.get("userId") != null) {
	        session.setAttribute("authUserId", map.get("userId"));
	        session.setAttribute("isVerified", true);
	    }
	    return new Gson().toJson(resultMap);
	}
	
	// * 유료 리뷰 열람 시 열람 권 차감 * -> 태화님이 새로 만든다고 해서 안쓸 듯.
		@PostMapping("/usePass.dox")
		@ResponseBody
		public HashMap<String, Object> usePass(@RequestBody HashMap<String, Object> map, HttpSession session) {
		    String userId = (String) session.getAttribute("sessionId");
		    map.put("userId", userId);
		    return memberService.decreasePass(map);
		}
	
	// *메인 홈 출력* 
		@GetMapping("/mainPostList.dox")
		@ResponseBody
		public List<Member> getMainPostList() {
		    return memberService.getMainPostList();
		}
	// 회사 소개 페이지
		@GetMapping("/about.do")
		public String about() {
		    return "/common/home-about";
		}
	// 찾아오시는 길 페이지
		@Value("${kakao.map.key:none}")
		private String kakaoMapKey;

		@GetMapping("/location.do")
		public String location(Model model) {
		    model.addAttribute("kakaoMapKey", kakaoMapKey);
		    return "/common/home-about2";
		}
	 
	// 최근 리뷰
		@GetMapping("/mainReviewList.dox")
		@ResponseBody
		public List<Member> getMainReviewList(HttpSession session) {
			String userId = (String) session.getAttribute("sessionId");
		    return memberService.getMainReviewList(userId);
		}
		  
	// 챗봇 로그 저장
		@PostMapping("/ask")
		public ResponseEntity<?> askChatbot(@RequestBody Map<String, String> params, HttpSession session) {
			// 구조를 따라가서 실제 질문 텍스트를 추출합니다.
			String question = params.get("prompt");
		    if (question == null || question.isEmpty()) {
		        return ResponseEntity.badRequest().body("질문이 비어있습니다.");
		    }
		    // 2. 실제 AI 응답 가져오기 (가짜 텍스트 대신 실제 서비스 호출)
		    String answer;
	        try {
	            answer = geminiService.getContents(question); // 2. 여기서 AI 답변을 받아옵니다.
	        } catch (Exception e) {
	            e.printStackTrace();
	            answer = "죄송합니다. 제미나이 AI와 연결하는 중 오류가 발생했습니다. 😢";
	        }
		    
		    // DB 저장 로직 (userId가 세션에 있으면 저장)
		    String userId = (String) session.getAttribute("userId");
		    memberService.saveChatLog(userId, question, answer, "AI");

		 // 4. Vue가 받기 편하게 단순한 Map 구조로 응답합니다.
		    Map<String, String> result = new HashMap<>();
		    result.put("answer", answer);
		    return ResponseEntity.ok(result);
		}
		@PostMapping("/saveLog")
		@ResponseBody
		public String saveLog(@RequestBody Map<String, Object> params, HttpSession session) {
			// 1. 프론트엔드(JS)에서 보낸 데이터 꺼내기
		    String question = (String) params.get("question");
		    String answer = (String) params.get("answer");
		    String type = (String) params.get("type");
		    
		    // 2. 세션에서 로그인한 사용자 아이디 가져오기
		    String userId = (String) session.getAttribute("sessionId");

		    // 3. 서비스 호출 (이게 있어야 DB에 들어갑니다!)
		    memberService.saveChatLog(userId, question, answer, type);

		    return "success";
		}
}
