<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            /* 기본 레이아웃 */
            body {
                font-family: 'Malgun Gothic', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }

            #app {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border: 1px solid #ddd;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* 헤더 영역 */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                border-bottom: 2px solid #333;
            }

            .nav-top button {
                padding: 8px 15px;
                margin-right: 5px;
                border: 1px solid #ff7f9f;
                background: white;
                color: #ff7f9f;
                cursor: pointer;
                border-radius: 5px;
            }

            .user-info {
                background: #ff7f9f;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
            }

            /* 메인 바디 레이아웃 */
            .container {
                display: flex;
                flex: 1;
            }

            /* 사이드바 */
            aside {
                width: 220px;
                background: #fff0f3;
                padding: 20px;
                border-right: 1px solid #ddd;
            }

            .menu-item {
                position: relative;
                margin-bottom: 10px;
            }

            .menu-item button {
                width: 100%;
                padding: 12px;
                text-align: center;
                border: 1px solid #ddd;
                background: white;
                cursor: pointer;
                font-weight: bold;
            }

            .menu-item button.active {
                background: #ff1493;
                color: white;
                border-color: #ff1493;
            }

            /* 숫자 배지 */
            .badge {
                position: absolute;
                right: -10px;
                top: 50%;
                transform: translateY(-50%);
                background: #ff1493;
                color: white;
                border-radius: 12px;
                padding: 2px 10px;
                font-size: 12px;
                border: 2px solid white;
                z-index: 10;
            }

            /* 메인 컨텐츠 */
            main {
                flex: 1;
                padding: 30px;
            }

            .content-card {
                border: 2px solid #ff7f9f;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 20px;
                position: relative;
            }

            /* .section-title {
                background: #ffb400;
                display: inline-block;
                padding: 5px 15px;
                color: white;
                font-weight: bold;
                margin-bottom: 15px;
            } */
            /* 전체 컨테이너 */
            .booking-time-container {
                margin-top: 30px;
                padding: 20px;
                background-color: #fff;
                border-radius: 10px;
                /* [디자인 팁] 두 번째 이미지의 깔끔한 그림자 효과 참고 */
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            /* 제목 스타일 */
            .section-title {
                font-size: 1.2rem;
                font-weight: 700;
                margin-bottom: 25px;
                color: #333;
            }

            /* 오전/오후 그룹 스타일 */
            .time-slot-group {
                margin-bottom: 25px;
            }

            .time-ampm {
                font-size: 0.95rem;
                color: #888;
                margin-bottom: 10px;
                font-weight: 600;
            }

            /* 버튼들을 나열하는 그리드 */
            .time-slots {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
                gap: 10px;
                /* 버튼 사이 간격 */
            }

            /* 1. [기본 상태] 버튼 스타일 */
            .time-btn {
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #ddd;
                /* [디자인 팁] 두 번째 이미지의 깔끔한 테두리 참고 */
                background-color: #fff;
                font-size: 1rem;
                font-weight: 500;
                color: #555;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
                /* 부드러운 변화 효과 */
            }

            /* 호버 효과 (마우스 올렸을 때) */
            .time-btn:not(:disabled):hover {
                background-color: #f0f0f0;
                border-color: #bbb;
            }

            /* 2. [예약 불가 상태] (disabled/booked) 회색 처리 */
            .time-btn.booked:disabled {
                background-color: #f7f7f7;
                color: #ccc;
                border-color: #eee;
                cursor: not-allowed;
                /* 클릭 안 됨 마우스 모양 */
                text-decoration: line-through;
                /* [디자인 팁] 직관성을 위해 줄 긋기 */
            }

            /* 3. [내가 선택한 상태] (active) 색깔로 강조 */
            .time-btn.active {
                /* [디자인 팁] 사용자 프로젝트의 메인 컬러를 여기 적용하세요! */
                background-color: #ffb6c1;
                /* 예시: 연한 핑크색 */
                color: #fff;
                border-color: #ffb6c1;
                font-weight: 700;
                box-shadow: 0 4px 6px rgba(255, 182, 193, 0.4);
                /* 버튼에도 살짝 그림자 */
            }

            /* 테이블 및 리스트 스타일 */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                background: #fef0f3;
                width: 120px;
            }

            .new-label {
                background: #ff7f9f;
                color: white;
                font-size: 10px;
                padding: 2px 4px;
                border-radius: 3px;
                vertical-align: middle;
                margin-right: 5px;
            }

            /* 탭 버튼 */
            .tab-menu {
                margin-bottom: 20px;
            }

            .tab-menu button {
                padding: 10px 20px;
                border: 1px solid #ddd;
                background: #eee;
                cursor: pointer;
            }

            .tab-menu button.active {
                background: #ff7f9f;
                color: white;
                border-color: #ff7f9f;
            }

            /* 푸터 */
            footer {
                background: #ffc1cc;
                padding: 20px;
                text-align: center;
                font-size: 14px;
                border-top: 1px solid #ddd;
            }

            /* 플로팅 버튼 */
            .ai-chatbot {
                position: fixed;
                right: 30px;
                bottom: 100px;
                background: #0099ff;
                color: white;
                width: 70px;
                height: 70px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            /* 리뷰 섹션 공통 */
            .review-header-info {
                display: flex;
                align-items: center;
                gap: 20px;
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #eee;
            }

            .review-thumb-box {
                width: 80px;
                height: 80px;
                background: #ffcef0;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 6px;
                font-size: 12px;
                color: #d6336c;
            }

            .review-product-name {
                flex: 1;
                font-size: 18px;
                color: #333;
            }

            .review-count-badge {
                font-size: 14px;
                color: #666;
                background: #fff;
                padding: 5px 12px;
                border-radius: 20px;
                border: 1px solid #ddd;
            }

            /* 상세 리뷰 카드 내부 */
            .detail-review-item {
                padding: 20px 0;
                border-bottom: 1px solid #f0f0f0;
            }

            .star-rating {
                color: #ffb400;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .review-photo {
                width: 100px;
                height: 100px;
                background: #fff0f3;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 11px;
                color: #ff7f9f;
                border: 1px solid #ffe0e6;
            }

            /* 페이징 */
            .pagination {
                text-align: center;
                margin-top: 25px;
            }

            .pagination a {
                display: inline-block;
                padding: 8px 12px;
                margin: 0 4px;
                text-decoration: none;
                color: #666;
                border-radius: 4px;
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                cursor: pointer;
                border: 1px solid transparent;
                font-weight: 500;
            }

            .pagination a:hover {
                background: #ff7f9f;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 124, 159, 0.3);
            }

            .pagination a:active {
                transform: translateY(0px);
            }

            /* 상품 등록/수정 폼 */
            .product-form-wrapper {
                background: white;
            }

            .product-form-section {
                margin-bottom: 25px;
            }

            .form-title-box {
                background: linear-gradient(135deg, #ff7f9f 0%, #ff9fb8 100%);
                padding: 12px 20px;
                color: white;
                font-weight: bold;
                font-size: 15px;
                border-radius: 6px 6px 0 0;
                margin-bottom: 0;
            }

            .form-content-box {
                border: 2px solid #ff7f9f;
                border-top: none;
                padding: 25px;
                border-radius: 0 0 6px 6px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group:last-child {
                margin-bottom: 0;
            }

            .form-label {
                display: block;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                font-size: 14px;
            }

            .category-group {
                display: flex;
                gap: 25px;
                padding: 10px 0;
            }

            .category-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .category-item input[type="checkbox"] {
                cursor: pointer;
                width: 18px;
                height: 18px;
            }

            .category-item label {
                cursor: pointer;
                margin: 0;
                font-size: 14px;
                color: #555;
            }

            .form-info-box {
                background: #fff9f0;
                border-left: 4px solid #ffb400;
                padding: 12px 15px;
                border-radius: 4px;
                color: #333;
                font-size: 14px;
                line-height: 1.6;
            }

            .form-info-label {
                font-weight: 600;
                color: #ff1493;
            }

            .image-editor-box {
                background: linear-gradient(135deg, #ffe0e6 0%, #fff0f3 100%);
                border: 2px dashed #ff7f9f;
                border-radius: 8px;
                padding: 40px;
                text-align: center;
                color: #ff7f9f;
                font-weight: 600;
                min-height: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .image-editor-box:hover {
                background: linear-gradient(135deg, #ffd4e5 0%, #ffe8ef 100%);
                border-color: #ff1493;
            }

            .form-button-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                justify-content: flex-end;
            }

            .form-button-group button {
                padding: 12px 30px;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .btn-submit {
                background: #ff7f9f;
                color: white;
            }

            .btn-submit:hover {
                background: #ff1493;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 124, 159, 0.3);
            }

            .btn-cancel {
                background: #f0f0f0;
                color: #666;
                border: 1px solid #ddd;
            }

            .btn-cancel:hover {
                background: #e8e8e8;
                border-color: #999;
            }

            /* --- 기존 레이아웃 유지 및 보강 --- */

            /* 상품 리스트 개별 아이템 카드 */
            .product-item {
                display: flex;
                align-items: flex-start;
                /* 상단 정렬 */
                gap: 20px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 20px;
                border: 1px solid #eee;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            .product-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(255, 127, 159, 0.2);
                border-color: #ff7f9f;
            }

            /* 이미지 박스 */
            .product-img-box {
                box-sizing: border-box;
                flex-shrink: 0;
                /* 이미지 크기 고정 */
                height: 140px;
                width: 140px;
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid #f0f0f0;
            }

            .product-img-box img {
                height: 100%;
                width: 100%;
                object-fit: cover;
                /* 이미지 비율 유지 */
            }

            /* 텍스트 정보 영역 */
            .product-info {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .product-info h4 {
                margin: 0;
                font-size: 1.2rem;
                color: #333;
                font-weight: 700;
            }

            .product-info .product-content {
                margin: 0;
                color: #777;
                font-size: 0.95rem;
                line-height: 1.5;
            }

            .product-info .product-price {
                margin-top: auto;
                /* 하단 배치 */
                font-weight: bold;
                color: #ff1493;
                font-size: 1.1rem;
            }

            /* 카테고리 & 태그 필터 영역 */
            .filter-section {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                border: 1px solid #ff7f9f;
                margin-bottom: 30px;
            }

            .filter-section h2,
            .filter-section h4 {
                margin-top: 0;
                color: #333;
            }

            .tag-filter {
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px dashed #ddd;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }

            .tag-filter label,
            .filter-section label {
                cursor: pointer;
                background: #fff0f3;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.9rem;
                color: #d6336c;
                border: 1px solid #ffe0e6;
                transition: 0.2s;
            }

            .tag-filter label:hover {
                background: #ff7f9f;
                color: white;
            }

            /* 추가된 부분 10:00  am */
            /* 상품 상세 페이지 레이아웃 */
            .detail-container {
                display: flex;
                gap: 30px;
                padding: 20px;
            }

            /* 왼쪽 컨텐츠 (이미지, 이름, 상세정보) */
            .detail-left {
                flex: 7;
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .detail-main-img {
                width: 100%;
                height: 400px;
                object-fit: cover;
                border-radius: 10px;
                border: 1px solid #ddd;
            }

            .detail-company-name {
                font-size: 24px;
                font-weight: bold;
                padding: 15px;
                border: 2px solid #333;
                background: #fff;
                display: inline-block;
            }

            .detail-description-card {
                background: #ffe0e6;
                /* 이미지의 핑크색 배경 부분 */
                min-height: 300px;
                padding: 30px;
                border-radius: 10px;
                border: 2px solid #ff7f9f;
                font-size: 16px;
                line-height: 1.8;
            }

            /* 오른쪽 사이드바 (예약하기) */
            .detail-right {
                flex: 3;
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .reservation-box {
                border: 2px solid #333;
                padding: 20px;
                border-radius: 10px;
                background: #fff;
            }

            .calendar-placeholder {
                width: 100%;
                height: 100px;
                background: #f0f0f0;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 1px dashed #ccc;
                margin-top: 10px;
            }

            .price-info-box {
                padding: 15px;
                border: 2px solid #333;
                background: #fff;
                font-weight: bold;
            }

            .price-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
            }

            /* 버튼 스타일 */
            .btn-reserve {
                background: #ff4da6;
                color: white;
                padding: 15px;
                border: none;
                border-radius: 8px;
                font-weight: bold;
                font-size: 18px;
                cursor: pointer;
            }

            .btn-inquiry {
                background: #ff7f9f;
                color: white;
                padding: 15px;
                border: none;
                border-radius: 8px;
                font-weight: bold;
                font-size: 18px;
                cursor: pointer;
            }

            .btn-reserve:hover,
            .btn-inquiry:hover {
                opacity: 0.9;
            }


            /* 결제 확인 화면 스타일 */
            .payment-container {
                padding: 50px;
                max-width: 800px;
                margin: 0 auto;
                line-height: 2;
            }

            .payment-container h2 {
                font-size: 32px;
                margin-bottom: 40px;
            }

            .payment-info-row {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .total-payment-amount {
                text-align: right;
                font-size: 28px;
                font-weight: bold;
                margin: 40px 0;
            }

            .payment-btn-group {
                display: flex;
                justify-content: center;
                gap: 20px;
            }

            /* .btn-final-reserve {
                background-color: #ffc107;
                /* 노란색 */
                /* border: 1px solid #ddd;
                padding: 15px 60px;
                font-size: 20px;
                font-weight: bold;
                cursor: pointer;
                border-radius: 5px; */
            /* } */ 

            /* .btn-cancel-pay {
                background-color: white;
                border: 1px solid #333;
                padding: 15px 60px;
                font-size: 20px;
                font-weight: bold;
                cursor: pointer;
                border-radius: 5px;
            } */

            /* 티켓 전체 컨테이너 */
            .payment-container {
                padding: 50px 20px;
                display: flex;
                justify-content: center;
                background-color: #f9f9f9;
            }

            /* 🎟️ 티켓 카드 스타일 */
            .reservation-ticket {
                width: 100%;
                max-width: 700px;
                background: #fff;
                border-radius: 15px;
                position: relative;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                /* 둥실 떠오르는 애니메이션 */
                overflow: hidden;
                border: 1px solid #eee;
            }

            /* [핵심] 마우스 호버 효과 */
            .reservation-ticket:hover {
                transform: translateY(-10px);
                /* 위로 살짝 올라감 */
                box-shadow: 0 20px 40px rgba(255, 127, 159, 0.15);
                /* 강조 색상으로 그림자 */
            }

            /* 티켓 헤더 (분홍색 포인트) */
            .ticket-header {
                background-color: #ff7f9f;
                padding: 12px 25px;
                display: flex;
                justify-content: space-between;
                color: #fff;
                font-size: 0.8rem;
                letter-spacing: 2px;
                font-weight: bold;
            }

            /* 티켓 바디 */
            .ticket-body {
                display: flex;
                padding: 30px;
                border-bottom: 2px dashed #eee;
                /* 티켓 절취선 느낌 */
            }

            .ticket-info {
                flex: 2;
                border-right: 2px dashed #eee;
                padding-right: 20px;
            }

            .ticket-side {
                flex: 1;
                padding-left: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
            }

            /* 정보 텍스트 스타일 */
            .info-row {
                margin-bottom: 20px;
            }

            .info-row label {
                display: block;
                font-size: 0.85rem;
                color: #999;
                margin-bottom: 5px;
            }

            .info-row .value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #333;
            }

            .product-name .value {
                color: #ff7f9f;
                font-size: 1.3rem;
            }

            .date-time {
                color: #333;
            }

            .time-tag {
                background: #fff0f3;
                color: #ff7f9f;
                padding: 2px 8px;
                border-radius: 4px;
                font-size: 0.9rem;
            }

            /* 금액 및 바코드 */
            .amount-label {
                font-size: 0.8rem;
                color: #999;
            }

            .amount-value {
                font-size: 1.5rem;
                font-weight: 800;
                color: #333;
                margin: 10px 0;
            }

            .agreement-text {
                font-size: 0.75rem;
                color: #bbb;
                margin-bottom: 15px;
            }

            .ticket-barcode {
                font-family: 'Libre Barcode 39', cursive;
                font-size: 2rem;
                color: #ddd;
                letter-spacing: 2px;
            }

            /* 버튼 그룹 */
            .payment-btn-group {
                padding: 25px;
                display: flex;
                gap: 15px;
            }

            .btn-final-reserve {
                flex: 2;
                background: #ff7f9f;
                color: white;
                border: none;
                padding: 15px;
                border-radius: 8px;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
            }

            .btn-final-reserve:hover {
                background: #ff5c85;
            }

            .btn-cancel-pay {
                flex: 1;
                background: #fff;
                color: #999;
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 8px;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <header>
                <div class="logo"><img src="/img/merryViewLogo.png" alt="메리뷰" height="60"></div>
                <div class="nav-top">
                    <button>회사소개</button>
                    <button>제휴업체</button>
                    <button>커뮤니티</button>
                    <button>패스구매</button>
                    <button>고객센터</button>
                </div>
                <div class="user-info">{{ user.name }}님</div>
            </header>

            <div class="container">


                <main>
                    <main>
                        <div v-if="currentMenu === 'main' && productPage === 'list'">
                            <div class="filter-section">
                                <!-- <div class="section-title">조회 필터</div> -->
                                <h2>카테고리</h2>
                                <label><input type="checkbox" v-model="selectCategory" value="스튜디오"> 스튜디오</label>
                                <label><input type="checkbox" v-model="selectCategory" value="드레스"> 드레스</label>
                                <label><input type="checkbox" v-model="selectCategory" value="메이크업"> 메이크업</label>

                                <div class="tag-filter">
                                    <h4 style="width: 100%;">분위기 선택</h4>
                                    <label v-for="tag in productTag" :key="tag">
                                        <input type="checkbox" :value="tag" v-model="selectTags">
                                        {{ tag }}
                                    </label>
                                </div>
                            </div>

                            <div v-for="item in filteredList" :key="item.id" class="product-item"
                                @click="goDetailPage(item)" style="cursor:pointer;">
                                <div class="product-img-box">
                                    <img :src="item.thumbnail" alt="item.name">
                                </div>
                                <div class="product-info">
                                    <h4>{{item.name}}</h4>
                                    <p class="product-content">{{item.content}}</p>
                                    <div v-if="item.tag" style="display: flex; gap: 5px;">
                                        <span v-for="t in item.tag"
                                            style="font-size: 11px; color: #ff7f9f;">{{t}}</span>
                                    </div>
                                    <p class="product-price">{{item.price}}</p>
                                </div>
                            </div>
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'detail'">
                            {{product1}}
                            <button @click="fnBack()" style="margin-bottom:10px;">← 뒤로가기</button>
                                
                            <div class="detail-container">
                                <div class="detail-left">
                                    <img :src="product1.thumbnail" class="detail-main-img">
                                    <div class="detail-company-name">
                                        {{ product1.company }} </div>
                                    <div class="detail-description-card">
                                        <h3 style="margin-top:0;">{{ product1.name }}</h3>
                                        <p>{{ product1.content }}</p>
                                        <hr>
                                        <p>※ 상세 옵션 안내 및 유의사항이 여기에 들어갑니다.</p>
                                    </div>
                                </div>

                                <div class="detail-right">
                                    <div class="reservation-box">
                                        <div
                                            style="font-weight:bold; border-bottom:1px solid #ddd; padding-bottom:10px;">
                                            예약하기</div>
                                        <div class="calendar-placeholder"
                                            style="background: white; flex-direction: column;">
                                            <label for="res-date"
                                                style="font-size: 14px; margin-bottom: 10px; color: #666;">방문 예정일을
                                                선택해주세요</label>
                                            <input type="date" id="res-date" v-model="selectedDate"
                                                style="padding: 10px; border: 1px solid #ff7f9f; border-radius: 5px; width: 80%;">



                                        </div>
                                        <div class="booking-time-container">
                                            <h3 class="section-title">방문 희망 시간을 선택해 주세요</h3>

                                            <div class="time-slot-group">
                                                <h4 class="time-ampm">오전</h4>
                                                <div class="time-slots">
                                                    <button v-for="t in amTimes" :key="t" class="time-btn"
                                                        :class="{ 'active': selectedTime === t, 'booked': bookedTimes.includes(t) }"
                                                        :disabled="bookedTimes.includes(t)" @click="fnSelectTime(t)">
                                                        {{ t }}
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="time-slot-group">
                                                <h4 class="time-ampm">오후</h4>
                                                <div class="time-slots">
                                                    <button v-for="t in pmTimes" :key="t" class="time-btn"
                                                        :class="{ 'active': selectedTime === t, 'booked': bookedTimes.includes(t) }"
                                                        :disabled="bookedTimes.includes(t)" @click="fnSelectTime(t)">
                                                        {{ t }}
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="price-info-box">
                                        <div class="price-row">
                                            <span>예상 견적 :</span>
                                            <span>{{ product1.price }}</span>
                                        </div>
                                    </div>

                                    <div class="price-info-box">
                                        <div class="price-row">
                                            <span>예약금 :</span>
                                            <span>{{ product1.deposit }}</span>
                                        </div>
                                    </div>

                                    <button class="btn-reserve" @click="fnReserve">예약하기</button>
                                    <button class="btn-inquiry" @click="currentMenu = 'inquiry'">상품 문의하기</button>
                                </div>
                            </div>
                        </div>

                        <div v-if="currentMenu === 'main' && productPage === 'payment'" class="payment-container">
                            
                            <div class="reservation-ticket">
                                <div class="ticket-header">
                                    <span class="ticket-brand">MERRY VIEW RESERVATION</span>
                                    <span class="ticket-type">OFFICIAL TICKET</span>
                                </div>
                                <!-- {{product1}}
                                {{selectedDate}}
                                {{selectedTime}} -->
                                <!-- <div style="text-align: right;">
                                    <img :src="product1.thumbnail" style="max-height: 200px; margin-top: 10px; margin-right: 20px;">
                                </div> -->
                                
                                <div class="ticket-body">
                                    <div class="ticket-info">
                                        <div class="info-row product-name">
                                            <label>결제 상품</label>
                                            <div class="value">{{ product1.name }} <small>({{ product1.company
                                                    }})</small></div>
                                        </div>

                                        <div class="info-grid">
                                            <div class="info-row">
                                                <label>예약 일시</label>
                                                <div class="value date-time">{{ selectedDate }} <span
                                                        class="time-tag">{{ selectedTime }}</span></div>
                                            </div>
                                            <div class="info-row">
                                                <label>예약자명</label>
                                                <div class="value">{{ user.name }}님</div>
                                            </div>
                                        </div>


                                        <div class="info-row">
                                            <label>휴대폰 번호</label>
                                            <div class="value">{{ user.contact }}</div>
                                        </div>

                                    </div>

                                    <div class="ticket-side">
                                        <div class="side-content">
                                            <img :src="product1.thumbnail" style="max-height: 200px;">
                                            <div class="amount-label">TOTAL DEPOSIT</div>
                                            <div class="amount-value">{{ product1.deposit }}</div>
                                            <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                                            <!-- <div class="ticket-barcode">|| ||| || |||| | ||</div> -->
                                        </div>
                                    </div>
                                </div>
                                <div class="payment-btn-group">
                                    <button class="btn-cancel-pay" @click="productPage = 'detail'">뒤로가기</button>
                                    <button class="btn-final-reserve" @click="fnFinalOrder(user)">결제 및 예약 확정</button>
                                </div>
                            </div>
                        </div>


                        <!-- <div class="payment-info-row">결제 상품 : {{ product1.name }}({{product1.company}})</div>
                        <div class="payment-info-row">예약일자 및 시간 : {{ selectedDate }} {{ selectedTime }}</div>
                        <div class="payment-info-row">예약자명 : {{ user.name }}</div>
                        <div class="payment-info-row">휴대폰번호 : {{ user.contact}}</div>
                        <div class="payment-info-row">예약금 : {{ product1.deposit }}</div>
                        <div class="payment-info-row">필수항목동의 : 노쇼관련</div>

                        <div class="total-payment-amount">
                            결제 금액 : {{ product1.deposit }}
                        </div>

                        <div class="payment-btn-group">
                            <button class="btn-final-reserve" @click="fnFinalOrder(user)">예약하기</button>
                            <button class="btn-cancel-pay" @click="productPage = 'detail'">취소</button>
                        </div> -->
            </div>

            </main>
            </main>
        </div>
        </div>

        <footer>
            푸터 → 업체 정보 | 사업자번호: 000-00-00000 | 고객센터: 1588-0000
        </footer>

        <div class="ai-chatbot">ai 챗봇</div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    amTimes: ['10:00', '11:00'],
                    pmTimes: ['13:00', '14:00', '15:00', '16:00', '17:00'],

                    bookedTimes: [], // 서버에서 받아온 시간들 (HH:mm:ss 형태)
                    selectedTime: '', // 사용자가 클릭한 시간 (HH:mm 형태)



                    selectedDate: '',
                    selectTags: [],
                    productTag: [],
                    selectCategory: [],
                    productList3: [],
                    inquiryList: [
                        { id: 1, product: '화려하게', title: '투어 일정 변경하고 싶습니다.', userid: '김결혼', content: '04.01일 예약했는데 04.08일로 변경하고 싶어요.' },
                        { id: 2, product: '스몰 웨딩', title: '메이크업 추가되나요?', userid: '아리랑', content: '메이크업 여기서 받고싶어요.' },
                    ],
                    user: {
                        id: 1, name: 'maygirl05', contact: '010-xxxx-xxxx'
                    },
                    currentMenu: 'main', // 초기 화면
                    reviewTab: 'detail',

                    page1: 'main', // 상품별 리뷰 페이지 구분 변수
                    productPage: 'list', //(list: 목록, reg: 등록, edit: 수정)

                    page: 1,
                    product: '',
                    product1: {},
                    proType: [],

                    //product === productList.        v-for = "pro in productList" :key="pro.id"   v-if="product === pro.name" 
                    productList: [
                        {
                            id: 1,
                            thumbnail: 'https://img1.newsis.com/2021/09/26/NISI20210926_0000834715_web.jpg',
                            name: '내추럴 스몰 웨딩',
                            company: '아름 스튜디오',
                            content: '자연스러운 채광과 함께하는 소규모 웨딩 패키지입니다.',
                            price: '1,700,000원',
                            category: ['스튜디오', '드레스'],
                            tag: ['내추럴한', '인물 중심', '가성비']
                        },
                        {
                            id: 2,
                            thumbnail: 'https://i.imgur.com/RwwCSsD.jpeg',
                            name: '럭셔리 비즈 패키지',
                            company: '엘레강스 웨딩',
                            content: '화려한 호텔 예식에 어울리는 프리미엄 비즈 드레스와 메이크업.',
                            price: '3,500,000원',
                            category: ['드레스', '메이크업'],
                            tag: ['화려한', '비즈 맛집', '프리미엄']
                        },
                        {
                            id: 3,
                            thumbnail: 'https://i.imgur.com/vVJ0lAD.jpeg',
                            name: '동화같은 가든 스냅',
                            company: '포레스트 필름',
                            content: '야외 정원에서 펼쳐지는 몽환적인 분위기의 촬영 세트입니다.',
                            price: '1,200,000원',
                            category: ['스튜디오'],
                            tag: ['몽환적인', '야외 스냅', '그리너리']
                        },
                        {
                            id: 4,
                            thumbnail: 'https://i.imgur.com/OOOUXX2.jpeg',
                            name: '클래식 단아 화보',
                            company: '고은 사진관',
                            content: '시간이 흘러도 변치 않는 단아하고 클래식한 인물 중심 촬영.',
                            price: '2,100,000원',
                            category: ['스튜디오'],
                            tag: ['클래식한', '단아한', '인물 중심']
                        },
                        {
                            id: 5,
                            thumbnail: 'https://i.imgur.com/13Pd2g0.jpeg',
                            name: '제주 푸른 바다 스냅',
                            company: '아일랜드 스냅',
                            content: '제주도의 푸른 바다와 숲을 배경으로 하는 감성 스냅 여행.',
                            price: '1,500,000원',
                            category: ['스튜디오'],
                            tag: ['제주 스냅', '야외 스냅', '빈티지한']
                        },
                        {
                            id: 6,
                            thumbnail: 'https://i.imgur.com/5NZ6N6J.jpeg',
                            name: '심플 실크 패키지',
                            company: '실크로드 웨딩',
                            content: '깔끔한 실크 드레스와 깨끗한 윤광 메이크업의 조화.',
                            price: '1,800,000원',
                            category: ['드레스', '메이크업'],
                            tag: ['실크 드레스', '심플한', '윤광 메이크업']
                        },
                        {
                            id: 7,
                            thumbnail: 'https://i.imgur.com/unGGPeY.jpeg',
                            name: '빈티지 레트로 웨딩',
                            company: '기억 저장소',
                            content: '유니크한 소품과 빈티지한 색감이 매력적인 스튜디오 상품.',
                            price: '1,400,000원',
                            category: ['스튜디오'],
                            tag: ['빈티지한', '세련된', '커스터마이징']
                        },
                        {
                            id: 8,
                            thumbnail: 'https://i.imgur.com/HH39Q7x.jpeg',
                            name: '프리미엄 토탈 샵',
                            company: '골든 라벨',
                            content: '스튜디오, 드레스, 메이크업을 한 번에 해결하는 올인원 패키지.',
                            price: '4,200,000원',
                            category: ['스튜디오', '드레스', '메이크업'],
                            tag: ['토탈 샵', '프리미엄', '우아한']
                        },
                        {
                            id: 9,
                            thumbnail: 'https://i.imgur.com/dfAstzQ.jpeg',
                            name: '로맨틱 야간 촬영',
                            company: '미드나잇 스튜디오',
                            content: '도시의 야경과 전구 조명이 어우러진 로맨틱한 분위기.',
                            price: '1,100,000원',
                            category: ['스튜디오'],
                            tag: ['야간 촬영', '몽환적인', '감성적인']
                        },
                        {
                            id: 10,
                            thumbnail: 'https://i.imgur.com/zE63IB8.jpeg',
                            name: '모던 시크 스튜디오',
                            company: '블랙 앤 화이트',
                            content: '심플한 배경에서 인물에만 집중하는 세련된 화보 스타일.',
                            price: '1,600,000원',
                            category: ['스튜디오'],
                            tag: ['모던한', '세련된', '인물 중심']
                        },
                        {
                            id: 11,
                            thumbnail: 'https://i.imgur.com/x08AwJc.jpeg',
                            name: '러블리 과즙 팡팡',
                            company: '베리 메이크업',
                            content: '사랑스러운 신부를 위한 화사한 과즙 메이크업과 레이스 드레스.',
                            price: '2,300,000원',
                            category: ['드레스', '메이크업'],
                            tag: ['러블리한', '과즙 메이크업', '레이스 드레스']
                        },
                        {
                            id: 12,
                            thumbnail: 'https://i.imgur.com/BF7go1g.jpeg',
                            name: '그리너리 본식 스냅',
                            company: '모먼트 픽',
                            content: '식장 분위기를 그대로 담아내는 생생한 현장 본식 스냅.',
                            price: '900,000원',
                            category: ['스튜디오'],
                            tag: ['본식 스냅', '그리너리', '가성비']
                        },
                        {
                            id: 13,
                            thumbnail: 'https://i.imgur.com/zKxXEJ1.jpeg',
                            name: '동양적 우아함 패키지',
                            company: '연정 메이크업',
                            content: '전통의 미와 현대적 감각이 어우러진 우아한 스타일링.',
                            price: '2,500,000원',
                            category: ['드레스', '메이크업'],
                            tag: ['우아한', '단아한', '음영 메이크업']
                        },
                        {
                            id: 14,
                            thumbnail: 'https://i.imgur.com/jCdqTnb.jpeg',
                            name: '나만의 커스터마이징',
                            company: '더 원 웨딩',
                            content: '신랑 신부가 원하는 컨셉을 그대로 구현하는 맞춤 상품.',
                            price: '3,000,000원',
                            category: ['스튜디오', '드레스', '메이크업'],
                            tag: ['커스터마이징', '세련된', '단독 홀']
                        },
                        {
                            id: 15,
                            thumbnail: 'https://i.imgur.com/vWUgcRD.jpeg',
                            name: '실속 알뜰 패키지',
                            company: '굿데이 웨딩',
                            content: '필요한 것만 쏙쏙 담은 거품 없는 실속형 웨딩 상품.',
                            price: '800,000원',
                            category: ['메이크업', '드레스'],
                            tag: ['가성비', '심플한', '단아한']
                        }
                    ],


                    simpleReviews: [
                        // 1~7: 스몰 웨딩 (7개)
                        { id: 1, product: '스몰 웨딩', content: '드레스 피팅 때 전문가 포스가 느껴져서 안심됐어요.', userid: '예신이1004', rating: 5, updated: 'new' },
                        { id: 2, product: '스몰 웨딩', content: '지정했던 드레스가 대여 중이라 다른 걸 입어 아쉬워요.', userid: '드레스투어중', rating: 3, updated: 'new' },
                        { id: 3, product: '스몰 웨딩', content: '메이크업 지속력이 좀 떨어져서 촬영 중간에 수정했어요.', userid: '수정화장필수', rating: 3, updated: 'new' },
                        { id: 4, product: '스몰 웨딩', content: '대기 공간이 좁아서 부모님 모시고 가기엔 좀 불편해요.', userid: '효도신부', rating: 2, updated: 'old' },
                        { id: 5, product: '스몰 웨딩', content: '드레스 상태가 조금 사용감이 느껴져서 아쉬웠습니다.', userid: '꼼꼼한체크', rating: 2, updated: 'old' },
                        { id: 6, product: '스몰 웨딩', content: '가까운 지인들만 모시는 자리에 딱 맞는 심플한 드레스가 많아요.', userid: '심플리즘', rating: 5, updated: 'old' },
                        { id: 7, product: '스몰 웨딩', content: '소규모 예식이라 걱정했는데 상담 실장님이 동선까지 잘 짜주셨어요.', userid: '미니멀라이프', rating: 4, updated: 'old' },

                        // 8~12: 화려하게 (5개)
                        { id: 8, product: '화려하게', content: '헬퍼 이모님이 세심하게 챙겨주셔서 공주 된 기분이었어요.', userid: '행복한웨딩', rating: 5, updated: 'new' },
                        { id: 9, product: '화려하게', content: '수입 드레스 라인이 정말 독보적이네요. 화려함 끝판왕!', userid: '비즈가좋아', rating: 5, updated: 'new' },
                        { id: 10, product: '화려하게', content: '실장님이 제 체형에 딱 맞는 드레스를 잘 골라주셨어요.', userid: '체형교정마법', rating: 5, updated: 'old' },
                        { id: 11, product: '화려하게', content: '야간 촬영 추가했는데 분위기가 정말 환상적이에요.', userid: '밤하늘의별', rating: 5, updated: 'old' },
                        { id: 12, product: '화려하게', content: '조명 아래서 비즈가 반짝이는 게 너무 예뻐서 눈을 뗄 수가 없었네요.', userid: '반짝이덕후', rating: 5, updated: 'old' },

                        // 13~15: 동화같은 분위기 (3개)
                        { id: 13, product: '동화같은 분위기', content: '스튜디오 채광이 너무 예뻐서 원본도 만족스러워요.', userid: '촬영끝행복시작', rating: 5, updated: 'old' },
                        { id: 14, product: '동화같은 분위기', content: '작가님이 긴장을 잘 풀어주셔서 자연스럽게 찍었습니다.', userid: '웃는게어색해', rating: 5, updated: 'old' },
                        { id: 15, product: '동화같은 분위기', content: '스튜디오 배경이 유행을 좀 탈 것 같지만 사진은 예쁩니다.', userid: '감성신부v', rating: 4, updated: 'old' }
                    ],
                    reviews: [
                        { id: 1, product: '스몰 웨딩', rating: 5, author: '김결혼', content: '웨딩 플래너님이 정말 세심하게 도와주셔서 만족스러웠어요.', date: '26.04.08', updated: 'new' },
                        { id: 2, product: '스몰 웨딩', rating: 4, author: '김tntn', content: '드레스 퀄리티가 기대 이상이었습니다!', date: '26.04.08', updated: 'new' },
                        { id: 3, product: '스몰 웨딩', rating: 5, author: '김발랄', content: '스튜디오 촬영 분위기가 너무 좋아서 즐겁게 찍었어요.', date: '26.04.08', updated: 'new' },
                        { id: 4, product: '스몰 웨딩', rating: 5, author: '김망고', content: '스냅 사진 퀄리티가 정말 좋아요.', date: '26.04.08', updated: 'new' },
                        { id: 5, product: '스몰 웨딩', rating: 3, author: '김딸기', content: '예식 진행 스태프들이 매우 프로페셔널했습니다.', date: '26.04.07', updated: 'old' },
                        { id: 6, product: '스몰 웨딩', rating: 4, author: '김포도', content: '예약 과정이 간편해서 좋았어요.', date: '26.04.07', updated: 'old' },
                        { id: 7, product: '스몰 웨딩', rating: 3, author: '김사과', content: '디테일까지 신경 써주셔서 감동이었습니다.', date: '26.04.07', updated: 'old' },
                        { id: 8, product: '스몰 웨딩', rating: 3, author: '김오렌지', content: '예산에 맞춰 잘 추천해주셔서 도움이 많이 됐어요.', date: '26.04.06', updated: 'old' },
                        { id: 9, product: '스몰 웨딩', rating: 5, author: '김자몽', content: '웨딩 촬영 결과물이 정말 만족스러웠습니다.', date: '26.04.05', updated: 'old' },
                        { id: 10, product: '스몰 웨딩', rating: 3, author: '김레몬', content: '당일 진행이 체계적이라 믿고 맡길 수 있었어요.', date: '26.04.05', updated: 'old' },
                        { id: 11, product: '스몰 웨딩', rating: 3, author: '김복숭아', content: '친구들에게도 추천하고 싶은 업체입니다.', date: '26.04.02', updated: 'old' },
                        { id: 12, product: '스몰 웨딩', rating: 5, author: '김수박', content: '상담부터 계약까지 과정이 투명했어요.', date: '26.04.02', updated: 'old' },
                        { id: 13, product: '스몰 웨딩', rating: 5, author: '김참외', content: '웨딩홀 연출이 너무 아름다웠습니다.', date: '26.04.01', updated: 'old' },
                        { id: 14, product: '스몰 웨딩', rating: 5, author: '김멜론', content: '가성비 좋은 패키지라 만족해요.', date: '26.04.01', updated: 'old' },
                        { id: 15, product: '스몰 웨딩', rating: 3, author: '김키위', content: '플래너님 응대가 빠르고 정확했습니다.', date: '26.04.01', updated: 'old' },

                        // 화려하게 (10개)
                        { id: 16, product: '화려하게', rating: 3, author: '김미미', content: '메이크업이 자연스럽고 예쁘게 잘 되었어요.', date: '26.04.08', updated: 'new' },
                        { id: 17, product: '화려하게', rating: 5, author: '김sksk', content: '상담부터 진행까지 전반적으로 만족합니다.', date: '26.04.08', updated: 'new' },
                        { id: 18, product: '화려하게', rating: 5, author: '김하늘', content: '예식 당일 진행이 매끄러워서 걱정 없이 진행했어요.', date: '26.04.08', updated: 'new' },
                        { id: 19, product: '화려하게', rating: 3, author: '김바다', content: '플래너님 덕분에 준비 과정이 훨씬 수월했습니다.', date: '26.04.05', updated: 'old' },
                        { id: 20, product: '화려하게', rating: 3, author: '김초코', content: '드레스 종류가 다양해서 선택하기 좋았어요.', date: '26.04.05', updated: 'old' },
                        { id: 21, product: '화려하게', rating: 5, author: '김쿠키', content: '촬영 작가님이 포즈도 잘 잡아주셔서 만족!', date: '26.04.04', updated: 'old' },
                        { id: 22, product: '화려하게', rating: 4, author: '김라떼', content: '웨딩홀 분위기가 정말 고급스러웠습니다.', date: '26.04.04', updated: 'old' },
                        { id: 23, product: '화려하게', rating: 5, author: '김모카', content: '상담이 친절하고 꼼꼼해서 신뢰가 갔어요.', date: '26.04.03', updated: 'old' },
                        { id: 24, product: '화려하게', rating: 5, author: '김코코', content: '헤어 스타일링이 마음에 쏙 들었습니다.', date: '26.04.02', updated: 'old' },
                        { id: 25, product: '화려하게', rating: 5, author: '김치즈', content: '전체 패키지 구성이 합리적이었어요.', date: '26.04.02', updated: 'old' },

                        // 동화같은 분위기 (5개)
                        { id: 26, product: '동화같은 분위기', rating: 5, author: '김파인', content: '드레스 피팅 경험이 정말 좋았어요.', date: '26.04.08', updated: 'new' },
                        { id: 27, product: '동화같은 분위기', rating: 5, author: '김체리', content: '소소한 요청도 잘 반영해주셔서 감사했습니다.', date: '26.04.08', updated: 'new' },
                        { id: 28, product: '동화같은 분위기', rating: 5, author: '김블루베리', content: '전체 일정 관리가 체계적이었어요.', date: '26.04.08', updated: 'new' },
                        { id: 29, product: '동화같은 분위기', rating: 5, author: '김라임', content: '결혼 준비 스트레스가 많이 줄었습니다.', date: '26.04.05', updated: 'old' },
                        { id: 30, product: '동화같은 분위기', rating: 5, author: '김코코넛', content: '인생에 한 번뿐인 날을 잘 만들어주셔서 감사합니다.', date: '26.04.01', updated: 'old' }
                    ],
                    reservationList: [
                        { id: 1, product: '동화같은 분위기', content: '몽환적인 야외 촬영 희망합니다.', resDate: '26.03.01', useDate: '26.04.01 14:00PM', name: '김결혼', contact: '010-1234-5678', price: '50,000원' },
                        { id: 2, product: '화려하게', content: '럭셔리한 호텔 연회장 예약 건입니다.', resDate: '26.03.05', useDate: '26.04.05 10:00AM', name: '5월신부', contact: '010-9876-5432', price: '100,000원' },
                        { id: 3, product: '스몰 웨딩', content: '직계 가족만 모시는 조용한 예식입니다.', resDate: '26.03.10', useDate: '26.04.10 16:00PM', name: '김tntn', contact: '010-5555-6666', price: '30,000원' },
                        { id: 4, product: '동화같은 분위기', content: '디즈니 컨셉 웨딩 상담 부탁드려요.', resDate: '26.03.12', useDate: '26.04.15 11:00AM', name: '이봄날', contact: '010-2222-3333', price: '50,000원' },
                        { id: 5, product: '화려하게', content: '조명이 화려한 웨딩홀을 원합니다.', resDate: '26.03.15', useDate: '26.04.18 13:00PM', name: '박정성', contact: '010-4444-5555', price: '100,000원' },
                        { id: 6, product: '스몰 웨딩', content: '펜션 전체 대관 스몰웨딩 상담입니다.', resDate: '26.03.18', useDate: '26.04.20 09:00AM', name: '최기록', contact: '010-7777-8888', price: '30,000원' },
                        { id: 7, product: '동화같은 분위기', content: '숲속 컨셉 촬영 예약입니다.', resDate: '26.03.20', useDate: '26.04.22 15:30PM', name: '정반짝', contact: '010-9999-0000', price: '50,000원' },
                        { id: 8, product: '화려하게', content: '풍성한 비즈 드레스 투어 희망합니다.', resDate: '26.03.22', useDate: '26.04.25 10:30AM', name: '강꽃님', contact: '010-1111-2222', price: '100,000원' },
                        { id: 9, product: '스몰 웨딩', content: '레스토랑 웨딩 식순 문의입니다.', resDate: '26.03.25', useDate: '26.04.28 17:00PM', name: '윤소식', contact: '010-3333-4444', price: '30,000원' },
                        { id: 10, product: '동화같은 분위기', content: '파스텔 톤 생화 장식 상담입니다.', resDate: '26.03.28', useDate: '26.05.02 12:00PM', name: '조전통', contact: '010-6666-7777', price: '50,000원' },
                        { id: 11, product: '화려하게', content: '대형 웨딩홀 촬영 스케줄 문의입니다.', resDate: '26.04.01', useDate: '26.05.05 14:00PM', name: '한찬란', contact: '010-8888-9999', price: '100,000원' }
                    ],
                    inquiry: [
                        { id: 1, }
                    ],
                    category: ["스튜디오", "드레스", "메이크업"],
                    selectedItems: [],
                    productForm: {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    },
                    pageSize: 0,
                    currentPage: 1,
                    previewUrl: null, // 미리보기용 URL
                    uploadFile: null,  // 서버로 보낼 실제 파일 객체
                    product2: {
                        companyNo: '',
                        productNo: '',
                        proType: [""],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: ''
                    },
                    userReservationList: []
                }

            }, // data
            computed: {
                filteredList() {
                    return this.productList.filter(product => {
                        // 카테고리 조건 (선택 안 했으면 pass, 선택했으면 포함 여부 확인)
                        const matchCategory = this.selectCategory.length === 0 ||
                            this.selectCategory.some(cat => product.category.includes(cat));

                        // 태그 조건
                        const matchTag = this.selectTags.length === 0 ||
                            this.selectTags.some(tag => product.tag.includes(tag));

                        // 둘 다 만족하는 것만 리턴 (AND 조건)
                        return matchCategory && matchTag;
                    });
                }
                ,
                resCount() {
                    return this.reservationList.length;
                }
                ,
                revCnt() {
                    return this.reviews.filter(r => r.updated === 'new').length
                        + this.simpleReviews.filter(r => r.updated === 'new').length;
                }
                ,
                editingProduct() {
                    // productList에서 이름이 일치하는 녀석을 찾고, 없으면 빈 객체{}를 반환
                    return this.productList.find(p => p.name === this.product) || {};
                },
                menuList() {
                    return [
                        { id: 'main', name: '마이 페이지', count: 0 },
                        { id: 'product', name: '상품 관리', count: 0 },
                        { id: 'reservation', name: '예약 관리', count: this.resCount },
                        { id: 'inquiry', name: '문의 내역', count: 2 },
                        { id: 'review', name: '리뷰 내역', count: this.revCnt },
                        { id: 'customer', name: '고객센터', count: 0 }
                    ];
                },
                weddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.reviews.filter(r => r.product === product.name).length
                        }
                    })
                },
                simpleweddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.simpleReviews.filter(r => r.product === product.name).length
                        }
                    })
                },


                filteredReviews() {
                    return this.reviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },
                filteredSimpleReviews() {
                    return this.simpleReviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },



                paginatedReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },
                paginatedSimpleReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },

                fnPaginatedReservation() {
                    let start = (this.currentPage - 1) * 3;
                    let end = start + 3;
                    return this.reservationList.slice(start, end);
                },

                fnPaginatedInquiry() {
                    let start = this.currentPage - 1;
                    let end = start + 1;
                    return this.inquiryList.slice(start, end);
                    //(0, 1), (1, 2)
                },



                totalPages() {
                    return Math.ceil(this.filteredReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
                },
                totalSimplePages() {
                    return Math.ceil(this.filteredSimpleReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
                }
                ,
                totalPageReservation() {
                    return Math.ceil(this.reservationList.length / 3);
                },



            },
            methods: {
                // 함수(메소드) - (key : function())
                fnPageChange(num) {
                    this.currentPage = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                },
                fnCom: function () {
                    let self = this;
                    let param = {
                        userid: 'sunsu09'
                    };
                    $.ajax({
                        url: "http://localhost:8080/company.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data); //info,result,message

                            self.user.name = data.info.comName;
                            self.user.usePeriod = data.info.usePeriod;
                            self.user.grade = data.info.grade;
                            self.user.lastPayment = data.info.lastPayment;

                            //console.log(self.user);
                        }
                    });
                },
                fnProductList: function () {
                    let self = this;
                    let param = {
                        userid: 'sunsu09'
                    };
                    $.ajax({
                        url: "http://localhost:8080/productList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data);

                            self.productList3 = data.list; //덮어씌우기
                        }
                    });
                },

                withdraw: function () {
                    if (confirm("정말 탈퇴하시겠습니까?")) {
                        alert("탈퇴되었습니다.");
                    } else {
                        alert("탈퇴가 취소되었습니다.");
                    }
                },
                updateProduct: function () {
                    alert("상품이 수정되었습니다.");

                    this.productPage = 'list'; // 수정 후 상품 목록으로 돌아가기
                    // 여기야!!(+)
                },

                goEditPage(item) {
                    let self = this;
                    self.productPage = 'edit';

                    let param = {
                        userid: 'sunsu09',
                        productNo: item.productNo //파라미터로 보내주면되는구나~
                    };
                    $.ajax({
                        url: "http://localhost:8080/productDetail.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            // 1. 일단 전체 데이터를 담습니다.
                            self.product1 = data.info;//덮어씌우기

                            //
                            // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                            // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                            if (typeof self.product1.proType === 'string') {
                                try {
                                    let rawArray = JSON.parse(self.product1.proType);//["MAKEUP" , "STUDIO"]

                                    self.product1.proType = rawArray.map(val => {
                                        if (val === 'MAKEUP') {
                                            return '메이크업';
                                        } else if (val === 'DRESS') {
                                            return '드레스';
                                        } else if (val === 'STUDIO') {
                                            return '스튜디오';
                                        } else {
                                            return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                        } //self.product1.proType = ["메이크업", "스튜디오"]
                                    })
                                } catch (e) {
                                    // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                                    self.product1.proType = [];
                                }
                            }



                        }
                    });
                },

                //프론트 만으로 되는거
                //goEditPage(item) {
                //    this.productPage = 'edit';
                //    this.product = item.name;
                // 중요: [... ]를 써서 원본이 아닌 '복사본'을 바구니에 담습니다.
                //    this.selectedItems = [...item.category];
                //},

                // [2] 등록 버튼 누를 때: 바구니 깨끗이 비우기
                goRegPage() {
                    this.productPage = 'reg';
                    this.product = ''; // 수정 대상이 없으므로 비워줍니다.
                    this.selectedItems = []; // 바구니를 비워야 등록창이 깨끗합니다.
                },

                // [3] 수정 완료 버튼 (Save)
                fnSave() {
                    // 1. 현재 어떤 상품을 찾으려 하는지 확인
                    console.log("현재 찾으려는 상품명:", this.product);
                    console.log("현재 바구니(체크된 것):", this.selectedItems);

                    // 2. productList에서 해당 상품 찾기
                    const item = this.productList.find(p => p.name === this.product);

                    if (item) {
                        // 3. 찾았다면 데이터 덮어씌우기
                        item.category = [...this.selectedItems];
                        console.log("수정 완료된 원본 데이터:", item);

                        alert("수정되었습니다!");
                        this.productPage = 'list';
                    } else {
                        // 4. 만약 못 찾았다면 왜 못 찾았는지 경고!
                        alert("수정 대상을 찾지 못했습니다. (콘솔창을 확인하세요)");
                        console.error("productList 안에 '" + this.product + "'와 일치하는 이름이 없습니다.");
                        console.log("현재 목록들:", this.productList.map(p => p.name));
                    }
                },
                fnAdd() {
                    const newProduct = {
                        id: this.productList.length > 0 ?
                            Math.max(...this.productList.map(p => p.id)) + 1 : 1,
                        thumbnail: this.productForm.thumbnail || "images/default-thumbnail.png",
                        name: this.productForm.name,
                        content: this.productForm.content,
                        price: this.productForm.price,
                        category: [...this.selectedItems]
                    }

                    this.productList.push({ ...newProduct });  //{...newProduct} <- 이게 복사본이야? (+)

                    alert("등록되었습니다!");
                    this.resetForm();

                    this.productPage = "list";


                },
                goRegPage2() {
                    this.product1 = {
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: ''
                    }
                    this.productPage = 'reg';

                },
                resetForm() {
                    this.productForm = {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    }

                    this.selectedItems = [];

                },
                fnRemove(item) {
                    //fnRemove(프로덕트 리스트에 있는요소)

                    if (confirm("정말 삭제하시겠습니까?")) {

                        const removed = this.productList.find(p => p.id === item.id);
                        const index = this.productList.indexOf(removed);
                        //removed 객체의 인덱스를 구해라. 담아라.

                        if (index !== -1) {
                            this.productList.splice(index, 1);
                            //index 위치에서부터1개 데이터 삭제하고 인덱스들을 앞으로 당김.

                            this.reviews = this.reviews.filter(r => r.product !== item.name);
                            this.simpleReviews = this.simpleReviews.filter(r => r.product !== item.name);

                        }


                        alert("삭제되었습니다.");
                    } else {
                        alert("삭제가 취소되었습니다.");
                    }

                },
                fnThumbnail(inquiry) {    //fnThumbnail(개별문의)
                    return this.productList.find(p => p.name === inquiry.product).thumbnail;
                }
                ,
                handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
                    this.currentMenu = menuId;
                    this.productPage = 'list';
                    this.page = 1;
                    this.page1 = 'main';
                    this.reviewTab = 'detail';
                    this.currentPage = 1;

                    if (menuId === 'main') {
                        this.fnCom();
                    }
                    else if (menuId === 'product') {
                        this.fnProductList();
                    }
                },
                fnFileChange(event) {
                    // 1. 이벤트가 일어난 대상(input)에서 선택된 파일들 중 첫 번째[0]를 가져와요.
                    const file = event.target.files[0];

                    if (file) {
                        // 2. 진짜 파일 덩어리를 우리 변수에 쏙 넣어둡니다.
                        this.uploadFile = file;

                        // 3. 브라우저가 "이 파일 내가 잠깐 보여줄 수 있게 가짜 주소 만들어줄게!" 하는 기능이에요.
                        this.previewUrl = URL.createObjectURL(file);

                    }
                },
                fnUpdateProduct() {
                    // 1. 택배 박스(FormData)를 하나 만듭니다.
                    // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
                    let self = this;
                    let formData = new FormData();

                    // 1. 사진 파일 담기(선택했을 때만)
                    if (this.uploadFile) {
                        formData.append("file", this.uploadFile);
                    }

                    // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
                    formData.append("productNo", this.product1.productNo);
                    formData.append("productName", this.product1.productName);
                    formData.append("productDetails", this.product1.productDetails);
                    formData.append("originalPrice", this.product1.originalPrice);

                    formData.append("proType", JSON.stringify(this.product1.proType));

                    $.ajax({
                        url: "/upload.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                            // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)


                            if (res.result === "success") {
                                alert("상품 정보가 모두 수정되었습니다!");
                                window.location.href = "/company9.do";
                            } else {
                                alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                            }

                        }
                    })
                },
                fnInsertProduct() {
                    // 1. 택배 박스(FormData)를 하나 만듭니다.
                    // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
                    let self = this;
                    let formData = new FormData();

                    // 1. 사진 파일 담기(선택했을 때만)
                    if (this.uploadFile) {
                        formData.append("file", this.uploadFile);
                    }

                    // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
                    //formData.append("companyNo", this.product2.companyNo);
                    formData.append("productNo", this.product2.productNo);
                    formData.append("productName", this.product2.productName);
                    formData.append("productDetails", this.product2.productDetails);
                    formData.append("originalPrice", this.product2.originalPrice);


                    formData.append("proType", JSON.stringify(this.product2.proType));
                    formData.append("userId", 'sunsu09');

                    $.ajax({
                        url: "/upload2.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                            // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)


                            if (res.result === "success") {
                                alert("상품 정보가 모두 수정되었습니다!");
                                window.location.href = "/company9.do";
                            } else {
                                alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                            }

                        }
                    })
                },
                fnRemove2(item) {  //item in productList
                    if (confirm("정말 삭제하시겠습니까?")) {

                        let self = this;
                        let param = {
                            productNo: item.productNo
                        };
                        console.log(item);
                        $.ajax({
                            url: "/productRemove.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                                alert(data.message);
                                location.href = "/company9.do"
                            }
                        });



                    } else {
                        alert("삭제가 취소되었습니다.");
                    }
                },
                fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "http://localhost:8080/",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                        }
                    });
                },
                goDetailPage(item) {
                    this.productPage = 'detail';
                    // 선택한 상품 정보를 product1(상세보기 바구니)에 담기
                    this.product1 = { ...item };

                    window.scrollTo(0, 0); // 화면 상단으로 이동
                },

                // 예약하기 버튼 클릭
                fnReserve() {
                    // 실제로는 여기서 날짜 선택 여부를 체크하면 좋아요!
                    if (!this.selectedDate) {
                        alert("예약 날짜를 선택해주세요!");
                        return;
                    }
                    this.productPage = 'payment'; // 결제 화면으로 렌더링 상태 변경
                    window.scrollTo(0, 0);
                },
                fnFinalOrder(user) {  //user
                    alert("최종 예약 및 결제가 완료되었습니다!");

                    let maxId = this.userReservationList.length > 0
                        ? Math.max(...this.userReservationList.map(item => item.id)) : 1;

                    this.userReservationList.push(
                        { id: maxId + 1, productName: this.product1.name, resDate: this.selectedDate, resName: this.user.name, phoneNo: this.user.contact, deposit: 100000 }
                    )
                    this.productPage = 'list';   // 다시 목록으로 보내거나
                    console.log(this.userReservationList);

                    //this.currentMenu = 'reservation'; // 예약 내역 페이지로 보냅니다.
                },
                fnGetTagAndProductList() {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "/getTagAndProductList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            self.productTag = data.taglist;

                            //한번 해보는거
                            let productList1 = data.productListForTag.map(p => {
                                return {
                                    id: p.productNo,
                                    companyNo: p.companyNo,
                                    thumbnail: p.imgUrl,
                                    name: p.productName,
                                    company: p.comName,
                                    content: p.productDetails,
                                    price: Number(p.originalPrice).toLocaleString() + '원',
                                    category: JSON.parse(p.proType),
                                    tag: JSON.parse(p.tag),
                                    deposit: Number(p.deposit).toLocaleString() + '원'
                                }
                            });
                            console.log(productList1);
                            self.productList = productList1;
                        }
                    });
                },
                // 시간 버튼 클릭 시 호출
                fnSelectTime(time) {
                    this.selectedTime = time;
                },
                fnBack() {
                    this.productPage = 'list';
                    this.selectedDate = '';
                    this.selectedTime = '';
                } 

            }, // methods
            //productTag

            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                //self.fnCom();
                self.fnGetTagAndProductList();
            }


        });

        app.mount('#app');
    </script>