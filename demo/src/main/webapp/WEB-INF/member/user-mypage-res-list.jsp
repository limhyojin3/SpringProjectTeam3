<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 목록</title>
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

        /* 페이지 인덱스 */
        .review-index-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 6px;
        }

        .btn-review-index {
            height: 34px;
            min-width: 34px;
            padding: 0 10px;
            background-color: #fff;
            color: #9b8fd4;
            border: 1.5px solid #9b8fd4;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-review-index:hover {
            background-color: #9b8fd4;
            color: white;
        }

        .btn-review-index.active-page {
            background-color: #9b8fd4;
            color: white;
            font-weight: bold;
            border-color: #9b8fd4;
        }

        .pagination-wrap {
            text-align: center;
            margin-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
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
                        <section class="res-section">
                            <div class="section-header">
                                <h2>내 예약 목록</h2>
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
                        <!-- 페이징 -->
                        <div class="pagination-wrap">
                            <button class="btn-page-arrow" @click="goPage(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                            <span v-for="p in totalPages" :key="p">
                                <button class="btn-page-num" :class="p === currentPage ? 'active-page' : ''" @click="goPage(p)">
                                    {{ p }}
                                </button>
                            </span>
                            <button class="btn-page-arrow" @click="goPage(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
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
                resList: [],
                currentPage: 1,
                totalPages: 0,
                pageSize: 3
            };
        },
        methods: {
            fetchList(page = 1) {
                let self = this;
                axios.get("/myReservationList.dox", {
                    params: {
                        currentPage: page,
                        pageSize: self.pageSize
                    }
                })
                .then(res => {
                    self.resList = res.data.list;
                    self.totalPages = res.data.totalPages;
                    self.currentPage = res.data.currentPage;
                })
                .catch(err => {
                    console.error(err);
                });
            },
            goPage(page) {
                if(page < 1 || page > this.totalPages) return;
                this.fetchList(page);
            }
        },
        mounted() {
            this.fetchList(1);
        }
    });

    app.mount('#app');
</script>
</body>
</html>