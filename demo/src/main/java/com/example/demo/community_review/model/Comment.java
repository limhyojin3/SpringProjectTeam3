package com.example.demo.community_review.model;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Comment {
    private Long commentNo;    // 댓글 번호 (PK)
    private Long postNo;       // 게시글 번호
    private Long reviewNo;	   // 리뷰 번호
    private String userId;     // 사용자 아이디
    private Long parentNo;     // 대댓글용
    private String content;    // 내용
    private int likeCnt;       // 좋아요 개수
    private int isDeleted;     // 삭제 되었는지 관리 용도
    private Timestamp regDate; // 생성일
}