package com.example.demo.community_review.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import com.example.demo.community_review.model.Review;

@Mapper
public interface ReviewMapper {

    /**
     * [1] 리뷰 기본 관리 (CRUD)
     */
    // 리뷰 등록
    int insertReview(Review review);
    
    // 전체 리뷰 목록 조회 (검색/필터 통합)
    List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> map);
    
    // 리뷰 상세 정보 조회
    HashMap<String, Object> selectReviewDetail(HashMap<String, Object> map);
    
    // (필요 시 유지) 무료 리뷰 전용 목록 조회
    List<HashMap<String, Object>> selectFreeReviewList(HashMap<String, Object> map);


    /**
     * [2] 상호작용 (좋아요 & 조회수)
     */
    // 조회수 증가
    int updateViewCount(Map<String, Object> map);
    
    // 좋아요 여부 확인 (1: 이미 누름, 0: 안 누름)
    int checkReviewLike(HashMap<String, Object> map);
    
    // 좋아요 기록 추가 (Review_Like 테이블)
    void insertReviewLike(HashMap<String, Object> map);
    
    // 좋아요 기록 삭제 (Review_Like 테이블)
    void deleteReviewLike(HashMap<String, Object> map);
    
    // 리뷰 본문 테이블의 like_cnt 증감
    void updateReviewLikeCount(HashMap<String, Object> map);


    /**
     * [3] 업체(Company) 관련 정보
     */
    // 업체 상세 정보 조회
    HashMap<String, Object> selectCompanyDetail(HashMap<String, Object> map);
    
    // 활성화된 업체 목록 조회 (리뷰 등록 시 선택용)
    List<HashMap<String, Object>> selectActiveCompanyList(HashMap<String, Object> map);


    
}