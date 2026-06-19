<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/product-reservation-payment-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/my-reservation-list-template.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/reservation-detail-template.css">

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
                        <div class="value">{{ product.name }} <small>({{ product.company }})</small></div>
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
                        <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                    </div>
                </div>
            </div>

            <div class="payment-btn-group">
                <button class="btn-cancel-pay" @click="$emit('back')">뒤로가기</button>
                <button class="btn-final-reserve" @click="fnSaveReservation">예약 저장하기</button>
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