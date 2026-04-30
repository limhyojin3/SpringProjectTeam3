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
                /* 전체 배경 */
                .middle {
                    width: 100%;
                    min-height: 100vh;
                    position: relative;
                    overflow: hidden;
                    background: linear-gradient(180deg, #fffdfd 0%, #fff6f8 100%);
                }

                /* 꽃 이미지 */
                .middle::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 500px;
                    height: 500px;
                    background-image: url(../../img/merryViewFlower2.png);
                    background-size: cover;
                    border-bottom-right-radius: 220px;
                }

                .middle::after {
                    content: '';
                    position: absolute;
                    right: 0;
                    bottom: 0;
                    width: 500px;
                    height: 500px;
                    background-image: url(../../img/merryViewFlower.png);
                    background-size: cover;
                    border-top-left-radius: 220px;
                }

                /* 중앙 */
                .main {
                    display: flex;
                    justify-content: center;
                    padding: 70px 20px;
                    position: relative;
                    z-index: 2;
                }

                .pay-finish-box {
                    width: 100%;
                    max-width: 760px;
                    background: #ffffffee;
                    border-radius: 30px;
                    padding: 30px 48px;
                    box-shadow: 0 15px 45px rgba(226, 170, 180, .15);
                    border: 1px solid #f6e4e7;
                    text-align: center;
                }

                /* 제목 */
                .ring-box {
                    font-size: 42px;
                    margin-bottom: 10px;
                }

                .pay-title {
                    font-size: 52px;
                    font-weight: 300;
                    color: #222;
                    margin-bottom: 10px;
                }

                .pay-title span {
                    color: #ec7f90;
                    font-weight: 700;
                }

                .pay-sub {
                    font-size: 21px;
                    color: #666;
                    line-height: 1.8;
                    margin-bottom: 25px;
                }

                /* 정보 */
                .info-head {
                    display: flex;
                    align-items: center;
                    gap: 18px;
                    font-size: 26px;
                    font-weight: 700;
                    margin-bottom: 14px;
                }

                .info-head::before,
                .info-head::after {
                    content: '';
                    flex: 1;
                    height: 1px;
                    background: #ececec;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 18px 0;
                    border-bottom: 1px solid #f1f1f1;
                    font-size: 20px;
                }

                .success {
                    color: #ec7085;
                    font-weight: 700;
                }

                /* 타입박스 */
                .type-box {
                    margin-top: 35px;
                    padding: 22px;
                    border-radius: 18px;
                    background: #fff6f7;
                    border: 1px solid #f5dce0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .type-left {
                    display: flex;
                    gap: 16px;
                    align-items: center;
                }

                .type-icon {
                    width: 54px;
                    height: 54px;
                    border-radius: 50%;
                    background: #ffe8ec;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                .type-check {
                    width: 44px;
                    height: 44px;
                    border-radius: 50%;
                    background: #efb2bc;
                    color: #fff;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }

                /* 버튼 */
                .btn-area {
                    margin-top: 30px;
                    display: flex;
                    gap: 16px;
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .btn-main,
                .btn-sub {
                    min-width: 230px;
                    height: 60px;
                    border-radius: 14px;
                    font-size: 19px;
                    font-weight: 700;
                }

                .btn-main {
                    border: none;
                    color: #fff;
                    background: linear-gradient(90deg, #ef8e9a, #e96f7f);
                }

                .btn-sub {
                    border: 2px solid #f0a8b2;
                    background: #fff;
                    color: #e77988;
                }

                .bottom-msg {
                    margin-top: 40px;
                    color: #d58f99;
                    font-size: 18px;
                }

                /* 반응형 */
                @media(max-width:768px) {

                    .pay-finish-box {
                        padding: 35px 20px;
                    }

                    .pay-title {
                        font-size: 34px;
                    }

                    .pay-sub {
                        font-size: 16px;
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 12px 0;
                        /* 기존 18px -> 12px */
                        border-bottom: 1px solid #f1f1f1;
                        font-size: 20px;
                    }

                    .type-box {
                        flex-direction: column;
                        gap: 18px;
                        align-items: flex-start;
                    }

                    .btn-main,
                    .btn-sub {
                        width: 100%;
                    }

                    .middle::before,
                    .middle::after {
                        width: 180px;
                        height: 180px;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div id="app">
                <div class="middle">
                    <div class="main">
                        <div class="pay-finish-box">

                            <div class="ring-box">💍</div>

                            <h2 class="pay-title">
                                결제가 <span>완료</span>되었습니다
                            </h2>

                            <p class="pay-sub">
                                소중한 순간을 함께 준비해주셔서 감사합니다.<br>
                                더 행복한 결혼 준비를 위해 언제나 함께할게요.
                            </p>

                            <div class="info-head">결제 정보</div>

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
                                    <span class="info-value success">${payment.pay_status}</span>
                                </div>

                                <div class="info-row">
                                    <span class="info-title">결제일시</span>
                                    <span class="info-value">${payment.pay_date}</span>
                                </div>

                            </div>

                            <c:if test="${type eq 'PASS'}">
                                <div class="type-box">
                                    <div class="type-left">
                                        <div class="type-icon">♡</div>
                                        <div class="type-text">
                                            패스권 구매 완료<br>
                                            상품명 : ${payment.pass_name}
                                        </div>
                                    </div>
                                    <div class="type-check">✔</div>
                                </div>
                            </c:if>

                            <c:if test="${type eq 'RES'}">
                                <div class="type-box">
                                    <div class="type-left">
                                        <div class="type-icon">♡</div>
                                        <div class="type-text">
                                            예약 결제 완료<br>
                                            예약번호 : ${payment.res_no}
                                        </div>
                                    </div>
                                    <div class="type-check">✔</div>
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

                            <div class="bottom-msg">
                                MARRY VIEW와 함께하는 모든 순간이 특별하길 바랍니다.
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