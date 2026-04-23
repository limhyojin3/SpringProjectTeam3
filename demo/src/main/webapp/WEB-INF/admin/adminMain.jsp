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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminNavi.css">
        <style>
            .middle {
                width: 100%;
                /* 화면 전체 높이를 사용하되, 헤더/푸터 제외한 나머지는 유연하게(1fr) */
                display: grid;
                grid-template-areas:
                    "nav main";
                grid-template-columns: 300px 1fr;
                /* 너비 고정 */
            }

            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
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
                flex-direction: column;
                align-items: center;
                justify-content: space-around;
                color: #888;
            }

            .reviewTable table {
                table-layout: fixed;
                width: 100%;
            }

            .reviewTable table th:nth-child(2),
            .reviewTable table th:nth-child(3),
            .reviewTable table td:nth-child(2),
            .reviewTable table td:nth-child(3) {
                max-width: 150px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .reportTable table {
                table-layout: fixed;
                width: 100%;
            }

            .reportTable table th:nth-child(2),
            .reportTable table th:nth-child(3),
            .reportTable table td:nth-child(2),
            .reportTable table td:nth-child(3) {
                max-width: 150px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
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
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <!-- 리뷰승인 카드 -->
                    <div class="dashboard-card">
                        <h4>리뷰승인</h4>
                        <div class="data-box">
                            <div class="reviewTable">
                                <h3>아직 승인되지 않은 리뷰 : {{reviewWait}}</h3>
                                <table>
                                    <tr>
                                        <th>번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>대기</th>
                                        <th>작성일</th>
                                    </tr>
                                    <tr v-for="item in reviewList">
                                        <td>{{item.reviewNo}}</td>
                                        <td>{{item.title}}</td></a>
                                        <td>{{item.userId}}</td>
                                        <td>{{item.approvalStatus}}</td>
                                        <td>{{item.postDay}}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <button @click="fnReview" type="button" class="detail-btn">상세보기</button>
                    </div>

                    <!-- 신고제보 카드 -->
                    <div class="dashboard-card">
                        <h4>신고제보</h4>
                        <div class="data-box">
                            <div class="reportTable">
                                <h3>아직 처리되지 않은 신고 : {{reportWait}}</h3>
                                <table>
                                    <tr>
                                        <th>번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>신고일</th>
                                    </tr>
                                    <tr v-for="item in reportList">
                                        <td>{{item.reportNo}}</td>
                                        <td>{{item.reportTitle}}</td>
                                        <td>{{item.reporterId}}</td>
                                        <td>{{item.reportDay}}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <button @click="fnPage('/adminReport.do')" type="button" class="detail-btn">상세보기</button>
                    </div>

                    <!-- 통계 카드 -->
                    <div class="dashboard-card">
                        <h4>통계</h4>
                        <div class="data-box">
                            <div>
                                매출 현황<br>{{salesNow.toLocaleString()}} 원<br>
                                전월대비
                                <span :class="salesGrowthRate === 0 ? 'same' : (salesGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(salesGrowthRate)}}%
                                </span>
                            </div>
                            <div>일반 회원 등록수<br>{{userNow}} 명<br>
                                전월대비
                                <span :class="userGrowthRate === 0 ? 'same' : (userGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(userGrowthRate)}}%
                                </span>
                            </div>
                            <div>일반 업체 등록수<br>{{nPartnerNow}} 곳<br>
                                전월대비
                                <span
                                    :class="nPartnerGrowthRate === 0 ? 'same' : (nPartnerGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(nPartnerGrowthRate)}}%
                                </span>
                            </div>
                            <div>제휴업체 등록수<br>{{partnerNow}} 곳<br>
                                전월대비
                                <span
                                    :class="partnerGrowthRate === 0 ? 'same' : (partnerGrowthRate < 0 ? 'down' : 'up')">
                                    {{formatPercent(partnerGrowthRate)}}%
                                </span>
                            </div>
                            <div>
                                전체 신규 등록 수 : {{newCommer}}
                                <br>
                                업체 제휴율 : {{affRate}}%
                            </div>
                        </div>
                        <button @click="fnPage('/adminStatistics.do')" type="button" class="detail-btn">상세보기</button>
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
                        activeMenu: "",
                        currentMenu: "",
                        list: [],
                        reviewList: [],
                        reviewWait: 0,
                        reviewNo: 0,
                        userId: "",
                        approvalStatus: "",
                        title: "",
                        postDay: "",
                        reportWait: 0,
                        reportList: [],
                        reportNo: 0,
                        reporterId: "",
                        reportTitle: "",
                        reportContent: "",
                        reportDay: "",
                        salesNow: 1,
                        salesBefore: 1,
                        salesGrowthRate: 3,
                        userNow: 1,
                        userBefore: 1,
                        userGrowthRate: 0,
                        nPartnerNow: 0,
                        nPartnerBefore: 0,
                        nPartnerGrowthRate: 0,
                        partnerNow: 1,
                        partnerBefore: 1,
                        partnerGrowthRate: 0,
                        doneCount: 0,
                        newCommer: 0,
                        affRate: 0,
                        processStatus: "WAIT_ACTION"
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnGetReviewList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/viewReview.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data)
                                self.reviewList = data.list;
                                self.reviewWait = self.reviewList.length > 0 ? self.reviewList[0].reviewWait : 0;
                            }
                        });
                    },

                    fnGetReportList: function () {
                        let self = this;
                        let param = {
                            processStatus: self.processStatus
                        };
                        $.ajax({
                            url: "http://localhost:8080/viewReport.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data)
                                self.reportList = data.list;
                                self.reportWait = self.reportList.length > 0 ? self.reportList[0].reportWait : 0;
                            }
                        });
                    },

                    fnAfterAllDone: function () {
                        let self = this;
                        self.newCommer = self.userNow + self.nPartnerNow + self.partnerNow;
                        let total = self.nPartnerNow + self.partnerNow;
                        self.affRate = total === 0 ? 0 : (self.partnerNow / total) * 100;
                    },

                    formatPercent(val) {
                        return Number(Math.abs(val || 0).toFixed(1)).toLocaleString();
                    },

                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnGetSales: function () {
                        let self = this;
                        let param = {
                            salesFlg: "salesNow"
                        };
                        $.ajax({
                            url: "http://localhost:8080/sales.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.list = data.list;
                                self.salesNow = data.list[data.list.length - 1].totalRevenue;
                                self.salesBefore = data.list[data.list.length - 2].totalRevenue;
                                self.salesGrowthRate = self.salesBefore === 0
                                    ? 0
                                    : ((self.salesNow - self.salesBefore) / self.salesBefore) * 100;
                            }
                        });
                    },

                    fnGetUsers: function (role) {
                        let self = this;
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
                                if (role === "USER") {
                                    self.userNow = data.list[data.list.length - 1].userCount;
                                    self.userBefore = data.list[data.list.length - 2].userCount;
                                    self.userGrowthRate = self.userBefore === 0
                                        ? 0
                                        : ((self.userNow - self.userBefore) / self.user.Before) * 100;
                                }
                                if (role === "NPARTNER") {
                                    self.nPartnerNow = data.list[data.list.length - 1].userCount;
                                    self.nPartnerBefore = data.list[data.list.length - 2].userCount;
                                    self.nPartnerGrowthRate = self.nPartnerBefore === 0
                                        ? 0
                                        : ((self.nPartnerNow - self.nPartnerBefore) / self.nPartnerBefore) * 100;
                                }
                                if (role === "PARTNER") {
                                    self.partnerNow = data.list[data.list.length - 1].userCount;
                                    self.partnerBefore = data.list[data.list.length - 2].userCount;
                                    self.partnerGrowthRate = self.partnerBefore === 0
                                        ? 0
                                        : ((self.partnerNow - self.partnerBefore) / self.partnerBefore) * 100;
                                }
                                self.fnAfterAllDone();
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

                    self.fnGetReviewList();
                    self.fnGetReportList();
                    self.fnGetSales();
                    self.fnGetUsers("USER");
                    self.fnGetUsers("NPARTNER");
                    self.fnGetUsers("PARTNER");
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>