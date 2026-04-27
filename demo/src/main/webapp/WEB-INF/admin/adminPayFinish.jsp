<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    background: #fff8f7;
                    min-height: 100vh;
                }

                .main {
                    padding: 50px 20px;
                    display: flex;
                    justify-content: center;

                }

                .pay-finish-box {
                    width: 100%;
                    max-width: 720px;
                    background: #fffdfc;
                    border-radius: 28px;
                    padding: 45px;
                    box-shadow: 0 12px 30px rgba(215, 154, 154, 0.15);
                    text-align: center;
                    border: 1px solid #f6e4e4;
                }

                .pay-img {
                    width: 320px;
                    max-width: 100%;
                    border-radius: 20px;
                    margin-bottom: 25px;
                }

                .pay-sub {
                    font-size: 15px;
                    color: #8a6d6d;
                    margin-bottom: 30px;
                }

                .info-box {
                    background: #fff7f7;
                    border-radius: 18px;
                    padding: 25px 30px;
                    text-align: left;
                    margin-top: 10px;
                    border: 1px solid #f3dddd;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 10px 0;
                    border-bottom: 1px solid #f6eaea;
                    font-size: 15px;
                }

                .info-row:last-child {
                    border-bottom: none;
                }

                .info-title {
                    font-weight: 700;
                    color: #9b7777;
                }

                .info-value {
                    color: #555;
                }

                .type-box {
                    margin-top: 22px;
                    padding: 18px;
                    border-radius: 16px;
                    background: #fff2f2;
                    color: #8d6c6c;
                    font-weight: 600;
                }

                .btn-area {
                    margin-top: 35px;
                    display: flex;
                    gap: 14px;
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .btn-main {
                    background: #e8b7b7;
                    border: none;
                    color: white;
                    padding: 11px 24px;
                    border-radius: 12px;
                    font-weight: 600;
                    transition: 0.2s;
                }

                .btn-main:hover {
                    background: #d89e9e;
                    color: white;
                }

                .btn-sub {
                    background: #fff;
                    border: 1px solid #e8b7b7;
                    color: #c18484;
                    padding: 11px 24px;
                    border-radius: 12px;
                    font-weight: 600;
                    transition: 0.2s;
                }

                .btn-sub:hover {
                    background: #fff5f5;
                }

                @media(max-width:768px) {
                    .pay-finish-box {
                        padding: 30px 20px;
                    }

                    .info-row {
                        flex-direction: column;
                        gap: 5px;
                    }

                    .pay-img {
                        width: 260px;
                    }
                }
            </style>
        </head>

        <body>
            <div id="app">
                <jsp:include page="/WEB-INF/common/header.jsp" />
                <div class="middle">
                    <div class="main">
                        <div class="pay-finish-box">

                            <img src="/img/merryViewPay.JPG" class="pay-img">

                            <p class="pay-sub">
                                주문이 정상적으로 처리되었습니다.<br>
                                아래 결제 정보를 확인해주세요.
                            </p>
                            ${payment}
                            <div class="info-box">

                                <div class="info-row">
                                    <span class="info-title">결제번호</span>
                                    <span class="info-value">${payment.pay_no}</span>
                                </div>

                                <div class="info-row">
                                    <span class="info-title">결제금액</span>
                                    <span class="info-value">${payment.amount} 원</span>
                                </div>

                                <div class="info-row">
                                    <span class="info-title">결제상태</span>
                                    <span class="info-value">${payment.pay_status}</span>
                                </div>

                                <div class="info-row">
                                    <span class="info-title">결제일시</span>
                                    <span class="info-value">${payment.pay_date}</span>
                                </div>

                            </div>

                            <c:if test="${type eq 'PASS'}">
                                <div class="type-box">
                                    패스권 구매 완료<br>
                                    상품명 : ${payment.pass_name}
                                </div>
                            </c:if>

                            <c:if test="${type eq 'RES'}">
                                <div class="type-box">
                                    예약 결제 완료<br>
                                    예약번호 : ${payment.res_no}
                                </div>
                            </c:if>

                            <c:if test="${type eq 'REG'}">
                                <div class="type-box">
                                    업체 등록 결제 완료<br>
                                    업체번호 : ${payment.company_no}
                                </div>
                            </c:if>

                            <div class="btn-area">
                                <button class="btn btn-main" onclick="location.href='/merryViewHome.do'">
                                    홈으로 이동
                                </button>

                                <button class="btn btn-sub" onclick="location.href='/api/review/list.do'">
                                    리뷰 게시판
                                </button>
                            </div>

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