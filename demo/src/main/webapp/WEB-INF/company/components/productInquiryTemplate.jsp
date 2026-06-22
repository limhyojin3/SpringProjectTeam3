<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/product-inquiry-write-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/my-inquiry-list-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/inquiry-detail-template.css">

<script type="text/x-template" id="product-inquiry-write-template">
    <div class="payment-container">
        <div class="reservation-ticket">
            <div class="ticket-header">
                <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                <span class="ticket-type">OFFICIAL TICKET</span>
            </div>

            <div class="ticket-body">
                <div class="ticket-info">
                    <div class="info-row product-name">
                        <label>문의할 상품</label>
                        <div class="value">{{ product.name }} <small>({{ product.company }})</small></div>
                    </div>
                    <div class="info-row">
                        <label>상품 및 서비스 내용</label>
                        <div class="value">{{ product.content }}</div>
                    </div>

                    <div class="info-grid">
                        <div class="info-row">
                            <label>문의자 명</label>
                            <div class="value">{{ sessionId }}</div>
                        </div>
                        <div class="info-row">
                            <label>문의 제목</label>
                            <div class="value">
                                <input v-model="title" class="inquiry-input-title">
                            </div>
                        </div>
                        <div class="info-row">
                            <label>문의 내용</label>
                            <div class="value">
                                <textarea v-model="contents" class="inquiry-textarea-contents"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ticket-side">
                    <div class="side-content">
                        <img :src="product.thumbnail" class="ticket-side-img">
                        <div class="amount-label">TOTAL PRICE(상품 및 서비스 가격)</div>
                        <div class="amount-value">{{ Number(product.price).toLocaleString() }}원</div>
                        <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                    </div>
                </div>
            </div>

            <div class="payment-btn-group">
                <button class="btn-cancel-pay" @click="$emit('back')">뒤로가기</button>
                <button class="btn-final-reserve" @click="submitInquiry">문의하기</button>
            </div>
        </div>
    </div>
</script>

<script type="text/x-template" id="my-inquiry-list-template">
    <div class="my-real-inquiry-container">
        <div class="inquiry-header-bar">
            <h2 class="inquiry-header-title">나의 문의 내역</h2>
            <button @click="$emit('back')" class="btn-sub-action">뒤로가기</button>
        </div>

        <div v-if="inquiryList && inquiryList.length > 0">
            <div v-for="(inquiry, index) in inquiryList" :key="index" @click="$emit('go-detail', inquiry)" class="inquiryTicket list-view-ticket">
                <div class="inquiry-img-box">
                    <img :src="inquiry.imgUrl" alt="상품이미지">
                </div>
                <div class="inquiry-info-box">
                    <div class="inquiry-prod-name">상품명: {{ inquiry.productName }}</div>
                    <div class="inquiry-title-text">{{ inquiry.inquiryTitle }}</div>
                    <div class="inquiry-content-text">{{ inquiry.inquiryContents }}</div>
                </div>
                <div class="inquiry-status-box">
                    <span v-if="inquiry.inquiryAns === '1'" class="badge-ans-complete">답변 완료</span>
                    <span v-else class="badge-ans-wait">답변 대기</span>
                </div>
            </div>
        </div>
        <div v-else class="inquiry-empty-box">
            문의하신 내역이 없습니다.
        </div>
    </div>
</script>

<script type="text/x-template" id="inquiry-detail-template">
    <div class="inquiry-detail-container">
        <div class="inquiry-detail-header">
            <h2 class="inquiry-detail-title">문의 내용 상세보기</h2>
            <button @click="$emit('back')" class="btn-back-outline">← 리스트로 돌아가기</button>
        </div>

        <div class="inquiry-product-card">
            <img :src="localInquiry.imgUrl" alt="문의 상품 이미지">
            <div>
                <div class="inquiry-card-label">문의 상품</div>
                <div class="inquiry-card-name">{{ localInquiry.productName }}</div>
            </div>
        </div>

        <div class="inquiry-content-box-wrapper">
            <div class="inquiry-box-header">
                <span class="inquiry-box-label">나의 문의</span>
                <span class="inquiry-box-number">No. {{ localInquiry.inquiryNo }}</span>
            </div>
            <div class="inquiry-box-body">
                <h3 class="inquiry-body-title">Q. {{ localInquiry.inquiryTitle }}</h3>
                <div class="inquiry-body-text">{{ localInquiry.inquiryContents }}</div>
            </div>
        </div>

        <div v-if="localInquiry.inquiryAns === '1'" class="answer-box-wrapper">
            <div class="answer-box-header">
                <span class="answer-prefix">A.</span> 업체 답변
            </div>
            <div class="answer-box-body">
                <div class="answer-body-text">
                    {{ localInquiry.answerContents || '답변 내용을 불러오는 중입니다.' }}
                </div>
                <div class="answer-body-meta">
                    답변자: {{ localInquiry.ansCompany || '관리자' }}
                </div>
            </div>
        </div>
        <div v-else class="answer-wait-box">
            <div class="answer-wait-icon">⏳</div>
            답변을 기다리고 있습니다. 조금만 더 기다려 주세요!
        </div>
    </div>
</script>