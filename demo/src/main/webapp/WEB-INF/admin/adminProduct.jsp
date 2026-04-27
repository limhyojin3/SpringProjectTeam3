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

            .navi {
                grid-area: nav;
                border: 1px solid blue;
                padding: 20px 10px;
                display: flex;
                flex-direction: column;
                gap: 8px;
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
                        <button :class="{active: activeTab === 'product'}" @click="fnChangeTab('product')">상품관리</button>
                        <button :class="{active: activeTab === 'coupon'}" @click="fnChangeTab('coupon')">쿠폰관리</button>
                        <button :class="{active: activeTab === 'pass'}" @click="fnChangeTab('pass')">패스관리</button>
                    </div>

                    <!-- 상품 -->
                    <table v-if="activeTab === 'product'" class="report-table">
                        <thead>
                            <tr>
                                <th>상품번호</th>
                                <th>업체명</th>
                                <th>상품명</th>
                                <th>가격</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="p in list" :key="p.productNo">
                                <td>{{ p.productNo }}</td>
                                <td>{{ p.comName}}</td>
                                <td>{{ p.productName }}</td>
                                <td>{{ p.originalPrice }}</td>
                                <td>{{ p.isActive === 1 ? '판매중' : '중지' }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 쿠폰 -->
                    <table v-if="activeTab === 'coupon'" class="report-table">
                        <thead>
                            <tr>
                                <th>코드</th>
                                <th>쿠폰명</th>
                                <th>할인율</th>
                                <th>발급방식</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="c in list" :key="c.couponCode">
                                <td>{{ c.couponCode }}</td>
                                <td>{{ c.couponName }}</td>
                                <td>{{ c.discountRate }}%</td>
                                <td>{{ c.issueType }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 패스 -->
                    <table v-if="activeTab === 'pass'" class="report-table">
                        <thead>
                            <tr>
                                <th>패스번호</th>
                                <th>이름</th>
                                <th>가격</th>
                                <th>리뷰수</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="p in list" :key="p.passNo">
                                <td>{{ p.passNo }}</td>
                                <td>{{ p.passName }}</td>
                                <td>{{ p.price }}</td>
                                <td>{{ p.reviewCnt }}</td>
                                <td>{{ p.isActive === 'Y' ? '사용중' : '중지' }}</td>
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
                        activeTab: "product",
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

                    fnGetList() {
                        let self = this;
                        let url = "";

                        if (self.activeTab === 'product') {
                            url = "/productList.dox";
                        } else if (self.activeTab === 'coupon') {
                            url = "/couponList.dox";
                        } else if (self.activeTab === 'pass') {
                            url = "/passList.dox";
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
                                console.log("🔥 응답:", res);
                                self.list = res.list;
                                self.index = Math.ceil(res.totalCount / self.pageSize);
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