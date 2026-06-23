<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 | MarryView</title>

    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notification-list.css">
    <style></style>
</head>
<body class="${sessionScope.sessionRole eq 'ADMIN' ? 'admin-notification-page' : ''}">
<jsp:include page="/WEB-INF/common/header.jsp" />
<div id="app" v-cloak
    data-api-base="${pageContext.request.contextPath}/api/notification"
    data-context-path="${pageContext.request.contextPath}"
    data-session-role="${sessionScope.sessionRole}">
<aside class="side-visual side-visual--left" aria-hidden="true">
    <video class="side-video"
           id="weddingSideVideo"
           data-src="${pageContext.request.contextPath}/img/weddinggirlmovie.mp4"
           data-poster="${pageContext.request.contextPath}/img/weddingPic.png"
           autoplay muted loop playsinline preload="none"></video>
    <span class="video-ornament video-ornament--top">MARRYVIEW FILM</span>
    <span class="video-ornament video-ornament--bottom">
        <span class="video-ornament-title">Our beautiful days</span>
        <span class="video-ornament-copy">MARRY DAY, MERRY DAYS</span>
    </span>
</aside>
<aside class="product-ad-rail" aria-label="메리뷰 입점 업체 추천 상품">
    <article class="product-ad-card">
        <div class="product-ad-topline">
            <span class="product-ad-label">MARRYVIEW PICK</span>
            <span class="product-ad-number">{{ productAdNumber }}</span>
        </div>
        <div class="product-ad-body">
            <div class="product-ad-visual" :class="currentProductAd.tone" aria-hidden="true">{{ currentProductAd.symbol }}</div>
            <div>
                <div class="product-ad-company">{{ currentProductAd.company }}</div>
                <h2 class="product-ad-name">{{ currentProductAd.name }}</h2>
                <div class="product-ad-price">
                    <span class="product-ad-discount">{{ currentProductAd.discount }}</span>
                    <span class="product-ad-amount">{{ currentProductAd.amount }}</span>
                </div>
            </div>
        </div>
        <div class="product-ad-bottom">
            <div class="product-ad-dots" aria-hidden="true">
                <span v-for="(_, index) in productAds" :key="index" class="product-ad-dot" :class="{ active: index === productAdIndex }"></span>
            </div>
            <div class="product-ad-actions">
                <button type="button" class="product-ad-arrow" @click="moveProductAd(-1)" aria-label="이전 추천 상품">‹</button>
                <button type="button" class="product-ad-arrow" @click="moveProductAd(1)" aria-label="다음 추천 상품">›</button>
                <button type="button" class="product-ad-link" @click="showToast('상품 상세 연결은 API 연동 시 추가됩니다.')">보러가기</button>
            </div>
        </div>
    </article>
</aside>
<aside class="wedding-celebration-rail" aria-label="메리뷰 회원 결혼 소식">
    <article class="celebration-card">
        <div class="celebration-topline">
            <span class="celebration-label">MARRYVIEW WEDDING</span>
            <span class="celebration-dday">{{ currentWeddingNews.dday }}</span>
        </div>
        <div class="celebration-rings" aria-hidden="true"><span></span><span></span></div>
        <p class="celebration-kicker">{{ currentWeddingNews.kicker }}</p>
        <h2 class="celebration-names">{{ currentWeddingNews.names }}</h2>
        <div class="celebration-date">{{ currentWeddingNews.date }}</div>
        <div class="celebration-divider" aria-hidden="true">♥</div>
        <p class="celebration-message">{{ currentWeddingNews.message }}</p>
        <div class="celebration-bottom" :class="{ 'is-mine': currentWeddingNews.isMine }">{{ currentWeddingNews.bottom }}</div>
    </article>
    <div class="celebration-nav" aria-label="결혼 소식 이동">
        <button type="button" class="celebration-arrow" @click="moveCelebration(-1)" aria-label="이전 결혼 소식">‹</button>
        <span class="celebration-position">{{ celebrationIndex + 1 }} / {{ weddingNews.length }}</span>
        <button type="button" class="celebration-arrow" @click="moveCelebration(1)" aria-label="다음 결혼 소식">›</button>
    </div>

    <section class="popular-feed" aria-labelledby="popularFeedTitle">
        <div class="popular-feed-head">
            <h2 class="popular-feed-title" id="popularFeedTitle">
                <span class="popular-live-dot" aria-hidden="true"></span>
                지금 인기 있어요
            </h2>
            <span class="popular-feed-caption">LIVE PICK</span>
        </div>
        <div class="popular-tabs" role="tablist" aria-label="인기 콘텐츠 종류">
            <button type="button" class="popular-tab" :class="{ active: popularType === 'post' }" @click="popularType = 'post'" role="tab" :aria-selected="popularType === 'post'">인기글</button>
            <button type="button" class="popular-tab" :class="{ active: popularType === 'review' }" @click="popularType = 'review'" role="tab" :aria-selected="popularType === 'review'">인기리뷰</button>
        </div>
        <ol class="popular-list">
            <li v-for="(item, index) in currentPopularItems" :key="item.title">
                <button type="button" class="popular-item" @click="showToast('상세 페이지 연결은 API 연동 시 추가됩니다.')" :aria-label="(index + 1) + '위 ' + item.title">
                    <span class="popular-rank">{{ index + 1 }}</span>
                    <span>
                        <span class="popular-item-title">{{ item.title }}</span>
                        <span class="popular-item-meta"><span>조회 {{ item.views }}</span><span>♥ {{ item.likes }}</span></span>
                    </span>
                </button>
            </li>
        </ol>
    </section>
</aside>

<main class="page-shell">
    <section class="brand-message" aria-label="메리뷰 브랜드 메시지">
        <p class="brand-slogan">Marry Day, <span class="accent">Merry Days.</span></p>
        <p class="brand-copy">
            결혼하는 오늘부터 함께 살아갈 모든 날까지.<br>
            메리뷰가 당신의 행복한 나날과 함께합니다.
        </p>
        <div class="brand-signature">MARRYVIEW</div>
    </section>

    <header class="page-header">
        <div>
            <button type="button" class="back-button" @click="goBack" aria-label="이전 페이지로 돌아가기">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 12H5M11 18l-6-6 6-6"/>
                </svg>
                이전으로
            </button>
            <div class="eyebrow">
                <c:choose>
                    <c:when test="${sessionScope.sessionRole eq 'ADMIN'}">Admin</c:when>
                    <c:otherwise>MarryView</c:otherwise>
                </c:choose>
            </div>
            <h1><c:choose>
                    <c:when test="${sessionScope.sessionRole eq 'ADMIN'}">관리자 알림</c:when>
                    <c:otherwise>알림</c:otherwise>
                </c:choose>
            </h1>
            <p class="header-copy">
                <c:choose>
                    <c:when test="${sessionScope.sessionRole eq 'ADMIN'}">
                        문의와 신고 접수, 처리 결과를 확인합니다.
                    </c:when>
                    <c:otherwise>
                        새로운 소식과 중요한 안내를 한눈에 확인하세요.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="user-chip">로그인 계정&nbsp; <strong>${sessionScope.sessionId}</strong></div>
    </header>

    <section class="notification-card" aria-labelledby="notificationHeading">
        <div class="toolbar">
            <div class="summary">
                <div class="bell-box" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9"/>
                        <path d="M10 21h4"/>
                    </svg>
                    <span class="count-badge">{{ unreadBadge }}</span>
                </div>
                <div>
                    <div class="summary-title" id="notificationHeading">
                        <c:choose>
                            <c:when test="${sessionScope.sessionRole eq 'ADMIN'}">업무 알림</c:when>
                            <c:otherwise>내 알림</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="summary-text">{{ summaryText }}</div>
                </div>
            </div>

            <div class="toolbar-actions">
                <button type="button" class="btn btn-ghost" @click="refreshAll(true)" :disabled="refreshing">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 11a8 8 0 1 0-2.3 5.7"/><path d="M20 4v7h-7"/>
                    </svg>
                    새로고침
                </button>
                <button type="button" class="btn btn-primary" @click="readAll" :disabled="refreshing || unreadCount === 0">모두 읽음</button>
            </div>
        </div>

        <div class="filter-row">
            <div class="filters" role="tablist" aria-label="알림 필터">
                <button v-for="filter in filters" :key="filter.value" type="button" class="filter-btn"
                    :class="{ active: currentFilter === filter.value }" @click="currentFilter = filter.value"
                    role="tab" :aria-selected="currentFilter === filter.value">{{ filter.label }}</button>
            </div>
            <span class="list-status">{{ filteredNotifications.length }}개의 알림</span>
        </div>

        <div class="notification-list" aria-live="polite">
            <div v-if="loading" class="state-view">
                <div>
                    <div class="loading-dots" aria-label="알림 불러오는 중"><span></span><span></span><span></span></div>
                </div>
            </div>
            <div v-else-if="errorMessage" class="state-view">
                <div><div class="state-icon">⚠</div><h3 class="state-title">알림을 불러오지 못했어요</h3><p class="state-copy">{{ errorMessage }}</p></div>
            </div>
            <div v-else-if="filteredNotifications.length === 0" class="state-view">
                <div><div class="state-icon">{{ emptyState.icon }}</div><h3 class="state-title">{{ emptyState.title }}</h3><p class="state-copy">{{ emptyState.copy }}</p></div>
            </div>
            <template v-else>
                <button v-for="item in filteredNotifications" :key="item.notificationNo" type="button"
                    class="notification-page-item" :class="{ unread: item.isRead === 'N' }" @click="readNotification(item)"
                    :aria-label="(item.isRead === 'N' ? '읽지 않은 알림: ' : '') + (item.content || '알림 내용 없음')">
                    <span class="type-icon" aria-hidden="true">{{ item.isRead === 'N' ? typeIcon(item.notificationType) : '✓' }}</span>
                    <span>
                        <span class="item-head"><span class="item-type">{{ typeLabel(item.notificationType) }}</span><span v-if="item.isRead === 'N'" class="new-dot" aria-label="새 알림"></span></span>
                        <p class="notification-page-content">{{ item.content || '알림 내용이 없습니다.' }}</p>
                        <span class="notification-meta">{{ formatDate(item.createdAt) }}</span>
                    </span>
                    <span class="read-label">{{ item.isRead === 'N' ? '읽음 처리' : '확인함' }}</span>
                </button>
            </template>
        </div>
    </section>

    <c:if test="${sessionScope.sessionRole eq 'ADMIN' or sessionScope.sessionRole eq '관리자'}">
        <aside class="developer-panel">
            <details>
                <summary>개발자용 API 응답 보기</summary>
                <pre class="response-box" :class="{ error: responseIsError }">{{ responseText }}</pre>
            </details>
        </aside>
    </c:if>

</main>

<div class="toast" :class="{ show: toastVisible }" role="status" aria-live="polite">{{ toastMessage }}</div>
</div>
<script src="${pageContext.request.contextPath}/js/common/notification-page.js"></script>
</body>
</html>
