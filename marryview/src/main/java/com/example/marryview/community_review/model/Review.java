package com.example.marryview.community_review.model;

import lombok.Data;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class Review {

    /* --- [1] 기본 정보 및 외래키 --- */
    private Long reviewNo;          // 기본키 (Auto Increment)
    private String userId;          // 작성자 ID (Member FK)
    private Long companyNo;         // 업체 번호 (Company FK)
    private String comName;         // 업체명 (조인용)
    private String externalName;    // 외부업체 이름
    private Long resNo;             // 예약 번호 (Reservation FK)
    private Integer productNo;      // 상품 번호 (Integer: 미선택 가능)
    private String productName;     // 상품명 (조인용)
    

    /* --- [2] 리뷰 본문 및 평점 --- */
    private String title;           // 제목
    private String content;         // 본문 내용
    private BigDecimal rating;      // 평점 (예: 4.5)
    private Long totalCost;         // 결제 금액
    private String bookingSource;   // 예약 출처 (플랫폼 이름 등)
    private Timestamp regDate;      // 등록일시
    private String dressCondition;	// 드레스 상태
    private String professionalism;	// 전문성
    private String waitingTimeStatus;	// 대기 시간 여부
    private String waitingDuration;		// 대기 시간
    private String extraChargeForce;	// 추가 요금 여부

    /* --- [3] 상태 및 통계 --- */
    private String approvalStatus;  // 승인 상태 (WAIT, APPROVED, REJECTED)
    private int viewCnt;            // 조회수
    private int likeCnt;            // 좋아요 수
    private int isPaid;             // 유료 여부 (0: 무료, 1: 영수증인증)

    /* --- [4] 이미지 및 영수증 파일 --- */
    private String originalName;    // 실제 파일명
    private String storedName;      // 서버 저장 파일명
    private String imgUrl;          // 이미지 접근 경로
    private String thumbnailUrl;    // 본문 추출 썸네일 (사용자용)
    private String imgDescription;  // 이미지 설명
    private String receiptName;     // 영수증 파일명

    /* --- [5] 열람권 및 로그 관련 (조인용) --- */
    private Integer remainingCount; // 잔여 열람권 갯수
    private int isViewed;           // 0: 안봄, 1: 봄
    private Timestamp usedAt;       // 유료 리뷰 사용 시간 (pass_usage_log)
    private Timestamp viewdAt;      // 무료 리뷰 조회 시간 (free_view_log)
    
//  ai요약

    private String aiSummary; // 추가
    private String summary; // 요약문 저장용

    private String largeCategory;
    private String mediumCategory;

}