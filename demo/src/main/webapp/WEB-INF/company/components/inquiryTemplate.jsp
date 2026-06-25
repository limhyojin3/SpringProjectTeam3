<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/inquiryTemplate.css">

<template id="inquiry-section-template">
    <div> 
    <div v-if="viewPage === 'main'">
            <div class="productlist-productReg">
                <div class="section-header">
                    <h2><i class="fas fa-comment-dots mr-2"></i>문의 관리 : <span class="res-count-highlight">전체 문의 {{ inquiryList ? inquiryList.length : 0 }}건</span></h2>
                </div>
            </div>

            <div class="content-card" v-for="i in fnPaginatedInquiry" :key="i">
                <div class="inquiry-product-header">
                    <div class="inquiry-thumb-wrap">
                        <img :src="fnThumbnail(i)" :alt="i.productName" class="productImg">
                    </div>
                    <div class="inquiry-product-info">
                        <span class="inquiry-product-badge">상품명</span>
                        <span class="inquiry-product-name">{{i.productName}}</span>
                    </div>
                </div>
                <div class="inquiry-section">
                    <table>
                        <tr>
                            <th>제목</th>
                            <td>{{i.inquiryTitle}}</td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>{{i.userId}}</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>{{i.inquiryContents}}</td>
                        </tr>
                        <tr>
                            <th>답변 여부</th>
                            <td v-if="i.inquiryAns == 1" class="status-done">답변 완료</td>
                            <td v-else class="status-wait">아직 답변하지 않음</td>
                        </tr>
                    </table>
                </div>
                <button class="btn-reply" @click="fnAnswerToProductInquiry(i)">
                    <i class="fas fa-pen mr-1"></i>답변하기
                </button>
            </div>  <!-- content-card 닫힘 -->
            
            <div class="pagination1">
                <a @click="fnPrevPage" href="javascript:;" :class="{ 'disabled-arrow': currentPage === 1 }">◀</a>
                
                <span v-for="num in visibleInquiryPageNumbers" :key="num">
                    <a @click="currentPage = num" href="javascript:;"
                        :class="{ 'active-page-node': currentPage === num }">
                        {{ num }}
                    </a>
                </span>
                
                <a @click="fnNextPage" href="javascript:;" :class="{ 'disabled-arrow': currentPage === totalInquiryPages || totalInquiryPages === 0 }">▶</a>
            </div>
        </div>

        <div v-if="viewPage === 'answer'">
            <div class="answer-card-container">
                <div class="answer-card-header">
                    <h2 class="answer-card-title">문의 답변 등록</h2>
                    <button @click="fnBacktoInquiry" class="btn-back-to-list">
                        ← 리스트로 돌아가기
                    </button>
                </div>

                <div class="original-inquiry-box">
                    <h3 class="original-inquiry-title">원본 문의 내용</h3>
                    <div class="inquiry-section">
                        <table class="original-inquiry-table">
                            <colgroup>
                                <col class="table-col-label">
                                <col class="table-col-content">
                                <col class="table-col-label">
                                <col class="table-col-content">
                            </colgroup>
                            <tr>
                                <th>문의 번호</th>
                                <td>{{ inquiryDetails.inquiryNo }}</td>
                                <th>작성자 ID</th>
                                <td>{{ inquiryDetails.userId }}</td>
                            </tr>
                            <tr>
                                <th>문의 제목</th>
                                <td colspan="3" class="text-bold">
                                    {{ inquiryDetails.inquiryTitle }}
                                </td>
                            </tr>
                            <tr>
                                <th class="valign-top">문의 내용</th>
                                <td colspan="3" class="text-pre-wrap">
                                    {{ inquiryDetails.inquiryContents }}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="answer-write-box">
                    <h3 class="answer-write-title">답변 달기</h3>
                    <div class="form-input-group">
                        <label class="form-input-label">답변자</label>
                        <input v-model="inquiryAnswer.ansUserId" placeholder="답변을 작성한 담당자명을 입력해주세요."
                            class="form-input-text">
                    </div>
                    <div class="form-input-group">
                        <label class="form-input-label">답변 내용</label>
                        <textarea v-model="inquiryAnswer.answerContents" placeholder="문의에 대한 정성스러운 답변을 작성해 주세요."
                            class="form-textarea-text"></textarea>
                    </div>
                    <div class="answer-action-buttons">
                        <button @click="fnBacktoInquiry" class="btn-action-cancel">
                            취소
                        </button>
                        <button @click="fnSaveAnswer" class="btn-action-submit">
                            <span v-if="inquiryAnswer.inquiryAns == 0">답변 등록하기</span>
                            <span v-else>답변 수정하기</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/inquiry-section-component.js"></script>