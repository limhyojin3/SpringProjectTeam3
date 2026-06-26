<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/companyDetail.css">

<script type="text/x-template" id="company-detail-template">
	<div>
		<div class="top-action-bar">
			<button @click="$emit('back')" class="btn-sub-action">← 뒤로가기</button>
		</div>

		<div class="company-detail-profile-card">
			<div class="company-card-header">
				<h2 class="font-weight-bold text-dark m-0">{{ companyInfo.comName }}</h2>
				<div @click.stop="fnToggleCompanyLike" :class="['like-chip-btn', { active: companyInfo.isCompanyLiked === 1 }]">
					<span>{{ companyInfo.isCompanyLiked === 1 ? '❤️' : '🤍' }}</span>
				</div>
			</div>
			<p class="company-detail-location mt-1">📍 업장 소재지: {{ companyInfo.comAddress || '등록된 주소 정보가 없습니다.' }}</p>
			
			<div class="company-detail-intro-container">
				<h5 class="company-detail-intro-title">✨ 업체 소개 한 줄 안내</h5>
				<p class="m-0 text-secondary lead style-p" style="font-size: 0.95rem; line-height: 1.6;">
					{{ companyInfo.comIntro || '안녕하세요! 저희 업장은 신뢰와 정성을 바탕으로 최고의 패키지 서비스를 약속드립니다. 하단에 준비된 전용 상품 라인업을 편안하게 둘러보세요.' }}
				</p>
			</div>
		</div>

		<div class="company-showroom-title-bar">
			<h3 class="font-weight-bold text-dark m-0" style="font-size: 1.2rem;">
				🎉 이 업체의 추천 패키지 상품 스펙 (총 {{ companyProducts.length }}개)
			</h3>
		</div>

		<div class="company-pokemon-grid">
			<div v-for="item in companyProducts" :key="item.productNo" class="product-item" @click="fnGoProductDetail(item)">
				<div class="product-img-box">
					<img :src="item.imgUrl" :alt="item.productName">
				</div>
				<div class="product-info">
					<h4 class="font-weight-bold">{{ item.productName }}</h4>
					<p class="product-content">{{ item.productContent }}</p>
					
					<div class="product-price-row">
						<p class="product-price m-0">{{ Number(item.productPrice).toLocaleString() }}원</p>
						<div @click.stop="fnToggleProductLike(item)" :class="['like-chip-btn', { active: item.isLiked === 1 }]">
							<span>{{ item.isLiked === 1 ? '❤️' : '🤍' }}</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div v-if="companyProducts.length === 0" class="company-detail-profile-card text-center p-5 text-muted" style="box-shadow: none !important;">
			현재 출고 준비 중인 패키지 상품이 존재하지 않는 업장입니다.
		</div>
	</div>
</script>

<script src="${pageContext.request.contextPath}/js/company-components/company-detail-component.js"></script>