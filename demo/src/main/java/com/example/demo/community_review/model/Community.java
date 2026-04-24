package com.example.demo.community_review.model;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Community {
    private Long postNo;      // 게시글 번호
    private String userId;    // 작성자 ID
    private String category;  // 카테고리 (자유, 질문 등)
    private String title;     // 제목
    private String content;   // 본문 (LONGTEXT)
    private int viewCnt;      // 조회수
    private int likeCnt;      // 좋아요 수
    private String regDate;// 등록일
    private int isDeleted;    // 삭제 여부 (0: 유지, 1: 삭제) 
    private int commentCnt;
    private int isLiked;
}