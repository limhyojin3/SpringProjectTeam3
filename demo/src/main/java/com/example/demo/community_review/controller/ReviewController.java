package com.example.demo.community_review.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
        // ✅ MemberController에서 사용하는 "sessionId"로 통일
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

 // --- [페이지 이동 및 로그 저장] ---

    @RequestMapping("/detail.do")
    public String goReviewDetail(@RequestParam("reviewNo") String reviewNo, HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");

        try {
            // 리뷰 상세 정보를 가져오기 위한 맵 세팅
            HashMap<String, Object> map = new HashMap<>();
            map.put("reviewNo", reviewNo);
            
            // 1. 리뷰 상세 정보를 DB에서 조회
            HashMap<String, Object> review = reviewService.getReviewDetailInfo(map);
            
            if (review != null && sessionId != null) {
                // DB 타입에 상관없이 비교하기 위해 String으로 변환
                String isPaid = String.valueOf(review.get("isPaid")); 
                String writerId = (String) review.get("userId");

                // 디버깅 콘솔 출력 (로그 안쌓이면 서버 콘솔 확인용)
                System.out.println("=== 무료리뷰 열람 로그 체크 ===");
                System.out.println("접속자: " + sessionId + " | 작성자: " + writerId + " | 유료여부: " + isPaid);

                // 조건: 무료리뷰(0 또는 N) 이고 + 내가 쓴 글이 아닐 때만 저장
                if (("0".equals(isPaid) || "N".equals(isPaid)) || "false".equals(isPaid) && !sessionId.equals(writerId)) {
                    System.out.println("결과: 무료 리뷰 열람 - 로그 저장 실행");
                    reviewService.saveFreeViewLog(map, sessionId); 
                } else {
                    System.out.println("결과: 조건 미충족 (유료리뷰거나 본인글임)");
                }
            }
        } catch (Exception e) {
            System.out.println("로그 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }

        // 뷰(JSP/HTML)로 데이터 전달
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
            
            resultMap.put("count", count);
            resultMap.put("list", list);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        return gson.toJson(resultMap);
    }
    
    /**
     * 리뷰 저장 (세션 키 "sessionId" 적용)
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
            // ✅ "userId" 대신 "sessionId"를 꺼내옵니다.
            String currentId = (String) session.getAttribute("sessionId");
            
            // 로그인 체크 로직 (DB 에러 방지)
            if (currentId == null) {
                return "{\"result\":\"fail\", \"message\":\"로그인이 필요합니다.\"}";
            }
            
            review.setUserId(currentId);

         // --- [파일 처리 로직 수정] ---
            if (receiptFile != null && !receiptFile.isEmpty()) {
                Map<String, String> fileInfo = fileService.uploadFile(receiptFile);
                if (fileInfo != null) {
                	// ✅ is_paid가 1(유료)인 경우에만 이미지 컬럼을 채움
                    // 만약 Review 모델에서 isPaid가 String이면 "1".equals(...) 
                    // int 타입이면 review.getIsPaid() == 1 로 비교
                    if ("1".equals(review.getIsPaid()) || Integer.valueOf(1).equals(review.getIsPaid())) {
                        review.setOriginalName(fileInfo.get("originalName"));
                        review.setStoredName(fileInfo.get("storedName"));
                        review.setImgUrl(fileInfo.get("imgUrl"));
                    } 
                    
                    // 무료/유료 공통으로 영수증 증빙 컬럼은 채워줌 (상태 관리용)
                    // 만약 DB 컬럼명이 receipt_name 이라면 아래와 같이 세팅
                    review.setReceiptName(fileInfo.get("storedName")); 
                }
            }
            // ---------------------------
            
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
    public String toggleLike(HttpServletRequest request, @RequestBody HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            HttpSession session = request.getSession();
            // ✅ "userId" 대신 "sessionId" 적용
            String currentId = (String) session.getAttribute("sessionId");
            map.put("userId", currentId);
            
            resultMap = reviewService.toggleReviewLike(map);
        } catch (Exception e) {
            resultMap.put("result", "error");
            resultMap.put("message", e.getMessage());
        }
        return gson.toJson(resultMap);
    }
    
    // 열람권 사용
    @PostMapping("/useTicket.dox")
    @ResponseBody
    public String useTicket(HttpServletRequest request, @RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");

        if (sessionId == null) {
            resultMap.put("result", "LOGIN_REQUIRED");
            return new Gson().toJson(resultMap);
        }

        map.put("userId", sessionId);
        
        try {
            resultMap = reviewService.useAccessTicket(map);
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "ERROR");
        }
        
        return new Gson().toJson(resultMap);
    }
    
    // 사용자의 남은 열람권
    @PostMapping("/getUserAccessCount.dox")
    @ResponseBody
    public String getUserAccessCount(@RequestBody HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) map.get("userId");
        
        // 이전에 만든 Mapper의 getUserAccessCount 호출
        Integer count = reviewService.getUserAccessCount(userId); 
        
        resultMap.put("count", count != null ? count : 0);
        return new Gson().toJson(resultMap);
    }
    
    @PostMapping("/productList.dox")
    @ResponseBody
    public Map<String, Object> getProductList(@RequestBody Map<String, Object> map) {
        Map<String, Object> result = new HashMap<>();
        try {
            // map 안에 프론트에서 보낸 companyNo가 들어있음
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