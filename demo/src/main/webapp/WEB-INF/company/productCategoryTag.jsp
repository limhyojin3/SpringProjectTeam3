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
                        <div v-if="currentMenu === 'main' && productPage === 'list'">
                            <!-- 💡 우리가 만든 상품 목록 컴포넌트를 조립합니다 -->
                            <product-list-component 
                                :product-list="productList"
                                :product-tag="productTag"
                                @go-detail="goDetailPage"
                                @go-my-res="goMyResPage"
                                @go-my-inquiry="goMyInquiryPage" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'detail'">
                            <product-detail-component
                                :product="product1"
                                :am-times="amTimes"
                                :pm-times="pmTimes"
                                :booked-times="bookedTimes"
                                @back="fnBack"
                                @go-inquiry="goInquiry"
                                @date-changed="onDetailDateChanged"
                                @reserve="onDetailReserve" />
                        </div>

                        <!-- 3️⃣ 상품 문의하기 화면 컴포넌트화 -->
                        <div v-if="currentMenu === 'main' && productPage === 'inquiry'">
                            <product-inquiry-write-component 
                                :product="product1"
                                :session-id="'${sessionScope.sessionId}'"
                                @back="productPage = 'detail'"
                                @submit="onInquirySubmit" />
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

                        <!-- 7️⃣ 나의 문의 내역 목록 화면 컴포넌트화 -->
                        <div v-if="currentMenu === 'main' && productPage === 'myRealInquiryList'">
                            <my-inquiry-list-component 
                                :inquiry-list="myInquiryList"
                                @back="productPage = 'list'"
                                @go-detail="fnInquiryAnswerDetails" />
                        </div>

                        <!-- 8️⃣ 단건 문의 내역 상세 답변 확인 화면 컴포넌트화 -->
                        <div v-if="currentMenu === 'main' && productPage === 'inquiry1Details'">
                            <inquiry-detail-component 
                                :inquiry="myInquiry1"
                                @back="productPage = 'myRealInquiryList'" />
                        </div>
                        
                    </main>
                </main>
            </div>
        </div> 

        <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
    </body>
 
    </html>

    <jsp:include page="/WEB-INF/company/components/productListTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/productDetailTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/productInquiryTemplate.jsp" />

    <script>
        window.SESSION_ID = "${sessionScope.sessionId}";
    </script>
    <script src="/js/company-components/product-list-component.js"></script>
    <script src="/js/company-components/product-detail-component.js"></script>
    <script src="/js/company-components/product-inquiry-component.js"></script>
    <script src="/js/product-category-tag.js"></script>