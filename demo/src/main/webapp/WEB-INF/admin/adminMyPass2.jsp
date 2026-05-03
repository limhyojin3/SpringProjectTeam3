<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>멤버십 결제 내역</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

        <%-- ✅ 마이페이지 공용 CSS --%>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

            <%-- ✅ 멤버십 결제 내역 페이지 전용 스타일만 --%>
                <style>
                    .pass-box {
                        background-color: #ffc7c2;
                        border-radius: 10px;
                        padding: 25px;
                        text-align: center;
                        margin-bottom: 20px;
                    }

                    .pass-box h3 {
                        font-size: 25px;
                        color: #333;
                        margin-bottom: 10px;
                    }

                    .pass-box p {
                        font-size: 20px;
                        color: #666;
                        margin-bottom: 15px;
                    }

                    .pay-section {
                        background-color: #fff;
                        padding: 40px;
                        border-radius: 12px;
                        border: 1px solid #eee;
                        width: 100%;
                        max-width: 800px;
                        height: fit-content;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
                    }

                    .pass-title {
                        font-size: 20px;
                        font-weight: bold;
                        color: #333;
                        margin-bottom: 20px;
                    }

                    .sold {
                        background-color: #ccc;
                        color: #888;
                    }

                    .empty-box {
                        opacity: 0;
                        pointer-events: none;
                        height: 180px;
                    }

                    .page-box {}
                </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="wrapper">
                <div class="main-content">
                    <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                        <div class="right-sections">
                            <section class="pay-section">
                                <p class="pass-title">내 패스 확인</p>
                                <p>잔여 열람권 수 : {{ remainingCount }}</p>
                                <div v-if="passList.length > 0">
                                    <div v-for="pass in passList" :key="pass.payNo"
                                        :class="pass.remainingCount === 0 ? 'pass-box sold' : 'pass-box'">
                                        <h3>{{ pass.itemName }}</h3>
                                        <p>결제 : {{ pass.payDate }}</p>
                                        <p>상태 : {{ pass.payStatus === 'SUCCESS' ? '결제완료' : pass.payStatus === 'CANCEL' ?
                                            '환불/취소 됨' : 결제실패}}</p>
                                    </div>
                                    <!-- 빈 공간 더미 -->
                                    <template v-if="passList.length > 3">
                                        <div v-for="n in (pageSize - passList.length)" class="pass-box empty-box"></div>
                                    </template>
                                </div>
                                <div class="pass-box" v-else>
                                    <h3>구매한 패스가 없습니다.</h3>
                                </div>
                                <div class="page-box">
                                    <button @click="fnPageMove(currentPage-1)" :disabled="currentPage===1">‹</button>

                                    <button v-for="p in index" :key="p" @click="fnPageMove(p)"
                                        :class="{active: currentPage === p}">
                                        {{ p }}
                                    </button>

                                    <button @click="fnPageMove(currentPage+1)"
                                        :disabled="currentPage===index">›</button>
                                </div>
                            </section>
                        </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
    </body>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    passList: [],
                    activeMenu: "",
                    sessionId: "${sessionScope.sessionId}",
                    sessionRole: "${sessionScope.sessionRole}",
                    remainingCount:0,
                    pageSize: 3,
                    index: 1,
                    currentPage: 1,
                };
            },
            methods: {
                fnGetMyPassList: function () {
                    let self = this;
                    let param = {
                        userId: self.sessionId,
                        pageSize: self.pageSize,
                        offSet: self.pageSize * (self.currentPage - 1),
                    };
                    $.ajax({
                        url: "http://localhost:8080/MyPassList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            console.log(data.list);
                            self.passList = data.list || [];
                            self.index = Math.ceil(data.totalCount / self.pageSize);
                            self.remainingCount = data.remainingCount;

                        }
                    });
                },
                fnPageMove(p) {
                    if (p < 1 || p > this.index) return;
                    this.currentPage = p;
                    this.fnGetMyPassList();
                },

            }, // methods
            mounted() {
                let self = this;
                self.fnGetMyPassList();
            },

        });

        app.mount('#app');
    </script>
    </body>

    </html>