package com.example.marryview.community_review.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.marryview.community_review.model.Inquiry;

@Mapper
public interface InquiryMapper {
	// 1:1 문의 등록
    int insertInquiry(HashMap<String, Object> map);

    // 내 문의 목록 조회
    List<Inquiry> selectMyInquiryList(HashMap<String, Object> map);

    // 문의 상세 조회 (상세 모달용)
    Inquiry selectInquiryDetail(HashMap<String, Object> map);

    // [문의 삭제] 문의글을 삭제 상태로 변경합니다.
    int deleteInquiry(Long inquiryNo);
    
    int selectInquiryCount(HashMap<String, Object> map);
}