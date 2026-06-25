<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 커뮤니티 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css"> 
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
    body { background-color: #f8f9fa; }
    
    .main-content {
        padding: 50px 40px;
        max-width: 1200px;
        margin: 0 auto;
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        margin-top: 30px;
        margin-bottom: 50px;
    }
    
    /* 탭 및 필터 스타일 */
    .review-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #eee; }
    .tab-item { cursor: pointer; padding: 12px 25px; font-weight: bold; color: #999; transition: 0.3s; position: relative; }
    .tab-item.active { color: var(--primary-color); }
    .tab-item.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 3px; background-color: var(--primary-color); }
    
    /* 전체 버튼 */
    .btn-cat-all { background: #f1f3f5; color: #868e96; }
    .btn-cat-all-active { background: #495057; color: #fff; }

    /* 유료 탭 - 골드 */
    .tab-item.tab-paid { color: #ff4d6d; }
    .tab-item.tab-paid.active { color: #ff4d6d; }
    .tab-item.tab-paid.active::after { background-color: #ff4d6d; }
    .tab-item.tab-paid:hover { color: #ff4d6d; }
    .tab-item.tab-paid i { color: #ff4d6d; }

    /* 무료 탭 - 민트/파랑 */
    .tab-item.tab-free { color: #4fc3f7; }
    .tab-item.tab-free.active { color: #4fc3f7; }
    .tab-item.tab-free.active::after { background-color: #4fc3f7; }
    .tab-item.tab-free:hover { color: #4fc3f7; }
    .tab-item.tab-free i { color: #4fc3f7; }

    /* 카테고리 버튼 파스텔 공통 */
    .btn-cat { border: none; font-weight: 600; border-radius: 20px; padding: 5px 14px; transition: all 0.2s; }
    .btn-cat:focus { outline: none; box-shadow: none; }

    /* 결혼 - 핑크 파스텔 */
    .btn-cat-wedding        { background: #ffe4ec; color: #c2185b; }
    .btn-cat-wedding:hover,
    .btn-cat-wedding.active { background: #f48fb1; color: #fff; }

    /* 가족행사 - 민트 파스텔 */
    .btn-cat-family        { background: #e0f7ef; color: #00796b; }
    .btn-cat-family:hover,
    .btn-cat-family.active { background: #80cbc4; color: #fff; }

    /* 친구와함께 - 라벤더 파스텔 */
    .btn-cat-friends        { background: #ede7f6; color: #6a1b9a; }
    .btn-cat-friends:hover,
    .btn-cat-friends.active { background: #ce93d8; color: #fff; }

    /* 정렬 버튼 파스텔 pill */
    .btn-order {
        border: none;
        font-weight: 600;
        border-radius: 20px;
        padding: 5px 14px;
        transition: all 0.2s;
        background: #f1f3f5;
        color: #868e96;
    }
    .order-btn-wrap { display: flex; gap: 8px; }
    .btn-order:focus { outline: none; box-shadow: none; }
    .btn-order:hover { background: #e9ecef; color: #495057; }
    .btn-order.active {
        background: #ffd6e0;
        color: #c2185b;
    }


    /* 뱃지 스타일 */
    .badge-paid { background: #fff0f3; color: #ff4d6d; border: 1px solid #ffccd5; padding: 5px 10px; }
    .badge-free { background: #e7f5ff; color: #228be6; border: 1px solid #a5d8ff; padding: 5px 10px; }
    .badge-best { background: #ffb703; color: white; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 0.75rem; }
    
    /* 공통 핑크 pill 버튼 */
    .btn-primary-pill {
        background-color: #f4a096;
        border: none;
        border-radius: 30px;
        font-weight: 700;
        color: #fff;
        padding: 10px 24px;
        transition: all 0.2s;
        box-shadow: 1px 1px 2px #ffb3c1;
    }
    .btn-primary-pill:hover {
        background-color: #e0354f;
        color: #fff;
    }
    .search-area .btn-primary-pill.btn-block {
        height: 46px;           /* 추가 */
        border-radius: 0 30px 30px 0; /* 오른쪽만 둥글게 */
        padding: 0 24px;
    }

    /* 검색바 영역 */
    .search-area {
        background: #fff5f7;
        padding: 24px 40px;
        border-radius: 16px;
        margin-bottom: 20px;
    }

    .search-area select.form-control {
        border: 1.5px solid #eee;
        border-right: none;
        border-radius: 30px 0 0 30px;
        background: #fff;
        color: #555;
        font-weight: 500;
        height: 46px;
        box-shadow: 1px 1px 2px #ffb3c1;
    }

    /* 셀렉트 박스 */
    .search-area select:focus,
    .search-area input:focus {
        border-color: #ffb3c1;
        box-shadow: none;
        outline: none;
    }

    /* 인풋 */
    .search-area input.form-control {
        border: 1.5px solid #eee;
        border-left: none;
        border-right: none;
        border-radius: 0;
        background: #fff;
        height: 46px;
        box-shadow: 1px 1px 2px #ffb3c1;
    }
        
    /* 카드 그리드 레이아웃 */
    .review-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; padding: 20px 0; }
    .review-card { background: #fff; border-radius: 15px; overflow: visible; border: 1px solid #eee; transition: all 0.3s ease; cursor: pointer; display: flex; flex-direction: column; position: relative; height: 100%; }
   .review-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 24px rgba(0,0,0,0.1);
        border-color: #ffb3c1;  /* var(--primary-color) → 연핑크 */
    }

    
    /* [수정] 카드 이미지 박스 - 높이를 180px에서 220px로 확대 */
    /* [수정] 카드 이미지 박스 - 고정 높이 대신 비율 사용 */
    .card-img-box {
    width: 100%;
    aspect-ratio: 4 / 3; /* 세로형으로 가장 안정적인 비율 */
    background-color: #f2f2f2;
    border-radius: 8px;
    overflow: hidden; 
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
}

    /* 이미지 처리 - 무조건 꽉 차게 */
    .card-img-box img {
        width: 100% !important;
        height: 100% !important;
        object-fit: cover !important; /* 이미지 비율 유지하며 박스 채우기 */
        object-position: center 5% !important;
        display: block;
    }

    .card-badges { position: absolute; top: 12px; left: 12px; z-index: 2; display: flex; gap: 6px; }
    
    /* [수정] 카드 바디 패딩 조정 */
    .card-body-custom { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; }
    .card-com-name { font-size: 0.85rem; color: var(--primary-color); font-weight: bold; margin-bottom: 4px; }
    
    /* [수정] 제목 영역 - margin-bottom을 12px에서 4px로 줄여 공백 제거 */
    /* 제목 영역 최적화 */
    .card-review-title { 
        font-size: 1.05rem; 
        font-weight: 700; 
        color: #333; 
        margin-bottom: 8px; /* 통계 영역과 약간 띄우기 */
        line-height: 1.4; 
        height: 3em; /* 2줄 기준 딱 맞는 높이 */
        overflow: hidden; 
        display: -webkit-box; 
        -webkit-line-clamp: 2; 
        -webkit-box-orient: vertical; 
    }
    
    .comment-count { color: var(--primary-color); font-weight: bold; font-size: 0.9rem; }
    
    /* [수정] 통계 영역 - 별점/하트가 제목에 더 가깝게 붙도록 조정 */
    .card-stats { font-size: 0.85rem; margin-bottom: 10px; display: flex; gap: 12px; }
    .card-stats .fa-heart { color: #f4a096; }
    .card-stats span:nth-child(2) { color: #f4a096; } /* 하트 숫자 */
    .card-stats .fa-eye { color: #adb5bd; }
    .card-stats span:nth-child(3) { color: #adb5bd; } /* 눈 숫자 */
    .card-info-row { display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 10px; border-top: 1px solid #f1f1f1; font-size: 0.8rem; color: #888; }

    /* 페이징 스타일 */
    .page-item.disabled .page-link { pointer-events: auto !important; cursor: not-allowed !important; }

    .page-link {
        cursor: pointer !important;
        color: #f4a096;
        border: 1.5px solid #ffd6e0;
        border-radius: 6px !important;
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 3px;
        font-weight: 600;
        transition: all 0.2s;
    }
    .page-link:hover {
        background-color: #fff0f3;
        color: #f4a096;
        border-color: #f4a096;
    }
    .page-item.active .page-link {
        background-color: #f4a096 !important;
        border-color: #f4a096 !important;
        color: white !important;
    }
    .page-item.disabled .page-link {
        color: #ccc !important;
        border-color: #eee !important;
        background: none !important;
    }
    /* 이전/다음 버튼 pill 형태 */
    .page-item:first-child .page-link,
    .page-item:last-child .page-link,
    .page-item:nth-child(2) .page-link,
    .page-item:nth-last-child(2) .page-link {
        width: auto;
        padding: 0 14px;
        border-radius: 6px !important;
    }
    
    /* 베스트 섹션 전체 레이아웃 */
    .best-review-wrapper {
        margin-bottom: 50px;
        padding: 20px;
        background-color: #fff5f7;
        border-radius: 20px;
        position: relative;
        overflow: hidden;
    }
    .best-main-title { text-align: center; font-size: 24px; font-weight: 800; margin-bottom: 5px; color: #333; }
    .best-sub-title { text-align: center; color: #888; margin-bottom: 30px; font-size: 14px; }
    .best-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }

    /* 배경 하트 장식 */
    /* 하트 장식 컨테이너 */
    .heart-deco {
        position: absolute;
        top: 0; left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        overflow: hidden;
        z-index: 0;
    }

    /* 하트 공통 */
    .heart-deco i {
        position: absolute;
        color: rgba(255, 182, 193, 0.15);
        font-size: 120px;
    }

    /* 각 하트 위치 */
    .heart-deco i:nth-child(1) { top: -20px;  left: -20px;  font-size: 160px; }
    .heart-deco i:nth-child(2) { top: 10px;   right: 40px;  font-size: 200px; }
    .heart-deco i:nth-child(3) { bottom: -30px; left: 100px; font-size: 140px; }
    .heart-deco i:nth-child(4) { bottom: -10px; right: -10px; font-size: 180px; }
    .heart-deco i:nth-child(5) { top: -30px; left: 50%; transform: translateX(-50%); font-size: 130px; opacity: 0.12; }
    .heart-deco i:nth-child(6) { top: 20px;  left: 35%; font-size: 80px; opacity: 0.07; }

    /* 베스트 섹션 내부 콘텐츠가 하트 위에 오도록 */
    .best-review-wrapper .section-header,
    .best-review-wrapper .best-grid {
        position: relative;
        z-index: 1;
    }

    /* 베스트 카드 디자인 */
    .best-card { position: relative; background: #fff; border-radius: 15px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); cursor: pointer; transition: all 0.3s ease; border: 1px solid #eee; }
    .best-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        border-color: #ffb3c1;  /* #FFD700 → 연핑크 */
    }

    /* 순위 뱃지 스타일 */
    .rank-label { position: absolute; top: -10px; left: -10px; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #fff; z-index: 5; box-shadow: 2px 2px 5px rgba(0,0,0,0.2); }
    .rank-1 { background: #FFD700; } 
    .rank-2 { background: #C0C0C0; } 
    .rank-3 { background: #CD7F32; } 

    /* [수정] 베스트 이미지 박스도 동일하게 확대 (선택사항) */
    /* 베스트 이미지 박스도 동일하게 적용 */
    /* 베스트 섹션 이미지 박스도 동일하게 적용 */
    .best-img-box {
        width: 100%;
        aspect-ratio: 4 / 3;
        background: #f8f9fa;
        overflow: hidden;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 14px 14px 0 0;
    }

    .best-img-box img {
        width: 100% !important;
        height: 100% !important;
        object-fit: cover !important;
        object-position: center 5% !important;
    }

    /* 베스트 텍스트 영역 */
    .best-info { padding: 15px; }
    .company-tag { font-size: 12px; color: #ff6b6b; font-weight: bold; }
    .title-text { margin: 8px 0; font-size: 16px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .best-meta { font-size: 13px; color: #999; display: flex; gap: 10px; }
    .best-meta .fa-heart { color: #f4a096; }
    .best-meta .fa-eye { color: #adb5bd; }  /* 회색 */
    .section-divider { border: 0; height: 1px; background: #eee; margin: 30px 0; }

    /* 이미지가 없을 때 로고 설정 */
    .default-logo, .no-img-default { object-fit: contain !important; padding: 20px; background-color: #f8f9fa; }
    .user-nickname{
        font-weight: bold;
    }

    /* 프리미엄 배지 스타일 */
    .badge-premium {
        background: linear-gradient(45deg, #f093fb 0%, #f5576c 100%); /* 화려한 그라데이션 */
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
        font-weight: bold;
        font-size: 0.75rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* 블러 처리 스타일 */
    .is-blurred {
        filter: blur(10px) grayscale(30%); /* 블러와 약간의 회색조 */
        transition: filter 0.3s ease;
        pointer-events: none; /* 블러된 상태에서 내부 요소 클릭 방지 선택 사항 */
    }

    /* 카드 이미지 컨테이너 상대 위치 설정 (배지 위치용) */
    .card-img-box, .best-img-box {
        position: relative;
        overflow: hidden;
    }
    .nickname-link {
        text-decoration: none; /* 밑줄 제거 */
        color: inherit;       /* 기존 글자색 유지 */
        cursor: pointer;
    }

    .nickname-link:hover {
        text-decoration: underline; /* 호버 시 밑줄 효과 */
        color: #555;                /* 살짝 다른 색상으로 강조 */
    }

    .badge-ticket {
        background-color: #f4a096;
        color: #fff;
    }

    /* 카테고리 영역 전체 */
    .category-wrap {
        position: relative;
        display: inline-block;
    }

    /* 카테고리 필터 하단 여백 */
    .category-filter-wrap {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-top: 20px;
        margin-bottom: 20px;
    }

    /* 드롭다운 패널 */
    .sub-category-dropdown {
        position: absolute;
        top: calc(100% + 8px);
        left: 0;
        background: #fff;
        border-radius: 16px;
        padding: 10px 12px;
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
        z-index: 100;
        box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        white-space: nowrap;
        min-width: max-content;
        overflow: visible;   /* 추가 - X버튼이 잘리지 않도록 */
    }

    /* 말풍선 꼬리 */
    .sub-category-dropdown::before {
        content: '';
        position: absolute;
        top: -6px;
        left: 20px;
        width: 12px;
        height: 12px;
        background: #fff;
        transform: rotate(45deg);
        box-shadow: -2px -2px 4px rgba(0,0,0,0.06);
    }

    /* 결혼 드롭다운 테두리 */
    .sub-dropdown-wedding {
        border: 1.5px solid #f48fb1;
    }
    .sub-dropdown-wedding::before {
        border-left: 1.5px solid #f48fb1;
        border-top: 1.5px solid #f48fb1;
    }

    /* 가족행사 드롭다운 테두리 */
    .sub-dropdown-family {
        border: 1.5px solid #80cbc4;
    }
    .sub-dropdown-family::before {
        border-left: 1.5px solid #80cbc4;
        border-top: 1.5px solid #80cbc4;
    }

    /* 친구와함께 드롭다운 테두리 */
    .sub-dropdown-friends {
        border: 1.5px solid #ce93d8;
    }
    .sub-dropdown-friends::before {
        border-left: 1.5px solid #ce93d8;
        border-top: 1.5px solid #ce93d8;
    }
    /* 드롭다운 닫기 버튼 */
    .btn-close-dropdown {
        background: #f1f3f5;
        border: none;
        border-radius: 50%;
        width: 24px;
        height: 24px;
        min-width: 24px;
        padding: 0;
        color: #999;
        font-size: 0.7rem;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-left: 2px;
        margin-top: 3px;
    }
    .btn-close-dropdown:hover {
        background: #dee2e6;
        color: #555;
    }

    /* 중분류 버튼 radius 대분류랑 통일 */
    .btn-sub-wedding,
    .btn-sub-family,
    .btn-sub-friends {
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.8rem;
        padding: 4px 12px;
    }

    /* 중분류 - 결혼 핑크 */
    .btn-sub-wedding        { background: #fff0f3; color: #c2185b; border: 1.5px solid #f48fb1; }
    .btn-sub-wedding:hover,
    .btn-sub-wedding.active { background: #f48fb1; color: #fff; border-color: #f48fb1; }

    /* 중분류 - 가족행사 민트 */
    .btn-sub-family        { background: #e0f7ef; color: #00796b; border: 1.5px solid #80cbc4; }
    .btn-sub-family:hover,
    .btn-sub-family.active { background: #80cbc4; color: #fff; border-color: #80cbc4; }

    /* 중분류 - 친구와함께 라벤더 */
    .btn-sub-friends        { background: #ede7f6; color: #6a1b9a; border: 1.5px solid #ce93d8; }
    .btn-sub-friends:hover,
    .btn-sub-friends.active { background: #ce93d8; color: #fff; border-color: #ce93d8; }

    /* 제목 커서 */
    .review-title-header { cursor: pointer; }

    /* 탭 하단 보더 제거 */
    .review-tabs-wrap { border-bottom: none; }

    /* PREMIUM 배지 위치 - 카드/베스트 공통 */
    .badge-premium-overlay {
        position: absolute;
        top: 12px;
        right: 12px;
        z-index: 10;
    }

    /* 왕관 아이콘 색상 */
    .icon-crown { color: #FFD700; }
            
    /* 리뷰 커뮤니티 제목 */
    .review-page-title {
        font-size: 1.8rem;
        font-weight: 800;
        color: #333;
        letter-spacing: -0.5px;
    }

    .review-page-title i {
        color: #f4a096;
        font-size: 1.6rem;
    }
    /* 닉네임 영역 */
        .nickname-container{
            position:relative;
            display:inline-block;
        }

        /* 프로필 카드 */
        .profile-hover-modal{
            position:absolute;
            left:50%;
            bottom:calc(100% + 12px);

            transform:translateX(-50%);
            

            width:230px;
            padding:18px;

            background:rgba(255,255,255,.95);
            backdrop-filter:blur(15px);

            border:1px solid rgba(255,255,255,.8);
            border-radius:22px;

            box-shadow:
                0 20px 50px rgba(255,92,138,.18),
                0 5px 15px rgba(0,0,0,.06);

            z-index:99999;

            animation:profilePopup .28s cubic-bezier(.22,1,.36,1);

            pointer-events:none;
        }

        /* 꼬리 */
        .profile-hover-modal::after{
            content:"";
            position:absolute;
            left:0px;
            bottom:-8px;

            width:16px;
            height:16px;

            background:white;

            transform:
                translateX(-50%)
                rotate(45deg);

            border-right:1px solid rgba(255,255,255,.8);
            border-bottom:1px solid rgba(255,255,255,.8);
        }

        .profile-hover-modal img{
            width:64px;
            height:64px;
            border-radius:50%;
            object-fit:cover;
            display:block;
            margin:0 auto 10px;

            border:3px solid #ffe4ec;
        }

        @keyframes profilePopup{
            0%{
                opacity:0;
                transform:
                    translateX(-50%)
                    translateY(12px)
                    scale(.92);
            }

            100%{
                opacity:1;
                transform:
                    translateX(-50%)
                    translateY(0)
                    scale(1);
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="review-page-title review-title-header" @click="fnReset">
                        <i class="fas fa-camera mr-2"></i>리뷰 커뮤니티
                    </h2>
                    <span v-if="sessionId" class="badge badge-ticket ml-2">
                        내 열람권: {{ userRemainingCount }}개
                    </span>
                    <p class="text-muted mb-0">생생한 이용 후기를 확인하고 스마트하게 선택하세요.</p>
                </div>
                <button class="btn btn-primary-pill btn-lg" @click="fnWrite">
                    <i class="fas fa-pen mr-2"></i>리뷰 작성하기
                </button>
            </div>

            <div class="search-area d-flex justify-content-center">
                <div class="input-group" style="max-width: 600px;">
                    <select class="form-control col-3" v-model="searchType">
                        <option value="all">전체</option>
                        <option value="company">업체명</option>
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                    </select>
                    <input type="text" class="form-control col-7" placeholder="검색어를 입력하세요" v-model="searchKeyword" @keyup.enter="fnList">
                    <div class="input-group-append col-2 p-0">
                        <button class="btn btn-primary-pill btn-block" @click="fnList">
                            <i class="fas fa-search mr-1"></i>검색
                        </button>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="review-tabs review-tabs-wrap mb-0">
                    <div class="tab-item" :class="{active: isPaid === null}" @click="fnFilter(null)">전체보기</div>
                    <div class="tab-item tab-paid" :class="{active: isPaid === 1}" @click="fnFilter(1)">
                        <i class="fas fa-gem mr-1"></i> 유료 리뷰
                    </div>
                    <div class="tab-item tab-free" :class="{active: isPaid === 0}" @click="fnFilter(0)">
                        <i class="fas fa-gift mr-1"></i> 무료 리뷰
                    </div>
                </div>
                <div class="btn-group btn-group-sm">
                    <div class="order-btn-wrap">
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'date'}" 
                                @click="fnChangeOrder('date')">
                            <i class="fas fa-clock mr-1"></i>최신순
                        </button>
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'views'}" 
                                @click="fnChangeOrder('views')">
                            <i class="fas fa-eye mr-1"></i>조회순
                        </button>
                        <button class="btn btn-sm btn-order" 
                                :class="{active: orderType === 'likes'}" 
                                @click="fnChangeOrder('likes')">
                            <i class="fas fa-heart mr-1"></i>좋아요순
                        </button>
                    </div>
                </div>
            </div>

            <div class="category-filter-wrap">
                <button class="btn btn-sm btn-cat mr-1"
                        :class="mainCategory === 'all' ? 'btn-cat-all-active' : 'btn-cat-all'"
                        @click="fnChangeLargeCategory('all')">전체</button>

                <!-- 결혼 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-wedding"
                            :class="{active: mainCategory === '결혼'}"
                            @click="fnChangeLargeCategory('결혼')">
                        <i class="fas fa-ring mr-1"></i>결혼
                    </button>
                    <div v-if="mainCategory === '결혼'" class="sub-category-dropdown sub-dropdown-wedding">
                        <button class="btn btn-sm btn-sub-wedding"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['결혼']" :key="sub"
                                class="btn btn-sm btn-sub-wedding"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>

                <!-- 가족행사 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-family"
                            :class="{active: mainCategory === '가족행사'}"
                            @click="fnChangeLargeCategory('가족행사')">
                        <i class="fas fa-users mr-1"></i>가족행사
                    </button>
                    <div v-if="mainCategory === '가족행사'" class="sub-category-dropdown sub-dropdown-family">
                        <button class="btn btn-sm btn-sub-family"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['가족행사']" :key="sub"
                                class="btn btn-sm btn-sub-family"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>

                <!-- 친구와함께 -->
                <div class="category-wrap">
                    <button class="btn btn-sm btn-cat btn-cat-friends"
                            :class="{active: mainCategory === '친구와함께'}"
                            @click="fnChangeLargeCategory('친구와함께')">
                        <i class="fas fa-glass-cheers mr-1"></i>친구와함께
                    </button>
                    <div v-if="mainCategory === '친구와함께'" class="sub-category-dropdown sub-dropdown-friends">
                        <button class="btn btn-sm btn-sub-friends"
                                :class="{active: subCategory === 'all'}"
                                @click="fnChangeMediumCategory('all')">전체</button>
                        <button v-for="sub in categoryMap['친구와함께']" :key="sub"
                                class="btn btn-sm btn-sub-friends"
                                :class="{active: subCategory === sub}"
                                @click="fnChangeMediumCategory(sub)">{{ sub }}</button>
                        <!-- 닫기 버튼 추가 -->
                        <button class="btn btn-sm btn-close-dropdown" @click.stop="fnChangeLargeCategory('all')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="best-review-wrapper" v-if="bestList && bestList.length > 0">
                <!-- 하트 장식 추가 -->
                <div class="heart-deco">
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                    <i class="fas fa-heart"></i>
                </div>
                <div class="section-header">
                    <h2 class="best-main-title">
                        <i class="fas fa-crown icon-crown"></i> WEEKLY BEST REVIEWS <i class="fas fa-crown icon-crown"></i> 
                    </h2>
                    <p class="best-sub-title">가장 많은 사랑을 받은 베스트 후기입니다.</p>
                </div>

                <div class="best-grid">
                    <div v-for="(best, index) in bestList" :key="best.reviewNo" class="best-card" @click="fnDetail(best)">
                        <div class="rank-label" :class="'rank-' + (index + 1)">{{index + 1}}</div>
                        
                        <div class="best-img-box">
                            <!-- [추가] 프리미엄 배지 (유료글이면 항상 노출) -->
                            <span v-if="best.isPaid == 1" class="badge-premium badge-premium-overlay">PREMIUM</span>

                            <!-- [수정] 조건부 블러 클래스 적용 -->
                            <img :src="best.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                                :class="{'no-img-default': !best.thumbnailUrl, 'is-blurred': shouldBlur(best)}"
                                @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'">
                        </div>

                        <div class="best-info">
                            <span class="company-tag">{{best.comName}}</span>
                            <a v-if="best.nickname !== '탈퇴회원'":href="'/userProfile.do?userId=' + best.userId" class="nickname-link">
                                <div class="user-nickname"> {{ best.nickname }} 님</div>
                            </a>
                            <h3 class="title-text">{{best.title}}</h3>
                            <div class="best-meta">
                                <span><i class="fas fa-heart"></i> {{best.likeCnt}}</span>
                                <span><i class="fas fa-eye"></i> {{best.viewCnt}}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="section-divider">

            <div class="review-grid">
                <div v-for="item in list" :key="item.reviewNo" class="review-card" @click="fnDetail(item)">
                    <div class="card-badges">
                        <span v-if="item.viewCnt >= 100 || item.likeCnt >= 50" class="badge-best">BEST</span>
                        <span v-if="item.isPaid == 1" class="badge badge-paid">유료</span>
                        <span v-else class="badge badge-free">무료</span>
                    </div>

                    <div class="card-img-box">
                        <!-- 오른쪽 상단 PREMIUM 배지 -->
                        <span v-if="item.isPaid == 1" class="badge-premium badge-premium-overlay">PREMIUM</span>
                        <img :src="item.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                            :class="{'default-logo': !item.thumbnailUrl, 'is-blurred': shouldBlur(item)}"
                            @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'"
                            alt="리뷰 썸네일">
                    </div>

                    <div class="card-body-custom">
                        <div class="card-com-name">{{ item.comName }}</div>
                        <h5 class="card-review-title">
                            {{ item.title }}
                            <span v-if="item.commentCnt > 0" class="comment-count">[{{ item.commentCnt }}]</span>
                        </h5>
                        
                        <div class="card-stats">
                            <span class="text-warning"><i class="fas fa-star mr-1"></i>{{ parseFloat(item.rating || 0).toFixed(1) }}</span>
                            <span><i class="fas fa-heart mr-1"></i>{{ item.likeCnt || 0 }}</span>
                            <span><i class="far fa-eye mr-1"></i>{{ item.viewCnt }}</span>
                        </div>

                        <div class="card-info-row">
                            <div class="nickname-container" 
                            @mouseenter="fnShowHover(item.userId, item.reviewNo)" 
                            @mouseleave="fnHideHover">
                            
                            <a v-if="item.nickname !== '탈퇴회원'" 
                            :href="'/userProfile.do?userId=' + item.userId" 
                            class="nickname-link">
                                <span class="nickname">@{{ item.nickname }}</span>
                            </a>
                            <b v-else class="text-danger">@{{ item.nickname }}</b>

                            <div v-if="hoverUserId === item.userId 
                                        && hoverReviewNo === item.reviewNo 
                                        && hoverInfo"
                                class="profile-hover-modal">

                                <div style="text-align:center;">

                                    <img
                                        :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                        style="
                                            width:50px;
                                            height:50px;
                                            border-radius:50%;
                                            object-fit:cover;
                                            display:block;
                                            margin:0 auto;
                                        ">

                                    <div class="mt-2 font-weight-bold">
                                        {{ hoverInfo.info.nickName }}
                                    </div>

                                    <div style="font-size:12px;color:#666;">
                                        게시글 {{ hoverInfo.postTotal }}
                                        |
                                        리뷰 {{ hoverInfo.reviewTotal }}
                                    </div>

                                </div>

                            </div>
                        </div>
                           
                            <span>{{ item.regDate }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="list.length == 0" class="py-5 text-center bg-light rounded border">
                <p class="text-muted mb-0">조건에 맞는 리뷰가 아직 없습니다.</p>
            </div>

            <div class="d-flex justify-content-center mt-4">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(1)">&laquo;</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage > 1 && fnPageChange(currentPage - 1)">이전</a>
                        </li>
                        <li class="page-item" v-for="page in pageNumbers" :key="page" :class="{active: currentPage === page}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(page)">{{ page }}</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage < totalPageCount && fnPageChange(currentPage + 1)">다음</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(totalPageCount)">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    list: [],
                    bestList : [],
                    isPaid: null,
                    searchKeyword: '',
                    searchType: 'all',
                    orderType : 'date',
                    sessionId: "${sessionId}",
                    userRole: "${sessionRole}",
                    category: 'all',
                    currentPage: 1,
                    pageSize: 9, // 카드 형태이므로 12개가 적당함 (3개씩 4줄 혹은 4개씩 3줄)
                    totalCount: 0,
                    pageBlockSize: 5,
                    userRemainingCount: 0, 
                    mainCategory: 'all', // mainCategory 대신 largeCategory 사용
                    subCategory: 'all', // subCategory 대신 mediumCategory 사용
                    // 대분류별 중분류 매핑 데이터
                    categoryMap: {
                        '결혼': ['스튜디오', '드레스', '메이크업'],
                        '가족행사': ['가족사진', '돌잔치', '아이생일파티', '기념일', '부모님생신'],
                        '친구와함께': ['우정사진', '브라이덜샤워', '파티룸']
                    },
                    hoverUserId : null,
                    hoverInfo : null,
                    hoverReviewNo : null,
                };
            },
            computed: {
                pageNumbers() {
                    const totalPages = Math.ceil(this.totalCount / this.pageSize);
                    const startPage = Math.floor((this.currentPage - 1) / this.pageBlockSize) * this.pageBlockSize + 1;
                    let endPage = startPage + this.pageBlockSize - 1;
                    if (endPage > totalPages) endPage = totalPages;
                    const pages = [];
                    for (let i = startPage; i <= endPage; i++) { pages.push(i); }
                    return pages;
                },
                totalPageCount() { return Math.ceil(this.totalCount / this.pageSize); }
            },
            methods: {
                fnShowHover(userId, reviewNo) {
                    this.hoverUserId = userId;
                    this.hoverReviewNo = reviewNo;
                    // 서버에서 데이터 가져오기
                    axios.get('/userProfileSimple.dox', { params: { userId: userId  } })
                        .then(res => {
                            this.hoverInfo = res.data; // 서버에서 보낸 info, reviewTotal, postTotal 저장
                        });
                },
                fnHideHover() {
                    this.hoverUserId = null;
                    this.hoverPostNo = null; // 초기화
                    this.hoverInfo = null;
                },
                fnGetUserTicket() {
                    if(!this.sessionId) return;
                    $.ajax({
                        url: "/api/review/getUserAccessCount.dox",
                        type: "POST",
                        data: JSON.stringify({ userId: this.sessionId }),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            this.userRemainingCount = result.count;
                        }
                    });
                },
                // 1차 분류 선택 시
                fnChangeLargeCategory(val) {
                    this.mainCategory = val;
                    this.subCategory = 'all'; // 대분류 변경 시 중분류 초기화
                    this.currentPage = 1;
                    this.fnList();
                },
                // 2차 분류 선택 시
                fnChangeMediumCategory(val) {
                    this.subCategory = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnList() {
                    const nParam = {
                        isPaid: this.isPaid,
                        largeCategory: this.mainCategory,  
                        mediumCategory: this.subCategory,
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType,
                        startIndex: (this.currentPage - 1) * this.pageSize,
                        pageSize: this.pageSize,
                        orderType: this.orderType 
                    };
                    $.ajax({
                        url: "/api/review/list.dox",
                        type: "POST",
                        data: JSON.stringify(nParam),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            if(result.result === "success") {
                                this.list = result.list;
                                this.totalCount = result.count;
                                this.bestList = result.bestList;
                            }
                        }
                    });
                },
                fnDetail(item) {
                    if (this.userRole === 'ADMIN' || (this.sessionId && this.sessionId === item.userId)) {
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                        return;
                    }
                    if (item.isPaid == 1 && !this.sessionId) {
                        alert("유료 리뷰는 로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    }
                    if (item.isPaid == 1) {
                        $.ajax({
                            url: "/api/review/useTicket.dox",
                            type: "POST",
                            data: JSON.stringify({ reviewNo: item.reviewNo, checkOnly: "Y" }),
                            contentType: "application/json",
                            success: (data) => {
                                let result = (typeof data === 'string') ? JSON.parse(data) : data;
                                if (result.result === "ALREADY_VIEWED") {
                                    location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                                } else {
                                    const confirmMsg = "유료 리뷰입니다. 열람권을 사용하여 확인하시겠습니까?\n" +
                                                       "------------------------------------------\n" +
                                                       "현재 보유 열람권: " + this.userRemainingCount + "개\n" +
                                                       "------------------------------------------";
                                    if (confirm(confirmMsg)) {
                                        this.fnExecuteUsage(item);
                                    }
                                }
                            }
                        });
                    } else {
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                    }
                },
                fnExecuteUsage(item) {
                    $.ajax({
                        url: "/api/review/useTicket.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: item.reviewNo }),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            if(result.result === "SUCCESS") {
                                this.userRemainingCount--; 
                                alert("열람권 1개가 차감되었습니다.\n남은 열람권: " + this.userRemainingCount + "개");
                                location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                            } else if(result.result === "NO_TICKET") {
                                alert("열람권이 부족합니다. (현재: " + this.userRemainingCount + "개)");
                            } else {
                                alert("처리 중 오류가 발생했습니다.");
                            }
                        }
                    });
                },
                fnCategoryFilter(val) {
                    this.category = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnFilter(val) {
                    this.isPaid = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnReset() {
                    this.isPaid = null;
                    this.category = 'all';
                    this.searchKeyword = '';
                    this.orderType = 'date';
                    this.currentPage = 1;
                    this.fnList();
                },
                fnPageChange(page) {
                    this.currentPage = page;
                    this.fnList();
                },
                fnWrite() {
                    if(!this.sessionId) {
                        alert("로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    } else {
                        location.href = "/api/review/add.do";
                    }
                },
                fnChangeOrder(type) {
                    this.orderType = type;
                    this.currentPage = 1;
                    this.fnList();
                },
                // 블러 처리 여부를 결정하는 핵심 로직
                shouldBlur(item) {
                    // 1. 관리자(ADMIN)는 절대 블러 안 함
                    if (this.userRole === 'ADMIN') return false;
                    
                    // 2. 유료 리뷰(isPaid == 1)가 아니면 블러 안 함
                    if (item.isPaid != 1) return false;
                    
                    // 3. 내가 쓴 리뷰(userId가 일치)면 블러 안 함
                    if (this.sessionId === item.userId) return false;
                    
                    // 4. 이미 열람권을 사용해 구매한 이력이 있다면 블러 안 함
                    // (이 데이터는 DB에서 'isViewed' 같은 컬럼으로 가져온다고 가정)
                    if (item.viewStatus === 'ALREADY_VIEWED') return false;

                    // 위 조건에 모두 해당하지 않는 유료 리뷰만 블러 처리
                    return true;
                },
            },
            mounted() {
                this.fnList();
                this.fnGetUserTicket();
            }
        }).mount('#app');
    </script>
</body>
</html>