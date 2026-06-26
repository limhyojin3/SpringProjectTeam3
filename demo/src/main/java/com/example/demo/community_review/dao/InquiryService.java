package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.InquiryMapper;
import com.example.demo.community_review.model.Inquiry;
import com.example.demo.admin.dao.NotificationService;

@Service
public class InquiryService {

    @Autowired
    private InquiryMapper inquiryMapper;
    
    @Autowired
    private NotificationService notificationService;

    // 문의 등록
    public Map<String, Object> addInquiry(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        int res = inquiryMapper.insertInquiry(map);
        notificationService.createInquiryReceived(
        	    map.get("inquiryNo"),
        	    (String) map.get("userId")
        	);
        resultMap.put("result", res > 0 ? "success" : "fail");
        return resultMap;
    }

    // 목록 조회 (페이징 및 필터 데이터 가공)
    public Map<String, Object> getMyInquiryList(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        
        // 1. 필터링된 문의 목록 조회 (LIMIT 포함)
        List<Inquiry> list = inquiryMapper.selectMyInquiryList(map);
        
        // 2. 필터링된 문의 전체 개수 조회 (페이징 버튼 계산용)
        int totalCount = inquiryMapper.selectInquiryCount(map);
        
        resultMap.put("list", list);
        resultMap.put("totalCount", totalCount); // 이 값이 있어야 JSP에서 페이징이 돌아갑니다.
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
        // 이미 Message 규격을 쓰고 계시니 그대로 유지합니다.
        return (inquiryMapper.deleteInquiry(inquiryNo) > 0) ? Message.MSG_REMOVE : Message.MSG_ERR;
    }
}