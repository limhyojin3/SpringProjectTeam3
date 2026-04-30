<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 1. JSTL 코어 태그 라이브러리를 사용하겠다고 선언합니다 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<head>
    <style>
       /* 1. 드롭다운 전체 래퍼 및 기본 설정 */
        .dropdown-header-wrap,
        .dropdown-header-wrap .container,
        .dropdown-header-wrap .navbar-collapse,
        .dropdown-header-wrap .navbar-nav {
            overflow: visible !important;
        }

        .dropdown-header-wrap {
            position: relative;
            z-index: 1000;
            background-color: white !important;
        }

        /* 2. 메인 메뉴(1차) 링크 스타일 */
        .custom-nav-link {
            /* 1. 핵심: 글자가 어떤 상황에서도 한 줄로 나오게 고정 */
            white-space: nowrap !important;
            /* 2. 메뉴 글자가 박스 밖으로 삐져나가지 않게 처리 */
            display: inline-block !important;
            /* 3. 메뉴 사이의 여백이 너무 넓다면 아래 수치를 살짝 줄여보세요 (기존 15px -> 10px) */
            padding: 15px 10px !important;
            /* 기존 폰트 설정 유지 */
            color: #ff4d6d !important;
            font-weight: 700 !important;
            text-decoration: none !important;
        }

        /* 3. 흰색 전체 배경판 (마이페이지 항목 수에 맞춰 높이 확장) */
        .header-bg-panel {
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            height: 0; /* 기본 상태 */
            background-color: white;
            border-bottom: 2px solid #fff0f3;
            transition: height 0.3s ease-in-out;
            z-index: -1;
            box-shadow: 0 10px 20px rgba(255, 77, 109, 0.05);
        }

        /* 활성화 시 배경판 높이 - 마이페이지 6개 항목 기준 320px */
        .dropdown-header-wrap.is-active .header-bg-panel {
            height: 270px; 
        }

        /* 4. 서브메뉴(2차) 리스트 및 정렬 (겹침 해결 핵심) */
        .nav-item.has-dropdown {
            position: relative;
            /* 메뉴 간 간격을 조금 더 넓혀서 겹침 방지 */
            margin: 0 15px; 
        }

        .dropdown-contents {
            min-width: 120px; /* 글자가 잘리지 않게 최소 너비를 조금 넓힘 */
            position: absolute;
            /* 1. 박스를 부모 메뉴의 정중앙으로 이동시키는 마법의 공식 */
            left: 50% !important;
            transform: translateX(-40%) !important; 
            top: 100%;
            width: auto;
            list-style: none !important;
            padding: 5px 0 !important; /* 위아래 여백만 유지 */
            margin: 0 !important;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease-in-out;
            /* 2. 글자 중앙 정렬 */
            text-align: center !important; 
        }

        /* 활성화 시 위치 유지 (기존 transform과 겹치지 않게 주의) */
        .dropdown-header-wrap.is-active .dropdown-contents {
            opacity: 1;
            visibility: visible;
            /* translateY만 살짝 추가해서 아래로 내려오는 효과 */
            transform: translateX(-50%) translateY(0) !important;
        }

        /* 활성화 시 서브메뉴 노출 */
        .dropdown-header-wrap.is-active .dropdown-contents {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        /* 5. 서브메뉴 아이템 글자 스타일 */
        .dropdown-contents li a {
            color: #888 !important;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 10px 5px !important;
            display: block;
            text-decoration: none !important;
            white-space: nowrap !important; /* 글자 줄바꿈 방지 */
            transition: color 0.2s;
        }

        .dropdown-contents li a:hover {
            color: #ff4d6d !important;
        }

        /* 화살표 아이콘 */
        .arrow-icon {
            font-size: 0.6rem;
            margin-left: 6px;
            opacity: 0.5;
        }
    </style>
</head>
<nav class="navbar navbar-expand-lg sticky-top bg-white shadow-sm dropdown-header-wrap" style="border-bottom: 2px solid #fff0f3 !important;">
    <div class="container">
        <a class="navbar-brand font-weight-bold"
           style="color: #ff4d6d !important; font-size: 1.6rem !important; text-decoration: none !important;"
           href="${pageContext.request.contextPath}/merryViewHome.do">
            MARRY VIEW
        </a>
        
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ml-auto" style="align-items: center; overflow: visible !important;">
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="javascript:void(0)">회사소개 </a>
                    <ul class="dropdown-contents">
                        <li><a href="/about.do">메리뷰 소개</a></li>
                        <li><a href="/location.do">찾아오시는 길</a></li>
                    </ul>
                </li>

                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="javascript:void(0)">상품목록</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/productCategoryTag.do">상품 찾기</a></li>
                    </ul>
                </li>

                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="javascript:void(0)">커뮤니티</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do">전체 보기</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=자유">자유글</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=질문">질문글</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=정보공유">정보공유글</a></li>
                    </ul>
                </li>

                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="javascript:void(0)">리얼리뷰</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/api/review/list.do">전체보기</a></li>
                        <li><a href="/api/review/list.do?isPaid=1">💎 유료 리뷰</a></li>
                        <li><a href="/api/review/list.do?isPaid=0">🎁 무료 리뷰</a></li>
                    </ul>
                </li>

                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="javascript:void(0)">패스구매</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/adminPass.do">패스구매</a></li>
                    </ul>
                </li>

                <li class="nav-item has-dropdown">
                    <c:choose>
                        <%-- 1. 로그인 상태 확인 --%>
                        <c:when test="${not empty sessionScope.sessionId}">
                            <c:choose>
                                <%-- 2. 일반 사용자(USER)인 경우만 드롭다운 메뉴 포함 --%>
                                <c:when test="${sessionScope.sessionRole == 'USER'}">
                                    <a class="nav-link custom-nav-link" href="javascript:void(0);">마이페이지</a>
                                    <ul class="dropdown-contents">
                                        <li><a href="${pageContext.request.contextPath}/userMyPage.do">마이페이지 홈</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-pay.do">결제 멤버십 내역</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-review.do">리뷰 열람 내역</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-write.do">내가 쓴 글/리뷰/댓글</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-like.do">좋아요 목록</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-cs.do">내 문의/신고 내역</a></li>
                                    </ul>
                                </c:when>

                                <%-- 3. 파트너/관리자 등은 드롭다운 없이 단일 링크로 유지 --%>
                                <c:when test="${sessionScope.sessionRole == 'PARTNER' or sessionScope.sessionRole == 'NPARTNER'}">
                                    <a class="nav-link custom-nav-link" href="javascript:void(0)">업체페이지</a>
                                    <ul class="dropdown-contents">
                                        <li><a href="${pageContext.request.contextPath}/partnerManagement.do">업체페이지 홈</a></li>
                                        <li><a href="${pageContext.request.contextPath}/partnerManagement.do?menu=product">상품 관리</a></li>
                                        <li><a href="${pageContext.request.contextPath}/partnerManagement.do?menu=reservation">예약 관리</a></li>
                                        <li><a href="${pageContext.request.contextPath}/partnerManagement.do?menu=inquiry">문의 내역</a></li>
                                        <li><a href="${pageContext.request.contextPath}/partnerManagement.do?menu=review">리뷰 내역</a></li>
                                    </ul>
                                </c:when>
                                <c:when test="${sessionScope.sessionRole == 'ADMIN'}">
                                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/adminMain.do">관리자페이지 <i class="fas fa-chevron-right arrow-icon"></i></a>
                                </c:when>
                            </c:choose>
                        </c:when>

                        <%-- 4. 비로그인 상태일 때 --%>
                        <c:otherwise>
                            <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/login.do">마이페이지 <i class="fas fa-chevron-right arrow-icon"></i></a>
                        </c:otherwise>
                    </c:choose>
                </li>

                <li class="nav-item mx-3" style="color: #ffb3c1 !important;">|</li>
                
                <c:if test="${sessionRole != 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${sessionRole == 'COMPANY' ? '#' : '/userMyPage-cs.do'}" style="color: #ff4d6d !important; padding: 0 10px !important;">
                            <i class="fas fa-headset" style="font-size: 1.3rem !important;"></i>
                        </a>
                    </li>
                </c:if>

                <c:if test="${not empty sessionScope.sessionId}">
                    <li class="nav-item" style="color: #ff4d6d; font-weight: bold; margin-left: 10px;">
                        <span>${sessionScope.sessionName}님!</span>
                    </li>
                </c:if>

                <li class="nav-item">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login.do" title="로그인" style="color: #ff4d6d !important; padding: 0 10px !important;">
                                <i class="fas fa-user-circle" style="font-size: 1.3rem !important;"></i>
                                <span style="font-size: 0.95rem; font-weight: bold; margin-left: 4px;">로그인</span>
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
    <div class="header-bg-panel"></div>
</nav>
<script>
document.addEventListener('DOMContentLoaded', function() {

    // ── 1. 헤더 드롭다운 (기존 방식 유지) ──────────────────
    const header = document.querySelector('.dropdown-header-wrap');
    if (header) {
        header.addEventListener('mouseenter', () => header.classList.add('is-active'));
        header.addEventListener('mouseleave', () => header.classList.remove('is-active'));
    }

    // ── 2. URL 파라미터 탭 클릭 처리 ──────────────────────
    function handleTabClick() {
        const urlParams = new URLSearchParams(window.location.search);
        const categoryParam = urlParams.get('category');
        const isPaidParam   = urlParams.get('isPaid');

        // 업체 로그인 시← 추가
        if (menuParam) {
            setTimeout(() => {
                const navBtns = document.querySelectorAll('.nav-btn');
                navBtns.forEach(btn => {
                    const menuMap = {
                        'product': '상품 관리',
                        'reservation': '예약 관리',
                        'inquiry': '문의 내역',
                        'review': '리뷰 내역'
                    };
                    if (btn.innerText.trim() === menuMap[menuParam]) {
                        btn.click();
                    }
                });
            }, 400);
        }

        // A. 유료/무료 리뷰 탭
        if (isPaidParam !== null) {
            document.querySelectorAll('.review-tabs .tab-item').forEach(tab => {
                if ((isPaidParam === '1' && tab.innerText.includes('유료')) ||
                    (isPaidParam === '0' && tab.innerText.includes('무료'))) {
                    tab.click();
                }
            });
        }

        // B. 카테고리 탭 (자유글, 질문글, 정보공유글 등)
        if (categoryParam) {
            document.querySelectorAll('button, .tab-item').forEach(btn => {
                const btnText = btn.innerText.replace(/[^가-힣a-zA-Z]/g, '').trim();
                if (btnText.includes(categoryParam.trim())) {
                    btn.click();
                }
            });
        }
    }

    // Vue 마운트 완료 후 실행
    const observer = new MutationObserver(() => {
        const tabs = document.querySelectorAll('.review-tabs .tab-item, .tab-item, button');
        if (tabs.length > 0) {
            observer.disconnect();
            handleTabClick();
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });

    // 이미 렌더링 완료된 경우 바로 실행
    handleTabClick();

});


</script>