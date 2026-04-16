package com.example.demo.common.like;

import lombok.Data;

@Data
public class LikeDTO {
    private String type;     // POST 또는 REVIEW
    private Long targetId;   // 게시글 번호 또는 리뷰 번호
    private String userId;   // 좋아요 누른 유저 아이디
}