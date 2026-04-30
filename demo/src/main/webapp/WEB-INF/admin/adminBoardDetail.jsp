<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>게시판 상세</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminNavi.css">

        <style>
            html,
            body {
                height: 100%;
            }

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
                padding: 30px;
                background-color: #f8f9fa;
                width: 1000px;
            }

            .main img {
                max-width: 100% !important;
                height: auto;
                display: block;
            }

            .main .card {
                width: 100%;
            }

            .main .card>div {
                width: 100%;
            }

            .main div[v-html] * {
                max-width: 100% !important;
                box-sizing: border-box;
                width: 100%;
                overflow: hidden;
            }

            .card {
                border-radius: 12px;
                border: none;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
            }

            .card-header {
                font-weight: bold;
                background-color: #f1f3f5;
                border-bottom: none;
            }

            .btn-danger,
            .btn-success {
                font-weight: bold;
            }

            input.form-control {
                border-radius: 8px;
            }

            .summary-box {
                background: #f1f3f5;
                padding: 10px;
                border-radius: 10px;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .summary-box.danger {
                background: #ffe5e5;
                color: red;
            }

            .summary-title {
                font-size: 12px;
                color: #666;
                margin-bottom: 5px;

            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div v-if="post">
                        <h3>게시글 상세</h3>

                        <div class="card p-3">
                            <div><b>번호:</b> {{ post.postNo }}</div>
                            <div><b>카테고리:</b> {{ post.category }}</div>
                            <div><b>작성자:</b> {{ post.userId }}</div>
                            <div><b>작성일:</b> {{ post.regDate }}</div>
                            <div><b>조회수:</b> {{ post.viewCnt }}</div>
                            <div><b>좋아요:</b> {{ post.likeCnt }}</div>
                        </div>

                        <div class="card p-3">
                            <h5>제목</h5>
                            <div>{{ post.title }}</div>
                        </div>

                        <div class="card p-3">
                            <h5>내용</h5>
                            <div v-html="post.content" style="max-width:100%; overflow:auto;"></div>
                        </div>

                        <button class="btn btn-secondary" @click="fnBack">목록으로</button>
                    </div>
                    <div v-else>
                        게시글을 불러오는 중입니다.
                    </div>
                </div>
                <jsp:include page="/WEB-INF/common/footer.jsp" />
                <script>
                    const app = Vue.createApp({
                        data() {
                            return {
                                activeMenu: "",
                                selectedUser: null,
                                postNo: 0,
                                post: null,
                                sessionId: "${sessionScope.sessionId}",
                                sessionRole: "${sessionScope.sessionRole}",
                            };
                        },

                        methods: {

                            fnPage(url) {
                                location.href = url;
                            },

                            formatDate(date) {
                                return date ? date.substring(0, 10) : '-';
                            },

                            fnGetPostDetail(postNo) {
                                let self = this;

                                $.ajax({
                                    url: "http://localhost:8080/postDetail.dox",
                                    type: "POST",
                                    dataType: "json",
                                    data: { postNo: postNo },
                                    success: function (res) {
                                        console.log(res);
                                        self.post = res.post
                                    }
                                });
                            },

                        },

                        mounted() {
                            const urlParams = new URLSearchParams(location.search);
                            const postNo = urlParams.get("postNo");
                            console.log(this.postNo);

                            this.postNo = postNo;
                            if (postNo) {
                                this.fnGetPostDetail(postNo);
                            }
                            const path = location.pathname;
                            this.activeMenu =
                                path.includes('adminMain') ? 'main' :
                                    path.includes('adminUser') ? 'user' :
                                        path.includes('adminCompany') ? 'company' :
                                            path.includes('adminBoard') ? 'board' :
                                                path.includes('adminReviewWait') ? 'reviewWait' :
                                                    path.includes('adminPayment') ? 'payment' :
                                                        path.includes('adminReport') ? 'report' :
                                                            path.includes('adminInquiry') ? 'inquiry' :
                                                                path.includes('adminStatistics') ? 'stats' :
                                                                    '';
                        }
                    });

                    app.mount('#app');
                </script>

    </body>

    </html>