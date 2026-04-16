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
            /* 1. 컨테이너: 높이를 명확히 주고 쉼표를 없앰 */
            .container {
                width: 100%;
                /* 화면 전체 높이를 사용하되, 헤더/푸터 제외한 나머지는 유연하게(1fr) */
                display: grid;
                grid-template-areas:
                    "header header"
                    "nav main"
                    "footer footer";
                grid-template-rows: 80px auto minmax(80px, auto);
                /* 높이 고정 (쉼표 없음) */
                grid-template-columns: 220px 1fr;
                /* 너비 고정 */
                gap: 5px;
            }

            /* 2. 각 영역별 테두리 및 색상 */
            .header {
                grid-area: header;
                border: 2px solid red;
                display: flex;
                /* 가로 정렬 */
                align-items: center;
                /* 세로 중앙 정렬 */
                justify-content: space-between;
                /* 양 끝과 사이에 공간 배치 */
                padding: 0 20px;
            }

            .logo {
                width: 100px;
                height: 60px;
                background-color: pink;
                color: white;
                text-align: center;
            }

            .menu-group {
                display: flex;
                gap: 15px;
            }

            .menu-group button {
                padding: 10px 18px;
                font-weight: bold;
                cursor: pointer;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: white;
                transition: 0.2s;
            }

            .menu-group button:hover {
                background-color: #f8f9fa;
                border-color: red;
                /* 강조색 */
                color: red;
            }

            .loginbtn {
                display: flex;
                flex-direction: row;
                border: 2px solid gray
            }

            .serviceBox {
                width: 50px;
                height: 50px;
            }

            .serviceBox img {
                max-width: 100%;
                height: auto;
                display: block;
            }

            .nav {
                grid-area: nav;
                border: 1px solid blue;
                padding: 20px 10px;
                display: flex;
                flex-direction: column;
                gap: 8px;
                background-color: #ffc7c2;
            }

            .nav-btn {
                width: 100%;
                padding: 12px 10px;
                text-align: left;
                background-color: white;
                border: 1px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
            }

            .nav-btn:hover {
                background-color: #e3f2fd;
                border-color: #2196f3;
                color: #1976d2;
            }

            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
                background-color: #ffc7c2;
                padding: 20px;
                display: flex;
                gap: 20px;
                /* 카드 사이 간격 */
                align-items: flex-start;
                /* 카드들이 위쪽에 고정되도록 */
            }

            /* 대시보드 카드 개별 박스 */
            .dashboard-card {
                flex: 1;
                /* 가로 크기 균등 분할 */
                max-width: 300px;
                /* 너무 넓어지지 않게 제한 */
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 15px;
                background-color: #fff;
                text-align: center;
                box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.05);
            }

            .dashboard-card h4 {
                margin-top: 0;
                margin-bottom: 15px;
            }

            /* 세로가 가로보다 2배 긴 박스 */
            .data-box {
                width: 100%;
                aspect-ratio: 1 / 2;
                /* 가로 1 : 세로 2 비율 유지 */
                background-color: #f1f1f1;
                border: 1px dashed #bbb;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #888;
            }

            /* 상세보기 버튼 (적당히 작은 크기) */
            .detail-btn {
                padding: 6px 12px;
                font-size: 12px;
                background-color: #555;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .detail-btn:hover {
                background-color: #333;
            }

            .footer {
                grid-area: footer;
                border: 2px solid gray;
                background-color: #f9f9f9;
                padding: 20px;
                font-size: 13px;
                color: #666;
                display: flex;
                flex-direction: column;
                /* 위아래 섹션 구분 */
                gap: 10px;
            }

            .footer-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #ddd;
                padding-bottom: 10px;
            }

            .footer-bottom {
                display: flex;
                flex-wrap: wrap;
                /* 가로로 쭉 나열되다가 모자라면 다음줄로 */
                gap: 5px 20px;
                color: #888;
            }

            .footer-bottom span::after {
                content: "|";
                margin-left: 20px;
                color: #ccc;
            }

            .footer-bottom span:last-child::after {
                content: "";
                /* 마지막 항목은 선 제거 */
            }

            .footer-links a {
                text-decoration: none;
                color: #666;
                margin-right: 15px;
            }

            .footer-links .bold-link {
                font-weight: bold;
                color: #333;
            }
        </style>
    </head>

    <body>
        <div id="app" class="container">
            <div class="header">
                <div class="logo">메리뷰
                </div>
                <div class="menu-group">
                    <button type="button">회사소개</button>
                    <button type="button">제휴업체</button>
                    <button type="button">커뮤니티</button>
                    <button type="button">패스구매</button>
                    <button type="button">리뷰조회</button>
                </div>
                <div class="loginbtn">
                    <div class="serviceBox">
                        <img src="../img/logoServiceJPG.JPG" alt="">
                    </div>
                    <button type="button">관리자</button>
                </div>
            </div>
            <div class="nav">
                <button type="button" class="nav-btn">관리자 메인 페이지</button>
                <button type="button" class="nav-btn">전체 회원 목록</button>
                <button type="button" class="nav-btn">전체 업체 목록</button>
                <button type="button" class="nav-btn">전체 게시판/리뷰 목록</button>
                <button type="button" class="nav-btn">결제 및 상품 관리</button>
                <button type="button" class="nav-btn">신고 제보 관리</button>
                <button type="button" class="nav-btn">통계</button>
            </div>
            <div class="main">
                <!-- 리뷰승인 카드 -->
                <div class="dashboard-card">
                    <h4>리뷰승인</h4>
                    <div class="data-box">내용 영역</div>
                    <button type="button" class="detail-btn">상세보기</button>
                </div>

                <!-- 신고제보 카드 -->
                <div class="dashboard-card">
                    <h4>신고제보</h4>
                    <div class="data-box">내용 영역</div>
                    <button type="button" class="detail-btn">상세보기</button>
                </div>

                <!-- 통계 카드 -->
                <div class="dashboard-card">
                    <h4>통계</h4>
                    <div class="data-box">내용 영역</div>
                    <button @click="fnStatistics" type="button" class="detail-btn">상세보기</button>
                </div>
            </div>
            <div class="footer">
                <!-- 상단: 로고, 링크, 고객센터 -->
                <div class="footer-top">
                    <div style="font-weight: bold; font-size: 16px; color: #333;">MERRYVIEW</div>
                    <div class="footer-links">
                        <a href="#">회사소개</a>
                        <a href="#" class="bold-link">개인정보처리방침</a>
                        <a href="#">이용약관</a>
                        <a href="#">파트너 입점문의</a>
                    </div>
                    <div>고객센터 <span style="font-weight: bold; color: #ff6b6b;">1588-0000</span> (평일 10:00~18:00)</div>
                </div>

                <!-- 하단: 업체 정보 가로 나열 -->
                <div class="footer-bottom">
                    <span>(주)메리뷰</span>
                    <span>대표: 김메리</span>
                    <span>사업자등록번호: 123-45-67890</span>
                    <span>통신판매업신고: 제 2026-서울강남-01234호</span>
                    <span>주소: 서울특별시 강남구 테헤란로 77길 11, 메리타워 15층</span>
                    <span>이메일: help@merryview.com</span>
                </div>

                <div style="font-size: 11px; color: #bbb; margin-top: 5px;">
                    © 2026 MerryView Inc. All Rights Reserved.
                </div>
            </div>
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnStatistics:function () {
                        location.href="adminStatistics.do"
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
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>