package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.community_review.dao.ReviewService;
import com.example.demo.community_review.model.Review;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/review")
public class ReviewController {
	
	@Autowired
    private ReviewService reviewService;
	// --- [페이지 이동] ---
    // 전체/무료/유료 통합 리뷰 게시판 홈
    @RequestMapping("/list.do")
    public String reviewList(HttpServletRequest request, org.springframework.ui.Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        // JSP에서 로그인 여부 및 작성자 본인 확인용으로 사용
        model.addAttribute("sessionId", sessionId);
        
        return "/review/review-list"; // 새로 만들 통합 JSP 파일명 
    }

    /**
     * 리뷰 작성 페이지로 이동
     * 주소: /review/add.do
     */
    @RequestMapping("/add.do")
    public String goReviewAdd(HttpServletRequest request, org.springframework.ui.Model model) {
        // 지금은 아이디를 고정해서 쓰고 있지만, 
        // 나중에 세션을 쓸 때를 대비해 세션 아이디를 모델에 담아줍니다.
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        
        // 만약 세션이 없으면 테스트용 아이디를 강제로 넘겨줄 수도 있습니다.
        if(sessionId == null) {
            sessionId = "seoyeonbride";
        }
        
        model.addAttribute("sessionId", sessionId);
        
        // 리턴값은 JSP 파일의 경로입니다. (WEB-INF 하위 경로에 맞춰 수정하세요)
        return "/review/review-add"; 
    }

    // --- [데이터 통신] ---

    // 1. 업체 상세 정보 가져오기 (이게 안 떠서 문제였던 부분!)
    @RequestMapping("/company-detail.dox") // 주소가 /api/review/company-detail.dox 가 됩니다.
    @ResponseBody
    public String getCompanyDetail(@RequestParam HashMap<String, Object> map) {
        // map 안에 companyNo가 담겨서 옵니다.
        return new Gson().toJson(reviewService.getCompanyDetail(map));
    }

    /**
     * 통합 리뷰 리스트 가져오기 (전체/유료/무료 필터링)
     * @param map { isPaid: null(전체) or 0(무료) or 1(유료), searchKeyword, searchType }
     */
    @PostMapping("/list.dox")
    @ResponseBody
    public String getReviewList(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        Gson gson = new Gson();
        
        try {
            // 서비스단에서 검색어 trim 및 통합 쿼리 실행
            List<HashMap<String, Object>> list = reviewService.selectReviewList(map);
            
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
            resultMap.put("message", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
        }
        
        return gson.toJson(resultMap);
    }
    
    /**
     * 통합 리뷰 저장 (무료/유료)
     * @param reviewDataJson : 프론트에서 보낸 JSON 문자열
     * @param receiptFile : 필수 영수증 파일
     * @param reviewFiles : 선택 리뷰 사진 리스트
     */
    @PostMapping("/save.dox")
    @ResponseBody
    public String saveReview(
            @RequestParam("reviewData") String reviewDataJson,
            @RequestParam("receiptFile") MultipartFile receiptFile,
            @RequestParam(value = "reviewFiles", required = false) List<MultipartFile> reviewFiles,
            HttpServletRequest request) {

        Gson gson = new Gson();
        
        try {
            // 1. JSON 데이터 변환
            Review review = gson.fromJson(reviewDataJson, Review.class);
            
         // 2. 로그인 체크 로직 (이 부분을 주석 처리해야 합니다!)
            /* HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("userId");
            if (userId == null) {
                return "{\"result\":\"fail\", \"message\":\"로그인이 필요합니다.\"}";
            }
            */

            // 3. 테스트용 아이디 강제 주입
            String fixedUserId = "seoyeonbride"; 
            review.setUserId(fixedUserId);

            // 3. 서비스 호출
            return reviewService.registerReview(review, receiptFile, reviewFiles);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"result\":\"error\", \"message\":\"서버 통신 중 오류가 발생했습니다.\"}";
        }
    }
}