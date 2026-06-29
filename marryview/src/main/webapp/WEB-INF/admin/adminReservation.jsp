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
            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
                padding: 20px;
                gap: 20px;
            }

            :root {
                --primary-color: #4a90e2;
                --bg-color: #f8f9fa;
            }

            .pay-container {
                max-width: 600px;
                margin: 50px auto;
                padding: 0 20px;
                font-family: 'Pretendard', sans-serif;
            }

            .pay-header {
                text-align: center;
                margin-bottom: 40px;
            }

            .pay-header h2 {
                font-size: 2rem;
                color: #333;
            }

            .pay-header p {
                color: #666;
            }

            .pay-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
            }

            .pay-card {
                background: white;
                border: 1px solid #ddd;
                border-radius: 12px;
                padding: 30px 20px;
                text-align: center;
                transition: transform 0.3s ease;
                position: relative;
            }

            .pay-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            /* 추천 카드 강조 */
            .pay-card.highlight {
                border: 2px solid var(--primary-color);
            }

            .badge {
                position: absolute;
                top: -12px;
                left: 50%;
                transform: translateX(-50%);
                background: var(--primary-color);
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
            }

            .pay-name {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .pay-price {
                font-size: 2rem;
                font-weight: 800;
                color: #333;
                margin-bottom: 5px;
            }

            .pay-price span {
                font-size: 1rem;
                font-weight: normal;
            }

            .pay-review {
                font-size: 0.9rem;
                color: #888;
                margin-bottom: 20px;
            }

            .pay-features {
                list-style: none;
                padding: 0;
                margin-bottom: 30px;
                text-align: left;
            }

            .pay-features li {
                margin-bottom: 10px;
                color: #555;
                font-size: 0.95rem;
            }

            .pay-features li::before {
                content: '✓';
                color: var(--primary-color);
                margin-right: 8px;
                font-weight: bold;
            }

            .pay-button {
                width: 100%;
                padding: 12px;
                background: var(--primary-color);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: background 0.2s;
            }

            .pay-button:hover {
                background: #357abd;
            }

            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }

            .modal-content {
                background: white;
                padding: 30px;
                border-radius: 15px;
                width: 400px;
                text-align: center;
            }

            .order-info {
                margin: 20px 0;
                text-align: left;
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
            }

            .pay-methods {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .pay-methods button {
                flex: 1;
                padding: 10px;
                border: 1px solid #ddd;
                cursor: pointer;
                border-radius: 5px;
            }

            .pay-methods button.active {
                border-color: var(--primary-color);
                background: #eef5ff;
                color: var(--primary-color);
                font-weight: bold;
            }

            .modal-btns {
                display: flex;
                gap: 10px;
            }

            .btn-cancel {
                flex: 1;
                padding: 12px;
                background: #ccc;
                border: none;
                border-radius: 8px;
                cursor: pointer;
            }

            .btn-pay {
                flex: 2;
                padding: 12px;
                background: var(--primary-color);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <div class="main">
                    <div class="pay-content">
                        <!-- 제목 -->
                        <div class="pay-header">
                            <h2>예약 결제</h2>
                            <p>예약 정보를 확인하고 결제를 진행하세요</p>
                        </div>

                        <!-- 카드 -->
                        <div class="pay-card highlight" v-if="info">

                            <!-- 예약 정보 -->
                            <div class="pay-name">예약 정보</div>

                            <div class="order-info">
                                <p><strong>예약번호</strong> {{info.res_no}}</p>
                                <p><strong>상품번호</strong> {{info.product_no}}</p>
                                <p><strong>업체번호</strong> {{info.company_no}}</p>
                                <p><strong>이용 날짜</strong> {{info.use_date}}</p>
                                <p><strong>이용 시간</strong> {{info.use_time}}</p>
                            </div>

                            <!-- 금액 -->
                            <div class="pay-price">
                                {{info.amount}} <span>원</span>
                            </div>

                            <!-- 약관 -->
                            <div class="text-left mt-4">
                                <label class="d-block">
                                    <input type="checkbox" v-model="agreeAll" @change="toggleAll">
                                    전체 동의
                                </label>
                                <hr>

                                <label class="d-block">
                                    <input type="checkbox" v-model="agreeRequired1" @change="updateAll">
                                    (필수) 결제 및 이용약관 동의
                                </label>

                                <label class="d-block">
                                    <input type="checkbox" v-model="agreeRequired2" @change="updateAll">
                                    (필수) 개인정보 수집 및 이용 동의
                                </label>

                                <label class="d-block">
                                    <input type="checkbox" v-model="agreeOptional1" @change="updateAll">
                                    (선택) 마케팅 정보 수신 동의
                                </label>
                            </div>

                            <!-- 버튼 -->
                            <div class="mt-4">
                                <button class="btn btn-secondary mr-2" onclick="history.back()">취소</button>

                                <button class="btn btn-primary" @click="fnPayment(info)"
                                    :disabled="!(agreeRequired1 && agreeRequired2)">
                                    결제하기
                                </button>
                            </div>

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
                        info: {
                            res_no: 1,
                            user_id: "test_user",
                            product_no: 2001,
                            company_no: 3001,
                            use_date: "2026-05-01",
                            use_time: "14:00",
                            amount: 1000
                        },
                        sessionId: "${sessionId}",
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
                                merchant_uid: "order_RES" + self.sessionId + "_" + new Date().getTime(), // 주문 고유 번호
                                name: "예약금",
                                amount: 1000,      //제품 가격

                            },
                            function (response) {
                                if (response.success) {
                                    // 우리쪽 db에 결제정보 저장
                                    // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                    // 결제 성공 후 서버 검증
                                    self.fnVerifyPayment(response.imp_uid);
                                } else {
                                    console.log("에러내용: " + response.error_msg);
                                    alert("결제가 취소되었습니다");
                                }
                            },
                        );
                    },

                    fnVerifyPayment(imp_uid) {
                        let self = this
                        $.ajax({
                            url: "http://localhost:8080/verifyPayment.dox",
                            type: "POST",
                            data: {
                                userId: self.sessionId,     // 로그인 아이디
                                imp_uid: imp_uid,           // 결제 고유 값(중복)
                                amount: 1000,
                                itemName: "등록비",
                                type: "RES",
                                resNo: self.info.res_no

                            },
                            success: function (res) {
                                if (res.result == "success") {
                                    alert("결제가완료되었습니다");
                                    self.isModalOpen = false;
                                    location.href = "/adminPayFinish.do?payNo=" + res.payNo + "&type=RES";
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
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>