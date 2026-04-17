package com.example.demo.community_review.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.community_review.model.Review;

@Mapper
public interface ReviewMapper {
    // XML의 id와 메서드명이 일치해야 합니다.
    int insertReview(Review review);
    List<Review> selectReviewList();
    
// --- 좋아요 관련 메서드 추가 ---
    
    // 1. 좋아요 여부 확인 (파라미터가 2개 이상일 땐 @Param을 붙여주는 게 안전합니다)
    int checkReviewLike(HashMap<String, Object> map);
    
    // 2. 좋아요 기록 추가
    void insertReviewLike(HashMap<String, Object> map);
    
    // 3. 좋아요 기록 삭제
    void deleteReviewLike(HashMap<String, Object> map);
    
    // 4. 리뷰 테이블의 like_cnt 증감 (amount에 1 또는 -1 전달)
    void updateReviewLikeCount(HashMap<String, Object> map);
}