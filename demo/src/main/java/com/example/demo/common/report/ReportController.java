package com.example.demo.common.report;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

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