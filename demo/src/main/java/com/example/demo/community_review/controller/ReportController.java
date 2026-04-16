package com.example.demo.community_review.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.ReportService;
import com.example.demo.community_review.model.Report;

@RestController
@RequestMapping("/api/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    // 신고하기 API
    @PostMapping("/add")
    public String addReport(@RequestBody Report report) {
        return reportService.addReport(report);
    }

    // 내 신고 목록 조회 API
    @GetMapping("/list")
    public List<Report> getReports(@RequestParam String reporterId) {
        return reportService.getMyReports(reporterId);
    }
}