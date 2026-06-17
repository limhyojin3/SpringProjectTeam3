<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- <%-- 1. JSTL 코어 태그 라이브러리를 사용하겠다고 선언합니다 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> -->
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/partner-management.css">
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div id="wrapper">
                <div class="main-content">
                    <div class="container1">
                        <aside>
                            <div class="left-banner">
                                <div class="nav-container">
                                    <div class="nav-title">업체페이지</div>
                                    <button class="nav-btn" @click="handleMenuClick('main')">업체페이지</button>
                                    <button class="nav-btn" @click="handleMenuClick('product')">상품 관리</button>
                                    <button class="nav-btn" @click="handleMenuClick('reservation')">예약 관리</button>
                                    <button class="nav-btn" @click="handleMenuClick('inquiry')">문의 내역</button>
                                    <button class="nav-btn" @click="handleMenuClick('review')">리뷰 내역</button>
                                </div>
                            </div>
                        </aside>
                        <main>
                            <div v-if="currentMenu === 'main'">
                                <main-menu-component :user="user" @reg-ptn="fnRegPTN"></main-menu-component>
                            </div>
                            <div v-if="currentMenu === 'product'">
                                <product-section-component></product-section-component>
                            </div>
                            <!-- 예약관리 페이지 -->
                            <div v-if="currentMenu === 'reservation'">
                                <reservation-section-component
                                    :res-count="resCount"
                                    :selected-res="selectedRes"
                                    :paged-res-list="pagedResList"
                                    :registered-product-list="registeredProductList"
                                    :reservation-list="reservationList"
                                    :res-current-page="resCurrentPage"
                                    :total-res-page-count="totalResPageCount"
                                    :get-res-status-text="getResStatusText"
                                    
                                    @select-res="selectedRes = $event"
                                    @change-page="resCurrentPage = $event"
                                ></reservation-section-component>
                                
                            </div>
                            <div v-if="currentMenu === 'inquiry'">
                                <inquiry-section-component
                                    :view-page="viewPage"
                                    :inquiry-list="inquiryList"
                                    :fn-paginated-inquiry="fnPaginatedInquiry"
                                    :fn-thumbnail="fnThumbnail"
                                    :fn-answer-to-product-inquiry="fnAnswerToProductInquiry"
                                    :current-page="currentPage"
                                    :inquiry-details="inquiryDetails"
                                    :inquiry-answer="inquiryAnswer"
                                    :fn-backto-inquiry="fnBacktoInquiry"
                                    :fn-save-answer="fnSaveAnswer"
                                    
                                    @change-page="currentPage = $event"
                                ></inquiry-section-component>
                                
                            </div>
                            <div v-if="currentMenu === 'review'">
                                <review-section-component
                                    :view-page="viewPage"
                                    :review-tab="reviewTab"
                                    :total-review-cnt="totalReviewCnt"
                                    :total-simple-review-cnt="totalSimpleReviewCnt"
                                    :new-review-cnt="newReviewCnt"
                                    :paged-registered-product-list="pagedRegisteredProductList"
                                    :registered-product-list="registeredProductList"
                                    :review-专-page="reviewListPage"
                                    :review-list-page="reviewListPage"
                                    :total-review-list-pages="totalReviewListPages"
                                    :new-unpaid-review-cnt="newUnpaidReviewCnt"
                                    :paged-product-list-for-simple-reviews="pagedProductListForSimpleReviews"
                                    :total-simple-review-list-pages="totalSimpleReviewListPages"
                                    :reviews="reviews"
                                    :paginated-reviews="paginatedReviews"
                                    :current-page="currentPage"
                                    :total-pages="totalPages"
                                    :simple-reviews="simpleReviews"
                                    :paginated-simple-reviews="paginatedSimpleReviews"
                                    :total-simple-pages="totalSimplePages"
                                    
                                    :fn-review="fnReview"
                                    :fn-simple="fnSimple"
                                    :fn-review-details="fnReviewDetails"
                                    :fn-simple-review-details="fnSimpleReviewDetails"
                                    :fn-go-back-to-list="fnGoBackToList"
                                    :star-rating="starRating"
                                    :clean-text="cleanText"
                                    :fn-page-change="fnPageChange"
                                    
                                    @change-review-list-page="reviewListPage = $event"
                                    @change-current-page="currentPage = $event"
                                ></review-section-component>
                                
                            </div>
                        </main>
                    </div>
                </div>
            </div>
        </div> <!--app 끝-->
        
        <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
    </body>

    </html>

    <jsp:include page="/WEB-INF/company/components/mainTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/productTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/reservationTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/inquiryTemplate.jsp" />
    <jsp:include page="/WEB-INF/company/components/reviewTemplate.jsp" />
    
    <script>
        // 💡 중요: 외부 JS 파일이 JSP 세션 ID를 쓸 수 있도록 전역 변수에 먼저 담아줍니다.
        window.SESSION_ID = "${sessionScope.sessionId}";
    </script>
    <script src="/js/partner-utils.js"></script>
    
    <script src="/js/company-components/main-menu-component.js"></script>
    <script src="/js/company-components/product-section-component.js"></script>
    <script src="/js/company-components/reservation-section-component.js"></script>
    <script src="/js/company-components/inquiry-section-component.js"></script>
    <script src="/js/company-components/review-section-component.js"></script>

    <script src="/js/partner-management.js"></script>