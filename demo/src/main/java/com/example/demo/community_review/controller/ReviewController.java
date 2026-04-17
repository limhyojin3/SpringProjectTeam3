package com.example.demo.community_review.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;
import com.example.demo.community_review.dao.ReviewService;
import com.example.demo.community_review.model.Review;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/api/review")
public class ReviewController {
	
	// --- [페이지 이동 메서드] ---

	// 1. 리뷰 작성 페이지 이동
	@RequestMapping("/add.do")
	public String addPage() {
	    // 리턴값은 JSP 파일의 경로입니다.
	    // 설정에 따라 /WEB-INF/views/review/review-add.jsp 등을 찾아갑니다.
	    return "/review/review-add"; 
	}
	// 2. 리뷰 목록 조회
	@RequestMapping("/list.do")
	public String listPage() {
	    return "/review/review-list"; // jsp 경로
	}

    @Autowired
    private ReviewService reviewService;
    
    @RequestMapping("/list.dox")
    @ResponseBody
    public String getList(@RequestParam HashMap<String, Object> map) {
        // 이제 map 안에 검색어, 카테고리 필터 등을 담아서 던질 수 있습니다.
        return new Gson().toJson(reviewService.getReviewList(map));
    }

    @PostMapping("/add.dox")
    @ResponseBody
    public String addReview(
        @RequestParam("file") MultipartFile file, // 필수 전달
        @RequestParam("reviewData") String reviewDataJson,
        HttpServletRequest request
    ) {
    	
    	Gson gson = new Gson();
        // 1. 세션에서 사용자 아이디 가져오기
//        String sessionId = (String) request.getSession().getAttribute("userId");
    	String sessionId = "seoyeonbride";
        
        // [로그인 체크] 만약 세션이 null이면 바로 실패 리턴
//        if (sessionId == null || sessionId.equals("")) {
//        	return new Gson().toJson(Message.FAIL_LOGIN);        
//        	}
        try {
        	// 2. JSON 데이터 파싱
            Review review = gson.fromJson(reviewDataJson, Review.class);
            
            // 3. 세션 아이디를 객체에 강제 주입 (사용자 조작 방지)
            review.setUserId(sessionId);
            
            // 4. 서비스 호출 (서비스에서 결과 JSON을 직접 리턴하게 수정했다면 그대로 리턴)
            return reviewService.registerReview(review, file);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
	        return gson.toJson(Message.FAIL_SERVER);
		}
        // 등록 실패 : 저장되었습니다 라고 떠서 고쳐야됨.

        
    }
}