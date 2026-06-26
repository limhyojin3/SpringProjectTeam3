package com.example.marryview.community_review.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.marryview.admin.dao.NotificationService;
import com.example.marryview.community_review.mapper.CommentMapper;
import com.example.marryview.community_review.mapper.CommunityMapper;
import com.example.marryview.community_review.mapper.ReportMapper;
import com.example.marryview.community_review.mapper.ReviewMapper;
import com.example.marryview.community_review.model.Report;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;

    /* 게시글이나 리뷰의 제목을 가져오기 위해 해당 Mapper들을 추가로 주입받아야 합니다. 
       기존에 사용하시는 Mapper 인터페이스명이 다르다면 이름만 수정해주세요.
    */
     @Autowired
     private CommunityMapper communityMapper; 
     @Autowired
     private ReviewMapper reviewMapper;
     @Autowired
     private CommentMapper commentMapper;
     @Autowired
     private NotificationService notificationService;

    // 신고 등록 (중복 체크 + 타겟 제목 자동 추출 포함)
    public Map<String, Object> addReport(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();

        try {
            // 1. 중복 신고 여부 확인
            int count = reportMapper.checkDuplicateReport(map);

            if (count > 0) {
                resultMap.put("result", "fail");
                resultMap.put("message", "이미 신고하신 내역입니다.");
            } else {
                // 2. targetTitle 세팅 (신고 시점에 원본 제목/내용 스냅샷 저장)
                String targetType = (String) map.get("targetType");
                String targetId = String.valueOf(map.get("targetId"));
                String targetTitle = "정보 없음";

                // 로직 설명: 타입에 따라 각각의 테이블에서 제목(Title)이나 내용(Content)을 조회해옴
                if ("POST".equals(targetType)) {
                     targetTitle = communityMapper.getPostTitle(targetId);
//                    targetTitle = "게시글: " + targetId; // 실제 연동 전 테스트용
                } else if ("REVIEW".equals(targetType)) {
                     targetTitle = reviewMapper.getReviewTitle(targetId);
//                    targetTitle = "리뷰: " + targetId; // 실제 연동 전 테스트용
                } else if ("MEMBER".equals(targetType)) {
                    targetTitle = (String) map.get("targetUserId") + " 유저 신고";
                } else if ("COMMENT".equals(targetType)) {
                     targetTitle = commentMapper.getCommentContent(targetId);
//                    targetTitle = "댓글: " + targetId;
                }
                
             // 데이터가 삭제되었거나 조회가 안될 경우 예외 처리
                if (targetTitle == null || targetTitle.trim().isEmpty()) {
                    targetTitle = targetType + " (" + targetId + ") - 정보 없음";
                }

                // 추출한 제목을 map에 다시 넣어서 insert 쿼리로 보냄
                map.put("targetTitle", targetTitle);

                // 3. 신고 정보 저장
                int res = reportMapper.insertReport(map);
                if (res > 0) {
                	notificationService.createReportReceived(
                		    map.get("reportNo"),
                		    (String) map.get("reporterId")
                		);
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

    // 내 신고 내역 가공 (목록 + 전체 개수)
    public Map<String, Object> getMyReportList(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        
        try {
            // 1. 목록 조회
            List<Report> list = reportMapper.selectMyReports(map);
            // 2. 전체 카운트 조회
            int totalCount = reportMapper.selectReportCount(map);
            
            resultMap.put("list", list);
            resultMap.put("totalCount", totalCount);
            resultMap.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        
        return resultMap;
    }
}