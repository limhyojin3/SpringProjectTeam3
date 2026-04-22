package com.example.demo.company.model;

import lombok.Data;

@Data
public class Company {
    private Long companyNo;      // company_no
    private String userId;       // user_id
    private String comName;      // com_name
    private String comType;      // com_type
    private String comIntro;     // com_intro
    private String comAddress;   // com_address
    private String status;       // status
    private String bizNo;        // biz_no
    private String ceoName;      // ceo_name
    private String comTel;       // com_tel
    private String registrationFee; // registration_fee
    
    // 통계용 필드 (DB 테이블엔 없지만 화면에 뿌릴 때 필요)
    private Double avgRating;
    private Integer reviewCount;
}