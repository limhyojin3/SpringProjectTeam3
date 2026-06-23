<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="left-banner">
    <div class="nav-container">
        <div class="nav-title">마이페이지</div>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage.do'">
            <i class="fas fa-home"></i> 마이페이지
        </button>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage-pay.do'">
            <i class="fas fa-credit-card"></i> 결제 멤버십 내역
        </button>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage-review.do'">
            <i class="fas fa-book-open"></i> 리뷰 열람 내역
        </button>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage-write.do'">
            <i class="fas fa-pen"></i> 내가 쓴 글/리뷰/댓글
        </button>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage-like.do'">
            <i class="fas fa-heart"></i> 좋아요 목록
        </button>
        <button class="nav-btn" onclick="location.href='${pageContext.request.contextPath}/userMyPage-cs.do'">
            <i class="fas fa-headset"></i> 내 문의/신고 내역
        </button>
    </div>
</div>