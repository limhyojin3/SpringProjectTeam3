package com.example.marryview.community_review.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.marryview.community_review.model.Report;

@Mapper
public interface ReportMapper {
	// [신고 접수]
    int insertReport(HashMap<String, Object> map);

    // [나의 신고 내역]
    List<Report> selectMyReports(HashMap<String, Object> map);
    
    // [중복 신고 체크]
    int checkDuplicateReport(HashMap<String, Object> map);
    
    // 신고 전체 개수 조회
    int selectReportCount(HashMap<String, Object> map);
}