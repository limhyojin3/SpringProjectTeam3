package com.example.demo.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.community_review.mapper.ReportMapper;
import com.example.demo.community_review.model.Report;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;

 // 신고 등록 (중복 체크 포함)
    public Map<String, Object> addReport(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            // 1. 중복 신고 여부 확인 (신고자ID, 타입, 대상ID 조합)
            int count = reportMapper.checkDuplicateReport(map);

            if (count > 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", "이미 신고하신 내역입니다.");
            } else {
                // 2. 신고 정보 저장
                int res = reportMapper.insertReport(map);
                if (res > 0) {
                    resultMap.put("result", "success");
                } else {
                    resultMap.put("result", "fail");
                    resultMap.put("message", "신고 접수에 실패했습니다.");
                }
            }
        } catch (Exception e) {
            resultMap.put("result", "error");
            resultMap.put("message", "서버 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return resultMap;
    }

    // 나의 신고 내역 조회
    public Map<String, Object> getMyReports(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        List<Report> list = reportMapper.selectMyReports(map);
        
        resultMap.put("list", list);
        resultMap.put("result", "success");
        
        return resultMap;
    }
}