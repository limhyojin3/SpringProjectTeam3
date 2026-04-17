package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.ReviewMapper;
import com.example.demo.community_review.model.Review;
import com.google.gson.Gson;

@Service
public class ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private FileService fileService;
    
    public List<Review> getReviewList(HashMap<String, Object> map) {
        return reviewMapper.selectReviewList(map);
    }
    

    /**
     * 리뷰 등록 로직 (영수증 파일 처리 포함)
     * @param review 작성된 리뷰 데이터 객체
     * @param file   영수증 파일 (필수)
     * @return JSON 문자열 (Message 객체 기반)
     */
    @Transactional(rollbackFor = Exception.class) 
    public String registerReview(Review review, MultipartFile file) {
        Gson gson = new Gson();
        
        // 1. 영수증 파일 필수 검증
        if (file == null || file.isEmpty()) {
            // "fail" 결과와 함께 에러 메시지 객체를 JSON으로 변환해서 리턴
            return gson.toJson(new Message("fail", "영수증 인증은 필수입니다."));
        }

        try {
            // 2. 파일 처리 (물리적 저장 및 파일명 세팅)
            review.setOriginalName(file.getOriginalFilename());
            String savedName = fileService.uploadFile(file); // FileService에서 UUID 파일명 리턴
            
            review.setStoredName(savedName);
            review.setImgUrl("/uploads/" + savedName); // 웹 접근 경로 세팅

            // 3. DB 저장 (이미 Controller에서 userId가 세팅된 상태)
            int result = reviewMapper.insertReview(review);
            
            // 4. 결과 리턴 (성공 시 SUCCESS_ADD 객체 상수를 JSON으로 변환)
            if (result > 0) {
                return gson.toJson(Message.SUCCESS_ADD);
            } else {
                return gson.toJson(Message.FAIL_SERVER);
            }

        } catch (Exception e) {
            e.printStackTrace(); 
            // 트랜잭션 롤백을 위해 RuntimeException 발생시키면서 에러 메시지 던짐
            throw new RuntimeException(gson.toJson(Message.FAIL_SERVER));
        }
    }
}