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
                    <table v-if="activeTab === 'pass'" class="report-table">
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
                    <table v-if="activeTab === 'reservation'" class="report-table">
                        <thead>
                            <tr>
                                <th>결제번호</th>
                                <th>유저</th>
                                <th>예약번호</th>
                                <th>상품명</th>
                                <th>금액</th>
                                <th>환불여부</th>
                                <th>결제일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="r in list" :key="r.payNo">
                                <td>{{ r.payNo }}</td>
                                <td>{{ r.userId }}</td>
                                <td>{{ r.resNo }}</td>
                                <td>{{ r.productName }}</td>
                                <td>{{ r.amount }}</td>
                                <td>{{ r.resStatus}}</td>
                                <td>{{ formatDate(r.payDate) }}</td>
                                <td>
                                    <button @click="fnRefund(r)">환불</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 등록 결제 -->
                    <table v-if="activeTab === 'registration'" class="report-table">
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
                                self.list = res.list;
                                self.index = Math.ceil(res.totalCount / self.pageSize);
                            }
                        });
                    },

                    fnRefund(r) {
                        if (!confirm("환불 처리하시겠습니까?")) return;

                        $.ajax({
                            url: "/reservationRefund.dox",
                            type: "POST",
                            data: {
                                pay_no: r.payNo
                            },
                            success: () => {
                                alert("환불 완료");
                                this.fnGetList();
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
                                                    path.includes('adminStatistics') ? 'stats' :
                                                        '';
                    self.fnGetList();

                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>