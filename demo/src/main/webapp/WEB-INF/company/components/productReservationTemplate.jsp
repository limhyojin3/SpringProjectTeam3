<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/product-reservation-payment-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/my-reservation-list-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/reservation-detail-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/reservationAgreementModal.css">

<script type="text/x-template" id="product-reservation-payment-template">
    <div class="payment-container">
        <div class="reservation-ticket">
            <div class="ticket-header">
                <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                <span class="ticket-type">OFFICIAL TICKET</span>
            </div>

            <div class="ticket-body">
                <div class="ticket-info">
                    <div class="info-row product-name">
                        <label>예약 상품</label>
                        <div class="value">{{ product.name }} <small>({{ product.comName }})</small></div>
                    </div>
                    <div class="info-row">
                        <label>TOTAL PRICE(상품 및 서비스 가격)</label>
                        <div class="value">{{ Number(product.price).toLocaleString() }}원</div>
                    </div>

                    <div class="info-grid">
                        <div class="info-row">
                            <label>예약 일시</label>
                            <div class="value date-time">{{ selectedDate }} <span class="time-tag">{{ selectedTime }}</span></div>
                        </div>
                        <div class="info-row">
                            <label>예약자명</label>
                            <div class="value">{{ userid }} 님</div>
                        </div>
                    </div>

                    <div class="info-row">
                        <label>요청 사항</label>
                        <div class="value">{{ resContent ? resContent : "요청사항 없음" }}</div>
                    </div>
                </div>

                <div class="ticket-side">
                    <div class="side-content">
                        <img :src="product.thumbnail" class="ticket-side-img">
                        <div class="amount-label">TOTAL DEPOSIT</div>
                        <div class="amount-value">{{ Number(product.deposit).toLocaleString() }}원</div>
                        
                        <div class="agreement-text" @click="fnOpenModal" style="display: flex; align-items: center; gap: 6px; cursor: pointer; margin-top: 15px; user-select: none;">
                            <input type="checkbox" v-model="isAgreed" @click.stop style="cursor: pointer; width: 15px; height: 15px; accent-color: #ff4da6;">
                            <span style="text-decoration: underline; font-weight: bold; color: #ff4da6;">필수 항목 동의 : 노쇼관련 (보기)</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="payment-btn-group">
                <button class="btn-cancel-pay" @click="$emit('back')">뒤로가기</button>
                <button class="btn-final-reserve" @click="fnSaveReservation" :disabled="!isAgreed">예약 저장하기</button>
            </div>
        </div>

        <div v-if="isModalOpen" class="res-custom-modal-overlay" @click="fnCloseModal">
            <div class="res-custom-modal-content" @click.stop>
                <div class="res-custom-modal-header">
                    <h3>⚠️ 필수 약관 동의 (노쇼 관련 규정)</h3>
                </div>
                <div class="res-custom-modal-body">
                    <p><strong>[메리뷰 웨딩 중개 서비스 노쇼 및 환불 규정]</strong></p>
                    <p>1. 메리뷰는 이벤트상품 제공업체와 고객 간의 원활한 매칭 및 예약을 대행하는 중개 서비스 플랫폼입니다.</p>
                    <p>2. 방문 예약을 확정 지은 후, 별도의 사전 고지 없이 당일 불참하는 <strong>'노쇼(No-Show)'</strong> 처리 시 원칙적으로 <strong>예약금은 일체 환불되지 않습니다.</strong></p>
                    <p>3. 단, 불가피한 사정(천재지변, 중대 사고 등)으로 인해 참석이 불가한 경우, 이를 증명할 수 있는 공식 행정/의료 서류를 제출하여 주시면 해당 제휴사 내규에 의거해 예약금 환불 및 일정 조율이 가능합니다.</p>
                    <p style="color: #ff4da6; font-weight: bold; margin-top: 18px; text-align: center;">※ 위 세부 안내 사항을 숙지하셨으며, 규정에 전적으로 동의하십니까?</p>
                </div>
                <div class="res-custom-modal-footer">
                    <button class="modal-btn-cancel" @click="fnCloseModal">닫기</button>
                    <button class="modal-btn-agree" @click="fnAgreeAndClose">동의하고 확인</button>
                </div>
            </div>
        </div>
    </div>
</script>

<script type="text/x-template" id="my-reservation-list-template">
    <div class="my-res-container">
        <button @click="$emit('back')" class="btn-sub-action">← 뒤로가기</button>
        <h2 class="list-title">나의 예약 내역</h2>
        <div v-for="(r, index) in reservationList" :key="index" class="mini-ticket" @click="$emit('go-detail', r)">
            <div class="ticket-img">
                <img :src="r.imgUrl" :alt="r.productName">
            </div>

            <div class="ticket-brief-info">
                <div class="info-top">
                    <span class="res-no">No. {{ r.resNo }}</span>
                </div>

                <h3 class="product-name">{{ r.productName }}</h3>
                <p class="res-date-time">예약 날짜/시간 : {{ r.useDate }} {{ r.useTime.slice(0, 5) + ':00'}}</p>
                <div class="status-message" :class="r.resStatus">
                    <span v-if="r.resStatus === 'WAIT'">⚠️ 30분 이내에 결제하지 않으면 취소됩니다.</span>
                    <span v-else-if="r.resStatus === 'CONFIRM'">✅ 예약이 확정되었습니다.</span>
                    <span v-else-if="r.resStatus === 'DONE'">⏳ 만료된 예약입니다.</span>
                    <span v-else-if="r.resStatus === 'CANCEL'">❌ 취소된 예약입니다.</span>
                </div>
            </div>
            <div class="ticket-edge">
                <span>DETAIL</span>
            </div>
        </div>
    </div>
</script>

<script type="text/x-template" id="reservation-detail-template">
    <div class="payment-container">
        <div class="reservation-ticket">
            <div class="ticket-header">
                <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                <span class="ticket-type">OFFICIAL TICKET</span>
            </div>
            <div class="ticket-body">
                <div class="ticket-info">
                    <div class="info-row product-name">
                        <label>예약 상품</label>
                        <div class="value">{{ reservation.productName }} <small>({{ reservation.comName }})</small></div>
                    </div>
                    <div class="info-row">
                        <label>TOTAL PRICE(상품 및 서비스 가격)</label>
                        <div class="value">{{ Number(reservation.originalPrice).toLocaleString() }}원</div>
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <label>예약 사용일시</label>
                            <div class="value date-time">{{ reservation.useDate }} <span class="time-tag">{{ reservation.useTime }}</span></div>
                        </div>
                        <div class="info-row">
                            <label>예약자명</label>
                            <div class="value">{{ reservation.userId }}님</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <label>예약 저장</label>
                        <div class="value">{{ reservation.resDate }} {{ reservation.resTime }}</div>
                    </div>
                    <div class="info-row">
                        <label>휴대폰 번호</label>
                        <div class="value">{{ reservation.tel }}</div>
                    </div>
                    <div class="info-row">
                        <label>요청 사항</label>
                        <div class="value">{{ reservation.resContent }}</div>
                    </div>
                </div>
                <div class="ticket-side">
                    <div class="side-content">
                        <img :src="reservation.imgUrl" class="ticket-side-img">
                        <div class="amount-label">TOTAL DEPOSIT(예약금)</div>
                        <div class="amount-value">{{ Number(reservation.deposit).toLocaleString() }}원</div>
                        <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                    </div>
                </div>
            </div>
            <div class="payment-btn-group">
                <button class="btn-cancel-pay" @click="$emit('back')">뒤로가기</button>
                <button class="btn-final-reserve" @click="fnPaymentFinal" :disabled="reservation.resStatus !== 'WAIT'">
                    {{ buttonName }}
                </button>
            </div>
        </div>
    </div>
</script>