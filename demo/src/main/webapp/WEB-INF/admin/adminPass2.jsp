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
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Playfair+Display:wght@700&display=swap"
            rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Great+Vibes&display=swap');

            :root {
                --primary: #e88aa2;
                /* 로즈 핑크 */
                --primary-dark: #d86f8c;
                --sub: #7c8db5;
                /* 은은한 블루 */
                --gold: #d9b26f;
                --text: #2b2b2b;
                --muted: #777;
                --line: #ececec;
                --bg: #fff8fb;
                --card: #ffffff;
                --shadow: 0 15px 35px rgba(0, 0, 0, .08);
            }

            body {
                background:
                    radial-gradient(circle at top left, #ffeef4 0%, transparent 35%),
                    radial-gradient(circle at right bottom, #eef4ff 0%, transparent 30%),
                    #f8f9fb;
            }

            .main {
                grid-area: main;
                padding: 30px;
                border: none;
                padding-top: 0px;
            }

            /* 전체 래퍼 */
            .pass-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 20px;
                padding-top: 0px;
            }

            .brand-wrap {
                text-align: center;
                margin-bottom: 18px;
            }

            .pass-header {
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                margin-bottom: 48px;
                padding-top: 10px;
                overflow: visible;
            }

            /* 메인 로고 */
            .brand-title {
                position: relative;
                display: inline-block;

                font-family: 'Great Vibes', cursive;
                font-size: 92px;
                font-weight: 400;
                line-height: 1.32;

                /* 핵심 : 필기체 좌측 튀는 현상 보정 */
                padding: 24px 28px 14px 52px;
                margin: 0;
                transform: translateX(10px);

                letter-spacing: 1px;
                white-space: nowrap;
                overflow: visible;

                /* 골드 그라데이션 */
                background: linear-gradient(90deg,
                        #8b6524 0%,
                        #c89a3e 18%,
                        #f6e08d 34%,
                        #fff7c9 48%,
                        #d7aa45 62%,
                        #9d6e1f 78%,
                        #f4dd88 100%);

                background-size: 300% auto;

                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;

                text-shadow:
                    0 2px 3px rgba(255, 255, 255, .55),
                    0 8px 16px rgba(166, 120, 37, .18),
                    0 18px 35px rgba(0, 0, 0, .08);

                animation: goldMove 5s linear infinite;
            }

            /* 반짝이 */
            .brand-title::before {
                content: "✦";
                position: absolute;
                top: 12px;
                right: -10px;
                font-size: 22px;
                color: #ffe89a;
                text-shadow: 0 0 14px rgba(255, 232, 138, .9);
                animation: twinkle 1.8s ease-in-out infinite;
            }

            .brand-title::after {
                content: "✧";
                position: absolute;
                left: 8px;
                bottom: 16px;
                font-size: 18px;
                color: #fff1aa;
                text-shadow: 0 0 12px rgba(255, 232, 138, .85);
                animation: twinkle 2.4s ease-in-out infinite .5s;
            }

            .hero-text {
                margin-top: 8px;
            }

            .hero-main {
                font-size: 22px;
                font-weight: 700;
                color: #333;
                letter-spacing: -0.5px;
            }

            .hero-sub {
                margin-top: 8px;
                display: inline-block;
                padding: 10px 24px;
                font-size: 15px;
                font-weight: 600;
                color: #b07c39;
                background: #fff8ea;
                border-radius: 999px;
            }

            /* 서브 문구 */
            .brand-sub {
                margin-top: 10px;
                font-family: 'Playfair Display', serif;
                font-size: 14px;
                letter-spacing: 4px;
                color: #b28a3a;
                text-transform: uppercase;
            }

            /* 밑줄 장식 */
            .brand-line {
                width: 180px;
                height: 2px;
                margin: 14px auto 0;
                background: linear-gradient(90deg, transparent, #d7b15b, transparent);
            }

            /* 금빛 이동 */
            @keyframes goldShine {
                0% {
                    background-position: -250px 0;
                }

                100% {
                    background-position: 350px 0;
                }
            }

            /* 반짝임 */
            @keyframes twinkle {

                0%,
                100% {
                    opacity: .4;
                    transform: scale(.8) rotate(0deg);
                }

                50% {
                    opacity: 1;
                    transform: scale(1.2) rotate(12deg);
                }
            }

            /* 모바일 */
            @media(max-width:768px) {
                .brand-title {
                    font-size: 52px;
                }

                .brand-sub {
                    font-size: 12px;
                    letter-spacing: 2px;
                }
            }

            /* 설명 문구 */
            .pass-header p {
                margin: 4px 0;
                font-size: 18px;
                color: #666;
                font-weight: 500;
                letter-spacing: -0.2px;
            }

            .pass-header p:first-of-type {
                font-weight: 700;
                color: #3f3f3f;
            }

            .pass-header h2 {
                font-size: 42px;
                font-weight: 800;
                color: var(--text);
                margin-bottom: 12px;
                letter-spacing: -1px;
            }

            .pass-header h2 span {
                color: var(--primary);
            }

            .pass-header p {
                font-size: 17px;
                color: #666;
                margin: 0;
            }

            /* 하단 고급 문구 */
            .pass-header::after {
                content: "REAL REVIEW · SMART CHOICE · HAPPY WEDDING";
                display: block;
                margin-top: 14px;
                font-size: 13px;
                letter-spacing: 3px;
                color: #c59a3f;
                font-weight: 700;
            }

            /* 애니메이션 */
            @keyframes goldMove {
                0% {
                    background-position: 0% center;
                }

                100% {
                    background-position: 300% center;
                }
            }

            @keyframes twinkle {

                0%,
                100% {
                    opacity: .4;
                    transform: scale(.85) rotate(0deg);
                }

                50% {
                    opacity: 1;
                    transform: scale(1.2) rotate(15deg);
                }
            }

            /* 모바일 */
            @media(max-width:768px) {
                .brand-title {
                    font-size: 60px;
                    padding: 18px 18px 8px 34px;
                    transform: translateX(5px);
                }

                .pass-header p {
                    font-size: 15px;
                }

                .pass-header::after {
                    font-size: 11px;
                    letter-spacing: 1.5px;
                }
            }

            /* 카드 영역 */
            .pass-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 28px;
            }

            /* 카드 */
            .pass-card {
                background: rgba(255, 255, 255, .88);
                backdrop-filter: blur(8px);
                border: 1px solid rgba(255, 255, 255, .7);
                border-radius: 24px;
                padding: 35px 28px;
                text-align: center;
                position: relative;
                overflow: hidden;
                box-shadow: var(--shadow);
                transition: .25s ease;
            }

            .pass-card::before {
                content: "";
                position: absolute;
                inset: 0;
                background: linear-gradient(135deg, rgba(232, 138, 162, .08), rgba(124, 141, 181, .05));
                z-index: 0;
            }

            .pass-card>* {
                position: relative;
                z-index: 1;
            }

            .pass-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 45px rgba(0, 0, 0, .12);
            }

            /* 추천 카드 자동 강조 */
            .pass-card:nth-child(2) {
                border: 2px solid var(--primary);
            }

            .pass-card:nth-child(2)::after {
                content: "BEST PASS";
                position: absolute;
                top: 16px;
                right: -34px;
                background: linear-gradient(90deg, var(--primary), var(--primary-dark));
                color: #fff;
                width: 140px;
                padding: 6px 0;
                font-size: 12px;
                font-weight: 800;
                transform: rotate(35deg);
                letter-spacing: 1px;
            }

            /* 이름 */
            .pass-name {
                font-size: 30px;
                font-weight: 800;
                color: #222;
                margin-bottom: 18px;
            }

            /* 가격 */
            .pass-price {
                font-size: 42px;
                font-weight: 900;
                color: var(--primary-dark);
                margin-bottom: 8px;
                line-height: 1;
            }

            .pass-price span {
                font-size: 18px;
                font-weight: 600;
                margin-left: 4px;
                color: #444;
            }

            /* 설명 */
            .pass-review {
                margin: 18px 0 24px;
                color: #666;
                font-size: 15px;
                background: #fafafa;
                padding: 12px;
                border-radius: 12px;
            }

            /* 기능 추가 느낌 */
            .pass-review::before {
                content: "💬 ";
            }

            /* 버튼 */
            .pay-button {
                width: 100%;
                border: none;
                border-radius: 14px;
                padding: 15px;
                font-size: 16px;
                font-weight: 800;
                color: #fff;
                cursor: pointer;
                background: linear-gradient(90deg, var(--primary), var(--primary-dark));
                transition: .2s;
            }

            .pay-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 18px rgba(232, 138, 162, .35);
            }

            /* 모달 */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, .45);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                padding: 20px;
                backdrop-filter: blur(4px);
            }

            .modal-content {
                width: 100%;
                max-width: 520px;
                background: #fff;
                border-radius: 24px;
                padding: 35px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, .18);
                animation: fadeUp .25s ease;
            }

            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal-content h2 {
                font-size: 28px;
                font-weight: 800;
                margin-bottom: 22px;
                color: #222;
            }

            .modal-content p {
                margin-bottom: 10px;
                color: #555;
                font-size: 15px;
            }

            .modal-content hr {
                margin: 20px 0;
                border: none;
                border-top: 1px solid #eee;
            }

            /* 체크박스 */
            .modal-content label {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                padding: 10px 0;
                cursor: pointer;
                color: #444;
                font-size: 15px;
            }

            .modal-content input[type=checkbox] {
                margin-top: 3px;
                transform: scale(1.15);
                accent-color: var(--primary);
            }

            /* 버튼영역 */
            .buttons {
                display: flex;
                gap: 12px;
                margin-top: 28px;
            }

            .buttons button {
                flex: 1;
                border: none;
                border-radius: 14px;
                padding: 14px;
                font-size: 15px;
                font-weight: 800;
                cursor: pointer;
            }

            .buttons button:first-child {
                background: #ececec;
                color: #444;
            }

            .buttons button:last-child {
                background: linear-gradient(90deg, var(--primary), var(--primary-dark));
                color: #fff;
            }

            .buttons button:disabled {
                opacity: .55;
                cursor: not-allowed;
            }

            .sakura {
                position: fixed;
                top: -50px;
                pointer-events: none;
                z-index: 999999;

                width: 28px;
                height: 28px;

                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath fill='%23ff7aa8' d='M32 4c4 8 10 10 18 10-8 4-10 10-10 18 4-8 10-10 18-10-8-4-10-10-10-18-4 8-10 10-18 10-8 0-14-2-18-10 8 0 14-2 18-10z'/%3E%3C/svg%3E");
                background-size: contain;
                background-repeat: no-repeat;

                filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.15));

                animation: sakuraFall linear forwards;
            }

            @keyframes sakuraFall {
                0% {
                    transform: translateY(0) translateX(0) rotate(0deg) scale(1);
                    opacity: 1;
                }

                50% {
                    transform: translateY(50vh) translateX(60px) rotate(180deg) scale(1.2);
                    opacity: 0.9;
                }

                100% {
                    transform: translateY(110vh) translateX(-40px) rotate(720deg) scale(0.9);
                    opacity: 0;
                }
            }

            .pass-description {
                min-height: 70px;
                margin-bottom: 28px;
                padding: 22px 28px;
                border-radius: 18px;
                background: #fcf6f9;
                box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                font-size: 17px;
                font-weight: 600;
                color: #555;
                text-align: center;
                line-height: 1.7;
                transition: .3s ease;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <div class="main">
                    <div class="pass-container">
                        <div class="pass-header">
                            <h2 class="brand-title">MerryViewPass</h2>
                            <!-- <div class="hero-text">
                                <p class="hero-main">실제 신부들의 진짜 경험만 담았습니다</p>
                                <p class="hero-sub">후회 없는 스드메 선택, MerryViewPass에서 시작하세요</p>
                            </div> -->
                        </div>
                        <div class="pass-description">
                            {{ hoverText }}
                        </div>
                        <div class="pass-grid">
                            <div class="pass-card" v-for="pass in passList" @mouseenter="changeDesc(pass)"
                                @mouseleave="resetDesc">

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

        
                            <hr>

                            <!-- 약관 -->
                            <!-- 전체 동의 -->
                            <label>
                                <input type="checkbox" v-model="agreeAll" @change="toggleAll" />
                                전체 동의
                            </label>

                            <hr />

                            <!-- 필수 -->
                            <label>
                                <input type="checkbox" v-model="agreeRequired1" @change="updateAll" />
                                (필수) 결제 및 이용약관 동의
                                <br>
                                현재 가지고 계신 열람권횟수가
                                <br>
                                구매하신 패스의 열람권 개수보다
                                <br>
                                적을경우 환불이 불가합니다!
                            </label>

                            <label>
                                <input type="checkbox" v-model="agreeRequired2" @change="updateAll" />
                                (필수) 개인정보 수집 및 이용 동의
                            </label>

                            <!-- 선택 -->
                            <label>
                                <input type="checkbox" v-model="agreeOptional1" @change="updateAll" />
                                (선택) 마케팅 정보 수신 동의
                            </label>

                            <div class="buttons">
                                <button @click="closeModal">취소</button>
                                <button @click="fnPayment(selectedPass)"
                                    :disabled="!(agreeRequired1 && agreeRequired2) || isPaying">
                                    {{ isPaying ? '결제 진행중...' : '결제하기' }}
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
      
        <jsp:include page="/WEB-INF/common/chat-bot2.jsp" />
     
        <script>
            var IMP = window.IMP;
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
                        isPaying: false,
                        hoverText: "실제 신부들의 진짜 경험만 담았습니다.후회 없는 스드메 선택, MerryViewPass에서 시작하세요",
                        defaultText: "실제 신부들의 진짜 경험만 담았습니다.후회 없는 스드메 선택, MerryViewPass에서 시작하세요",
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnPayment: function (selectedPass) {
                        let self = this;

                        if (self.isPaying) {
                            return;
                        }

                        if (!(this.agreeRequired1 && this.agreeRequired2)) {
                            alert("필수 약관에 동의해주세요");
                            return;
                        }

                        self.isPaying = true;

                        IMP.request_pay(
                            {
                                channelKey: "channel-key-1ebd3d65-20bd-412e-83f3-b7e0c3b368ff",
                                pay_method: "card",
                                merchant_uid: "order_PASS" + self.sessionId + "_" + new Date().getTime(), // 주문 고유 번호
                                name: selectedPass.passName,
                                amount: selectedPass.price,      //제품 가격
                            },
                            function (response) {
                                // 결제 종료 시 호출되는 콜백 함수
                                // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
                                // 결제 결과를 처리하는 로직을 작성합니다.
                                console.log(response);
                                console.log("전체 response:", response);
                                console.log("success:", response.success);
                                console.log("imp_uid:", response.imp_uid);
                                console.log("status:", response.status);
                                console.log("paid_amount:", response.paid_amount);
                                if (response.imp_uid) {
                                    console.log("포트원 번호: " + response.imp_uid);
                                    // 우리쪽 db에 결제정보 저장
                                    // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                    // 결제 성공 후 서버 검증
                                    console.log("imp_uid:", response.imp_uid);
                                    self.fnVerifyPayment(response.imp_uid, response.merchant_uid, selectedPass);
                                } else {
                                    console.log("에러내용: " + response.error_msg);
                                    self.isPaying = false;
                                    console.log(response);
                                    alert("결제가 취소되었습니다");
                                }
                            },
                        );
                    },

                    fnVerifyPayment(imp_uid, merchant_uid, selectedPass) {
                        let self = this
                        console.log("서버로 보내는 imp_uid:", imp_uid);
                        $.ajax({
                            url: "http://localhost:8080/verifyPayment.dox",
                            type: "POST",
                            data: {
                                userId: self.sessionId,     // 로그인 아이디
                                imp_uid: imp_uid,           // 결제 고유 값(중복)
                                merchant_uid: merchant_uid,
                                passNo: selectedPass.passNo,
                                amount: selectedPass.price,
                                itemName: selectedPass.passName,
                                reviewCnt: selectedPass.reviewCnt,
                                type: "PASS"
                            },
                            success: function (res) {
                                console.log(res);
                                if (res.result == "success") {
                                    self.isModalOpen = false;
                                    self.isPaying = false;
                                    console.log("포트원 번호: " + res.imp_uid);
                                    alert("결제가완료되었습니다");
                                    location.href = "/adminPayFinish.do?payNo=" + res.payNo + "&type=PASS";
                                    //예약이면 &type=RES 등록이면 &type=REG
                                } else {
                                    console.log("에러내용: " + res.error_msg);
                                    self.isPaying = false;
                                    alert("결제 검증 실패");
                                }
                            }, error: function (xhr, status, err) {
                                self.isPaying = false;
                                alert("서버 통신 오류");
                                console.log(xhr);
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
                        self.paymentMethod = "";
                        self.agreeAll = false;
                        self.agreeRequired1 = false;
                        self.agreeRequired2 = false;
                        self.agreeOptional1 = false;
                        self.fnCheck(pass);
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

                    closeModal: function () {
                        this.isModalOpen = false;
                        this.selectedPass = null;
                    },

                    changeDesc(pass) {
                        this.hoverText = pass.description || pass.passName + " 상품입니다.";
                    },

                    resetDesc() {
                        this.hoverText = this.defaultText;
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
                    const maxSakura = 40;
                    setInterval(() => {
                        const current = document.querySelectorAll(".sakura").length;

                        if (current >= maxSakura) return;

                        createSakura();
                    }, 150);
                    function createSakura() {
                        const current = document.querySelectorAll(".sakura").length;
                        if (current >= maxSakura) return;
                        const el = document.createElement("div");
                        el.className = "sakura";

                        // 랜덤 위치
                        el.style.left = Math.random() * window.innerWidth + "px";

                        // ❗ 크기 확 키움 (중요)
                        const size = Math.random() * 22 + 8; // 18 ~ 40px
                        el.style.width = size + "px";
                        el.style.height = size + "px";

                        // 속도 다양화
                        const duration = Math.random() * 4 + 4; // 4~8초
                        el.style.animationDuration = duration + "s";

                        // 깊이감 (앞/뒤)
                        el.style.zIndex = Math.random() > 0.5 ? 999999 : 999998;

                        document.body.appendChild(el);

                        setTimeout(() => {
                            el.remove();
                        }, duration * 8000);
                    }
                    setInterval(createSakura, 200);

                    window.addEventListener("beforeunload", () => {
                        clearInterval(sakuraInterval);
                    });
                },
            });
            app.mount('#app');
        </script>
    </body>

    </html>