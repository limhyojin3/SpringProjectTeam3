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
            .dashboard-container{
                width: 1200px;
                background: #fff;
                padding: 20px;
                border-radius: 10px;
            }
            .chart-area {
                
            }

            .chart-area div {
                width: auto;
                height: auto;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="dashboard-container">
                        <!-- 버튼 영역 -->
                        <div class="tab-menu">
                            <button :class="{active: activeTab === 'sales'}"@click="activeTab = 'sales'; fnGetSales();">월별 매출 현황</button>
                            <button :class="{active: activeTab === 'users'}"@click="activeTab = 'users'; fnGetUsers('USER');">일반 회원 등록수</button>
                            <button :class="{active: activeTab === 'companys'}"@click="activeTab = 'companys'; fnGetUsers('NPARTNER');">일반 업체 등록수</button>
                            <button :class="{active: activeTab === 'partners'}"@click="activeTab = 'partners'; fnGetUsers('PARTNER')">제휴업체 등록수</button>
                        </div>
                        <!-- 차트 영역 -->
                        <div class="chart-area">
                            <div v-if="activeTab === 'sales'">
                                <h3>월별 매출 현황</h3>
                                <div id="chart-sales"></div>
                            </div>
                            <div v-if="activeTab === 'users'">
                                <h3>일반 회원 등록수</h3>
                                <div id="chart-users"></div>
                            </div>
                            <div v-if="activeTab === 'companys'">
                                <h3>일반 업체 등록수</h3>
                                <div id="chart-companys"></div>
                            </div>
                            <div v-if="activeTab === 'partners'">
                                <h3>제휴 업체 등록수</h3>
                                <div id="chart-partners"></div>
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
                        priceList: [],
                        monthList: [],
                        clientList: [],
                        role: "",
                        activeMenu: "",

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
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
                                type: 'line'
                            },
                            xaxis: {
                                categories: self.monthList
                            }
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
                                    self.fnDrawChart("#chart-companys", "일반 업체 수");
                                } else if (self.role == "PARTNER") {
                                    self.fnDrawChart("#chart-partners", "제휴 업체 수");
                                }
                            }
                        });
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