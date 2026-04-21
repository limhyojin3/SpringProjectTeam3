<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 1. JSTL 코어 태그 라이브러리를 사용하겠다고 선언합니다 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<nav class="navbar navbar-expand-lg sticky-top bg-white shadow-sm" style="border-bottom: 2px solid #fff0f3 !important;">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/" 
           style="color: #ff4d6d !important; font-size: 1.6rem !important; text-decoration: none !important;">
           MERRY VIEW
        </a>
        
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ml-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link" href="#" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">업체찾기</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">커뮤니티</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">리얼리뷰</a>
                </li>

                <%-- 2. 마이페이지 분기 처리: 로그인 했을 때만 보여주고 권한별로 주소 다르게 --%>
                    <li class="nav-item">
                        <c:choose>
                            <%-- 1. 로그인 상태라면: 각각의 마이페이지로 이동 --%>
                            <c:when test="${not empty sessionScope.sessionId}">
                                <c:choose>
                                    <%-- 1. 일반 회원인 경우 --%>
                                    <c:when test="${sessionScope.sessionRole == 'USER'}">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/userMyPage.do" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">마이페이지</a>
                                    </c:when>
                                    <%-- 2. 업체(PARTNER 또는 NPARTNER)인 경우 --%>
                                    <c:when test="${sessionScope.sessionRole == 'PARTNER' or sessionScope.sessionRole == 'NPARTNER'}">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/company10.do" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">업체페이지</a>
                                    </c:when>
                                    <%-- 3. 관리자인 경우 --%>
                                    <c:when test="${sessionScope.sessionRole == 'ADMIN'}">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/adminMain.do" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">관리자페이지</a>
                                    </c:when>
                                </c:choose>
                            </c:when>

                            <%-- 4. 로그인 상태가 아니라면: 그냥 로그인 페이지로 이동 --%>
                            <c:otherwise>
                                <a class="nav-link" href="${pageContext.request.contextPath}/login.do" style="color: #ff4d6d !important; font-weight: 700 !important; padding: 0 15px !important;">마이페이지</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                
                <li class="nav-item mx-3" style="color: #ffb3c1 !important;">|</li>
                <%-- 아이콘 메뉴들 --%>
                <li class="nav-item">
                    <a class="nav-link" href="javascript:;" style="color: #ff4d6d !important; padding: 0 10px !important;">
                        <i class="fas fa-headset" style="font-size: 1.3rem !important;"></i>
                    </a>
                </li>
                <%-- 로그인 시 "OOO님" 문구 표시 --%>
                <c:if test="${not empty sessionScope.sessionId}">
                    <li class="nav-item" style="color: #ff4d6d; font-weight: bold; margin-left: 10px;">
                        <%-- 세션에 저장된 사용자 이름 변수명을 확인하세요 (예: userName) --%>
                        <span>${sessionScope.sessionName}님!</span>
                    </li>
                </c:if>

                <li class="nav-item">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login.do" title="로그인" style="color: #ff4d6d !important; padding: 0 10px !important;">
                                <i class="fas fa-user-circle" style="font-size: 1.3rem !important;"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout.do" title="로그아웃" style="color: #ff4d6d !important; padding: 0 10px !important;">
                                <i class="fas fa-sign-out-alt" style="font-size: 1.3rem !important;"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>
    </div>
</nav>