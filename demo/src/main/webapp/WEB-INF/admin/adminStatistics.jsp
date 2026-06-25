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
            .chart-area {
                padding: 24px;
                background: #f8f9fc;
                border: 1px solid #dfe4ee;
                border-radius: 16px;
                box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
            }

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
                background: #f1f5f9;
                border: 1px solid #d8e0eb;
                border-top: 4px solid #64748b;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);

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
                background: #e5e8f1;
                border-color: #cbd5e1;
                border-top-color: #334155;
                transform: translateY(-5px);
                box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
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
                            <button :class="{active: activeTab == 'passes'}"
                                @click="activeTab = 'passes'; fnGetPassSales();">
                                패스 판매
                            </button>
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
                            <div v-if="activeTab == 'passes'">
                                <h2>패스별 판매 현황</h2>
                                <div id="chart-passes"></div>
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

                        <div v-if="activeTab == 'passes'" class="stats-summary-grid">

                            <div class="stats-mini-card">
                                <p>전체 패스 판매</p>
                                <h3>{{ passTotalSold.toLocaleString() }}건</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>가장 많이 팔린 패스</p>
                                <h3>{{ bestPassName || '-' }}</h3>
                            </div>

                            <div class="stats-mini-card">
                                <p>BEST 패스 판매량</p>
                                <h3>{{ bestPassSold.toLocaleString() }}건</h3>
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
                        passNameList: [],
                        passSoldList: [],
                        passTotalSold: 0,
                        bestPassName: "",
                        bestPassSold: 0,
                        chart: null,
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
                            colors: ['#475569'],
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
                                colors: ['#475569'],
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

                    fnPassSalesChart: function () {
                        let self = this;

                        if (self.chart) {
                            self.chart.destroy();
                        }

                        const options = {
                            // 패스별 판매 건수
                            series: self.passSoldList,

                            // 패스 이름
                            labels: self.passNameList,

                            chart: {
                                height: 380,
                                type: "donut",
                                toolbar: {
                                    show: false
                                },
                                dropShadow: {
                                    enabled: true,
                                    top: 6,
                                    left: 2,
                                    blur: 8,
                                    opacity: 0.18
                                }
                            },

                            colors: [
                                "#e88aa2",
                                "#7c8db5",
                                "#f3b562",
                                "#76b7b2"
                            ],

                            stroke: {
                                width: 4,
                                colors: ["#ffffff"]
                            },

                            plotOptions: {
                                pie: {
                                    expandOnClick: true,

                                    donut: {
                                        size: "62%",

                                        labels: {
                                            show: true,

                                            name: {
                                                show: true,
                                                fontSize: "15px",
                                                color: "#64748b"
                                            },

                                            value: {
                                                show: true,
                                                fontSize: "25px",
                                                fontWeight: 700,
                                                formatter: function (value) {
                                                    return Number(value).toLocaleString() + "건";
                                                }
                                            },

                                            total: {
                                                show: true,
                                                label: "전체 판매",
                                                fontSize: "14px",
                                                color: "#64748b",

                                                formatter: function () {
                                                    return self.passTotalSold.toLocaleString() + "건";
                                                }
                                            }
                                        }
                                    }
                                }
                            },

                            dataLabels: {
                                enabled: true,

                                formatter: function (percent) {
                                    return percent.toFixed(1) + "%";
                                }
                            },

                            legend: {
                                position: "bottom",
                                fontSize: "14px",

                                formatter: function (name, options) {
                                    const soldCount =
                                        options.w.globals.series[options.seriesIndex];

                                    return name + " · " +
                                        Number(soldCount).toLocaleString() + "건";
                                }
                            },

                            tooltip: {
                                y: {
                                    formatter: function (value) {
                                        return Number(value).toLocaleString() + "건 판매";
                                    }
                                }
                            },

                            noData: {
                                text: "패스 판매 데이터가 없습니다."
                            },

                            responsive: [{
                                breakpoint: 768,
                                options: {
                                    chart: {
                                        height: 330
                                    },

                                    legend: {
                                        position: "bottom"
                                    }
                                }
                            }]
                        };

                        self.chart = new ApexCharts(
                            document.querySelector("#chart-passes"),
                            options
                        );

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
                            colors: ['#475569'],
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
                                colors: ['#475569'],
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

                    fnGetPassSales: function () {
                        let self = this;

                        $.ajax({
                            url: "/pass.dox",
                            dataType: "json",
                            type: "POST",
                            data: {},

                            success: function (data) {
                                const list = data.list || [];

                                self.passNameList = [];
                                self.passSoldList = [];
                                self.passTotalSold = 0;
                                self.bestPassName = "";
                                self.bestPassSold = 0;

                                list.forEach(function (pass) {
                                    const soldCount = Number(pass.soldCount || 0);

                                    self.passNameList.push(pass.passName);
                                    self.passSoldList.push(soldCount);
                                    self.passTotalSold += soldCount;

                                    // 체험용 패스는 BEST 선정에서 제외
                                    if (Number(pass.passNo) !== 1 &&
                                        soldCount > self.bestPassSold) {

                                        self.bestPassName = pass.passName;
                                        self.bestPassSold = soldCount;
                                    }
                                });

                                self.$nextTick(function () {
                                    self.fnPassSalesChart();
                                });
                            },

                            error: function () {
                                alert("패스 판매 통계를 불러오지 못했습니다.");
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