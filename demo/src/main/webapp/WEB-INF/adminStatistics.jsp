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
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
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

            .tab-buttons {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .tab-buttons button {
                padding: 10px 15px;
                border: none;
                background: #eee;
                cursor: pointer;
                border-radius: 5px;
            }

            .tab-buttons button:hover {
                background: #ff6b6b;
                color: white;
            }

            .chart-area {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
            }

            .chart-area div {
                width: auto;
                height: auto;
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
                <button @click="fnGoMain();" type="button" class="nav-btn">관리자 메인
                    페이지</button>
                <button type="button" class="nav-btn">전체 회원 목록</button>
                <button type="button" class="nav-btn">전체 업체 목록</button>
                <button type="button" class="nav-btn">전체 게시판/리뷰 목록</button>
                <button type="button" class="nav-btn">결제 및 상품 관리</button>
                <button type="button" class="nav-btn">신고 제보 관리</button>
                <button type="button" class="nav-btn">통계</button>
            </div>
            <div class="main">
                <div class="dashboard-container">
                    <!-- 버튼 영역 -->
                    <div class="tab-buttons">
                        <button @click="selectedTab = 'sales'; fnGetSales();">매출현황</button>
                        <button @click="selectedTab = 'user'; fnGetUsers();">일반 회원 등록수</button>
                        <button @click="selectedTab = 'company'">일반 업체 등록수</button>
                        <button @click="selectedTab = 'partner'">제휴업체 등록수</button>
                    </div>
                    <!-- 차트 영역 -->
                    <div class="chart-area">
                        <div v-if="selectedTab === 'sales'">
                            <h3>월별 매출 현황</h3>
                            <div id="chart-sales"></div>
                        </div>
                        <div v-if="selectedTab === 'user'">
                            <h3>일반 회원 등록수</h3>
                            <div id="chart-user"></div>
                        </div>
                        <div v-if="selectedTab === 'company'">
                            <h3>일반 업체 등록수</h3>
                            <div id="chart-company"></div>
                        </div>
                        <div v-if="selectedTab === 'partner'">
                            <h3>제휴 업체 등록수</h3>
                            <div id="chart-partner"></div>
                        </div>
                    </div>
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
                        selectedTab: "sales",
                        list: [],
                        priceList: [],
                        monthList: [],
            
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnGoMain() {
                        location.href = 'http://localhost:8080/adminMain.do';
                    },
                    fnSalesChart: function () {
                        let self = this;
                        if (self.chart) {
                            self.chart.destroy(); // 기존 차트 제거
                        }
                        var options = {
                            series: [{
                                name: "매출액",
                                data: self.priceList
                            }],
                            chart: {
                                height: 350,
                                type: 'line',
                                zoom: {
                                    enabled: false
                                }
                            },
                            dataLabels: {
                                enabled: false
                            },
                            stroke: {
                                curve: 'straight'
                            },
                            // title: {
                            //     text: 'Product Trends by Month',
                            //     align: 'left'
                            // },
                            grid: {
                                row: {
                                    colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
                                    opacity: 0.5
                                },
                            },
                            xaxis: {
                                categories: self.monthList
                            },
                        };
                        if(self.selectedTab == "sales"){
                        self.chart = new ApexCharts(document.querySelector("#chart-sales"), options);
                        self.chart.render();
                        }
                        // if(self.selectedTab == "user"){
                        // self.chart = new ApexCharts(document.querySelector("#chart-user"), options);
                        // self.chart.render();
                        // }
                    },
                    fnGetSales: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/sales.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.priceList = [];
                                self.monthList = [];
                                for (let i = 0; i < data.list.length; i++) {
                                    self.priceList.push(data.list[i].totalRevenue);
                                    self.monthList.push(data.list[i].saleMonth);
                                }
                                self.fnSalesChart();
                            }
                        });
                    },

                    fnGetUsers: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/clients.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.priceList = [];
                                self.monthList = [];
                                for (let i = 0; i < data.list.length; i++) {
                                    self.priceList.push(data.list[i].totalRevenue);
                                    self.monthList.push(data.list[i].saleMonth);
                                }
                                self.fnSalesChart();
                            }
                        });
                    },

                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    self.fnGetSales();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>