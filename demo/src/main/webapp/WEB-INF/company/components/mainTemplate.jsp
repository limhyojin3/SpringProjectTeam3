<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/mainTemplate.css">

<template id="main-menu-template">
    <div class="premium-dashboard-wrapper">
        <h2 class="dashboard-welcome-msg">안녕하세요, '<span class="welcome-highlight">{{ user.name }}</span>'님!</h2>
        
        <div class="dashboard-action-bar">
            
            <div v-if="user.grade === 'NPARTNER'" class="grade-track-row">
                <div class="premium-badge-wrapper">
                    <span class="badge-premium-label npartner">일반 회원사</span>
                    <span class="badge-premium-notice">*관리자 최종 승인 후 제휴 등급으로 격상됩니다.</span>
                </div>
                <div class="premium-action-wrapper">
                    <button class="btn-premium-upgrade" @click="$emit('reg-ptn')">👑 공식 제휴업체로 등록·결제하기</button>
                </div>
            </div>

            <div v-if="user.grade === 'PARTNER'" class="grade-track-row partner-center-mode">
                <div class="official-partner-panel">
                    <span class="crown-icon">👑</span> 
                    <span class="official-title-text">MARRY VIEW OFFICIAL PARTNER</span>
                    <span class="badge-premium-label partner">공식 인증 제휴사</span>
                </div>
            </div>
            
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/main-menu-component.js"></script>