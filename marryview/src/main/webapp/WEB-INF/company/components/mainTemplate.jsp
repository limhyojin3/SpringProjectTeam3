<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/mainTemplate.css">

<template id="main-menu-template">
    <div class="premium-dashboard-wrapper">
        <div class="dashboard-welcome-box">
            <h2 class="dashboard-welcome-msg">
                안녕하세요, '<span class="welcome-highlight">{{ user.name }}</span>'님!
            </h2>
        </div>
        
        <div class="dashboard-action-bar">
            
            <div v-if="user.grade === 'NPARTNER'" class="grade-track-row">
                <div class="premium-badge-wrapper">
                    <span class="badge-premium-label npartner">일반 회원사</span>
                    <span class="badge-premium-notice">*관리자 최종 승인 후 제휴 등급으로 격상됩니다.</span>
                    <!-- 추가 -->
                    <span class="fee-notice">
                        <i class="fas fa-info-circle mr-1"></i>
                        현재 예약 수수료 <b>10%</b> 적용 중 · 공식 제휴사 전환 시 <b>5%</b>로 감면
                    </span>
                </div>
                <!-- 버튼 그대로 유지 -->
                <div class="premium-action-wrapper">
                    <button class="btn-premium-upgrade" @click="$emit('reg-ptn')">
                        <i class="fas fa-crown mr-2"></i>공식 제휴업체로 등록·결제하기
                    </button>
                </div>
            </div>

            <div v-if="user.grade === 'PARTNER'" class="grade-track-row partner-center-mode">
                <div class="official-partner-panel">
                    <span class="crown-icon"><i class="fas fa-crown"></i></span>
                    <span class="official-title-text">MARRY VIEW OFFICIAL PARTNER</span>
                    <span class="badge-premium-label partner">공식 인증 제휴사</span>
                </div>
            </div>
        </div>
        <!-- dashboard-action-bar 아래에 추가 -->
        <div class="dashboard-shortcut-row">
            <div class="shortcut-card" @click="$emit('menu-change', 'product')">
                <i class="fas fa-box"></i>
                <span>상품 관리</span>
            </div>
            <div class="shortcut-card" @click="$emit('menu-change', 'reservation')">
                <i class="fas fa-calendar-alt"></i>
                <span>예약 관리</span>
            </div>
            <div class="shortcut-card" @click="$emit('menu-change', 'inquiry')">
                <i class="fas fa-comment-dots"></i>
                <span>문의 내역</span>
            </div>
            <div class="shortcut-card" @click="$emit('menu-change', 'review')">
                <i class="fas fa-star"></i>
                <span>리뷰 내역</span>
            </div>
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/main-menu-component.js"></script>