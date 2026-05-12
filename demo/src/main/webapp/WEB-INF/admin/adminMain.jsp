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
            .main {
                display: flex;
                flex-direction: column;
                gap: 20px;
                width: 100%;
            }

            .dashboard-grid,
            .content-grid {
                width: 80%;
                /* 부모 너비에 꽉 차도록 명시 */
            }

            /* 상단 카드 grid */
            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
            }

            /* 카드 */
            .summary-card {
                background: white;
                border-radius: 24px;
                padding: 24px;
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);
                transition: 0.2s;
            }

            .summary-card:hover {
                transform: translateY(-4px);
            }

            /* 상단 영역 */
            .summary-top {
                display: flex;
                align-items: center;
                gap: 18px;
            }

            /* 아이콘 */
            .summary-icon {
                width: 64px;
                height: 64px;
                border-radius: 18px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 26px;
                color: white;
            }

            /* 색상 */
            .summary-icon.users {
                background: #4c6ef5;
            }

            .summary-icon.review {
                background: #f59f00;
            }

            .summary-icon.partner {
                background: #12b886;
            }

            .summary-icon.sales {
                background: #fa5252;
            }

            /* 텍스트 */
            .summary-title {
                font-size: 14px;
                color: #868e96;
                margin-bottom: 6px;
            }

            .summary-value {
                font-size: 30px;
                font-weight: 700;
                color: #212529;
            }

            /* 하단 */
            .summary-bottom {
                margin-top: 20px;
                padding-top: 16px;
                border-top: 1px solid #f1f3f5;
                font-size: 13px;
                color: #868e96;
            }

            /* 운영 카드 grid */
            .content-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
                margin-top: 24px;
            }

            /* 카드 */
            .dashboard-card {
                background: white;
                border-radius: 24px;
                padding: 28px;
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);

                display: flex;
                flex-direction: column;
                transition: 0.2s ease;
                border: 1px solid #f1f3f5;

                overflow: hidden;
            }

            .dashboard-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 24px rgba(0, 0, 0, 0.1);
            }

            /* 헤더 */
            .card-header-box {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 18px;
            }

            .card-header-box h3 {
                font-size: 22px;
                font-weight: 700;
                color: #212529;
            }

            /* 전체보기 버튼 */
            .more-btn {
                border: none;
                background: #edf2ff;
                color: #4263eb;
                padding: 8px 14px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: 600;
                margin-bottom: 25px;
                cursor: pointer;
                transition: 0.2s;
            }

            .more-btn:hover {
                background: #4263eb;
                color: white;
            }

            /* 카운트 */
            .card-count {
                margin-bottom: 20px;
                font-size: 15px;
                color: #495057;
            }

            .card-count span {
                font-size: 26px;
                font-weight: 700;
                color: #fa5252;
                margin-left: 6px;
            }

            /* 테이블 */
            .dashboard-table {
                width: 100%;
                border-collapse: collapse;
            }

            .dashboard-table thead {
                background: #f8f9fa;
            }

            .dashboard-table th {
                padding: 14px 10px;
                font-size: 14px;
                color: #495057;
                font-weight: 700;
                border-bottom: 1px solid #e9ecef;
            }

            .dashboard-table td {
                padding: 14px 10px;
                font-size: 14px;
                color: #343a40;
                border-bottom: 1px solid #f1f3f5;
                text-align: center;
            }

            /* hover */
            .dashboard-table tbody tr {
                transition: 0.15s;
            }

            .dashboard-table tbody tr:hover {
                background: #f8f9ff;
            }

            /* 반응형 */
            @media (max-width: 1200px) {
                .dashboard-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .content-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 768px) {
                .dashboard-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <!-- 상단 통계 카드 -->
                    <div class="dashboard-grid">

                        <!-- 전체 회원 -->
                        <div class="summary-card">
                            <div class="summary-top">
                                <div class="summary-icon users">
                                    <i class="fas fa-users"></i>
                                </div>

                                <div class="summary-info">
                                    <div class="summary-title">전체 회원</div>
                                    <div class="summary-value">
                                        {{ allMember }}
                                    </div>
                                </div>
                            </div>

                            <div class="summary-bottom">
                                가입된 전체 회원 수
                            </div>
                        </div>

                        <!-- 전체 리뷰 -->
                        <div class="summary-card">
                            <div class="summary-top">
                                <div class="summary-icon review">
                                    <i class="fas fa-star"></i>
                                </div>

                                <div class="summary-info">
                                    <div class="summary-title">승인된 리뷰</div>
                                    <div class="summary-value">
                                        {{ ApprovedReviews }}
                                    </div>
                                </div>
                            </div>

                            <div class="summary-bottom">
                                승인 완료된 리뷰 수
                            </div>
                        </div>

                        <!-- 제휴 업체 -->
                        <div class="summary-card">
                            <div class="summary-top">
                                <div class="summary-icon partner">
                                    <i class="fas fa-store"></i>
                                </div>

                                <div class="summary-info">
                                    <div class="summary-title">제휴 업체</div>
                                    <div class="summary-value">
                                        {{ allPartners }}
                                    </div>
                                </div>
                            </div>

                            <div class="summary-bottom">
                                현재 등록된 업체 수
                            </div>
                        </div>

                        <!-- 이번달 매출 -->
                        <div class="summary-card">
                            <div class="summary-top">
                                <div class="summary-icon sales">
                                    <i class="fas fa-coins"></i>
                                </div>

                                <div class="summary-info">
                                    <div class="summary-title">이번달 매출</div>
                                    <div class="summary-value">
                                        ₩ {{ salesNow.toLocaleString() }}
                                    </div>
                                </div>
                            </div>

                            <div class="summary-bottom">
                                이번달 누적 결제 금액
                            </div>
                        </div>
                    </div>

                    <!-- 중단 -->
                    <!-- 운영 관리 카드 -->
                    <div class="content-grid">

                        <!-- 리뷰 승인 -->
                        <div class="dashboard-card">

                            <div class="card-header-box">
                                <h2>리뷰 승인</h2>

                                <button @click="fnPage('/adminReview.do')" class="more-btn">
                                    전체보기
                                </button>
                            </div>

                            <div class="card-count">
                                검토 대기 리뷰
                                <span>{{reviewWait}}</span>
                            </div>

                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in reviewList.slice(0,5)">
                                        <td>{{item.title}}</td></a>
                                        <td>{{item.userId}}</td>
                                        <td>{{item.postDay}}</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>

                        <!-- 신고 관리 -->
                        <div class="dashboard-card">

                            <div class="card-header-box">
                                <h2>신고 관리</h2>

                                <button @click="fnPage('/adminReport.do')" class="more-btn">
                                    전체보기
                                </button>
                            </div>

                            <div class="card-count">
                                미처리 신고
                                <span>{{reportWait}}</span>
                            </div>

                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>신고 제목</th>
                                        <th>신고자</th>
                                        <th>신고일</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in reportList.slice(0,5)">
                                        <td>{{item.reportTitle}}</td>
                                        <td>{{item.reporterId}}</td>
                                        <td>{{item.reportDay}}</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                        <!--  -->
                        <!-- 문의 관리 -->
                        <div class="dashboard-card">

                            <div class="card-header-box">
                                <h2>문의 관리</h2>

                                <button @click="fnPage('/adminInquiry.do')" class="more-btn">
                                    전체보기
                                </button>
                            </div>

                            <div class="card-count">
                                답변 대기 문의
                                <span>{{inquryCount}}</span>
                            </div>

                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>문의 제목</th>
                                        <th>작성자</th>
                                        <th>문의일</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in inquiryList.slice(0,5)">
                                        <td>{{item.title}}</td>
                                        <td>{{item.userId}}</td>
                                        <td>{{item.regDate}}</td>
                                    </tr>
                                </tbody>
                            </table>

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
                        memberNow: 1,
                        memberBefore: 1,
                        memberGrowthRate: 0,
                        allMember: 0,
                        ApprovedReviews: 0,
                        allPartners: 0,
                        inquiryList: [],
                        inquryCount: 0,
                        doneCount: 0,
                        newCommer: 0,
                        affRate: 0,
                        processStatus: "WAIT_ACTION",
                        pageSize: 15,
                        index: 1,
                        currentPage: 1,
                        reviewPageSize: 15,
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

                    fnGetApprovedReviewList: function () {
                        let self = this;
                        let param = {
                            approvalStatus: "APPROVED",
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
                                self.ApprovedReviews = data.totalCount;
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

                                if (role === "ALL") {
                                    self.memberNow = now;
                                    self.memberBefore = before;
                                    self.memberGrowthRate = growth;
                                }

                                self.fnAfterAllDone();
                            }
                        });
                    },

                    fnGetALLUsers: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/allClients.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                self.allMember = data.count;
                            }
                        });
                    },

                    fnGetAllPartners: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/allPartners.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                self.allPartners = data.count;
                            }
                        });
                    },

                    fnGetInquirys: function (role) {
                        let self = this;
                        let param = {
                            status: "WAIT",
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1)
                        };
                        $.ajax({
                            url: "http://localhost:8080/inquiry.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                self.inquiryList = data.list;
                                self.inquryCount = data.totalCount;
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
                    self.fnGetALLUsers();
                    self.fnGetApprovedReviewList();
                    self.fnGetAllPartners();
                    self.fnGetInquirys();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>