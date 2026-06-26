package com.example.marryview.company.model;

import java.util.Date;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
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
	
	// 💡 [기능 확장] 조인용 업체 정보 확장 필드 (위치, 소개글 추가 수혈)
	private String comName;
	private String comIntro;
	private String comAddress;
	
	// 💡 [기능 확장] 좋아요(Like) 상태 및 통계 제어용 확장 필드
	private Integer likeCnt;
	private Integer isLiked; // 현재 세션 사용자의 좋아요 여부 (1: 빨간하트, 0: 빈하트)
	
	// 등록/수정 동적 연동용 태그 리스트
	private List<String> uniqueNewTagsOnly;

	// 프론트엔드 Vue3 호환성 필드 (v-for 변수명 싱크용)
	private Long id;
	private String thumbnail;
	private String name;
	private String content;
	private Long price;
	private String company;
	
	private int isCompanyLiked;

	// MyBatis 조인 매핑 시 하위 호환성을 완벽히 유지하기 위한 커스텀 특화 세터
	public void setComName(String comName) {
		this.comName = comName;
		this.company = comName;
	}
	private String comImgUrl;
}