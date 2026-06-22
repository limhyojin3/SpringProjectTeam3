package com.example.demo.company.mapper;

import java.util.List;
import java.util.Map;
import com.example.demo.company.model.Company;
import com.example.demo.company.model.Review;

public interface CompanyMapper {
    // 업체 프로필 및 회원 정보 조회
    Company selectCompany(Map<String, Object> map);
    
    // 업체 일련번호 조회
    String selectCompanyByUserId(String userId);
    
    // 리뷰 통계 및 카운트 조회 관련 (결과 가방을 유연한 Map 구조로 변경하여 무거운 DTO 의존 제거)
    List<Map<String, Object>> selectReviewCnt(Map<String, Object> map);
    List<Map<String, Object>> selectSimpleReviewCnt(Map<String, Object> map);
    Map<String, Object> selectNewReviewCnt(Map<String, Object> map);
    Map<String, Object> selectNewSimpleReviewCnt(Map<String, Object> map);
    
    // 리뷰 상세 내역 조회
    List<Review> selectReviewDetails3(Map<String, Object> map);
    List<Review> selectSimpleReviewDetails3(Map<String, Object> map);
    
    // 신규 라벨 상태 업데이트
    int updateOldNewLabels(Map<String, Object> map);
}