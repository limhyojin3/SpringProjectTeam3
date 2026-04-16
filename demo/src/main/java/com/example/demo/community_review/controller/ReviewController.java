package com.example.demo.community_review.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.community_review.dao.ReviewService;
import com.example.demo.community_review.model.Review;

@RestController
@RequestMapping("/api/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    // 리뷰 등록 요청 수신
    // @ModelAttribute를 사용하면 폼 데이터(텍스트)를 Review 객체에 자동 매핑함
    @PostMapping("/add")
    public String addReview(Review review, 
                            @RequestParam(value = "file", required = false) MultipartFile file) {
        // 입력받은 데이터와 파일을 서비스로 전달하여 비즈니스 로직 수행
        return reviewService.registerReview(review, file);
    }
}