package com.example.marryview.company.model;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class Company {
    private Long companyNo;
    private String userId;
    private String comName;
    private String comIntro;
    private Date payDate;
    
    // Member 조인 필드
    private String userPwd;
    private String userName;
    private String tel;
    private String email;
}