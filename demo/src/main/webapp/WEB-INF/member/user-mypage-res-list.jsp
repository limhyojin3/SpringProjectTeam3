<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 예약 목록 css --%>
    <style>
        .res-section {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #eee;
            width: 100%;
            max-width: 800px;
            height: fit-content;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }

        .res-list {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .res-item {
            border: 1px solid #ffd1d1;
            background-color: #fff9f9;
            padding: 25px;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .res-item p {
            margin: 0;
            font-size: 14px;
            color: #555;
        }

        .res-product-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px !important;
        }

        .res-status {
            font-weight: bold;
            color: #f4a096;
        }

        .res-status.done { color: #9b8fd4; }
        .res-status.cancel { color: #ccc; }
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
                        <section class="res-section">
                            <div class="section-header">
                                <h2>내 예약 목록 ({{ resList.length }}개)</h2>
                            </div>

                            <div class="res-list" v-if="resList.length > 0">
                                <div v-for="res in resList" :key="res.resNo" class="res-item">
                                    <p class="res-product-name">{{ res.productName }}</p>
                                    <p>업체명 : {{ res.comName }}</p>
                                    <p>예약일자 : {{ res.resDate }} {{ res.resTime }}</p>
                                    <p>예약금 : {{ res.originalPrice.toLocaleString() }}원</p>
                                    <p>상태 :
                                        <span class="res-status"
                                            :class="res.resStatus === 'DONE' ? 'done' : res.resStatus === 'CANCEL' ? 'cancel' : ''">
                                            {{ res.resStatus }}
                                        </span>
                                    </p>
                                </div>
                            </div>

                            <div class="res-item" v-else>
                                <p style="text-align:center;">예약 내역이 없습니다.</p>
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
                resList: []
            };
        },
        methods: {
            
        },
        mounted() {
            let self = this;
            axios.get("/myReservationList.dox")
                .then(res => {
                    self.resList = res.data;
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