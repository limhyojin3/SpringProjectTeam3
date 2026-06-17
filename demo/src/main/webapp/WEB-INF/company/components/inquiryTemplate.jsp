<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<template id="inquiry-section-template">
    <div> <div v-if="viewPage === 'main'">
            <div class="section-header">
                <h2>문의 관리 : <span style="color:#9b8fd4;">전체 문의 {{inquiryList.length}}건</span></h2>
            </div>
            <div class="content-card" v-for="i in fnPaginatedInquiry" :key="i">
                <div style="display: flex;">
                    <div style="width: 100px; height: 100px;  margin-right: 20px; text-align: center;">
                        <img :src="fnThumbnail(i)" :alt="i.productName" class="productImg">
                    </div>
                    <h3>상품명 : <span style="color: #d6336c;">{{i.productName}}</span> </h3>
                </div>
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
                        <td v-if="i.inquiryAns === '1'" style="color:#0099ff">답변 완료</td>
                        <td v-else>아직 답변하지 않음</td>
                    </tr>
                </table>
                <button class="btn-reply" @click="fnAnswerToProductInquiry(i)">답변하기</button>
            </div>
            
            <div class="pagination1">
                <span v-for="num in inquiryList.length" :key="num">
                    <a @click="currentPage = num" href="javascript:;"
                        :style="currentPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
                        {{num}}
                    </a>
                </span>
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
                            <span v-if="inquiryAnswer.inquiryAns === '0'">답변 등록하기</span>
                            <span v-else>답변 수정하기</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>