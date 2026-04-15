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
            /* 기본 초기화 */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Malgun Gothic", sans-serif;
            }

            body {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                background-color: #f0f0f0;
            }

            /* 전체 컨테이너 (분홍색 배경) */
            .dashboard-container {
                width: 400px;
                background-color: #f9c7c7;
                /* 이미지와 유사한 분홍색 */
                padding: 20px;
                border: 1px solid #d1a7a7;
                border-radius: 4px;
            }

            .section-box {
                margin-bottom: 20px;
            }

            /* 제목 스타일 */
            .title {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
            }

            /* 그래프 영역 (회색 박스) */
            .graph-placeholder {
                width: 100%;
                height: 150px;
                background-color: #777;
                /* 진회색 배경 */
                color: white;
                display: flex;
                justify-content: center;
                align-items: center;
                text-align: center;
                font-size: 14px;
                padding: 20px;
                border: 1px solid #555;
            }

            /* 통계 리스트 스타일 (흰색 배경) */
            .stats-list {
                list-style: none;
                background-color: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 4px;
            }

            .stats-list li {
                padding: 12px 15px;
                font-size: 14px;
                border-bottom: 1px solid #eee;
                color: #444;
            }

            /* 마지막 리스트 아이템은 하단 선 제거 */
            .stats-list li:last-child {
                border-bottom: none;
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
                <div class="dashboard-container">
                    <!-- 그래프 섹션 -->
                    <section class="section-box">
                        <h2 class="title">그래프</h2>
                        <div class="graph-placeholder">
                            그래프 쓰인 그 사이트에서 퍼오기
                        </div>
                    </section>

                    <!-- 통계 수 위젯 섹션 -->
                    <section class="section-box">
                        <h2 class="title">통계 수 위젯</h2>
                        <ul class="stats-list">
                            <li>매출현황</li>
                            <li>일반 사용자 등록수</li>
                            <li>일반 업체 등록수</li>
                            <li>제휴업체 등록수</li>
                        </ul>
                    </section>
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
                        message: "연결됨",
                        list: ["데이터 1", "데이터 2", "데이터 3"]
                    };
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>