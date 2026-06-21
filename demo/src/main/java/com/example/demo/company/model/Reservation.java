package com.example.demo.company.model;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class Reservation {
    private Integer resNo;
    private String userId;
    private Long productNo;
    private Long companyNo;
    private Date resDate;
    private String resTime;
    private String resStatus;
    private String resContent;
    private String useDate;
    private String useTime;
    private Date payDate;
    private Integer payNo;

    // 조인 쿼리 버퍼용 필드
    private String productName;
    private String productDetails;
    private Long originalPrice;
    private String imgUrl;
    private String proType;
    private String tag;
    private Integer deposit;
    private String tel;
    private String comName;
    private Long amount;
    private String payStatus;
    private Integer refund;
    private Date refundDate;
}