<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <div class="navi">
        <button type="button" :class="['navi-btn', activeMenu === 'main' ? 'activebtn' : '']"
            @click="fnPage('/adminMain.do')">관리자 메인 페이지</button>

        <button type="button" :class="['navi-btn', activeMenu === 'user' ? 'activebtn' : '']"
            @click="fnPage('/adminUser.do')">회원 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'company' ? 'activebtn' : '']"
            @click="fnPage('/adminCompany.do')">업체 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'board' ? 'activebtn' : '']"
            @click="fnPage('/adminBoard.do')">게시판 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'review' ? 'activebtn' : '']"
            @click="fnPage('/adminReview.do')">리뷰 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'payment' ? 'activebtn' : '']"
            @click="fnPage('/adminPayment.do')">결제 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'product' ? 'activebtn' : '']"
            @click="fnPage('/adminProduct.do')">상품 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'report' ? 'activebtn' : '']"
            @click="fnPage('/adminReport.do')">신고 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'inquiry' ? 'activebtn' : '']"
            @click="fnPage('/adminInquiry.do')">문의 관리</button>

        <button type="button" :class="['navi-btn', activeMenu === 'stats' ? 'activebtn' : '']"
            @click="fnPage('/adminStatistics.do')">통계</button>
    </div>