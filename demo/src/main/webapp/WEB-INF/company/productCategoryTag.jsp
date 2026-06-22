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
            <div class="container1">
                <main>
                    <main>
                        <div v-if="currentMenu === 'main' && productPage === 'list'">
                            <product-list-component 
                                :product-list="productList"
                                :product-tag="productTag"
                                @update-filter-list="fnLoadProductList"
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
                                @success="onReservationSuccess" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'resultOfReservation'">
                            <my-reservation-list-component
                                @back="fnBack"
                                @go-detail="fnGoDetail" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'reservaionPaymentDetails'">
                            <reservation-detail-component
                                :reservation="myReservation1"
                                @back="productPage='resultOfReservation'"
                                @payment-success="onReservationSuccess" />
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'myRealInquiryList'">
                            <my-inquiry-list-component 
                                @back="productPage = 'list'"
                                @go-detail="fnInquiryAnswerDetails" />
                        </div>

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

    <script src="/js/product-service.js"></script>
    <script src="/js/product-category-tag.js"></script>