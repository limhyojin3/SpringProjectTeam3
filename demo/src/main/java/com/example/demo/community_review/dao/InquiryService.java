package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message; // [간단주석] 공유해주신 메시지 규격 사용
import com.example.demo.community_review.mapper.InquiryMapper;
import com.example.demo.community_review.model.Inquiry;

@Service
public class InquiryService {

    @Autowired
    private InquiryMapper inquiryMapper;

 // 문의 등록
    public Map<String, Object> addInquiry(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        int res = inquiryMapper.insertInquiry(map);
        resultMap.put("result", res > 0 ? "success" : "fail");
        return resultMap;
    }

    // 목록 조회
    public Map<String, Object> getMyInquiryList(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        List<Inquiry> list = inquiryMapper.selectMyInquiryList(map);
        resultMap.put("list", list);
        resultMap.put("result", "success");
        return resultMap;
    }

    // 상세 조회
    public Map<String, Object> getInquiryDetail(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        Inquiry info = inquiryMapper.selectInquiryDetail(map);
        resultMap.put("info", info);
        resultMap.put("result", "success");
        return resultMap;
    }

    // 문의 삭제
    public String removeInquiry(Long inquiryNo) {
        return (inquiryMapper.deleteInquiry(inquiryNo) > 0) ? Message.MSG_REMOVE : Message.MSG_ERR;
    }
}