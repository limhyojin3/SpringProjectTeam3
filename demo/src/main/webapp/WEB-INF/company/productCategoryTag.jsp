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
                                @back="fnBack"
                                @go-inquiry="goInquiry"
                                @reserve="onDetailReserve" />
                        </div>

                        <!-- 3️⃣ 상품 문의하기 화면 컴포넌트화 -->
                        <div v-if="currentMenu === 'main' && productPage === 'inquiry'">
                            <product-inquiry-write-component 
                                :product="product1" 
                                :session-id="userid"
                                @back="productPage = 'detail'"
                                @success="productPage = 'list'" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'payment'">
                            <product-reservation-payment-component
                                :product="product1"
                                :selected-date="selectedDate"
                                :selected-time="selectedTime"
                                :userid="userid"
                                :res-content="res_content"
                                @back="productPage = 'detail'"
                                @save-reservation="fnSaveReservation(user)" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'resultOfReservation'">
                            <my-reservation-list-component
                                :reservation-list="myReservationList"
                                @back="fnBack()"
                                @go-detail="fnGoDetail" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'reservaionPaymentDetails'">
                            <reservation-detail-component
                                :reservation="myReservation1"
                                :button-name="fnButtonName"
                                @back="productPage='resultOfReservation'"
                                @pay-final="fnPaymentFinal" />
                        </div>

                        <!-- 7️⃣ 나의 문의 내역 목록 화면 컴포넌트화 -->
                        <div v-if="currentMenu === 'main' && productPage === 'myRealInquiryList'">
                            <my-inquiry-list-component 
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
    <jsp:include page="/WEB-INF/company/components/productReservationTemplate.jsp" />

    <script>
        window.SESSION_ID = "${sessionScope.sessionId}";
    </script>
    <script src="/js/company-components/product-list-component.js"></script>
    <script src="/js/company-components/product-detail-component.js"></script>
    <script src="/js/company-components/product-inquiry-component.js"></script>
    <script src="/js/company-components/product-reservation-component.js"></script>

    <script src="/js/product-service.js"></script>
    <script src="/js/product-category-tag.js"></script>