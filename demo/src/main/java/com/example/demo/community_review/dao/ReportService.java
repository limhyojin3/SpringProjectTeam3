package com.example.demo.community_review.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.community_review.mapper.ReportMapper;
import com.example.demo.community_review.model.Report;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;

    // 신고 등록 로직 (Message.MSG_ADD 사용)
    public String addReport(Report report) {
        return (reportMapper.insertReport(report) > 0) ? Message.MSG_ADD : Message.MSG_ERR;
    }

    // 내 신고 내역 조회 로직
    public List<Report> getMyReports(String reporterId) {
        return reportMapper.selectMyReports(reporterId);
    }
}