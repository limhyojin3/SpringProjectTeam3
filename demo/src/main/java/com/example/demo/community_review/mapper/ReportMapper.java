package com.example.demo.community_review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.community_review.model.Report;

@Mapper
public interface ReportMapper {
    // [신고 접수] 사용자가 제출한 신고 정보를 저장
    int insertReport(Report report);

    // [나의 신고 내역] 내가 한 신고들만 모아보기
    List<Report> selectMyReports(String reporterId);
}