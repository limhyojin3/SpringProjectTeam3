<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    </head>

    <body>

        <div class="admin-side">
            <% String adminUri=request.getRequestURI(); String forwardUri=(String)
                request.getAttribute("javax.servlet.forward.request_uri"); if (forwardUri !=null) { adminUri=forwardUri;
                } boolean isAccountMenu=adminUri.contains("adminUser") || adminUri.contains("adminCompany") ||
                adminUri.contains("adminRegistration"); boolean isContentMenu=adminUri.contains("adminBoard") ||
                adminUri.contains("adminReview"); boolean isSalesMenu=adminUri.contains("adminPayment") ||
                adminUri.contains("adminPayFinish") || adminUri.contains("adminProduct") ||
                adminUri.contains("adminPass") || adminUri.contains("adminMyPass") ||
                adminUri.contains("adminReservation"); boolean isCsMenu=adminUri.contains("adminReport") ||
                adminUri.contains("adminInquiry"); boolean isStatisticsMenu=adminUri.contains("adminStatistics"); %>

                <a class="admin-title" href="${pageContext.request.contextPath}/adminMain.do">관리자페이지</a>


                <!-- 계정관리 -->
                <div class="menu-box <%= isAccountMenu ? " active" : "" %>">
                    <div class="default-view">계정 관리
                        <a href="${pageContext.request.contextPath}/adminUser.do"></a>
                    </div>
                    <div class="hover-view">
                        <a class="<%= adminUri.contains("adminUser") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminUser.do">회원</a>

                        <a class="<%= adminUri.contains("adminCompany") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminCompany.do">업체</a>
                    </div>
                </div>

                <!-- 콘텐츠관리 -->
                <div class="menu-box <%= isContentMenu ? " active" : "" %>">
                    <div class="default-view">콘텐츠 관리
                        <a href="${pageContext.request.contextPath}/adminBoard.do"></a>
                    </div>
                    <div class="hover-view">
                        <a class="<%= adminUri.contains("adminBoard") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminBoard.do">게시글</a>

                        <a class="<%= adminUri.contains("adminReview") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminReview.do">리뷰</a>
                    </div>
                </div>

                <!-- 매출관리 -->
                <div class="menu-box <%= isSalesMenu ? " active" : "" %>">
                    <div class="default-view">매출 관리
                        <a href="${pageContext.request.contextPath}/adminPayment.do"></a>
                    </div>
                    <div class="hover-view">
                        <a class="<%= adminUri.contains("adminPayment") || adminUri.contains("adminPayFinish")
                            ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminPayment.do">결제</a>

                        <a class="<%= adminUri.contains("adminProduct") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminProduct.do">상품</a>
                    </div>
                </div>

                <!-- 고객센터 -->
                <div class="menu-box <%= isCsMenu ? " active" : "" %>">
                    <div class="default-view">고객센터
                        <a href="${pageContext.request.contextPath}/adminReport.do"></a>
                    </div>
                    <div class="hover-view">
                        <a class="<%= adminUri.contains("adminReport") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminReport.do">신고</a>

                        <a class="<%= adminUri.contains("adminInquiry") ? "activebtn" : "" %>"
                            href="${pageContext.request.contextPath}/adminInquiry.do">문의</a>
                    </div>
                </div>

                <!-- 통계 -->
                <a href="${pageContext.request.contextPath}/adminStatistics.do"
                    class="single-btn <%= isStatisticsMenu ? " active" : "" %>">
                    통계 보기
                </a>

        </div>