package com.example.demo.community_review.model;

import lombok.Data;

/**
 * 1:1 문의사항(Inquiry) 모델 클래스
 * 고객센터 문의 및 답변 데이터를 관리합니다.
 */
@Data
public class Inquiry {

    private Long inquiryNo;      // 문의 번호 (PK, 자동 증가)
    
    private String userId;       // 작성자 아이디 (Member 테이블 참조)
    
    private String inquiryType;  // 문의 유형 (예: 결제, 시스템 이용, 일반 문의 등)
    
    private String title;        // 문의 제목
    
    private String content;      // 문의 본문 내용
    
    private String answerContent; // 관리자 답변 내용 (답변 전에는 null 또는 빈 값)
    
    /**
     * 답변 처리 상태
     * - WAIT: 답변 대기 중
     * - DONE: 답변 완료
     */
    private String status;       
    
    private String regDate;      // 문의 등록 일자 (YYYY-MM-DD 형식)
    
    private String answerDate;   // 답변 등록 일자 (답변이 완료된 시점의 시간)
}