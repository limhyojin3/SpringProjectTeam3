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
            body {
                background: #f8f9fc;
                font-size: 14px;
                color: #333;
            }

            .middle {
                width: 100%;
                display: grid;
                grid-template-areas: "nav main";
                grid-template-columns: 300px 1fr;
                min-height: calc(100vh - 160px);
            }

            .main {
                grid-area: main;
                padding: 35px;
            }

            /* 메인 카드 */
            .content-box {
                width: 100%;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
                padding: 30px;
            }

            /* 제목 */
            .page-title {
                font-size: 26px;
                font-weight: 700;
                color: #222;
                margin-bottom: 25px;
            }

            /* 탭 */
            .tab-menu {
                display: flex;
                gap: 12px;
                margin-bottom: 25px;
                flex-wrap: wrap;
            }

            .tab-menu button {
                border: none;
                background: #eef1f6;
                color: #555;
                padding: 12px 24px;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 600;
                transition: all .25s ease;
                cursor: pointer;
            }

            .tab-menu button:hover {
                background: #dbe7ff;
                color: #2b62ff;
                transform: translateY(-2px);
            }

            .tab-menu button.active {
                background: linear-gradient(135deg, #4a7dff, #275df7);
                color: white;
                box-shadow: 0 6px 14px rgba(39, 93, 247, 0.25);
            }

            /* 테이블 */
            .payment-table {
                width: 100%;
                border-collapse: collapse;
                overflow: hidden;
                border-radius: 14px;
            }

            .payment-table thead {
                background: #f4f6fa;
            }

            .payment-table th {
                padding: 16px;
                text-align: center;
                font-size: 14px;
                font-weight: 700;
                color: #444;
                border-bottom: 1px solid #e6eaf0;
            }

            .payment-table td {
                padding: 15px;
                text-align: center;
                font-size: 14px;
                color: #555;
                border-bottom: 1px solid #f0f2f5;
            }

            .payment-table tbody tr {
                transition: .2s;
            }

            .payment-table tbody tr:hover {
                background: #f8fbff;
            }

            /* 공통 버튼 */
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

            button:hover {
                background: #dbe7ff;
                color: #2b62ff;
            }

            /* 환불 버튼 */
            .btn-refund {
                background: #fff0f0;
                color: #e04a4a;
            }

            .btn-refund:hover {
                background: #ffdede;
                color: #c62828;
            }

            /* 페이징 */
            .page-box {
                margin-top: 25px;
                display: flex;
                justify-content: center;
                gap: 8px;
                flex-wrap: wrap;
            }

            .page-box button {
                min-width: 42px;
            }

            .page-box button.active {
                background: #275df7;
                color: white;
            }

            .page-box button:disabled {
                opacity: .4;
                cursor: not-allowed;
            }

            /* 상태 뱃지 */
            .badge-success {
                display: inline-block;
                background: #e7f8ee;
                color: #1c9b52;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }

            .badge-danger {
                display: inline-block;
                background: #fff0f0;
                color: #e04a4a;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }

            @media (max-width: 1200px) {
                .middle {
                    grid-template-columns: 220px 1fr;
                }
            }

            @media (max-width: 900px) {
                .middle {
                    grid-template-columns: 1fr;
                }

                .main {
                    padding: 20px;
                }

                .tab-menu {
                    flex-direction: column;
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="tab-menu">
                        <button :class="{active: activeTab === 'pass'}" @click="fnChangeTab('pass')">패스권결제</button>
                        <button :class="{active: activeTab === 'reservation'}"
                            @click="fnChangeTab('reservation')">예약결제</button>
                        <button :class="{active: activeTab === 'registration'}"
                            @click="fnChangeTab('registration')">등록결제</button>
                    </div>

                    <!-- 패스권 결제 -->
                    <table v-if="activeTab === 'pass'" class="payment-table">
                        <thead>
                            <tr>
                                <th>결제번호</th>
                                <th>유저</th>
                                <th>패스권</th>
                                <th>금액</th>
                                <th>상태</th>
                                <th>날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="p in list" :key="p.payNo">
                                <td>{{ p.payNo }}</td>
                                <td>{{ p.userId }}</td>
                                <td>{{ p.passName }}</td>
                                <td>{{ p.amount }}</td>
                                <td>{{ p.payStatus }}</td>
                                <td>{{ formatDate(p.payDate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 예약 결제 -->
                    <table v-if="activeTab === 'reservation'" class="payment-table">
                        <thead>
                            <tr>
                                <th>결제번호</th>
                                <th>유저</th>
                                <th>예약번호</th>
                                <th>상품명</th>
                                <th>예약금</th>
                                <th>결제여부</th>
                                <th>진행여부</th>
                                <th>결제일</th>
                                <!-- <th>관리</th> -->
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="r in list" :key="r.payNo">
                                <td>{{ r.payNo }}</td>
                                <td>{{ r.userId }}</td>
                                <td>{{ r.resNo }}</td>
                                <td>{{ r.productName }}</td>
                                <td>{{ r.amount }}</td>
                                <td>{{ r.payStatus }}</td>
                                <td>{{ r.resStatus }}</td>
                                <td>{{ formatDate(r.payDate) }}</td>
                                <!-- <td>
                                    <button @click="fnRefund(r)">환불
                                    </button>
                                </td> -->
                            </tr>
                        </tbody>
                    </table>

                    <!-- 등록 결제 -->
                    <table v-if="activeTab === 'registration'" class="payment-table">
                        <thead>
                            <tr>
                                <th>결제번호</th>
                                <th>업체명</th>
                                <th>금액</th>
                                <th>결제일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="c in list" :key="c.payNo">
                                <td>{{ c.payNo }}</td>
                                <td>{{ c.comName }}</td>
                                <td>{{ c.amount }}</td>
                                <td>{{ formatDate(c.payDate) }}</td>
                            </tr>
                        </tbody>
                    </table>
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
                        activeTab: "pass",
                        list: [],
                        pageSize: 10,
                        currentPage: 1,
                        index: 1
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnChangeTab(tab) {
                        this.activeTab = tab;
                        this.currentPage = 1;
                        this.fnGetList();
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnGetList() {
                        let self = this;

                        let url = "";

                        if (self.activeTab === 'pass') {
                            url = "/passPaymentList.dox";
                        } else if (self.activeTab === 'reservation') {
                            url = "/reservationPaymentList.dox";
                        } else if (self.activeTab === 'registration') {
                            url = "/registrationPaymentList.dox";
                        }

                        $.ajax({
                            url: url,
                            type: "POST",
                            dataType: "json",
                            data: {
                                pageSize: self.pageSize,
                                offSet: self.pageSize * (self.currentPage - 1)
                            },
                            success: function (res) {
                                console.log(res);
                                self.list = res.list;
                                self.index = Math.ceil(res.totalCount / self.pageSize);
                            }
                        });
                    },

                    fnRefund(p) {
                        let self = this;

                        if (!confirm("환불하시겠습니까?")) {
                            return;
                        }

                        $.ajax({
                            url: "http://localhost:8080/refundPayment.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                payNo: p.payNo,
                                imp_uid: p.impUid
                            },
                            success: function (data) {
                                alert(data.message);
                                self.fnGetList();
                            },
                            error: function () {
                                alert("환불 실패");
                            }
                        });
                    }

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
                                                    path.includes('adminStatistics') ? 'stats' :
                                                        '';
                    self.fnGetList();

                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>