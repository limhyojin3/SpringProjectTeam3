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
                <div class="main">
                    <div v-if="!paymentInfo">
                        결제가 완료 되었습니다!
                        <br>
                        이용해 주셔서 감사합니다!

                    </div>

                    <div v-else>
                        <h3>결제가 완료 되었습니다!</h3>

                        <hr>

                        <p><b>결제번호:</b> ${payment.pay_no}</p>
                        <p><b>상품명:</b> ${payment.item_name}</p>
                        <p><b>결제 금액:</b> ${payment.amount}</p>
                        <p><b>결제일:</b> ${payment.pay_date}</p>

                        <button class="btn btn-primary" onclick="location.href='/merryViewHome.do'">
                            홈으로 이동
                        </button>
                    </div>

                </div>
            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
        <script>
            const IMP_UID = new URLSearchParams(location.search).get("imp_uid");
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        activeMenu: "",
                        impUid: null,
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
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