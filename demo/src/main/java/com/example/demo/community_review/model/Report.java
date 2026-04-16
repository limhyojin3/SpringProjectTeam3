package com.example.demo.community_review.model;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Report {
    private Long reportNo;      // report_no (PK)
    private String reporterId;  // reporter_id (신고자 아이디)
    private String targetType;  // target_type (MEMBER, POST, REVIEW, COMPANY)
    private Long targetId;      // target_id (신고 대상 번호)
    private String targetUserId;// target_user_id (신고 대상 유저 아이디)
    private String reportTitle; // report_title (신고 제목)
    private String reportContent;// report_content (신고 내용)
    private int answerStatus;   // answer_status (답변 여부)
    private int actionStatus;   // action_status (조치 여부)
    private Timestamp regDate;  // reg_date (신고일)
}