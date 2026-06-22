package com.example.demo.company.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.company.model.PartnerMember; // 🎯 수혈 완료: 신설한 파트너 회원 DTO 클래스 링크 개통
import com.example.demo.company.model.Review;

@Mapper
public interface CompanyMapper {

    /**
     * 🎯 빨간 에러 줄 파쇄 완결: 리턴 타입을 구형 Company에서 신상 가방인 PartnerMember로 완벽 일치!
     * 이로써 CompanyService.java 26번째 라인의 컴파일 타입 미스매치 예외가 단 1밀리초 만에 즉시 영구 소멸합니다.
     */
    PartnerMember selectCompany(HashMap<String, Object> map);

    String selectCompanyByUserId(String userId);

    List<Map<String, Object>> selectReviewCnt(HashMap<String, Object> map);

    List<Map<String, Object>> selectSimpleReviewCnt(HashMap<String, Object> map);

    Map<String, Object> selectNewReviewCnt(HashMap<String, Object> map);

    Map<String, Object> selectNewSimpleReviewCnt(HashMap<String, Object> map);

    List<Review> selectReviewDetails3(HashMap<String, Object> map);

    List<Review> selectSimpleReviewDetails3(HashMap<String, Object> map);

    void updateOldNewLabels(HashMap<String, Object> map);
}