<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<template id="product-reg-sub-template">
    <div class="product-form-wrapper">
        <h2>상품 등록하기</h2>
        <div class="product-form-section">
            <div class="form-title-box">상품 기본 정보</div>
            <div class="form-content-box">
                <div class="form-group">
                    <label class="form-label">상품 이름</label>
                    <div class="form-info-box">
                        <input type="text" placeholder="여기에 상품 이름을 적어주세요."
                            v-model="initializedOneProductDetails.productName">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">카테고리</label>
                    <div class="category-group">
                        <div class="category-item" v-for="item in category" :key="item">
                            <label>
                                <input type="checkbox" :value="item"
                                    v-model="initializedOneProductDetails.proType">{{item}}
                            </label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">상품 태그</label>
                    <div>
                        <input type="text" placeholder="첫번째 태그" v-model="tagMap.input1">
                        <input type="text" placeholder="두번째 태그" v-model="tagMap.input2">
                        <input type="text" placeholder="세번째 태그" v-model="tagMap.input3">
                        <input type="text" placeholder="네번째 태그" v-model="tagMap.input4">
                        <input type="text" placeholder="다섯번째 태그" v-model="tagMap.input5">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">상품 설명</label>
                    <div class="form-info-box">
                        <textarea placeholder="상품에 대한 자세한 설명을 입력하세요."
                            v-model="initializedOneProductDetails.productDetails"></textarea>
                    </div>
                </div>
                <div>
                    <div class="form-group">
                        <label class="form-label"><span class="form-info-label">예상 견적</span></label>
                        <div class="form-info-box">
                            <input placeholder="여기에 견적을 적어주세요." type="text"
                                v-model="initializedOneProductDetails.originalPrice">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label"><span class="form-info-label">예약금</span></label>
                        <div class="form-info-box">
                            <input placeholder="여기에 예약금을 적어주세요." type="text"
                                v-model="initializedOneProductDetails.deposit">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-form-section">
            <div class="form-title-box">상품 이미지</div>
            <div class="form-content-box">
                <div class="form-group">
                    <div>등록할 이미지 :</div>
                    <label>
                        사진 선택하기
                        <input type="file" @change="fnFileChange($event)" ref="fileInput"
                            style="display: none;">
                    </label>
                    <div class="image-editor-box">
                        <div v-if="previewUrl">
                            <p>선택된 이미지 미리보기:</p>
                            <img :src="previewUrl">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-button-group">
            <button class="btn-cancel" @click="fnBackToList()">취소(돌아가기)</button>
            <button class="btn-submit" @click="fnInsertProduct()">상품 등록</button>
        </div>
    </div>
</template>

<!-- 🎯 자립형 격리 개통: 하단에서 이 등록 폼의 생명과 업로드 AJAX 로직을 전담 제어할 전용 JS를 직통 로드합니다. -->
<script src="${pageContext.request.contextPath}/js/company-components/product-reg-sub.js"></script>