package com.example.demo.company.model;

import java.util.Date;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
public class Product {
    private Long productNo;
    private Long companyNo;
    private String productName;
    private String productDetails;
    private Long originalPrice;
    private Integer isActive;
    private String imgUrl;
    private String proType;
    private String tag;
    private Integer deposit;
    private Date regDate;
    
    // 확장 카테고리 필드
    private String largeCategory;
    private String mediumCategory;
    
    // 조인용 업체명
    private String comName;
    
    // 등록/수정 동적 연동용 태그 리스트
    private List<String> uniqueNewTagsOnly;

    // 💡 렌더링 버그 해결 핵심: productTemplate.jsp 내 v-for 변수명(item.xxx)과 1:1 매핑되는 싱크용 호환 필드 추가
    private Long id;
    private String thumbnail;
    private String name;
    private String content;
    private Long price;
    
    // 💡 이중 방어용 동적 필드 추가: 자바스크립트 화면단에서 product.company 명칭으로 호출하더라도 예외 없이 무조건 수신되도록 유도
    private String company;

    // 💡 정밀 커스텀 세터 이식: MyBatis 가 comName 값을 채워줄 때 company 필드에도 값이 거울처럼 동시 복사되도록 안전망 설계
    public void setComName(String comName) {
        this.comName = comName;
        this.company = comName;
    }
}