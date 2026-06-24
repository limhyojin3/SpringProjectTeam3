<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productRegForm.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productRegChips.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productRegButtons.css">

<template id="product-reg-sub-template">
    <div class="product-form-wrapper">
        <h2>상품 등록하기</h2>
        <div class="product-form-section">
            <div class="form-title-box">상품 기본 정보</div>
            <div class="form-content-box">
                <div class="form-group">
                    <label class="form-label">상품 이름</label>
                    <input type="text" v-model="initializedOneProductDetails.productName" class="form-input-text">
                </div>

                <div class="form-group">
                    <label class="form-label">대분류</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" :class="{'active-large': initializedOneProductDetails.largeCategory === '결혼'}" @click="selectLargeCategory('결혼')">결혼</button>
                        <button type="button" class="premium-chip-btn" :class="{'active-large': initializedOneProductDetails.largeCategory === '가족행사'}" @click="selectLargeCategory('가족행사')">가족행사</button>
                        <button type="button" class="premium-chip-btn" :class="{'active-large': initializedOneProductDetails.largeCategory === '친구와함께'}" @click="selectLargeCategory('친구와함께')">친구와함께</button>
                    </div>
                </div>

                <div class="form-group" v-if="availableMediums.length > 0">
                    <label class="form-label">중분류</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" v-for="m in availableMediums" :key="m" :class="{'active-medium': initializedOneProductDetails.mediumCategory === m}" @click="selectMediumCategory(m)">{{m}}</button>
                    </div>
                </div>

                <div class="form-group" v-if="availableTags.length > 0">
                    <label class="form-label">태그</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" v-for="t in availableTags" :key="t" :class="{'active-tag': selectedTags.includes(t), 'disabled-lock': !selectedTags.includes(t) && selectedTags.length >= 3}" @click="toggleTagSelection(t)"># {{t}}</button>
                    </div>
                    <div class="tag-count-indicator">선택: {{selectedTags.length}} / 3</div>
                </div>

                <div class="form-group">
                    <label class="form-label">예상 견적 (원)</label>
                    <input type="text" v-model="initializedOneProductDetails.originalPrice" @input="fnInputComma('originalPrice')" class="form-input-text" style="text-align: right;" placeholder="금액을 입력하세요 (예: 1,500,000)">
                </div>

                <div class="form-group">
                    <label class="form-label">예약금 (원)</label>
                    <input type="text" v-model="initializedOneProductDetails.deposit" @input="fnInputComma('deposit')" class="form-input-text" style="text-align: right;" placeholder="예약금을 입력하세요 (예: 150,000)">
                </div>

                <div class="form-group">
                    <label class="form-label">상품 이미지 등록</label>
                    <input type="file" @change="fnFileChange" class="form-input-file" accept="image/*">
                    
                    <div class="preview-img-zone" v-if="imgPreviewUrl" style="margin-top: 10px;">
                        <img :src="imgPreviewUrl" alt="미리보기" style="max-width: 200px; max-height: 200px; border-radius: 6px; border: 1px solid #ddd; object-fit: cover;">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">상품 설명</label>
                    <textarea v-model="initializedOneProductDetails.productDetails" class="form-textarea"></textarea>
                </div>
            </div>
        </div>
        <div class="form-button-group">
            <button class="btn-cancel" @click="$emit('back')">취소</button>
            <button class="btn-submit" @click="fnInsertProduct()">상품 등록</button>
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/product-reg-core-module.js"></script>
<script src="${pageContext.request.contextPath}/js/company-components/product-reg-category-module.js"></script>
<script src="${pageContext.request.contextPath}/js/company-components/product-reg-sub.js"></script>