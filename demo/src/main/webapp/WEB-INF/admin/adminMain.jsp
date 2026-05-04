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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">
        <style>
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

            button {
                border: none;
                background: #eef1f6;
                padding: 8px 14px;
                border-radius: 10px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: .2s;
            }

        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">

            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <!-- 리뷰승인 카드 -->
                    <div class="dashboard-card">
                        <h4>리뷰승인</h4>
                        <div class="data-box">
                            <div class="reviewTable">
                                <h3>아직 검토되지 않은 리뷰 : {{reviewWait}}</h3>
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
                                <div class="page-box">
                                    <button @click="fnReviewPageMove(reviewCurrentPage-1)"
                                        :disabled="reviewCurrentPage===1">‹</button>

                                    <button v-for="r in reviewIndex" :key="r" @click="fnReviewPageMove(r)"
                                        :class="{active: reviewCurrentPage === r}">
                                        {{ r }}
                                    </button>

                                    <button @click="fnReviewPageMove(reviewCurrentPage+1)"
                                        :disabled="reviewCurrentPage===reviewIndex">›</button>
                                </div>
                            </div>
                        </div>
                        <button @click="fnPage('/adminReview.do')" type="button" class="detail-btn">상세보기</button>
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
                            <div class="page-box">
                                <button @click="fnPageMove(currentPage-1)" :disabled="currentPage===1">‹</button>

                                <button v-for="p in index" :key="p" @click="fnPageMove(p)"
                                    :class="{active: currentPage === p}">
                                    {{ p }}
                                </button>

                                <button @click="fnPageMove(currentPage+1)" :disabled="currentPage===index">›</button>
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
                            <div>
                                <div>일반업체 등록수<br>{{nPartnerNow}} 곳<br>
                                    전월대비
                                    <span
                                        :class="nPartnerGrowthRate === 0 ? 'same' : (nPartnerGrowthRate < 0 ? 'down' : 'up')">
                                        {{formatPercent(nPartnerGrowthRate)}}%
                                    </span>
                                </div>
                                <br>
                                <div>제휴업체 등록수<br>{{partnerNow}} 곳<br>
                                    전월대비
                                    <span
                                        :class="partnerGrowthRate === 0 ? 'same' : (partnerGrowthRate < 0 ? 'down' : 'up')">
                                        {{formatPercent(partnerGrowthRate)}}%
                                    </span>
                                    <br>
                                    <br>
                                    업체 제휴율 : {{formatPercent(affRate)}}%
                                </div>
                            </div>
                            <div>
                                전체 신규 등록 수 : {{newCommer}}
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
                        processStatus: "WAIT_ACTION",
                        pageSize: 6,
                        index: 1,
                        currentPage: 1,
                        reviewPageSize: 6,
                        reviewIndex: 1,
                        reviewCurrentPage: 1,
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnGetReviewList: function () {
                        let self = this;
                        let param = {
                            approvalStatus: "WAIT",
                            pageSize: self.reviewPageSize,
                            offSet: self.reviewPageSize * (self.reviewCurrentPage - 1)
                        };
                        $.ajax({
                            url: "http://localhost:8080/viewReview.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data)
                                self.reviewList = data.list;
                                self.reviewWait = self.reviewList.length > 0 ? self.reviewList[0].reviewWait : 0;
                                self.reviewIndex = Math.ceil(data.totalCount / self.reviewPageSize);
                            }
                        });
                    },

                    fnGetReportList: function () {
                        let self = this;
                        let param = {
                            processStatus: self.processStatus,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1)
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
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                            }
                        });
                    },

                    fnPageMove(p) {
                        if (p < 1 || p > this.index) return;
                        this.currentPage = p;
                        this.fnGetReportList();
                    },
                    fnReviewPageMove(p) {
                        if (p < 1 || p > this.reviewIndex) return;
                        this.reviewCurrentPage = p;
                        this.fnGetReviewList();
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
                                self.salesNow = data.list.length > 0
                                    ? data.list[data.list.length - 1].totalRevenue
                                    : 0;

                                self.salesBefore = data.list.length > 1
                                    ? data.list[data.list.length - 2].totalRevenue
                                    : 0;

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
                                let len = data.list.length;

                                let now = len > 0 ? data.list[len - 1].userCount : 0;
                                let before = len > 1 ? data.list[len - 2].userCount : 0;

                                let growth = before === 0
                                    ? 0
                                    : ((now - before) / before) * 100;

                                if (role === "USER") {
                                    self.userNow = now;
                                    self.userBefore = before;
                                    self.userGrowthRate = growth;
                                }

                                if (role === "NPARTNER") {
                                    self.nPartnerNow = now;
                                    self.nPartnerBefore = before;
                                    self.nPartnerGrowthRate = growth;
                                }

                                if (role === "PARTNER") {
                                    self.partnerNow = now;
                                    self.partnerBefore = before;
                                    self.partnerGrowthRate = growth;
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
                                        path.includes('adminReview') ? 'review' :
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