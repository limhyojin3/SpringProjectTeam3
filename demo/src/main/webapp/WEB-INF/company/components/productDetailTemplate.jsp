<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productDetailLayout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productReservation.css">

<script type="text/x-template" id="product-detail-template">
    <div>
        <button @click="$emit('back')" class="btn-sub-action">← 뒤로가기</button>

        <div class="detail-container">
            <div class="detail-left">
                <img :src="product.thumbnail" class="detail-main-img">
                
                <!-- 💡 타이틀 아키텍처 대개혁: 상품 이름을 웅장한 블랙 타이틀로 주인공 배치하고, 업체명은 그 위에 세련된 미니 배지로 서열 재정립 완료 -->
                <div class="detail-title-area">
                    <div class="detail-badge-company">{{ product.comName }}</div>
                    <h2 class="detail-product-title">{{ product.name }}</h2>
                </div>

                <div class="detail-description-card">
                    <p style="font-size: 16px; color: #333; margin-bottom: 20px; font-weight: 500;">{{ product.content }}</p>
                    <hr>
                    <p style="font-weight: bold; color: #ff4da6; margin-bottom: 12px;">※ 상세 옵션 안내 및 유의사항 :</p>
                    <ol style="padding-left: 20px; margin: 0; color: #444; font-size: 14px; line-height: 1.8;">
                        <li style="margin-bottom: 10px;"><strong>메리뷰는</strong> 이벤트상품 제공업체와 고객 간의 원활한 매칭 및 예약을 대행하는 중개 서비스 플랫폼입니다. 상품 예약 후 날짜와 시간을 꼭 유의하여 주시기 바랍니다.</li>
                        <li style="margin-bottom: 10px;">방문 예약을 확정 지은 후, 별도의 사전 고지 없이 당일 불참하는 <strong>'노쇼(No-Show)'</strong> 처리 시 원칙적으로 <strong>예약금은 일체 환불되지 않습니다.</strong></li>
                        <li style="margin-bottom: 0;">단, 불가피한 사정으로 인해 참석이 불가한 경우, 이를 증명할 수 있는 <strong>공식 서류를 지참하시면</strong> 소비자보호원의 소비자 권익에 대한 법적 사항을 준수하며 업체 내 환불규정에 따라 검토 후 예약금 환불이 가능합니다.</li>
                    </ol>
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
                
                <!-- 💡 버튼 아키텍처 대개혁: Primary 그라데이션 버튼과 Secondary 아웃라인 고스트 디자인 단자로 분리 매핑 개통 -->
                <button class="btn-reserve" @click="submitReserve">예약하기</button>
                <button class="btn-inquiry" @click="$emit('go-inquiry')">상품 문의하기</button>
            </div>
        </div>
    </div>
</script>
<script src="${pageContext.request.contextPath}/js/company-components/product-detail-component.js"></script>