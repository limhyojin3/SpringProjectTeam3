package com.example.demo.community_review.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.ReportService;

@RestController
@RequestMapping("/api/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

 // 신고하기 실행
    @PostMapping("/add.dox")
    public Map<String, Object> addReport(@RequestBody HashMap<String, Object> map) {
        return reportService.addReport(map);
    }

    // 내 신고 목록 불러오기
    @PostMapping("/my-list.dox")
    public Map<String, Object> getMyReports(@RequestBody HashMap<String, Object> map) {
        return reportService.getMyReports(map);
    }
}