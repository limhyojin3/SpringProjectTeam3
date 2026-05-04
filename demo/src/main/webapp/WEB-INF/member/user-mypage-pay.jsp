<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>멤버십 결제 내역</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
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
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
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

        .pagination-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 6px;
        }

        .btn-page-arrow,
        .btn-page-num {
            height: 34px;
            min-width: 34px;
            padding: 0 10px;
            background-color: #fff;
            color: #f4a096;
            border: 1.5px solid #f4a096;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-page-arrow:hover,
        .btn-page-num:hover {
            background-color: #f4a096;
            color: white;
        }

        .btn-page-num.active-page {
            background-color: #f4a096;
            color: white;
            font-weight: bold;
        }

        .btn-page-arrow:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <div id="wrapper">
            <div class="main-content">
                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />
                <div class="right-sections">
                    <section class="pay-section">
                        <p class="pass-title">멤버십 결제 내역</p>
                        <div v-if="loaded && passList.length > 0">
                            <div v-for="pass in passList" :key="pass.passNo"
                                :class="pass.remainingCount === 0 ? 'pass-box sold' : 'pass-box'">
                                <h3>{{ pass.itemName }}</h3>
                                <p>결제 : {{ pass.payDate }} ~ 잔여 {{ pass.remainingCount }}회
                                    <span v-if="pass.remainingCount === 0">~ 소진완료</span>
                                </p>
                            </div>
                        </div>
                        <div class="pass-box" v-else-if="loaded">
                            <h3>구매한 패스가 없습니다.</h3>
                        </div>
                    </section>
                    <!-- 페이징 -->
                        <div class="pagination-wrap">
                            <button class="btn-page-arrow" @click="fetchList(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                            <button class="btn-page-num"
                                    v-for="p in totalPages" :key="p"
                                    :class="p === currentPage ? 'active-page' : ''"
                                    @click="fetchList(p)">
                                {{ p }}
                            </button>
                            <button class="btn-page-arrow" @click="fetchList(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
                        </div>
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
                currentPage: 1,
                totalPages: 0,
                loaded: false
            };
        },
        methods: {
            fetchList(page = 1) {
                let self = this;
                axios.get("/myPassWalletList.dox", {
                    params: { currentPage: page }
                })
                .then(res => {
                    self.passList = res.data.list || [];  // null 방어
                    self.totalPages = res.data.totalPages || 0;
                    self.currentPage = res.data.currentPage || 1;
                    self.loaded = true;
                })
                .catch(err => {
                    console.error(err);
                    self.loaded = true;  // 오류나도 화면 보여주기
                });
            }
        }, // methods
        mounted() {
            this.fetchList(1);
        }
    });
    app.mount('#app');
</script>
</body>
</html>