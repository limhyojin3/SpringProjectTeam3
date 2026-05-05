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
        <script src="${pageContext.request.contextPath}/js/page-change.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <style>
            /* 전체 배경 */
            body {
                background:
                    radial-gradient(circle at top left, #ffe4ec 0%, transparent 40%),
                    radial-gradient(circle at bottom right, #e8f0ff 0%, transparent 35%),
                    linear-gradient(180deg, #f7f8fb, #f4f6fa);
            }

            /* 컨테이너 */
            .pay-container {
                max-width: 700px;
                margin: 40px auto;
                padding: 20px;
            }

            /* 헤더 */
            .pay-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .brand-title {
                font-family: 'Great Vibes', cursive;
                font-size: 64px;
                background: linear-gradient(90deg, #c89a3e, #fff7c9, #d7aa45);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .sub-text {
                color: #777;
                margin-top: 6px;
            }

            /* 박스 */
            /* 기본 박스 (연한 컬러) */
            .pay-box {
                background: rgba(255, 255, 255, 0.65);
                backdrop-filter: blur(10px);
                border-radius: 18px;
                padding: 20px;
                margin-bottom: 18px;
                border: 1px solid rgba(255, 255, 255, 0.4);
                box-shadow: 0 8px 20px rgba(0, 0, 0, .04);
            }

            /* 강조 박스 (가격) */
            .highlight-box {
                background: linear-gradient(135deg, #fff, #fff7fb);
                border: 1px solid rgba(232, 138, 162, 0.25);
                box-shadow: 0 18px 40px rgba(232, 138, 162, 0.12);
            }

            /* 타이틀 */
            .box-title {
                font-weight: 800;
                margin-bottom: 12px;
                color: #333;
            }

            /* 가격 */
            .price {
                font-size: 40px;
                font-weight: 900;
                color: #d86f8c;
            }

            .price span {
                font-size: 16px;
                margin-left: 4px;
            }

            /* 설명 */
            .info-text {
                font-size: 14px;
                color: #666;
                line-height: 1.6;
                margin-top: 10px;
            }

            /* 체크박스 */
            .check-item {
                display: block;
                margin: 10px 0;
                font-size: 14px;
            }

            /* 버튼 박스 */
            .button-box {
                display: flex;
                gap: 10px;
            }

            /* 버튼 */
            .btn-pay,
            .btn-cancel {
                flex: 1;
                height: 52px;
                border-radius: 14px;
                border: none;
                font-weight: 800;
                cursor: pointer;
            }

            .btn-pay {
                background: linear-gradient(90deg, #e88aa2, #d86f8c);
                color: #fff;
                box-shadow: 0 10px 18px rgba(232, 138, 162, .3);
            }

            .btn-pay:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .btn-cancel {
                background: #eee;
                color: #555;
            }

            .glass-card {
                max-width: 520px;
                margin: 40px auto;
                padding: 28px;

                background: rgba(255, 255, 255, 0.65);
                backdrop-filter: blur(18px);

                border-radius: 26px;
                border: 1px solid rgba(255, 255, 255, 0.4);

                box-shadow:
                    0 25px 60px rgba(0, 0, 0, 0.10),
                    0 10px 25px rgba(232, 138, 162, 0.12);

                transform: translateY(0);
                transition: 0.3s ease;
            }

            /* 떠있는 느낌 */
            .glass-card:hover {
                transform: translateY(-6px);
                box-shadow:
                    0 35px 80px rgba(0, 0, 0, 0.12),
                    0 15px 35px rgba(232, 138, 162, 0.18);
            }

            /* ===== 금빛 글로우 + 반짝임 핵심 ===== */
            .brand-title {
                position: relative;
                display: inline-block;
            }

            /* 금빛 흐르는 광택 */
            .brand-title {
                background: linear-gradient(90deg,
                        #8b6524 0%,
                        #c89a3e 20%,
                        #fff3b0 40%,
                        #d7aa45 60%,
                        #9d6e1f 100%);
                background-size: 300% auto;

                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;

                animation: goldMove 4s linear infinite;
            }

            /* 반짝이 2개 포인트 */
            .brand-title::before,
            .brand-title::after {
                content: "✦";
                position: absolute;
                color: #ffe89a;
                text-shadow: 0 0 15px rgba(255, 232, 138, 0.9);
                animation: sparkle 2s infinite ease-in-out;
            }

            .brand-title::before {
                top: 10px;
                right: -10px;
            }

            .brand-title::after {
                bottom: 12px;
                left: -12px;
                animation-delay: 0.6s;
            }

            /* 금빛 이동 */
            @keyframes goldMove {
                0% {
                    background-position: 0% center;
                }

                100% {
                    background-position: 300% center;
                }
            }

            /* 반짝임 */
            @keyframes sparkle {

                0%,
                100% {
                    opacity: 0.3;
                    transform: scale(0.8) rotate(0deg);
                }

                50% {
                    opacity: 1;
                    transform: scale(1.3) rotate(15deg);
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <div class="main">
                    <div class="glass-card">

                        <!-- 타이틀 -->
                        <div class="pay-header" style="margin-bottom:20px;">
                            <h2 class="brand-title" style="font-size:48px;">MerryView</h2>
                            <p class="sub-text">제휴 등록 결제</p>
                        </div>

                        <!-- 가격 -->
                        <div class="price" style="text-align:center;">
                            1,000<span>원</span>
                        </div>

                        <!-- 안내 -->
                        <div class="info-text" style="text-align:center; margin:15px 0;">
                            결제 후 즉시 제휴 등록이 진행됩니다.
                        </div>

                        <!-- 약관 -->
                        <div class="pay-box" style="background:rgba(255,255,255,0.6);">
                            <label class="check-item">
                                <input type="checkbox" v-model="agreeAll" @change="toggleAll">
                                전체 동의
                            </label>

                            <label class="check-item">
                                <input type="checkbox" v-model="agreeRequired1" @change="updateAll">
                                (필수) 결제 및 이용약관
                            </label>

                            <label class="check-item">
                                <input type="checkbox" v-model="agreeRequired2" @change="updateAll">
                                (필수) 개인정보 수집 및 이용
                            </label>

                            <label class="check-item">
                                <input type="checkbox" v-model="agreeOptional1" @change="updateAll">
                                (선택) 마케팅 수신
                            </label>
                        </div>

                        <!-- 버튼 -->
                        <div class="button-box" style="margin-top:18px;">
                            <button class="btn-cancel" onclick="history.back()">
                                취소
                            </button>

                            <button class="btn-pay" @click="fnPayment" :disabled="!(agreeRequired1 && agreeRequired2)">
                                결제하기
                            </button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
        <script>
            IMP.init("imp48518435");
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        activeMenu: "",
                        sessionId: "${sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                        isModalOpen: false,
                        paymentMethod: "",
                        //전체 동의
                        agreeAll: false,
                        // 필수 동의
                        agreeRequired1: false,
                        agreeRequired2: false,
                        // 선택 동의
                        agreeOptional1: false,

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnPayment: function () {
                        let self = this;
                        if (!(this.agreeRequired1 && this.agreeRequired2)) {
                            alert("필수 약관에 동의해주세요");
                            return;
                        }
                        IMP.request_pay(
                            {
                                channelKey: "channel-key-1ebd3d65-20bd-412e-83f3-b7e0c3b368ff",
                                pay_method: "card",
                                merchant_uid: "order_REG" + self.sessionId + "_" + new Date().getTime(), // 주문 고유 번호
                                name: "등록비",
                                amount: 1000,      //제품 가격
                            },
                            function (response) {
                                console.log(response);
                                console.log("전체 response:", response);
                                console.log("success:", response.success);
                                console.log("imp_uid:", response.imp_uid);
                                console.log("status:", response.status);
                                console.log("paid_amount:", response.paid_amount);
                                if (response.success) {
                                    console.log("포트원 번호: " + response.imp_uid);
                                    // 우리쪽 db에 결제정보 저장
                                    // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                    // 결제 성공 후 서버 검증
                                    console.log("imp_uid:", response.imp_uid);
                                    self.fnVerifyPayment(response.imp_uid, response.merchant_uid);
                                } else {
                                    console.log("에러내용: " + response.error_msg);
                                    alert("결제가 취소되었습니다");
                                }
                            },
                        );
                    },

                    fnVerifyPayment(imp_uid, merchant_uid) {
                        let self = this
                        console.log("서버로 보내는 imp_uid:", imp_uid);
                        $.ajax({
                            url: "http://localhost:8080/verifyPayment2.dox",
                            type: "POST",
                            data: {
                                userId: this.sessionId,     // 로그인 아이디
                                imp_uid: imp_uid,           // 결제 고유 값(중복)
                                merchant_uid: merchant_uid,
                                amount: 1000,
                                itemName: "제휴등록비",
                                type: "REG"


                            },
                            success: function (res) {
                                console.log(res);
                                if (res.result == "success") {
                                    console.log("포트원 번호: " + res.imp_uid);
                                    alert("결제가완료되었습니다");
                                    self.isModalOpen = false;
                                    location.href = "/adminPayFinish.do?payNo=" + res.payNo + "&type=REG";
                                } else {
                                    console.log("에러내용: " + res.error_msg);
                                    alert("결제 검증 실패");
                                }
                            }
                        });
                    },

                    toggleAll() {
                        const value = this.agreeAll;
                        this.agreeRequired1 = value;
                        this.agreeRequired2 = value;
                        this.agreeOptional1 = value;
                    },

                    updateAll() {
                        this.agreeAll = this.agreeRequired1 && this.agreeRequired2 && this.agreeOptional1;
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