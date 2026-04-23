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
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <section class="pay-section">
                        <p class="pass-title">멤버십 결제 내역</p>
                        <div v-if="passList.length > 0">
                            <div v-for="pass in passList" :key="pass.passNo"
                                :class="pass.remainingCount === 0 ? 'pass-box sold' : 'pass-box'">
                                <h3>{{ pass.itemName }}</h3>
                                <p>결제 : {{ pass.payDate }} ~ 잔여 {{ pass.remainingCount }}회
                                    <span v-if="pass.remainingCount === 0">~ 소진완료</span>
                                </p>
                            </div>
                        </div>
                        <div class="pass-box" v-else>
                            <h3>구매한 패스가 없습니다.</h3>
                        </div>
                    </section>
                </div>
            </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
    </div>
</body>
<script>
    const app = Vue.createApp({
        data() {
            return {
                passList: []
            };
        },
        methods: {

        }, // methods
        mounted() {
            let self = this;
            axios.get("/myPassWalletList.dox")
                .then(res => {
                    self.passList = res.data;
                })
                .catch(err => {
                    console.error(err);
                });
                }
            });
    app.mount('#app');
</script>
</body>
</html>