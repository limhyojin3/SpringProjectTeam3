package com.example.demo.community_review.model;

import lombok.Data;

@Data
public class Inquiry {
    private Long inquiryNo;     // inquiry_no
    private String userId;      // user_id
    private String inquiryType; // inquiry_type
    private String title;       // title
    private String content;     // content
    private String answerContent; // answer_content (답변 내용)
    private String status;      // status (WAIT, DONE)
    private String regDate;     
    private String answerDate;
}