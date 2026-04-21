package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.community_review.dao.FileService; // FileService 임포트
import com.example.demo.community_review.dao.ReviewService;
import com.example.demo.community_review.model.Review;
import com.google.gson.Gson;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/review")
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;

    @Autowired
    private FileService fileService; // 고도화된 파일 서비스를 주입합니다.
    
    private Gson gson = new Gson();

    // --- [페이지 이동] ---
    
    @RequestMapping("/list.do")
    public String reviewList(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        model.addAttribute("sessionId", sessionId);
        return "/review/review-list"; 
    }

    @RequestMapping("/add.do")
    public String goReviewAdd(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        if(sessionId == null) sessionId = "th3613"; // 테스트용 고정
        model.addAttribute("sessionId", sessionId);
        return "/review/review-add"; 
    }

    @RequestMapping("/detail.do")
    public String goReviewDetail(@RequestParam("reviewNo") String reviewNo, HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("userId");
        if(sessionId == null) sessionId = "th3613"; // 테스트용 고정
        model.addAttribute("reviewNo", reviewNo);
        model.addAttribute("sessionId", sessionId);
        return "/review/review-detail";  
    }

    // --- [데이터 통신 API] ---

    @RequestMapping("/company-list.dox")
    @ResponseBody
    public String getActiveCompanyList(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = reviewService.selectActiveCompanyList(map);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        return gson.toJson(resultMap);
    }

    @PostMapping("/list.dox")
    @ResponseBody
    public String getReviewList(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            List<HashMap<String, Object>> list = reviewService.selectReviewList(map);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        return gson.toJson(resultMap);
    }
    
    /**
     * 리뷰 저장 (파일 고도화 적용)
     */
    @PostMapping("/save.dox")
    @ResponseBody
    public String saveReview(
            @RequestParam("reviewData") String reviewDataJson,
            @RequestParam(value = "receiptFile", required = false) MultipartFile receiptFile,
            @RequestParam(value = "reviewFiles", required = false) List<MultipartFile> reviewFiles) {
        try {
            // 1. JSON 데이터를 객체로 변환
            Review review = gson.fromJson(reviewDataJson, Review.class);
            
            // 2. 작성자 아이디 고정 (th3613)
            review.setUserId("th3613");

            // 3. 파일 업로드 처리 및 DB 컬럼 데이터 세팅 (영수증 파일 예시)
            if (receiptFile != null && !receiptFile.isEmpty()) {
                Map<String, String> fileInfo = fileService.uploadFile(receiptFile);
                if (fileInfo != null) {
                    // Review 모델에 형님이 말씀하신 3개 컬럼 필드가 있다고 가정합니다.
                    review.setOriginalName(fileInfo.get("originalName"));
                    review.setStoredName(fileInfo.get("storedName"));
                    review.setImgUrl(fileInfo.get("imgUrl"));
                }
            }
            
            // 4. 서비스 호출 (DB 저장)
            return reviewService.registerReview(review, receiptFile, reviewFiles);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"result\":\"error\", \"message\":\"서버 통신 중 오류\"}";
        }
    }
    
    @PostMapping("/detail.dox")
    @ResponseBody
    public String getReviewDetail(@RequestBody HashMap<String, Object> map, 
                                  HttpServletRequest request, 
                                  HttpServletResponse response) {
        HashMap<String, Object> resultMap = new HashMap<>();
        try {
            String reviewNo = String.valueOf(map.get("reviewNo"));
            Cookie[] cookies = request.getCookies();
            boolean isVisited = false;

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("viewed_reviews")) {
                        if (cookie.getValue().contains("|" + reviewNo + "|")) {
                            isVisited = true;
                        } else {
                            String newValue = cookie.getValue() + reviewNo + "|";
                            cookie.setValue(newValue);
                            cookie.setPath("/");
                            cookie.setMaxAge(60 * 60 * 24); 
                            response.addCookie(cookie);
                        }
                        break;
                    }
                }
            }

            if (!isVisited) {
                if (cookies == null || java.util.Arrays.stream(cookies).noneMatch(c -> c.getName().equals("viewed_reviews"))) {
                    Cookie newCookie = new Cookie("viewed_reviews", "|" + reviewNo + "|");
                    newCookie.setPath("/");
                    newCookie.setMaxAge(60 * 60 * 24);
                    response.addCookie(newCookie);
                }
                reviewService.plusViewCount(map);
            }

            HashMap<String, Object> info = reviewService.getReviewDetailInfo(map);
            if (info != null) {
                resultMap.put("info", info);
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "fail");
            }
        } catch (Exception e) {
            resultMap.put("result", "error");
        }
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/like.dox")
    @ResponseBody
    public String toggleLike(@RequestBody HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            // 좋아요 누를 때도 아이디 고정
            map.put("userId", "th3613");
            resultMap = reviewService.toggleReviewLike(map);
        } catch (Exception e) {
            resultMap.put("result", "error");
            resultMap.put("message", e.getMessage());
        }
        return gson.toJson(resultMap);
    }
}