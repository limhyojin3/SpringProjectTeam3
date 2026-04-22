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
        <script src="../../js/page-change.js"></script>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
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
                gap: 20px;
            }

            :root {
                --primary-color: #4a90e2;
                --bg-color: #f8f9fa;
            }

            .pass-container {
                max-width: 1100px;
                margin: 50px auto;
                padding: 0 20px;
                font-family: 'Pretendard', sans-serif;
            }

            .pass-header {
                text-align: center;
                margin-bottom: 40px;
            }

            .pass-header h2 {
                font-size: 2rem;
                color: #333;
            }

            .pass-header p {
                color: #666;
            }

            .pass-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
            }

            .pass-card {
                background: white;
                border: 1px solid #ddd;
                border-radius: 12px;
                padding: 30px 20px;
                text-align: center;
                transition: transform 0.3s ease;
                position: relative;
            }

            .pass-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            /* 추천 카드 강조 */
            .pass-card.highlight {
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

            .pass-name {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .pass-price {
                font-size: 2rem;
                font-weight: 800;
                color: #333;
                margin-bottom: 5px;
            }

            .pass-price span {
                font-size: 1rem;
                font-weight: normal;
            }

            .pass-review {
                font-size: 0.9rem;
                color: #888;
                margin-bottom: 20px;
            }

            .pass-features {
                list-style: none;
                padding: 0;
                margin-bottom: 30px;
                text-align: left;
            }

            .pass-features li {
                margin-bottom: 10px;
                color: #555;
                font-size: 0.95rem;
            }

            .pass-features li::before {
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
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <div class="navi">
                    <button :class="['navi-btn', activeMenu === 'user' ? 'activebtn' : '']"
                        @click="goPage('/adminUser.do', 'user')">회원 목록</button>

                    <button :class="['navi-btn', activeMenu === 'company' ? 'activebtn' : '']"
                        @click="goPage('/adminCompany.do', 'company')">업체 목록</button>

                    <button :class="['navi-btn', activeMenu === 'board' ? 'activebtn' : '']"
                        @click="goPage('/adminBoard.do', 'board')">게시판</button>

                    <button :class="['navi-btn', activeMenu === 'reviewWait' ? 'activebtn' : '']"
                        @click="goPage('/adminReviewWait.do', 'reviewWait')">리뷰 대기</button>

                    <button :class="['navi-btn', activeMenu === 'payment' ? 'activebtn' : '']"
                        @click="goPage('/adminPayment.do', 'payment')">결제/상품</button>

                    <button :class="['navi-btn', activeMenu === 'report' ? 'activebtn' : '']"
                        @click="goPage('/adminReport.do', 'report')">신고</button>

                    <button :class="['navi-btn', activeMenu === 'stats' ? 'activebtn' : '']"
                        @click="goPage('/adminStatistics.do', 'stats')">통계</button>
                </div>
                <div class="main">
                    <div class="pass-container">
                        <div class="pass-header">
                            <h2>원하시는 패스를 선택하세요</h2>
                            <p>나에게 딱 맞는 플랜으로 서비스를 시작해보세요.</p>
                        </div>
                        <div class="pass-grid">
                            <div class="pass-card" v-for="pass in passList">

                                <div class="pass-name">{{ pass.passName }}</div>

                                <div class="pass-price">
                                    {{ pass.price.toLocaleString() }}<span>원</span>
                                </div>

                                <div class="pass-review">
                                    열람 가능한 리뷰 수: {{ pass.reviewCnt }}개
                                </div>

                                <button class="pay-button" @click="openModal(pass)">
                                    결제하기
                                </button>
                            </div>
                        </div>
                    </div>
                    <div v-if="isModalOpen" class="modal-overlay">
                        <div class="modal-content">

                            <h2>결제 확인</h2>

                            <p>상품명: {{ selectedPass.passName }}</p>
                            <p>가격: {{ selectedPass.price.toLocaleString() }}원</p>
                            <p>열람 가능한 리뷰 수: {{ selectedPass.reviewCnt }}개</p>

                            <p v-if="selectedPass.description">
                                {{ selectedPass.description }}
                            </p>

                            <hr />

                            <!-- 결제수단 -->
                            <select v-model="paymentMethod">
                                <option value="">결제방법을 선택하세요</option>
                                <option value="card">카드</option>
                                <option value="kakaopay">카카오페이</option>
                                <option value="naverpay">네이버페이</option>
                                <option value="tosspay">토스</option>
                            </select>

                            <!-- 약관 -->
                            <!-- 전체 동의 -->
                            <label>
                                <input type="checkbox" v-model="agreeAll" @change="toggleAll" />
                                전체 동의
                            </label>

                            <hr />

                            <!-- 필수 -->
                            <label>
                                <input type="checkbox" v-model="agreeRequired1" />
                                (필수) 결제 및 이용약관 동의
                            </label>

                            <label>
                                <input type="checkbox" v-model="agreeRequired2" />
                                (필수) 개인정보 수집 및 이용 동의
                            </label>

                            <!-- 선택 -->
                            <label>
                                <input type="checkbox" v-model="agreeOptional1" />
                                (선택) 마케팅 정보 수신 동의
                            </label>

                            <div class="buttons">
                                <button @click="closeModal">취소</button>
                                <button @click="fnPayment(selectedPass)"
                                    :disabled="!(agreeRequired1 && agreeRequired2) || (paymentMethod ==='')">
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
                        passList: [],
                        //sessionId: "hyunwoo1125",       //체험권 비구매자
                        //sessionId: "junho0324",        //체험권 구매자
                        sessionId: "${sessionId}",
                        isModalOpen: false,
                        selectedPass: null,
                        paymentMethod: "",
                        //전체 동의
                        agreeAll: false,
                        // 필수 동의
                        agreeRequired1: false,
                        agreeRequired2: false,
                        // 선택 동의
                        agreeOptional1: false,
                        price: 1,

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnPayment: function (selectedPass) {
                        let self = this;
                        if (!(this.agreeRequired1 && this.agreeRequired2)) {
                            alert("필수 약관에 동의해주세요");
                            return;
                        }
                        IMP.request_pay(
                            {
                                channelKey: "channel-key-1ebd3d65-20bd-412e-83f3-b7e0c3b368ff",
                                pay_method: self.paymentMethod,
                                merchant_uid: "order_" + new Date().getTime(), // 주문 고유 번호
                                name: selectedPass.passName,
                                amount: 1,      //제품 가격
                            },
                            function (response) {
                                // 결제 종료 시 호출되는 콜백 함수
                                // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
                                // 결제 결과를 처리하는 로직을 작성합니다.
                                console.log(response);
                                if (response.success) {
                                    alert("결제되었습니다!");
                                    // 우리쪽 db에 결제정보 저장
                                    // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                    // 결제 성공 후 서버 검증
                                    self.fnVerifyPayment(response.imp_uid, selectedPass);
                                    pageChange("/adminPayFinish.do", {orderId : response.imp_uid});
                                } else {
                                    alert("결제가 취소되었습니다");
                                }
                            },
                        );
                    },

                    fnVerifyPayment(imp_uid, selectedPass) {
                        $.ajax({
                            url: "/verifyPayment.dox",
                            type: "POST",
                            data: {
                                userId: this.sessionId,     // 로그인 아이디
                                imp_uid: imp_uid,           // 결제 고유 값(중복)
                                passNo: selectedPass.passNo,
                                amount: selectedPass.price,
                                itemName: selectedPass.passName,

                            },
                            success: function (res) {
                                if (res.success) {
                                    alert("결제 완료페이지만드는게나을듯");
                                    location.href = "/merryViewHome.do";
                                } else {
                                    alert("결제 검증 실패");
                                }
                            }
                        });
                    },

                    fnGetPassList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/pass.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.passList = data.list;
                            }
                        });
                    },
                    fnCheck: function (pass) {
                        let self = this;
                        if (!self.sessionId || self.sessionId === "null" || self.sessionId === "") {
                            if (confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                                location.href = "/login.do";
                            }
                            return;
                        }
                        if (pass.passName === "체험용 패스") {
                            let param = {
                                userId: self.sessionId
                            };
                            $.ajax({
                                url: "http://localhost:8080/passCheck.dox",
                                dataType: "json",
                                type: "POST",
                                data: param,
                                success: function (data) {
                                    console.log(data);
                                    if (data.info != null) {
                                        alert("이미 체험용 패스권을 구매하셨어요");
                                        return;
                                    }
                                    self.selectedPass = pass;
                                    self.isModalOpen = true;
                                    console.log(self.selectedPass);
                                }
                            });
                        } else {
                            self.selectedPass = pass;
                            self.isModalOpen = true;
                             console.log(self.selectedPass);
                        }
                    },
                    openModal: function (pass) {
                        let self = this;
                        self.paymentMethod = "",
                            self.agreeAll = false,
                            self.agreeRequired1 = false,
                            self.agreeRequired2 = false,
                            self.agreeOptional1 = false,
                            self.fnCheck(pass);
                    },

                    toggleAll() {
                        const value = this.agreeAll;
                        this.agreeRequired1 = value;
                        this.agreeRequired2 = value;
                        this.agreeOptional1 = value;
                    },

                    closeModal: function () {
                        this.isModalOpen = false;
                        this.selectedPass = null;
                    }

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
                    self.fnGetPassList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>