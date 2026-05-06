package com.example.demo.member.model;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ChatLog {
	private int chatNo;          // PK (자동증가)
    private String userId;       // 사용자 ID
    private String question;     // 질문 내용
    private String answer;       // 답변 내용
    private String chatType;     // AI인지 FIXED(고정답변)인지 구분
    private LocalDateTime createdAt; // 저장 시간

}
