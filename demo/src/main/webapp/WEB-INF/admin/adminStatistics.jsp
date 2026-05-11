<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="../../js/page-change.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminNavi.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">
        <style>
            .chart-area {}

            .chart-area div {
                width: auto;
                height: auto;
            }
            
            .stats-summary-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin-top: 24px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                text-align: center;
                transition: all 0.3s ease;
            }

            .stats-mini-card {
                background: #fff0f3;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                border: none;
                transition: all 0.3s ease;
            }

            .stats-mini-card p {
                font-size: 14px;
                color: #868e96;
                margin-bottom: 10px;
            }

            .stats-mini-card h3 {
                font-size: 24px;
                font-weight: 700;
                color: #212529;
            }

            .stats-mini-card .up {
                color: #fa5252;
            }

            .stats-mini-card .down {
                color: #228be6;
            }

            .stats-mini-card:hover {
                background: #ffe3e8;
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            .up {
                color: #e74c3c;
            }

            .up::before {
                content: "▲ ";
            }

            .down {
                color: #3498db;
            }

            .down::before {
                content: "▼ ";
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="container">
                        <!-- 버튼 영역 -->
                        <div class="tab-menu">
                            <button :class="{active: activeTab == 'sales'}"
                                @click="activeTab = 'sales'; fnGetSales();">월별 매출 현황</button>
                            <button :class="{active: activeTab == 'users'}"
                                @click="activeTab = 'users'; fnGetUsers('USER');">일반 회원
                                등록수</button>
                            <button :class="{active: activeTab == 'nPartners'}"
                                @click="activeTab = 'nPartners'; fnGetUsers('NPARTNER');">일반 업체
                                등록수</button>
                            <button :class="{active: activeTab == 'partners'}"
                                @click="activeTab = 'partners'; fnGetUsers('PARTNER')">제휴업체
                                등록수</button>
                        </div>
                        <!-- 차트 영역 -->
                        <div class="chart-area">
                            <div v-if="activeTab == 'sales'">
                                <h2>월별 매출 현황</h2>
                                <div id="chart-sales"></div>
                            </div>
                            <div v-if="activeTab == 'users'">
                                <h2>일반 회원 등록수</h2>
                                <div id="chart-users"></div>
                            </div>
                            <div v-if="activeTab == 'nPartners'">
                                <h2>일반 업체 등록수</h2>
                                <div id="chart-nPartners"></div>
                            </div>
                            <div v-if="activeTab == 'partners'">
                                <h2>제휴 업체 등록수</h2>
                                <div id="chart-partners"></div>
                            </div>
                        </div>

                        <div v-if="activeTab == 'sales'" class="stats-summary-grid">

                            <div class="stats-mini-card">
                                <p>이번달 매출</p>
                                <h3>{{salesNow.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>저번달 매출</p>
                                <h3>{{salesBefore.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>증감률</p>
                                <h3 :class="salesGrowthRate == 0 ? 'same' : (salesGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(salesGrowthRate)}}%
                                </h3>
                            </div>

                        </div>

                        <div v-if="activeTab == 'users'" class="stats-summary-grid">

                            <div class="stats-mini-card">
                                <p>이번달 회원 수</p>
                                <h3>{{userNow.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>저번달 회원 수</p>
                                <h3>{{userBefore.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>증감률</p>
                                <h3 :class="userGrowthRate == 0 ? 'same' : (userGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(userGrowthRate)}}%
                                </h3>
                            </div>

                        </div>

                        <div v-if="activeTab == 'nPartners'" class="stats-summary-grid">

                            <div class="stats-mini-card">
                                <p>이번달 일반 업체 수</p>
                                <h3>{{nPartnerNow.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>저번달 일반 업체 수</p>
                                <h3>{{nPartnerBefore.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>증감률</p>
                                <h3
                                    :class="nPartnerGrowthRate == 0 ? 'same' : (nPartnerGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(nPartnerGrowthRate)}}%
                                </h3>
                            </div>

                        </div>

                        <div v-if="activeTab == 'partners'" class="stats-summary-grid">

                            <div class="stats-mini-card">
                                <p>이번달 일반 업체 수</p>
                                <h3>{{partnerNow.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>저번달 일반 업체 수</p>
                                <h3>{{partnerBefore.toLocaleString()}}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>증감률</p>
                                <h3 :class="partnerGrowthRate == 0 ? 'same' : (partnerGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(partnerGrowthRate)}}%
                                </h3>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        activeTab: "sales",
                        list: [],
                        salesNow: 1,
                        salesBefore: 1,
                        salesGrowthRate: 3,
                        priceList: [],
                        monthList: [],
                        clientList: [],
                        role: "",
                        activeMenu: "",
                        userNow: 1,
                        userBefore: 1,
                        userGrowthRate: 0,
                        nPartnerNow: 0,
                        nPartnerBefore: 0,
                        nPartnerGrowthRate: 0,
                        partnerNow: 1,
                        partnerBefore: 1,
                        partnerGrowthRate: 0,
                        newCommer: 0,
                        affRate: 0,
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    formatPercent(val) {
                        return Number(Math.abs(val || 0).toFixed(1)).toLocaleString();
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
                                type: 'area',
                                zoom: {
                                    enabled: false
                                },
                                toolbar: { show: false },
                                animations: { enabled: true }
                            },
                            colors: ['#FF4560'],
                            dataLabels: {
                                enabled: false
                            },
                            stroke: {
                                curve: 'smooth',
                                width: 3,
                                lineCap: 'round'
                            },

                            markers: {
                                size: 5,
                                colors: ['#FF4560'],
                                strokeColors: '#fff',
                                strokeWidth: 2,
                                hover: { size: 7 }
                            },

                            xaxis: {
                                categories: self.monthList
                            },

                        };
                        self.chart = new ApexCharts(document.querySelector("#chart-sales"), options);
                        self.chart.render();
                    },

                    fnDrawChart(id, name) {
                        let self = this;

                        if (self.chart) self.chart.destroy();

                        var options = {
                            series: [{
                                name: name,
                                data: self.clientList
                            }],
                            chart: {
                                height: 350,
                                type: 'area',
                                zoom: {
                                enabled: false
                            },
                            toolbar: { show: false },
                            animations: { enabled: true },
                            },
                            
                            xaxis: {
                                categories: self.monthList
                            },
                            colors: ['#FF4560'],
                            dataLabels: {
                                enabled: false
                            },
                            stroke: {
                                curve: 'smooth',
                                width: 3,
                                lineCap: 'round'
                            },

                            markers: {
                                size: 5,
                                colors: ['#FF4560'],
                                strokeColors: '#fff',
                                strokeWidth: 2,
                                hover: { size: 7 }
                            },
                        };

                        self.chart = new ApexCharts(document.querySelector(id), options);
                        self.chart.render();
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
                                self.salesNow = data.list.length > 0
                                    ? data.list[data.list.length - 1].totalRevenue
                                    : 0;

                                self.salesBefore = data.list.length > 1
                                    ? data.list[data.list.length - 2].totalRevenue
                                    : 0;

                                self.salesGrowthRate = self.salesBefore == 0
                                    ? 0
                                    : ((self.salesNow - self.salesBefore) / self.salesBefore) * 100;
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

                    fnGetUsers: function (role) {
                        let self = this;
                        self.role = role;
                        let param = {
                            role: role
                        };
                        $.ajax({
                            url: "http://localhost:8080/clients.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.clientList = [];
                                self.monthList = [];
                                for (let i = 0; i < data.list.length; i++) {
                                    self.clientList.push(data.list[i].userCount);
                                    self.monthList.push(data.list[i].userMonth);
                                }
                                if (self.role == "USER") {
                                    self.fnDrawChart("#chart-users", "일반 회원 수");
                                } else if (self.role == "NPARTNER") {
                                    self.fnDrawChart("#chart-nPartners", "일반 업체 수");
                                } else if (self.role == "PARTNER") {
                                    self.fnDrawChart("#chart-partners", "제휴 업체 수");
                                }

                                let len = data.list.length;

                                let now = len > 0 ? data.list[len - 1].userCount : 0;
                                let before = len > 1 ? data.list[len - 2].userCount : 0;

                                let growth = before == 0
                                    ? 0
                                    : ((now - before) / before) * 100;

                                if (role == "USER") {
                                    self.userNow = now;
                                    self.userBefore = before;
                                    self.userGrowthRate = growth;
                                }

                                if (role == "NPARTNER") {
                                    self.nPartnerNow = now;
                                    self.nPartnerBefore = before;
                                    self.nPartnerGrowthRate = growth;
                                }

                                if (role == "PARTNER") {
                                    self.partnerNow = now;
                                    self.partnerBefore = before;
                                    self.partnerGrowthRate = growth;
                                }
                                self.fnAfterAllDone();
                            }
                        });
                    },

                    fnAfterAllDone: function () {
                        let self = this;
                        self.newCommer = self.userNow + self.nPartnerNow + self.partnerNow;
                        let total = self.nPartnerNow + self.partnerNow;
                        self.affRate = total == 0 ? 0 : (self.partnerNow / total) * 100;
                    },


                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    const path = location.pathname;

                    this.activeMenu =
                        path.includes('adminMain') ? 'main' :
                            path.includes('adminUser') ? 'user' :
                                path.includes('adminCompany') ? 'company' :
                                    path.includes('adminBoard') ? 'board' :
                                        path.includes('adminReviewWait') ? 'reviewWait' :
                                            path.includes('adminPayment') ? 'payment' :
                                                path.includes('adminReport') ? 'report' :
                                                    path.includes('adminInquiry') ? 'inquiry' :
                                                        path.includes('adminStatistics') ? 'stats' :
                                                            '';

                    self.fnGetSales();
                }
            });
            app.mount('#app');
        </script>
    </body>

    </html>