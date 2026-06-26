package com.example.demo.company.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class ProductInquiry {
    private Integer inquiryNo;
    private String userId;
    private Long companyNo;
    private Long productNo;
    private String inquiryTitle;
    private String inquiryContents;
    private Integer inquiryAns;

    // 조인용 필드
    private String productName;
    private String productDetails;
    private String imgUrl;
    private String proType;
    private String tag;
    private Long originalPrice;
    private Integer deposit;
    private String comName;
    private String comIntro;
    
    // 답변 조인용 필드
    private Integer answerNo;
    private String answerContents;
    private String ansUserId;
    
    private String inquiryDate;
    private String answerDate;
}