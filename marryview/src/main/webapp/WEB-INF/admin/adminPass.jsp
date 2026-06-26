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
                    radial-gradient(circle at top left, rgba(255, 238, 244, 0.95) 0%, transparent 36%),
                    radial-gradient(circle at right bottom, rgba(255, 228, 236, 0.75) 0%, transparent 34%),
                    linear-gradient(180deg, #fff0f5 0%, #fff8fb 420px, #ffffff 100%) !important;
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
                background: rgba(255, 255, 255, .92);
                backdrop-filter: blur(8px);
                border: 1.5px solid rgba(232, 138, 162, .28);
                border-radius: 24px;
                padding: 35px 28px;
                text-align: center;
                position: relative;
                overflow: hidden;
                box-shadow: 0 14px 32px rgba(232, 138, 162, .10);
                transition: transform .28s ease, box-shadow .28s ease, border-color .28s ease;
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
                border-color: rgba(232, 138, 162, .55);
                box-shadow: 0 22px 48px rgba(232, 138, 162, .18);
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
                color: #7a5d66;
                font-size: 15px;
                font-weight: 600;
                background: rgba(255, 248, 251, .58);
                border: 1px solid rgba(232, 138, 162, .12);
                padding: 11px 12px;
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



            .sakura {
                position: fixed;
                top: -50px;
                pointer-events: none;
                z-index: 999999;

                width: 28px;
                height: 28px;

                background-image: url("../../img/sakura3.png");
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
                min-height: 58px;
                margin: 0 auto 30px;
                padding: 0 24px;
                background: transparent;
                box-shadow: none;
                border-radius: 0;
                font-size: 17px;
                font-weight: 600;
                color: #6f5d66;
                text-align: center;
                line-height: 1.7;
                max-width: 900px;
                opacity: 1;
                transform: translateY(0);
                transition: opacity .45s ease, transform .45s ease;
            }

            .pass-description.is-fading {
                opacity: 0;
                transform: translateY(6px);
            }

            /* ===== 결제 모달 ===== */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(15, 15, 15, .55);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 99999;
                padding: 20px;
                backdrop-filter: blur(6px);
            }

            .modal-content {
                width: 100%;
                max-width: 620px;
                max-height: 90vh;
                overflow-y: auto;
                background: linear-gradient(180deg, #ffffff, #fff8fb);
                border-top-left-radius: 28px;
                border-bottom-left-radius: 28px;
                padding: 34px;
                box-shadow: 0 30px 70px rgba(0, 0, 0, .18);
                animation: modalShow .25s ease;
            }

            @keyframes modalShow {
                from {
                    opacity: 0;
                    transform: translateY(30px) scale(.96);
                }

                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .modal-content h2 {
                text-align: center;
                font-size: 28px;
                font-weight: 800;
                margin-bottom: 28px;
                color: #d86f8c;
            }

            /* 상품요약 */
            .modal-summary {
                background: #fff;
                border-radius: 18px;
                padding: 18px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, .05);
                margin-bottom: 20px;
            }

            .modal-summary p {
                display: flex;
                justify-content: space-between;
                margin: 10px 0;
                font-size: 15px;
            }

            .modal-summary span {
                color: #777;
            }

            .modal-summary strong {
                color: #222;
                font-weight: 800;
            }

            /* 모달 스크롤바 */
            .modal-content::-webkit-scrollbar {
                width: 6px !important;
            }

            .modal-content::-webkit-scrollbar-track {
                background: #fff5f7 !important;
                border-radius: 10px !important;
            }

            .modal-content::-webkit-scrollbar-thumb {
                background: #f3a6b8 !important;
                border-radius: 10px !important;
            }

            .modal-content::-webkit-scrollbar-thumb:hover {
                background: #ec6f8f !important;
            }

            /* 쿠폰 */
            .coupon-box {
                background: #fff;
                border-radius: 18px;
                padding: 18px;
                margin-bottom: 20px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, .05);
            }

            .coupon-title {
                font-weight: 800;
                margin-bottom: 14px;
                color: #444;
            }

            .coupon-row {
                display: flex;
                gap: 10px;
            }

            .coupon-row select {
                flex: 1;
                height: 46px;
                border: 1px solid #eee;
                border-radius: 12px;
                padding: 0 14px;
                outline: none;
            }

            .coupon-row button {
                width: 110px;
                border: none;
                border-radius: 12px;
                background: linear-gradient(90deg, #e88aa2, #d86f8c);
                color: #fff;
                font-weight: 700;
            }

            .discount-info {
                margin-top: 12px;
                font-size: 14px;
                color: #666;
            }

            /* 금액 */
            .total-box {
                background: #fff;
                border-radius: 18px;
                padding: 18px;
                margin-bottom: 20px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, .05);
            }

            .total-box p {
                display: flex;
                justify-content: space-between;
                margin: 10px 0;
            }

            .final-price {
                margin-top: 14px !important;
                padding-top: 14px;
                border-top: 1px dashed #eee;
                font-size: 20px;
                font-weight: 900;
                color: #d86f8c;
            }

            /* 약관 */
            .terms-wrap {
                background: #fff;
                border-radius: 18px;
                padding: 18px;
                margin-bottom: 22px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, .05);
            }

            .terms-wrap label {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 10px 0;
                font-size: 14px;
                cursor: pointer;
            }

            .terms-wrap input {
                width: 18px;
                height: 18px;
            }

            /* 버튼 */
            .buttons {
                display: flex;
                gap: 12px;
            }

            .buttons button {
                flex: 1;
                height: 52px;
                border: none;
                border-radius: 14px;
                font-size: 16px;
                font-weight: 800;
            }

            .buttons button:first-child {
                background: #f1f1f1;
                color: #555;
            }

            .buttons button:last-child {
                background: linear-gradient(90deg, #e88aa2, #d86f8c);
                color: #fff;
                box-shadow: 0 10px 18px rgba(232, 138, 162, .35);
            }

            .buttons button:disabled {
                opacity: .5;
                cursor: not-allowed;
            }

            .terms-notice {
                font-size: 12px;
                color: #777;
                margin-top: 6px;
                line-height: 1.4;
            }

            /* 모바일 */
            @media(max-width:768px) {
                .modal-content {
                    padding: 22px;
                    border-radius: 22px;
                }

                .coupon-row {
                    flex-direction: column;
                }

                .coupon-row button {
                    width: 100%;
                    height: 46px;
                }

                .buttons {
                    flex-direction: column;
                }
            }

            /* 잘팔린거!!!! */
            .best-pass-card {
                border: 2px solid rgba(216, 111, 140, .75);
                box-shadow:
                    0 18px 46px rgba(216, 111, 140, .24),
                    0 0 0 5px rgba(232, 138, 162, .10);
                transform: translateY(-4px);
            }

            .best-pass-card:hover {
                transform: translateY(-12px);
                border-color: rgba(216, 111, 140, .95);
                box-shadow:
                    0 24px 58px rgba(216, 111, 140, .30),
                    0 0 0 6px rgba(232, 138, 162, .16);
            }

            .best-pass-card::before {
                background:
                    linear-gradient(135deg, rgba(232, 138, 162, .16), rgba(255, 248, 234, .18));
            }

            .best-pass-badge {
                position: absolute;
                top: 14px;
                right: 14px;
                padding: 7px 14px;
                border-radius: 999px;
                background: linear-gradient(135deg, #ff6b8a, #d86f8c);
                color: white;
                font-size: 12px;
                font-weight: 900;
                letter-spacing: 1px;
                box-shadow: 0 8px 18px rgba(216, 111, 140, .35);
                z-index: 2;
            }

            .best-pass-card .pass-review {
                background: rgba(255, 249, 237, .62);
                border-color: rgba(217, 178, 111, .22);
                color: #7a5a2c;
            }

            .pass-sales-count {
                margin-top: 10px;
                color: #ff5c7a;
                font-size: 13px;
                font-weight: 700;
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
                            <h2 class="brand-title">MarryViewPass</h2>
                        </div>
                        <div class="pass-description" :class="{ 'is-fading': descFading }">
                            {{ hoverText }}
                        </div>
                        <div class="pass-grid">
                            <div class="pass-card" v-for="pass in passList" :key="pass.passNo"
                                :class="{ 'best-pass-card': pass.passNo == bestPassNo }" @mouseenter="changeDesc(pass)"
                                @mouseleave="resetDesc">

                                <div v-if="pass.passNo == bestPassNo" class="best-pass-badge">
                                    BEST
                                </div>

                                <div class="pass-name">{{ pass.passName }}</div>

                                <div class="pass-price">
                                    {{ pass.price.toLocaleString() }}원
                                </div>

                                <div class="pass-review">
                                    열람 가능한 리뷰 수: {{ pass.reviewCnt }}개
                                </div>

                                <div class="pass-sales-count" v-if="Number(pass.soldCount || 0) > 0">
                                    지금까지 {{ pass.soldCount }}명이 선택했어요
                                </div>

                                <button class="pay-button" @click="openModal(pass)">
                                    결제하기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 모달 -->
            <div v-if="isModalOpen" class="modal-overlay" @click="closeModal">
                <div class="modal-content" @click.stop>

                    <h2>✨ 결제 확인</h2>

                    <!-- 상품 요약 -->
                    <div class="modal-summary">
                        <p>
                            <span>상품명</span>
                            <strong>{{ selectedPass.passName }}</strong>
                        </p>
                        <p>
                            <span>열람 리뷰 수</span>
                            <strong>{{ selectedPass.reviewCnt }}개</strong>
                        </p>
                        <p>
                            <span>기본 금액</span>
                            <strong>{{ selectedPass.price.toLocaleString() }}원</strong>
                        </p>
                    </div>

                    <!-- 쿠폰 적용 -->
                    <div class="coupon-box">
                        <div class="coupon-title">🎁 쿠폰 할인 적용</div>

                        <div class="coupon-row">
                            <select v-model="selectedCoupon">
                                <option :value="null">쿠폰을 선택해주세요</option>
                                <option v-for="coupon in couponList" :value="coupon">
                                    {{ coupon.couponName }}
                                    ({{ coupon.discountRate }}% 할인 / D-{{ coupon.dday }})
                                </option>
                            </select>

                            <!-- 적용 전 -->
                            <button v-if="!isCouponApplied" @click="applyCoupon">

                                쿠폰적용
                            </button>

                            <!-- 적용 후 -->
                            <button v-else @click="cancelCoupon">

                                쿠폰취소
                            </button>
                        </div>
                        <div class="discount-info" v-if="selectedCoupon">
                            선택 쿠폰 :
                            {{ selectedCoupon.couponName }}
                        </div>
                    </div>

                    <!-- 결제 금액 -->
                    <div class="total-box">
                        <p>
                            <span>상품 금액</span>
                            <span>{{ selectedPass.price.toLocaleString() }}원</span>
                        </p>

                        <p>
                            <span>쿠폰 할인</span>
                            <span>- {{ discountAmount.toLocaleString() }}원</span>
                        </p>

                        <p class="final-price">
                            <span>최종 결제 금액</span>
                            <span>{{ finalPrice.toLocaleString() }}원</span>
                        </p>
                    </div>

                    <!-- 약관 -->
                    <div class="terms-wrap">

                        <label>
                            <input type="checkbox" v-model="agreeAll" @change="toggleAll">
                            전체 동의
                        </label>

                        <label>
                            <input type="checkbox" v-model="agreeRequired1" @change="updateAll">

                            (필수) 결제 및 이용약관 동의
                        </label>
                        <div class="terms-notice">
                            본 상품에 사용된 쿠폰은 결제성공 시 즉시 소멸되며, 환불 처리 되더라도 복구되지 않습니다. <br>
                            아울러 패스 이용 중 일부 열람권이 사용된 경우, 잔여 이용 가능 횟수에 따라 환불이 제한될 수 있습니다.
                        </div>

                        <label>
                            <input type="checkbox" v-model="agreeRequired2" @change="updateAll">

                            (필수) 개인정보 수집 및 이용 동의
                        </label>

                        <label>
                            <input type="checkbox" v-model="agreeOptional1" @change="updateAll">

                            (선택) 이벤트/마케팅 정보 수신 동의
                        </label>

                    </div>

                    <!-- 버튼 -->
                    <div class="buttons">
                        <button @click="closeModal">
                            취소
                        </button>

                        <button @click="fnPayment(selectedPass)"
                            :disabled="!(agreeRequired1 && agreeRequired2) || isPaying">

                            {{ isPaying ? '결제 진행중...' : finalPrice.toLocaleString() + '원 결제하기' }}

                        </button>
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
                        hoverText: "실제 신부들의 진짜 경험만 담았습니다.후회 없는 스드메 선택, MarryViewPass에서 시작하세요",
                        defaultText: "실제 신부들의 진짜 경험만 담았습니다.후회 없는 스드메 선택, MarryViewPass에서 시작하세요",
                        descFading: false,
                        couponList: [],
                        selectedCoupon: null,
                        isCouponApplied: false,
                        discountAmount: 0,
                        finalPrice: 0,
                    };
                },
                computed: {
                    bestPassNo: function () {
                        if (!this.passList || this.passList.length === 0) {
                            return null;
                        }

                        // 체험용 패스(passNo 1)는 인기 순위에서 제외
                        const paidPassList = this.passList.filter(function (pass) {
                            return Number(pass.passNo) !== 1;
                        });

                        if (paidPassList.length === 0) {
                            return null;
                        }

                        const bestPass = paidPassList.reduce(function (best, current) {
                            return Number(current.soldCount || 0) >
                                Number(best.soldCount || 0)
                                ? current
                                : best;
                        });

                        // 판매 기록이 하나도 없으면 배지를 표시하지 않음
                        return Number(bestPass.soldCount || 0) > 0
                            ? bestPass.passNo
                            : null;
                    }
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
                                amount: self.finalPrice,      //제품 가격
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
                                if (response.success === true) {
                                    // 우리쪽 db에 결제정보 저장
                                    // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                    // 결제 성공 후 서버 검증
                                    console.log("imp_uid:", response.imp_uid);
                                    self.fnVerifyPayment(response.imp_uid, response.merchant_uid, selectedPass);
                                } else {
                                    console.log("에러내용: " + response.error_msg);
                                    self.isPaying = false;
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
                                couponCode: self.selectedCoupon ? self.selectedCoupon.couponCode : "",
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
                                    alert("결제가 완료 되었습니다");
                                    location.href = "/adminPayFinish.do?payNo=" + res.payNo + "&type=PASS";
                                    //예약이면 &type=RES 등록이면 &type=REG
                                } else {
                                    console.log("에러내용: " + res.message);
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
                                    self.fnGetCouponList();
                                    console.log(self.selectedPass);
                                }
                            });
                        } else {
                            self.selectedPass = pass;
                            self.isModalOpen = true;
                            console.log(self.selectedPass);
                            self.fnGetCouponList();
                        }
                    },
                    fnGetCouponList: function () {
                        let self = this;

                        $.ajax({
                            url: "http://localhost:8080/couponUseList.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                userId: self.sessionId,
                                pageSize: 10,
                                offSet: 0,
                                status: "UNUSED"
                            },
                            success: function (data) {
                                console.log("쿠폰목록", data);

                                if (data.result == "success") {
                                    self.couponList = data.list;
                                } else {
                                    self.couponList = [];
                                }
                            },
                            error: function () {
                                self.couponList = [];
                                alert("쿠폰 조회 실패");
                            }
                        });
                    },
                    applyCoupon: function () {
                        let self = this;
                        if (!self.selectedCoupon || typeof self.selectedCoupon !== "object") {
                            alert("쿠폰을 선택해주세요.");
                            return;
                        }

                        let coupon = self.selectedCoupon;

                        self.discountAmount =
                            Math.floor(self.selectedPass.price *
                                coupon.discountRate / 100);
                        self.finalPrice =
                            self.selectedPass.price - self.discountAmount;

                        self.isCouponApplied = true;

                        if (self.finalPrice < 0) {
                            self.finalPrice = 0;
                        }
                    },

                    cancelCoupon: function () {

                        let self = this;

                        self.selectedCoupon = null;
                        self.discountAmount = 0;
                        self.finalPrice = self.selectedPass.price;
                        self.isCouponApplied = false;
                    },
                    openModal: function (pass) {
                        let self = this;
                        self.paymentMethod = "";
                        self.agreeAll = false;
                        self.agreeRequired1 = false;
                        self.agreeRequired2 = false;
                        self.agreeOptional1 = false;
                        self.selectedCoupon = null;
                        self.discountAmount = 0;
                        self.finalPrice = pass.price;
                        self.couponCode = "";
                        self.couponList = [];
                        self.fnCheck(pass);
                        self.isCouponApplied = false;
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
                        this.selectedCoupon = null;
                        this.isCouponApplied = false;
                        this.discountAmount = 0;
                        this.finalPrice = 0;
                        this.couponCode = "";
                        this.couponList = [];
                    },

                    changeDesc(pass) {
                        this.descFading = true;

                        setTimeout(() => {
                            this.hoverText = pass.description || pass.passName + " 상품입니다.";
                            this.descFading = false;
                        }, 180);
                    },

                    resetDesc() {
                        this.descFading = true;

                        setTimeout(() => {
                            this.hoverText = this.defaultText;
                            this.descFading = false;
                        }, 180);
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
                    window.addEventListener("keydown", function (e) {
                        if (e.key === "Escape" && self.isModalOpen) {
                            self.closeModal();
                        }
                    });

                    function createSakura() {
                        const current = document.querySelectorAll(".sakura").length;
                        if (current >= maxSakura) return;
                        const el = document.createElement("div");
                        el.className = "sakura";

                        // 랜덤 위치
                        el.style.left = Math.random() * window.innerWidth + "px";

                        const size = Math.random() * 22 + 8;
                        el.style.width = size + "px";
                        el.style.height = size + "px";


                        const duration = Math.random() * 4 + 4;
                        el.style.animationDuration = duration + "s";

                        // 깊이감 (앞/뒤)
                        el.style.zIndex = Math.random() > 0.5 ? 999999 : 999998;

                        document.body.appendChild(el);

                        setTimeout(() => {
                            el.remove();
                        }, duration * 3000);
                    }

                    const maxSakura = 40;
                    const sakuraInterval = setInterval(() => {
                        const current = document.querySelectorAll(".sakura").length;

                        if (current >= maxSakura) return;

                        createSakura();
                    }, 150);
                    setTimeout(() => {
                        clearInterval(sakuraInterval);
                    }, 60000);

                    window.addEventListener("beforeunload", () => {
                        clearInterval(sakuraInterval);
                    });
                },
            });
            app.mount('#app');
        </script>
    </body>

    </html>