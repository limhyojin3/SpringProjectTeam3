package com.example.demo.community_review.model;

import lombok.Data;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class Review {
    private Long reviewNo;       // 기본키 (Auto Increment)
    private String userId;       // 작성자 ID (Member FK)
    private Long companyNo;      // 업체 번호 (Company FK)
    private String comName;
    private Long resNo;          // 예약 번호 (Reservation FK)
    private BigDecimal rating;   // 평점 (예: 4.5)
    private String approvalStatus; // 승인 상태 (WAIT, APPROVED, REJECTED)
    private int viewCnt;         // 조회수
    private int likeCnt;         // 좋아요 수
    private int isPaid;          // 유료 여부 (0: 무료, 1: 영수증인증)
    private String receiptName; // 추가된 영수증 파일명
    private String title;        // 제목
    private String content;      // 본문 내용
    private String bookingSource;// 예약 출처 (플랫폼 이름 등)
    private String originalName; // 사용자가 올린 실제 파일명
    private String storedName;   // 서버 폴더에 저장된 중복 방지 파일명
    private String imgUrl;       // 이미지 접근 경로
    private String imgDescription; // 이미지 설명
    private Long totalCost;      // 결제 금액
    private Timestamp regDate;   // 등록일시
}