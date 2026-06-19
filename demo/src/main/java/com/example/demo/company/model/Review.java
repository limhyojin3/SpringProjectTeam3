package com.example.demo.company.model;

import lombok.Data;

@Data
public class Review {

    String reviewNo;
    String userId;
    String companyNo; //
    String resNo;
    String rating;
    String approvalStatus;
    
    String isPaid;
    String receiptName;
    String title;
    String content;
    String bookingSource;
    String originalName;
    String storedName;
    String imgUrl;
    String imgDescription;
    String regDate;
    String updated;
    
    String thumbnailUrl;
    
    long totalCost;
    long viewCnt;
    long likeCnt;
}