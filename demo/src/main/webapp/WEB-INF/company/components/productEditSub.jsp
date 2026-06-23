<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productEditSub.css">

<template id="product-edit-sub-template">
    <div class="product-form-wrapper">
        <h2>상품 수정하기</h2>
        <div class="product-form-section">
            <div class="form-title-box">상품 기본 정보</div>
            <div class="form-content-box">
                <div class="form-group">
                    <label class="form-label">상품 이름</label>
                    <input type="text" v-model="oneProductDetails.productName" class="form-input-text" placeholder="여기에 상품 이름을 적어주세요.">
                </div>

                <div class="form-group">
                    <label class="form-label">대분류 카테고리</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" :class="{'active-large': oneProductDetails.largeCategory === '결혼'}" @click="selectLargeCategory('결혼')">결혼</button>
                        <button type="button" class="premium-chip-btn" :class="{'active-large': oneProductDetails.largeCategory === '가족행사'}" @click="selectLargeCategory('가족행사')">가족행사</button>
                        <button type="button" class="premium-chip-btn" :class="{'active-large': oneProductDetails.largeCategory === '친구와함께'}" @click="selectLargeCategory('친구와함께')">친구와함께</button>
                    </div>
                </div>

                <div class="form-group" v-if="availableMediums.length > 0">
                    <label class="form-label">중분류 카테고리</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" v-for="m in availableMediums" :key="m" :class="{'active-medium': oneProductDetails.mediumCategory === m}" @click="selectMediumCategory(m)">{{m}}</button>
                    </div>
                </div>

                <div class="form-group" v-if="availableTags.length > 0">
                    <label class="form-label">명품 테마 태그 (최대 3개)</label>
                    <div class="chip-group-zone">
                        <button type="button" class="premium-chip-btn" v-for="t in availableTags" :key="t" :class="{'active-tag': selectedTags.includes(t), 'disabled-lock': !selectedTags.includes(t) && selectedTags.length >= 3}" @click="toggleTagSelection(t)"># {{t}}</button>
                    </div>
                    <div class="tag-count-indicator">선택: {{selectedTags.length}} / 3</div>
                </div>

                <div class="form-group">
                    <label class="form-label">예상 견적 (원)</label>
                    <input type="text" v-model="oneProductDetails.originalPrice" @input="fnInputComma('originalPrice')" class="form-input-text" style="text-align: right;" placeholder="여기에 견적을 적어주세요.">
                </div>

                <div class="form-group">
                    <label class="form-label">예약금 (원)</label>
                    <input type="text" v-model="oneProductDetails.deposit" @input="fnInputComma('deposit')" class="form-input-text" style="text-align: right;" placeholder="여기에 예약금을 적어주세요.">
                </div>

                <div class="form-group">
                    <label class="form-label">상품 설명</label>
                    <textarea v-model="oneProductDetails.productDetails" class="form-textarea" placeholder="상품에 대한 자세한 설명을 입력하세요."></textarea>
                </div>
            </div>
        </div>

        <div class="product-form-section">
            <div class="form-title-box">상품 이미지 관리</div>
            <div class="form-content-box">
                <div class="form-group">
                    <label class="form-label">기존 등록 이미지</label>
                    <div class="preview-img-zone" v-if="oneProductDetails.imgUrl">
                        <img :src="oneProductDetails.imgUrl" alt="기존 이미지">
                    </div>
                    <div v-else class="no-image-text" style="color: #999; font-size: 12px; padding: 10px 0;">등록된 기존 이미지가 없습니다.</div>
                </div>
                
                <div class="form-group" style="margin-top: 20px; border-top: 1px dashed #eee; padding-top: 20px;">
                    <label class="form-label">수정할 새로운 이미지 선택</label>
                    <input type="file" @change="fnFileChange($event)" ref="fileInput" class="form-input-file" accept="image/*">
                    
                    <div class="preview-img-zone" v-if="previewUrl" style="margin-top: 15px;">
                        <p style="font-size: 12px; color: #666; margin-bottom: 8px; font-weight: bold;">💡 변경 예정 이미지 미리보기:</p>
                        <img :src="previewUrl" alt="새 이미지 미리보기">
                    </div>
                </div>
            </div>
        </div>
        
        <div class="form-button-group">
            <button class="btn-cancel" @click="fnBackToList()">취소(돌아가기)</button>
            <button class="btn-submit" :disabled="!isModified" @click="fnUpdateProduct()">상품 수정</button>
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/product-edit-sub.js"></script>