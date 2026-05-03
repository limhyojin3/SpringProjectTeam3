```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>메리뷰 관리자 메뉴</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Pretendard','Malgun Gothic',sans-serif;
    background:#f4f6f9;
    color:#222;
}

/* 전체 레이아웃 */
.admin-wrap{
    width:320px;
    min-height:100vh;
    padding:14px 10px;
    background:#eef1f5;
    border-right:1px solid #dfe4ea;
}

/* 상단 타이틀 */
.admin-title{
    background:linear-gradient(135deg,#ff6b6b,#ff7f7f);
    color:#fff;
    font-size:20px;
    font-weight:700;
    padding:18px 16px;
    border-radius:12px;
    margin-bottom:18px;
    box-shadow:0 8px 20px rgba(255,107,107,.18);
}

/* 그룹 영역 */
.menu-group{
    background:#ffffff;
    border-radius:14px;
    padding:14px;
    margin-bottom:14px;
    box-shadow:0 6px 18px rgba(0,0,0,.04);
    border:1px solid #edf0f4;
}

/* 그룹 제목 */
.group-title{
    font-size:13px;
    font-weight:800;
    color:#888;
    letter-spacing:.5px;
    margin-bottom:12px;
    padding-left:2px;
    text-transform:uppercase;
}

/* 버튼 2열 */
.menu-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:10px;
}

/* 단일 버튼 */
.menu-single{
    display:grid;
    grid-template-columns:1fr;
}

/* 버튼 */
.menu-btn{
    display:flex;
    align-items:center;
    justify-content:center;
    min-height:58px;
    border-radius:12px;
    text-decoration:none;
    font-size:15px;
    font-weight:700;
    color:#222;
    background:#f8f9fb;
    border:1px solid #e8ebef;
    transition:all .25s ease;
}

.menu-btn:hover{
    transform:translateY(-3px);
    background:#fff0f3;
    border-color:#ffccd5;
    color:#ff4d6d;
    box-shadow:0 10px 18px rgba(255,77,109,.12);
}

/* 통계 강조 */
.menu-btn.primary{
    background:linear-gradient(135deg,#ff5c7a,#ff748e);
    color:#fff;
    border:none;
}

.menu-btn.primary:hover{
    background:linear-gradient(135deg,#ff4d6d,#ff6f88);
    color:#fff;
}

/* 작은 설명 */
.sub-desc{
    font-size:12px;
    color:#999;
    margin-top:8px;
    padding-left:2px;
}

/* 반응형 */
@media (max-width:768px){
    .admin-wrap{
        width:100%;
        min-height:auto;
    }
}
</style>
</head>

<body>

<div class="admin-wrap">

    <!-- 타이틀 -->
    <div class="admin-title">
        관리자 메인 페이지
    </div>

    <!-- 계정 관리 -->
    <div class="menu-group">
        <div class="group-title">계정 관리</div>

        <div class="menu-grid">
            <a href="/adminUser.do" class="menu-btn">회원 관리</a>
            <a href="/adminCompany.do" class="menu-btn">업체 관리</a>
        </div>

        <div class="sub-desc">회원 상태 / 업체 승인 / 계정 운영</div>
    </div>

    <!-- 콘텐츠 관리 -->
    <div class="menu-group">
        <div class="group-title">콘텐츠 관리</div>

        <div class="menu-grid">
            <a href="/adminBoard.do" class="menu-btn">게시판 관리</a>
            <a href="/adminReview.do" class="menu-btn">리뷰 관리</a>
        </div>

        <div class="sub-desc">게시글 / 리뷰 / 노출 상태 관리</div>
    </div>

    <!-- 매출 관리 -->
    <div class="menu-group">
        <div class="group-title">매출 관리</div>

        <div class="menu-grid">
            <a href="/adminPayment.do" class="menu-btn">결제 관리</a>
            <a href="/adminProduct.do" class="menu-btn">상품 관리</a>
        </div>

        <div class="sub-desc">결제 내역 / 패스 상품 운영</div>
    </div>

    <!-- 고객센터 -->
    <div class="menu-group">
        <div class="group-title">고객센터</div>

        <div class="menu-grid">
            <a href="/adminReport.do" class="menu-btn">신고 관리</a>
            <a href="/adminInquiry.do" class="menu-btn">문의 관리</a>
        </div>

        <div class="sub-desc">신고 접수 / 고객 문의 대응</div>
    </div>

    <!-- 통계 -->
    <div class="menu-group">
        <div class="group-title">데이터</div>

        <div class="menu-single">
            <a href="/adminStatistics.do" class="menu-btn primary">통계 보기</a>
        </div>

        <div class="sub-desc">매출 / 회원 / 유입 분석</div>
    </div>

</div>

</body>
</html>
```
