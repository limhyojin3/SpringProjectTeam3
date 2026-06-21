<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productDetailLayout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productReservation.css">

<script type="text/x-template" id="product-detail-template">
    <div>
        <button @click="$emit('back')" class="btn-sub-action">← 뒤로가기</button>

        <div class="detail-container">
            <div class="detail-left">
                <img :src="product.thumbnail" class="detail-main-img">
                <div class="detail-company-name">{{ product.comName }}</div>

                <div class="detail-description-card">
                    <h3>{{ product.name }}</h3>
                    <p>{{ product.content }}</p>
                    <hr>
                    <p>※ 상세 옵션 안내 및 유의사항 :</p>
                    <p>메리뷰는 웨딩업체의 상품을 중개합니다.
                       상품 예약 후 날짜와 시간을 꼭 유의하여 주시기 바랍니다.
                       노쇼인 경우 예약금 환불은 원칙적으로 불가하며
                       피치못한 사정으로 노쇼하실 경우, 불참 사유를 증명할 서류를 지참하시면
                       소비자보호원의 소비자 권익에 대한 법적 사항을 준수하며
                       업체 내 환불규정에 따라 검토후 예약금 환불이 가능합니다.</p>
                </div>

                <div class="detail-description-card2">
                    <h3>요청 사항</h3>
                    <textarea v-model="res_content" placeholder="예약시 요청 사항을 여기에 작성해주세요."></textarea>
                </div>
            </div>

            <div class="detail-right">
                <div class="reservation-box">
                    <div class="reservation-box-title">예약하기</div>

                    <div class="calendar-placeholder detail-view">
                        <label for="res-date">방문 예정일을 선택해주세요</label>
                        <input type="date" id="res-date" v-model="selectedDate">
                    </div>

                    <div class="booking-time-container">
                        <h3 class="section-title">방문 희망 시간을 선택해 주세요</h3>
                        
                        <div class="time-slot-group">
                            <h4 class="time-ampm">오전</h4>
                            <div class="time-slots">
                                <button v-for="t in amTimes" :key="t" class="time-btn"
                                    :class="{ 'active': selectedTime === t, 'booked': bookedTimes.includes(t) }"
                                    :disabled="bookedTimes.includes(t)" @click="selectedTime = t">
                                    {{ t }}
                                </button>
                            </div>
                        </div>

                        <div class="time-slot-group">
                            <h4 class="time-ampm">오후</h4>
                            <div class="time-slots">
                                <button v-for="t in pmTimes" :key="t" class="time-btn"
                                    :class="{ 'active': selectedTime === t, 'booked': bookedTimes.includes(t) }"
                                    :disabled="bookedTimes.includes(t)" @click="selectedTime = t">
                                    {{ t }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="price-info-box">
                    <div class="price-row">
                        <span>예상 견적 :</span>
                        <span>{{ Number(product.price).toLocaleString() }}원</span>
                    </div>
                </div>
                <div class="price-info-box">
                    <div class="price-row">
                        <span>예약금 :</span>
                        <span>{{ Number(product.deposit).toLocaleString() }}원</span>
                    </div>
                </div>
                
                <button class="btn-reserve" @click="submitReserve">예약하기</button>
                <button class="btn-inquiry" @click="$emit('go-inquiry')">상품 문의하기</button>
            </div>
        </div>
    </div>
</script>