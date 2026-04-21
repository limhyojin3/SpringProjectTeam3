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
                display: grid;
                grid-template-areas:
                    "nav main";
                grid-template-columns: 220px 1fr;
                /* 너비 고정 */
                gap: 5px;
            }

            .navi {
                grid-area: nav;
                border: 1px solid blue;
                padding: 20px 10px;
                display: flex;
                flex-direction: column;
                gap: 8px;
                background-color: #ffc7c2;
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
                                <option value="card">카드</option>
                                <option value="kakao">카카오페이</option>
                                <option value="toss">토스</option>
                            </select>

                            <!-- 약관 -->
                            <label>
                                <input type="checkbox" v-model="agree" />
                                결제 및 약관에 동의합니다
                            </label>

                            <div class="buttons">
                                <button @click="closeModal">취소</button>
                                <button @click="fnPayment(selectedPass)" :disabled="!agree">
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
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        activeMenu: "",
                        passList: [],
                        //sessionId: "hyunwoo1125",       //체험권 비구매자
                        sessionId: "junho0324",        //체험권 구매자
                        //sessionId: "${sessionId}"
                        isModalOpen: false,
                        selectedPass: null,
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnPayment: function (passName) {

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
                                }
                            });
                        } else {
                            self.selectedPass = pass;
                            self.isModalOpen = true;
                        }
                    },
                    openModal: function (pass) {
                        let self = this;
                        self.fnCheck(pass);
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