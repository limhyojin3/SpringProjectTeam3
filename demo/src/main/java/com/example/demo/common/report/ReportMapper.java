package com.example.demo.common.report;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ReportMapper {
    // [신고 접수] 사용자가 제출한 신고 정보를 저장
    int insertReport(Report report);

    // [나의 신고 내역] 내가 한 신고들만 모아보기
    List<Report> selectMyReports(String reporterId);
}