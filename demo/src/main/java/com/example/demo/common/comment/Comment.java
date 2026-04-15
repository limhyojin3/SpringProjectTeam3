package com.example.demo.common.comment;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Comment {
    private Long commentNo;    // comment_no
    private Long postNo;       // post_no (SQL에 Review용이 없으므로 Post 전용)
    private String userId;     // user_id
    private Long parentNo;     // parent_no (대댓글용)
    private String content;    // content
    private int likeCnt;       // like_cnt
    private int isDeleted;     // is_deleted
    private Timestamp regDate; // reg_date
}