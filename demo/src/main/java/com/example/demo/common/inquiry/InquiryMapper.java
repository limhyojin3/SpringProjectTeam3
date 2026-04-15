package com.example.demo.common.inquiry;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface InquiryMapper {
    // [문의 등록] 사용자가 새로운 문의를 작성합니다.
    int insertInquiry(Inquiry inquiry);

    // [문의 목록] 본인이 작성한 문의글만 리스트로 확인합니다.
    List<Inquiry> selectInquiryList(String userId);

    // [문의 삭제] 문의글을 삭제 상태로 변경합니다.
    int deleteInquiry(Long inquiryNo);
}