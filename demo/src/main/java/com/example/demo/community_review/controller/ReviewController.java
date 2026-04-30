package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.community_review.dao.FileService;
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
    private FileService fileService;
    
    private Gson gson = new Gson();

    // --- [페이지 이동] ---
    
    @RequestMapping("/list.do")
    public String reviewList(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");
        model.addAttribute("sessionId", sessionId);
        return "/review/review-list"; 
    }

    @RequestMapping("/add.do")
    public String goReviewAdd(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");
        model.addAttribute("sessionId", sessionId);
        return "/review/review-add"; 
    }

    @RequestMapping("/detail.do")
    public String goReviewDetail(@RequestParam("reviewNo") String reviewNo, HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");
        try {
            HashMap<String, Object> map = new HashMap<>();
            map.put("reviewNo", reviewNo);
            
            HashMap<String, Object> review = reviewService.getReviewDetailInfo(map);
            
            if (review != null && sessionId != null) {
                String isPaid = String.valueOf(review.get("isPaid")); 
                String writerId = (String) review.get("userId");

                // 무료리뷰이고 본인 글이 아닐 때만 로그 저장
                if (("0".equals(isPaid) || "N".equals(isPaid) || "false".equals(isPaid)) && !sessionId.equals(writerId)) {
                    reviewService.saveFreeViewLog(map, sessionId); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

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
            int count = reviewService.getReviewCount(map);
            List<HashMap<String, Object>> list = reviewService.selectReviewList(map);
            List<HashMap<String, Object>> bestList = reviewService.selectBestReviewList(map);
            
            resultMap.put("count", count);
            resultMap.put("list", list);
            resultMap.put("result", "success");
            resultMap.put("bestList", bestList);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        return gson.toJson(resultMap);
    }
    
    /**
     * 리뷰 저장 (썸네일 추출 및 파일 처리 통합)
     */
    @PostMapping("/save.dox")
    @ResponseBody
    public String saveReview(
            HttpServletRequest request, 
            @RequestParam("reviewData") String reviewDataJson,
            @RequestParam(value = "receiptFile", required = false) MultipartFile receiptFile,
            @RequestParam(value = "reviewFiles", required = false) List<MultipartFile> reviewFiles) {
        try {
            Review review = gson.fromJson(reviewDataJson, Review.class);
            
            HttpSession session = request.getSession();
            String currentId = (String) session.getAttribute("sessionId");
            
            if (currentId == null) {
                return "{\"result\":\"fail\", \"message\":\"로그인이 필요합니다.\"}";
            }
            
            review.setUserId(currentId);

            // [영수증 파일 처리]
            if (receiptFile != null && !receiptFile.isEmpty()) {
                Map<String, String> fileInfo = fileService.uploadFile(receiptFile);
                if (fileInfo != null) {
                    // 유료 리뷰일 경우에만 메인 이미지 컬럼들에 정보 채움
                    if ("1".equals(String.valueOf(review.getIsPaid()))) {
                        review.setOriginalName(fileInfo.get("originalName"));
                        review.setStoredName(fileInfo.get("storedName"));
                        review.setImgUrl(fileInfo.get("imgUrl"));
                    } 
                    // 공통 영수증 증빙 정보 저장
                    review.setReceiptName(fileInfo.get("storedName")); 
                }
            }
            
            // [핵심: 서비스 호출]
            // 서비스 내부에서 extractThumbnail(review.getContent())를 호출하여 
            // review.setThumbnailUrl()이 수행되도록 구현되어 있어야 합니다.
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
                    if ("viewed_reviews".equals(cookie.getName())) {
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
                if (cookies == null || java.util.Arrays.stream(cookies).noneMatch(c -> "viewed_reviews".equals(c.getName()))) {
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
    public String toggleLike(HttpServletRequest request, @RequestBody HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            HttpSession session = request.getSession();
            String currentId = (String) session.getAttribute("sessionId");
            map.put("userId", currentId);
            
            resultMap = reviewService.toggleReviewLike(map);
        } catch (Exception e) {
            resultMap.put("result", "error");
            resultMap.put("message", e.getMessage());
        }
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/useTicket.dox")
    @ResponseBody
    public String useTicket(HttpServletRequest request, @RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        String sessionId = (String) session.getAttribute("sessionId");
        String sessionRole = (String) session.getAttribute("sessionRole");

        if (sessionId == null) {
            resultMap.put("result", "LOGIN_REQUIRED");
            return gson.toJson(resultMap);
        }

        // 관리자 프리패스
        if ("ADMIN".equals(sessionRole)) {
            resultMap.put("result", "SUCCESS");
            resultMap.put("message", "관리자 권한으로 프리패스합니다.");
            return gson.toJson(resultMap);
        }

        // 본인 글 체크
        String writerId = (String) map.get("userId"); 
        if (sessionId.equals(writerId)) {
            resultMap.put("result", "SUCCESS");
            return gson.toJson(resultMap);
        }

        map.put("userId", sessionId);
        try {
            resultMap = reviewService.useAccessTicket(map);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "ERROR");
        }
        
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/getUserAccessCount.dox")
    @ResponseBody
    public String getUserAccessCount(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) map.get("userId");
        
        Integer count = reviewService.getUserAccessCount(userId); 
        
        resultMap.put("count", count != null ? count : 0);
        return gson.toJson(resultMap);
    }
    
    @PostMapping("/productList.dox")
    @ResponseBody
    public Map<String, Object> getProductList(@RequestBody Map<String, Object> map) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = reviewService.getProductListByCompany(map);
            result.put("list", list);
            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "error");
        }
        return result;
    }
}