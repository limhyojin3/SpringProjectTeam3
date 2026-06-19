<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-category.css">
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->

            <div class="container1">
                <main>
                    <main>
                        <product-catalog-component 
                            v-if="productPage === 'list'"
                            :product-list="productList"
                            :product-tag="productTag"
                            @go-detail="goDetailPage"
                            @change-page="changeProductPage" />

                        <div v-if="currentMenu === 'main' && productPage === 'detail'">
                            <!-- {{product1}} -->
                            <button @click="fnBack()" class="btn-sub-action">← 뒤로가기</button>

                            <div class="detail-container">
                                <div class="detail-left">
                                    <img :src="product1.thumbnail" class="detail-main-img">
                                    <div class="detail-company-name">{{ product1.company }}</div>

                                    <div class="detail-description-card">
                                        <h3>{{ product1.name }}</h3>
                                        <p>{{ product1.content }}</p>
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
                                                        :disabled="bookedTimes.includes(t)" @click="fnSelectTime(t)">
                                                        {{ t }}
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="time-slot-group">
                                                <h4 class="time-ampm">오후</h4>
                                                <div class="time-slots">
                                                    <button v-for="t in pmTimes" :key="t" class="time-btn"
                                                        :class="{ 'active': selectedTime === t, 'booked': bookedTimes.includes(t) }"
                                                        :disabled="bookedTimes.includes(t)" @click="fnSelectTime(t)">
                                                        {{ t }}
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="price-info-box">
                                        <div class="price-row">
                                            <span>예상 견적 :</span>
                                            <span>{{ Number(product1.price).toLocaleString() }}원</span>
                                        </div>
                                    </div>
                                    <div class="price-info-box">
                                        <div class="price-row">
                                            <span>예약금 :</span>
                                            <span>{{ Number(product1.deposit).toLocaleString() }}원</span>
                                        </div>
                                    </div>
                                    <button class="btn-reserve" @click="fnReserve">예약하기</button>
                                    <button class="btn-inquiry" @click="goInquiry()">상품 문의하기</button>
                                </div>
                            </div>
                        </div>
                        <div v-if="currentMenu === 'main' && productPage === 'inquiry'" class="payment-container">
                            <div class="reservation-ticket">
                                <div class="ticket-header">
                                    <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                                    <span class="ticket-type">OFFICIAL TICKET</span>
                                </div>

                                <div class="ticket-body">
                                    <div class="ticket-info">
                                        <div class="info-row product-name">
                                            <label>문의할 상품</label>
                                            <div class="value">{{ product1.name }} <small>({{ product1.company
                                                    }})</small></div>
                                        </div>
                                        <div class="info-row">
                                            <label>상품 및 서비스 내용</label>
                                            <div class="value">{{product1.content}}</div>
                                        </div>

                                        <div class="info-grid">
                                            <div class="info-row">
                                                <label>문의자 명</label>
                                                <div class="value">{{"${sessionScope.sessionId}"}}</div>
                                            </div>
                                            <div class="info-row">
                                                <label>문의 제목</label>
                                                <div class="value">
                                                    <input v-model="inquiry.title" class="inquiry-input-title">
                                                </div>
                                            </div>
                                            <div class="info-row">
                                                <label>문의 내용</label>
                                                <div class="value">
                                                    <textarea v-model="inquiry.contents"
                                                        class="inquiry-textarea-contents"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="ticket-side">
                                        <div class="side-content">
                                            <img :src="product1.thumbnail" class="ticket-side-img">
                                            <div class="amount-label">TOTAL PRICE(상품 및 서비스 가격)</div>
                                            <div class="amount-value">{{ Number(product1.price).toLocaleString() }}원
                                            </div>
                                            <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="payment-btn-group">
                                    <button class="btn-cancel-pay" @click="productPage = 'detail'">뒤로가기</button>
                                    <button class="btn-final-reserve" @click="fnInquiryAboutProduct">문의하기</button>
                                </div>
                            </div>
                        </div>
                        <div v-if="currentMenu === 'main' && productPage === 'payment'" class="payment-container">
                            <div class="reservation-ticket">
                                <div class="ticket-header">
                                    <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                                    <span class="ticket-type">OFFICIAL TICKET</span>
                                </div>

                                <div class="ticket-body">
                                    <div class="ticket-info">
                                        <div class="info-row product-name">
                                            <label>예약 상품</label>
                                            <div class="value">{{ product1.name }} <small>({{ product1.company
                                                    }})</small></div>
                                        </div>
                                        <div class="info-row">
                                            <label>TOTAL PRICE(상품 및 서비스 가격)</label>
                                            <div class="value">{{Number(product1.price).toLocaleString()}}원</div>
                                        </div>

                                        <div class="info-grid">
                                            <div class="info-row">
                                                <label>예약 일시</label>
                                                <div class="value date-time">{{ selectedDate }} <span
                                                        class="time-tag">{{ selectedTime }}</span></div>
                                            </div>
                                            <div class="info-row">
                                                <label>예약자명</label>
                                                <div class="value">{{userid}} 님</div>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <label>요청 사항</label>
                                            <div class="value">{{res_content ? res_content : "요청사항 없음"}}</div>
                                        </div>
                                    </div>

                                    <div class="ticket-side">
                                        <div class="side-content">
                                            <img :src="product1.thumbnail" class="ticket-side-img">
                                            <div class="amount-label">TOTAL DEPOSIT</div>
                                            <div class="amount-value">{{ Number(product1.deposit).toLocaleString() }}원
                                            </div>
                                            <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="payment-btn-group">
                                    <button class="btn-cancel-pay" @click="productPage = 'detail'">뒤로가기</button>
                                    <button class="btn-final-reserve" @click="fnSaveReservation(user)">예약 저장하기</button>
                                </div>
                            </div>
                        </div>



                        <div v-if="currentMenu === 'main' && productPage === 'resultOfReservation'"
                            class="my-res-container">
                            <button @click="fnBack()" class="btn-sub-action">← 뒤로가기</button>
                            <h2 class="list-title">나의 예약 내역</h2>
                            <div v-for="(r, index) in myReservationList" :key="index" class="mini-ticket"
                                @click="fnGoDetail(r)">
                                <div class="ticket-img">
                                    <img :src="r.imgUrl" :alt="r.productName">
                                </div>

                                <div class="ticket-brief-info">
                                    <div class="info-top">
                                        <span class="res-no">No. {{ r.resNo }}</span>
                                    </div>

                                    <h3 class="product-name">{{ r.productName }}</h3>
                                    <p class="res-date-time">예약 날짜/시간 : {{ r.useDate }} {{ r.useTime.slice(0, 5) +
                                        ':00'}}</p>
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

                        <div v-if="currentMenu === 'main' && productPage === 'reservaionPaymentDetails'"
                            class="payment-container">
                            <div class="reservation-ticket">
                                <div class="ticket-header">
                                    <span class="ticket-brand">MARRY VIEW RESERVATION</span>
                                    <span class="ticket-type">OFFICIAL TICKET</span>
                                </div>
                                <div class="ticket-body">
                                    <div class="ticket-info">
                                        <div class="info-row product-name">
                                            <label>예약 상품</label>
                                            <div class="value">{{ myReservation1.productName }} <small>({{
                                                    myReservation1.comName }})</small></div>
                                        </div>
                                        <div class="info-row">
                                            <label>TOTAL PRICE(상품 및 서비스 가격)</label>
                                            <div class="value">
                                                {{Number(myReservation1.originalPrice).toLocaleString()}}원</div>
                                        </div>
                                        <div class="info-grid">
                                            <div class="info-row">
                                                <label>예약 사용일시</label>
                                                <div class="value date-time">{{ myReservation1.useDate }} <span
                                                        class="time-tag">{{ myReservation1.useTime }}</span></div>
                                            </div>
                                            <div class="info-row">
                                                <label>예약자명</label>
                                                <div class="value">{{ myReservation1.userId }}님</div>
                                            </div>
                                        </div>
                                        <div class="info-row">
                                            <label>예약 저장</label>
                                            <div class="value">{{ myReservation1.resDate }} {{ myReservation1.resTime}}
                                            </div>
                                        </div>
                                        <div class="info-row">
                                            <label>휴대폰 번호</label>
                                            <div class="value">{{ myReservation1.tel }}</div>
                                        </div>
                                        <div class="info-row">
                                            <label>요청 사항</label>
                                            <div class="value">{{myReservation1.resContent}}</div>
                                        </div>
                                    </div>
                                    <div class="ticket-side">
                                        <div class="side-content">
                                            <img :src="myReservation1.imgUrl" class="ticket-side-img">
                                            <div class="amount-label">TOTAL DEPOSIT(예약금)</div>
                                            <div class="amount-value">{{ Number(myReservation1.deposit).toLocaleString()
                                                }}원</div>
                                            <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="payment-btn-group">
                                    <button class="btn-cancel-pay"
                                        @click="productPage='resultOfReservation'">뒤로가기</button>
                                    <button class="btn-final-reserve" @click="fnPaymentFinal()"
                                        :disabled="myReservation1.resStatus !== 'WAIT'">
                                        {{fnButtonName}}
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- 나의 문의내역 보는 리스트-->
                        <div v-if="currentMenu === 'main' && productPage === 'myRealInquiryList'"
                            class="my-real-inquiry-container">
                            <div class="inquiry-header-bar">
                                <h2 class="inquiry-header-title">나의 문의 내역</h2>
                                <button @click="productPage = 'list'" class="btn-sub-action">뒤로가기</button>
                            </div>

                            <div v-if="myInquiryList && myInquiryList.length > 0">
                                <div v-for="(inquiry, index) in myInquiryList" :key="index"
                                    @click="fnInquiryAnswerDetails(inquiry)" class="inquiryTicket list-view-ticket">

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
                        <div v-if="currentMenu === 'main' && productPage === 'inquiry1Details'"
                            class="inquiry-detail-container">
                            <div class="inquiry-detail-header">
                                <h2 class="inquiry-detail-title">문의 내용 상세보기</h2>
                                <button @click="productPage = 'myRealInquiryList'" class="btn-back-outline">← 리스트로
                                    돌아가기</button>
                            </div>

                            <div class="inquiry-product-card">
                                <img :src="myInquiry1.imgUrl" alt="문의 상품 이미지">
                                <div>
                                    <div class="inquiry-card-label">문의 상품</div>
                                    <div class="inquiry-card-name">{{ myInquiry1.productName }}</div>
                                </div>
                            </div>

                            <div class="inquiry-content-box-wrapper">
                                <div class="inquiry-box-header">
                                    <span class="inquiry-box-label">나의 문의</span>
                                    <span class="inquiry-box-number">No. {{ myInquiry1.inquiryNo }}</span>
                                </div>
                                <div class="inquiry-box-body">
                                    <h3 class="inquiry-body-title">Q. {{ myInquiry1.inquiryTitle }}</h3>
                                    <div class="inquiry-body-text">{{ myInquiry1.inquiryContents }}</div>
                                </div>
                            </div>

                            <div v-if="myInquiry1.inquiryAns === '1'" class="answer-box-wrapper">
                                <div class="answer-box-header">
                                    <span class="answer-prefix">A.</span> 업체 답변
                                </div>
                                <div class="answer-box-body">
                                    <div class="answer-body-text">
                                        {{ myInquiry1.answerContents || '답변 내용을 불러오는 중입니다.' }}
                                    </div>
                                    <div class="answer-body-meta">
                                        답변자: {{ myInquiry1.ansCompany || '관리자' }}
                                    </div>
                                </div>
                            </div>

                            <div v-else class="answer-wait-box">
                                <div class="answer-wait-icon">⏳</div>
                                답변을 기다리고 있습니다. 조금만 더 기다려 주세요!
                            </div>
                        </div>
            </div>
        </div>

        </main>
        </main>
        </div>
        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />

        <!-- <div class="ai-chatbot">ai 챗봇</div> -->
        </div>
    </body>

    </html>
    <jsp:include page="/WEB-INF/company/components/catalogTemplate.jsp" />

    <script>
        window.SESSION_ID = "${sessionScope.sessionId}";
    </script>
    <script src="/js/company-components/catalog-component.js"></script>

    <script src="/js/product-category-tag.js"></script>
