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

            .navi-btn {
                width: 100%;
                padding: 12px 10px;
                text-align: left;
                background-color: white;
                border: 1px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
            }

            .navi-btn:hover {
                background-color: #e3f2fd;
                border-color: #2196f3;
                color: #1976d2;
            }

            .activebtn {
                background-color: #ff6b6b;
                color: white;
                font-weight: bold;
                border: 1px solid #ff6b6b;
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
                <div class="navi">
                    <button :class="['navi-btn', activeMenu === 'main' ? 'activebtn' : '']"
                        @click="fnPage('/adminMain.do')">관리자 메인 페이지</button>

                    <button :class="['navi-btn', activeMenu === 'user' ? 'activebtn' : '']"
                        @click="fnPage('/adminUser.do')">전체 회원 목록</button>

                    <button :class="['navi-btn', activeMenu === 'company' ? 'activebtn' : '']"
                        @click="fnPage('/adminCompany.do')">전체 업체 목록</button>

                    <button :class="['navi-btn', activeMenu === 'board' ? 'activebtn' : '']"
                        @click="fnPage('/adminBoard.do')">전체 게시판/리뷰 목록</button>

                    <button :class="['navi-btn', activeMenu === 'reviewWait' ? 'activebtn' : '']"
                        @click="fnPage('/adminReviewWait.do')">승인 대기중인 리뷰</button>

                    <button :class="['navi-btn', activeMenu === 'payment' ? 'activebtn' : '']"
                        @click="fnPage('/adminPayment.do')">결제 및 상품 관리</button>

                    <button :class="['navi-btn', activeMenu === 'report' ? 'activebtn' : '']"
                        @click="fnPage('/adminReport.do')">신고 관리</button>

                    <button :class="['navi-btn', activeMenu === 'stats' ? 'activebtn' : '']"
                        @click="fnPage('/adminStatistics.do')">통계</button>
                </div>
                <div class="main">

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
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnGet: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.list = data.list;
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
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>