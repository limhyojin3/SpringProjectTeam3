<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

<style>
    /* ── 드롭다운 전체 래퍼 ── */
    .dropdown-header-wrap,
    .dropdown-header-wrap .container,
    .dropdown-header-wrap .navbar-collapse,
    .dropdown-header-wrap .navbar-nav {
        overflow: visible !important;
    }

    .dropdown-header-wrap .container {
        max-width: 1300px;
        padding: 0 20px;
    }

    /* 기본 유저 */
    .dropdown-header-wrap {
        border-bottom: 2px solid #fff0f3;
        box-shadow: 0 2px 4px rgba(255, 77, 109, 0.08);
        position: sticky;  /* ← 기존 코드에 있던 거 여기로 통합 */
        z-index: 1000;
        background-color: white !important;
    }

    /* 관리자 */
    .admin-mode {
        border-bottom: 2px solid #0f3460 !important;
        box-shadow: none !important;
    }

    /* ── 메인 메뉴(1차) 링크 ── */
    .custom-nav-link {
        white-space: nowrap !important;
        display: inline-block !important;
        padding: 15px 10px !important;
        color: #ff4d6d !important;
        font-weight: 700 !important;
        text-decoration: none !important;
    }

    /* ── 흰색 전체 배경판 ── */
    .header-bg-panel {
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        height: 0;
        background-color: white;
        border-bottom: 2px solid #fff0f3;
        transition: height 0.3s ease-in-out;
        z-index: -1;
        box-shadow: 0 10px 20px rgba(255, 77, 109, 0.05);
    }

    .dropdown-header-wrap.is-active .header-bg-panel {
        height: 270px;
    }

    /* ── 서브메뉴(2차) ── */
    .nav-item.has-dropdown {
        position: relative;
        margin: 0 15px;
    }

    .dropdown-contents {
        min-width: 120px;
        position: absolute;
        left: 50% !important;
        transform: translateX(-40%) !important;
        top: 100%;
        width: auto;
        list-style: none !important;
        padding: 5px 0 !important;
        margin: 0 !important;
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease-in-out;
        text-align: center !important;
    }

    .dropdown-header-wrap.is-active .dropdown-contents {
        opacity: 1;
        visibility: visible;
        transform: translateX(-50%) translateY(0) !important;
    }

    /* ── 서브메뉴 아이템 ── */
    .dropdown-contents li a {
        color: #888 !important;
        font-size: 0.9rem;
        font-weight: 500;
        padding: 10px 5px !important;
        display: block;
        text-decoration: none !important;
        white-space: nowrap !important;
        transition: color 0.2s;
    }

    .navbar .custom-nav-link:hover { color: #ff4d6d !important; }
    .navbar.partner-mode .custom-nav-link:hover { color: #9b8fd4 !important; }
    .navbar.admin-mode .custom-nav-link:hover { color: #e94560 !important; }

    .dropdown-contents li a:hover {
        color: #ff4d6d !important;
    }

    /* ── 화살표 아이콘 ── */
    .arrow-icon {
        font-size: 0.6rem;
        margin-left: 6px;
        opacity: 0.5;
    }

    /* ── 리얼리뷰 아이콘 ── */
    .fa-crown { color: #f0b429; }
    .fa-tag   { color: #ff8fab; }

    /* ── 알림 ── */
    .notification-wrap {
        position: relative;
        margin-left: 15px;
    }

    .notification-btn {
        color: #ff4d6d;
        font-size: 20px;
        position: relative;
        display: flex;
        align-items: center;
        text-decoration: none;
    }

    .notification-dropdown {
        display: none;
        position: absolute;
        top: 100%;
        right: 0;
        margin-top: 0;
        width: 340px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, .12);
        overflow: hidden;
        z-index: 9999;
    }

    .notification-wrap:hover .notification-dropdown {
        display: block;
    }

    .notification-header {
        display: flex;
        justify-content: space-between;
        padding: 15px;
        border-bottom: 1px solid #eee;
        font-weight: bold;
    }

    .notification-item {
        padding: 15px;
        border-bottom: 1px solid #f3f3f3;
        cursor: pointer;
        transition: .2s;
    }

    .notification-item:hover { background: #fff5f7; }
    .notification-item.unread { background: #eef7ff; }

    .notification-content {
        font-size: 14px;
        color: #444;
    }

    .notification-date {
        margin-top: 5px;
        color: #999;
        font-size: 12px;
    }

    .notification-footer {
        text-align: center;
        padding: 12px;
    }

    /* 기본 (유저) */
    .nav-name { color: #ff4d6d; font-weight: bold; margin-left: 10px; }
    .nav-icon-btn { color: #ff4d6d !important; padding: 0 10px !important; }

    /* ── 업체 모드 (연보라) ── */
    .partner-mode {
        background-color: #f8f6ff !important;
        border-bottom: 2px solid #d4cef0 !important;
        box-shadow: 0 2px 4px rgba(155, 143, 212, 0.08) !important;
    }
    .partner-mode .custom-nav-link { color: #9b8fd4 !important; }
    .partner-mode .header-bg-panel {
        background-color: #f8f6ff;
        border-bottom: 2px solid #f8f6ff;

    }
    .partner-mode .dropdown-contents li a:hover { color: #9b8fd4 !important; }
    .partner-mode .notification-btn,
    .partner-mode li[style*="color:#ff4d6d"],
    .partner-mode .nav-name span { color: #9b8fd4 !important; }
    .partner-mode .nav-name span { color: #9b8fd4 !important; }
    .partner-mode .nav-icon-btn { color: #9b8fd4 !important; }
    .partner-mode .nav-divider { color: #d4cef0 !important; }
    .partner-mode .navbar-brand span { color: #9b8fd4 !important; }
    .partner-mode .navbar-brand img { filter: hue-rotate(270deg); }

    /* ── 관리자 모드 (다크) ── */
    .admin-mode {
        background-color: #1a1a2e !important;
        border-bottom: 2px solid #0f3460 !important;
        box-shadow: none !important;
    }
    .admin-mode .custom-nav-link { color: #e94560 !important; }
    .admin-mode .header-bg-panel {
        background-color: #16213e;
        border-bottom: 2px solid #0f3460;
    }
    .admin-mode .dropdown-contents li a { color: #aaa !important; }
    .admin-mode .dropdown-contents li a:hover { color: #eee !important; }
    .admin-mode .notification-btn,
    .admin-mode .nav-link,
    .admin-mode li span { color: #eee !important; }
    .admin-mode .nav-name span { color: #eee !important; }
    .admin-mode .nav-icon-btn { color: #eee !important; }
    .admin-mode .nav-divider { color: #0f3460 !important; }
    .admin-mode .navbar-brand span { color: #eeeeee !important; }
    .admin-mode .navbar-brand img { filter: brightness(0) invert(1); }

    .navbar.partner-mode .nav-link:hover {
    text-shadow: 0 0 8px rgba(155, 143, 212, 0.5) !important;
    }
    .navbar.admin-mode .nav-link:hover {
        text-shadow: 0 0 8px rgba(233, 69, 96, 0.5) !important;
    }
</style>

<nav class="navbar navbar-expand-lg sticky-top dropdown-header-wrap
    <c:if test="${sessionScope.sessionRole == 'PARTNER' or sessionScope.sessionRole == 'NPARTNER'}">partner-mode</c:if>
    <c:if test="${sessionScope.sessionRole == 'ADMIN'}">admin-mode</c:if>">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/merryViewHome.do"
            style="text-decoration:none!important; display:flex; align-items:center; gap:20px;">
            <img src="${pageContext.request.contextPath}/css/marryview-logo.svg" alt="MARRY VIEW" style="height:35px; width:auto;">
            <span style="font-family:'Playfair Display',Georgia,serif; font-size:30px; font-weight:700; color:#ff4d6d; letter-spacing:0.5px;">MarryView</span>
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ml-auto" style="align-items: center; overflow: visible !important;">

                <!-- 회사소개 -->
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/about.do">회사소개</a>
                    <ul class="dropdown-contents">
                        <li><a href="/about.do">메리뷰 소개</a></li>
                        <li><a href="/location.do">찾아오시는 길</a></li>
                        <li><a href="/history.do">회사 연혁</a></li>
                        <li><a href="/terms.do">이용 약관</a></li>
                    </ul>
                </li>

                <!-- 상품목록 -->
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/productCategoryTag.do">상품목록</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/productCategoryTag.do">상품 찾기</a></li>
                        <li><a href="/partner.do">입점 문의</a></li>
                    </ul>
                </li>

                <!-- 커뮤니티 -->
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/api/community/list.do">커뮤니티</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do">전체 보기</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=자유">자유글</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=질문">질문글</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/community/list.do?category=정보">정보공유글</a></li>
                    </ul>
                </li>

                <!-- 리얼리뷰 -->
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/api/review/list.do">리얼리뷰</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/api/review/list.do">전체보기</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/review/list.do?isPaid=1"><i class="fa-solid fa-crown"></i> 유료 리뷰</a></li>
                        <li><a href="${pageContext.request.contextPath}/api/review/list.do?isPaid=0"><i class="fa-solid fa-tag"></i> 무료 리뷰</a></li>
                    </ul>
                </li>

                <!-- 패스구매 -->
                <li class="nav-item has-dropdown">
                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/adminPass.do">패스구매</a>
                    <ul class="dropdown-contents">
                        <li><a href="${pageContext.request.contextPath}/adminPass.do">패스상품보기</a></li>
                        <li><a href="${pageContext.request.contextPath}/adminMyPass.do">내 패스 조회</a></li>
                    </ul>
                </li>

                <!-- 마이페이지 -->
                <li class="nav-item has-dropdown">
                    <c:choose>
                        <c:when test="${not empty sessionScope.sessionId}">
                            <c:choose>
                                <c:when test="${sessionScope.sessionRole == 'USER'}">
                                    <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/userMyPage.do">마이페이지</a>
                                    <ul class="dropdown-contents">
                                        <li><a href="${pageContext.request.contextPath}/userMyPage.do">마이페이지 홈</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-pay.do">결제 멤버십 내역</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-review.do">리뷰 열람 내역</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-write.do">내가 쓴 글/리뷰/댓글</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-like.do">좋아요 목록</a></li>
                                        <li><a href="${pageContext.request.contextPath}/userMyPage-cs.do">내 문의/신고 내역</a></li>
                                    </ul>
                                </c:when>
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
                                    <ul class="dropdown-contents">
                                        <li style="display:flex; align-items:center"><a href="${pageContext.request.contextPath}/adminMain.do">관리자</a> / <a href="${pageContext.request.contextPath}/adminStatistics.do">통계</a></li>
                                        <li style="display:flex; align-items:center"><a href="${pageContext.request.contextPath}/adminUser.do">회원</a> / <a href="${pageContext.request.contextPath}/adminCompany.do">업체</a></li>
                                        <li style="display:flex; align-items:center"><a href="${pageContext.request.contextPath}/adminBoard.do">게시판</a> / <a href="${pageContext.request.contextPath}/adminReview.do">리뷰</a></li>
                                        <li style="display:flex; align-items:center"><a href="${pageContext.request.contextPath}/adminPayment.do">결제</a> / <a href="${pageContext.request.contextPath}/adminProduct.do">상품</a></li>
                                        <li style="display:flex; align-items:center"><a href="${pageContext.request.contextPath}/adminReport.do">신고</a> / <a href="${pageContext.request.contextPath}/adminInquiry.do">문의</a></li>
                                    </ul>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link custom-nav-link" href="${pageContext.request.contextPath}/login.do">마이페이지 <i class="fas fa-chevron-right arrow-icon"></i></a>
                        </c:otherwise>
                    </c:choose>
                </li>

                <li class="nav-item mx-3 nav-divider">|</li>

                <!-- 고객센터 -->
                <c:if test="${sessionRole != 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link nav-icon-btn"
                            href="${sessionRole == 'USER' ? '/userMyPage-cs.do' : sessionRole == 'ADMIN' ? '/adminMain.do' : (sessionRole == 'PARTNER' || sessionRole == 'NPARTNER') ? '/partnerManagement.do' : 'javascript:void(0)'}">
                            <i class="fas fa-headset" style="font-size: 1.3rem !important;"></i>
                        </a>
                    </li>
                </c:if>

                <!-- 알림 -->
                <c:if test="${not empty sessionScope.sessionId}">
                    <li class="nav-item notification-wrap">
                        <a href="javascript:void(0);" class="notification-btn">
                            <i class="fas fa-bell"></i>
                        </a>
                        <div class="notification-dropdown">
                            <div class="notification-header">
                                <span>알림</span>
                                <a href="javascript:;" @click="fnReadAll">모두 읽음</a>
                            </div>
                            <div class="notification-item" v-for="item in notificationList"
                                :key="item.notificationNo" @click="fnMove(item)"
                                :class="{ unread: item.isRead=='N' }">
                                <div class="notification-content">{{item.content}}</div>
                                <div class="notification-date">{{item.createdAt}}</div>
                            </div>
                            <div class="notification-footer">
                                <a href="/api/notification/list.do">전체보기</a>
                            </div>
                        </div>
                    </li>

                    <!-- 이름 -->
                    <li class="nav-item nav-name">
                        <span>${sessionScope.sessionName}님!</span>
                    </li>
                </c:if>

                <!-- 로그인/로그아웃 -->
                <li class="nav-item">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <a class="nav-link nav-icon-btn" href="${pageContext.request.contextPath}/login.do" title="로그인">
                                <i class="fas fa-user-circle" style="font-size: 1.3rem !important;"></i>
                                <span style="font-size: 0.95rem; font-weight: bold; margin-left: 4px;">로그인</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link nav-icon-btn" href="${pageContext.request.contextPath}/logout.do" title="로그아웃">
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
document.addEventListener('DOMContentLoaded', function () {

    /* ── 헤더 드롭다운 활성화 ── */
    const header = document.querySelector('.dropdown-header-wrap');
    if (header) {
        header.addEventListener('mouseenter', () => header.classList.add('is-active'));
        header.addEventListener('mouseleave', () => header.classList.remove('is-active'));
    }

    /* ── URL 파라미터에 따른 자동 탭 클릭 ── */
    function handleTabClick() {
        const urlParams     = new URLSearchParams(window.location.search);
        const categoryParam = urlParams.get('category');
        const isPaidParam   = urlParams.get('isPaid');
        const menuParam     = urlParams.get('menu');

        /* A. 업체 관리 페이지 */
        if (menuParam) {
            const vueApp = window.app || window.vm;
            if (vueApp && vueApp.currentMenu !== undefined) {
                vueApp.currentMenu = menuParam;
            }
            setTimeout(() => {
                const menuMap = {
                    'product':     '상품 관리',
                    'reservation': '예약 관리',
                    'inquiry':     '문의 내역',
                    'review':      '리뷰 내역'
                };
                document.querySelectorAll('.nav-btn').forEach(btn => {
                    if (btn.innerText.trim() === menuMap[menuParam]) btn.click();
                });
            }, 200);
        }

        /* B. 유료/무료 리뷰 탭 */
        if (isPaidParam !== null) {
            document.querySelectorAll('.tab-menu button, .review-tabs .tab-item').forEach(tab => {
                const text = tab.innerText.trim();
                if ((isPaidParam === '1' && text.includes('유료')) ||
                    (isPaidParam === '0' && text.includes('무료'))) {
                    tab.click();
                }
            });
        }

        /* C. 커뮤니티 카테고리 탭 */
        if (categoryParam) {
            document.querySelectorAll('.tab-menu button, .tab-item').forEach(btn => {
                const btnText = btn.innerText.replace(/[^가-힣a-zA-Z]/g, '').trim();
                if (btnText === categoryParam.trim()) btn.click();
            });
        }
    }

    /* ── Vue 렌더링 감지 후 탭 클릭 ── */
    const observer = new MutationObserver(() => {
        const target = document.querySelector('.tab-menu button, .nav-btn, .tab-item');
        if (target) {
            setTimeout(handleTabClick, 150);
            observer.disconnect();
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });
    handleTabClick();
});

/* ── 이미지 콤마 처리 전역 함수 ── */
function getFirstImg(imgUrls) {
    if (!imgUrls) return '/resources/img/no-image.png';
    const cleanUrl = imgUrls.replace(/[\[\]]/g, '');
    return (typeof cleanUrl === 'string' && cleanUrl.includes(','))
        ? cleanUrl.split(',')[0].trim()
        : cleanUrl;
}
</script>
