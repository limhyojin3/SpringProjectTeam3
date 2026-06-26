<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이벤트 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* 하단 빈 배경 제거 */
        html, body {
            min-height: unset !important;
            height: auto !important;
        }
        body {
            background: linear-gradient(180deg, #eaf6fb 0%, #ffffff 400px, #ffffff 100%);
        }

        .container-layout {
            min-height: unset !important;
        }
        /* ── 히어로 ── */
        .event-hero {
            width: 100%;
            height: 400px;
            background-image: url('/img/event/event2.jpg');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            background-color: white;
            display: flex;
            padding-top: 20px;
            padding-bottom: 60px;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            text-align: center;
            position: relative;
            overflow: hidden;
            color: #fff0f5;
            text-shadow: 2px 1px 1px rgb(97, 179, 255);
        }


        .event-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                linear-gradient(to right, rgba(234,246,251,0.85) 0%, rgba(255,255,255,0.1) 20%, rgba(255,255,255,0.1) 80%, rgba(234,246,251,0.85) 100%),
                linear-gradient(to bottom, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.2) 60%, rgba(255,255,255,0.95) 100%);
            z-index: 1;
        }

        /* 하단 그라데이션 페이드 */
        .event-hero::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 100px;
            background: linear-gradient(to bottom, transparent, white);
            z-index: 1;
        }

        /* ── 본문 ── */
        .event-body {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 24px 100px;
        }

        /* ── 섹션 타이틀 ── */
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #2c2c2c;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid #ffe4ec;
        }

        .section-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            background: #7ec8d8;
            color: white;
            letter-spacing: 0.04em;
        }

        .section-badge.always {
            background: #9b8fd4;
        }

        /* ── 고정 이벤트 그리드 ── */
        .fixed-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);  /* ✅ 3열 그리드 */
            gap: 20px;
            margin-bottom: 60px;
        }


        .fixed-card {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            animation: fadeUp 0.6s ease forwards;
            opacity: 0;
            display: flex;
            flex-direction: column;  /* ✅ 이미지 위, 텍스트 아래 */
            cursor:pointer;
            border: none; /* 추가 */
        }


        .fixed-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px rgba(244,160,150,0.25);
        }

        .fixed-card:nth-child(1) { animation-delay: 0.1s; }
        .fixed-card:nth-child(2) { animation-delay: 0.2s; }
        .fixed-card:nth-child(3) { animation-delay: 0.3s; }
        .fixed-card:nth-child(4) { animation-delay: 0.4s; }

        .fixed-card-top {
            width: 100%;
            height: 220px;  /* ✅ 이미지 높이 */
            background-size: cover;
            background-position: center;
            flex-shrink: 0;
        }

        .fixed-card-top .card-emoji {
            font-size: 36px;
            color: white;
            opacity: 0.9;
        }

        .fixed-card-top .card-brand {
            font-size: 13px;
            font-weight: 700;
            color: white;
            opacity: 0.9;
        }

        .fixed-card-body {
            background: white;
            padding: 24px 24px 28px;
            flex: 1;
        }

        .fixed-card-body .condition {
            font-size: 12px;
            color: #aaa;
            margin-bottom: 6px;
        }

        .fixed-card-body .reward {
            font-size: 15px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .fixed-card-body .gift-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            background: #eaf6fb;
            color: #5bbdd0;
            border: 1px solid #b8e0f0;
        }

        /* ── 상시 이벤트 리스트 ── */
        .always-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 60px;
        }

        .always-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            animation: fadeUp 0.6s ease forwards;
            opacity: 0;
            display: flex;
            flex-direction: column;
            cursor: pointer;
            padding: 0;  /* 기존 패딩 제거 */
            gap: 0;
        }

        .always-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px rgba(244,160,150,0.25);
        }
        .always-card:nth-child(1) { animation-delay: 0.4s; }
        .always-card:nth-child(2) { animation-delay: 0.5s; }
        .always-card:nth-child(3) { animation-delay: 0.6s; }

        .always-icon {
            width: 72px;
            height: 72px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            flex-shrink: 0;
        }

        .always-card-img {
            width: 100%;
            height: 220px;
            background-size: cover;
            background-position: center;
            flex-shrink: 0;
        }

        .always-card-body {
            background: white;
            padding: 24px 24px 28px;
            flex: 1;
        }

        .always-card-body .always-tag {
            font-size: 11px;
            font-weight: 700;
            color: #5bbdd0;
            background: #eaf6fb;
            padding: 3px 10px;
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 10px;
        }

        .always-card-body h3 {
            font-size: 15px;
            font-weight: 700;
            color: #333;
            margin-bottom: 6px;
        }

        .always-card-body p {
            font-size: 12px;
            color: #aaa;
            margin-bottom: 10px;
            line-height: 1.6;
        }

        .always-card-body .gift-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            background: #eaf6fb;
            color: #5bbdd0;
            border: 1px solid #b8e0f0;
        }

        .always-content { flex: 1; }

        .always-content .always-tag {
            font-size: 11px;
            font-weight: 700;
            color: #5bbdd0;
            background: #eaf6fb;
            padding: 3px 10px;
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 8px;
        }

        .always-content h3 {
            font-size: 17px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 6px;
        }

        .always-content p {
            font-size: 13px;
            color: #888;
            margin: 0;
            line-height: 1.6;
        }

        .always-reward {
            text-align: center;
            flex-shrink: 0;
        }

        .always-reward .reward-icon {
            font-size: 24px;
            color: #9b8fd4;
        }

        .always-reward .reward-text {
            font-size: 11px;
            color: #aaa;
            margin-top: 4px;
        }

        /* ── 애니메이션 ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── 반응형 ── */
        @media (max-width: 768px) {
            .fixed-grid { grid-template-columns: 1fr; }
            .always-card { flex-direction: column; text-align: center; }
        }
        /* 준비중 모달 */
        .prep-modal-bg {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 999;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .prep-modal {
            background: white;
            border-radius: 20px;
            padding: 48px 40px;
            text-align: center;
            width: 340px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            animation: modalPop 0.2s ease;
        }

        @keyframes modalPop {
            from { transform: scale(0.88); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
        }

        .prep-modal .prep-icon { font-size: 52px; margin-bottom: 16px; }
        .prep-modal h3 { font-size: 20px; font-weight: 700; color: #2c2c2c; margin-bottom: 8px; }
        .prep-modal p  { font-size: 13px; color: #aaa; line-height: 1.7; margin-bottom: 24px; }
        .prep-modal-btn {
            padding: 10px 32px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
        }
        .event-deco-left  { position:absolute; font-size:140px; opacity:0.08; top:-20px; left:-20px; color:white; }
        .event-deco-right { position:absolute; font-size:120px; opacity:0.08; bottom:-10px; right:-10px; color:white; }

        .summer-deco-wrap {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }

        .summer-deco {
            position: absolute;
            color: #a8dde9;
            opacity: 0.3;
        }

        /* 본문이 데코 위에 오도록 */
        .event-hero,
        .event-body {
            position: relative;
            z-index: 1;
        }

        .event-hero-title {
            width: 800px;
            max-width: 90%;
            position: relative;
            z-index: 2;
            margin-bottom: 50px;
        }

    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 준비중 모달 -->
        <div class="prep-modal-bg" v-if="showPrep" @click.self="showPrep = false">
            <div class="prep-modal">
                <div class="prep-icon"><i class="fas fa-tools"></i></div>
                <h3>이벤트 준비 중입니다!</h3>
                <p>더 좋은 혜택으로 곧 찾아올게요.<br>조금만 기다려주세요<i class="fas fa-heart" style="color:#f4a096;"></i></p>
                <button class="prep-modal-btn" @click="showPrep = false">확인</button>
            </div>
        </div>
        <!-- 여름 배경 데코 -->
        <div class="summer-deco-wrap">
            <i class="fas fa-fish summer-deco" style="top:8%; left:3%; font-size:120px; transform:rotate(20deg);"></i>
            <i class="fas fa-sun summer-deco" style="top:15%; right:5%; font-size:150px;"></i>
            <i class="fas fa-water summer-deco" style="top:40%; left:1%; font-size:100px;"></i>
            <i class="fas fa-umbrella-beach summer-deco" style="top:55%; right:2%; font-size:130px;"></i>
            <i class="fas fa-fish summer-deco" style="top:70%; left:5%; font-size:90px; transform:rotate(-15deg) scaleX(-1);"></i>
            <i class="fas fa-sun summer-deco" style="top:80%; right:6%; font-size:110px;"></i>
            <i class="fas fa-water summer-deco" style="top:90%; left:2%; font-size:80px;"></i>
        </div>
        <!-- 히어로 -->
        <div class="event-hero">
            <i class="fas fa-sun event-deco-left"></i>
            <img src="/img/event/marry_view_summer_hero_title_v4.svg" alt="MarryView Summer Event" class="event-hero-title">
            <i class="fas fa-umbrella-beach event-deco-right"></i>
        </div>

        <div class="event-body">

            <!-- 고정 이벤트 -->
            <div class="section-title">
                 <div class="reward-icon"><i class="fas fa-gift"></i></div>메리뷰 시즌 이벤트
                <span class="section-badge">~8월</span>
            </div>

            <div class="fixed-grid">
                <!-- 가족 사진 자랑 -->
                <div class="fixed-card"  @click="goEvent(1)">
                    <div class="fixed-card-top" style="background-image: url('/img/event/event_img1.jpg'); background-size: cover; background-position: center;">
                    </div>
                    <div class="fixed-card-body">
                        <div class="fixed-card-body-text">
                            <p class="condition">가족 사진을 올려주세요!</p>
                            <p class="reward">Team 가족 모여라! 가족 사진 자랑</p>
                            <span class="gift-badge"><i class="fas fa-gift"></i> 제주도 비행기 티켓 지원</span>
                        </div>
                    </div>
                </div>

                <!-- 여름 휴가비 지원 -->
                <div class="fixed-card"  @click="goEvent(2)">
                    <div class="fixed-card-top" style="background-image: url('/img/event/event_img5.jpg'); background-size: cover; background-position: center;">
                    </div>
                    <div class="fixed-card-body">
                        <div class="fixed-card-body-text">
                            <p class="condition">여름 휴가 사진 리뷰 등록 시</p>
                            <p class="reward">여름 휴가비 지원 이벤트</p>
                            <span class="gift-badge"><i class="fas fa-gift"></i> 휴가비 50만원 지원!</span>
                        </div>
                    </div>
                </div>
                <!-- 신혼부부 응모 -->
                <div class="fixed-card"  @click="goEvent(3)">
                    <div class="fixed-card-top" style="background-image: url('/img/event/event_img6.jpg'); background-size: cover; background-position: center;">
                    </div>
                    <div class="fixed-card-body">
                        <div class="fixed-card-body-text">
                            <p class="condition">신혼부부 인증 후 응모 시</p>
                            <p class="reward">신혼부부 응모! 신혼가전 지원!</p>
                            <span class="gift-badge"><i class="fas fa-gift"></i> LG 냉장고 지원</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 상시 이벤트 -->
            <div class="section-title">
                <i class="fas fa-wand-magic-sparkles"></i> 고정 이벤트
                <span class="section-badge always">고정</span>
            </div>

            <div class="always-list">
                <!-- 브라이덜샤워 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-card-img" style="background-image: url('/img/event/always_img1.jpg');"></div>
                    <div class="always-card-body">
                        <span class="always-tag">BRIDAL SHOWER</span>
                        <h3>브라이덜샤워 이벤트</h3>
                        <p>마이페이지에서 결혼 예정일을 입력하면<br>특별한 쿠폰 혜택을 드려요!</p>
                        <span class="gift-badge"><i class="fas fa-gift"></i> 쿠폰 발급</span>
                    </div>
                </div>

                <!-- 첫돌 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-card-img" style="background-image: url('/img/event/always_img2.jpg');"></div>
                    <div class="always-card-body">
                        <span class="always-tag">FIRST BIRTHDAY</span>
                        <h3>우리 아이 첫돌 사진 리뷰 이벤트</h3>
                        <p>소중한 첫돌 사진을 메리뷰에 리뷰로 남겨주세요!<br>베스트 리뷰 선정 시 기프트콘을 드립니다</p>
                        <span class="gift-badge"><i class="fas fa-gift"></i> 기프트콘 증정</span>
                    </div>
                </div>

                <!-- 내가 제일 잘나가 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-card-img" style="background-image: url('/img/event/always_img3.jpg');"></div>
                    <div class="always-card-body">
                        <span class="always-tag">BEST WEDDING</span>
                        <h3>내가 제일 잘나가 이벤트</h3>
                        <p>제일로 즐거운 결혼식 사진을 올려주세요!<br>콘테스트 선정 시 푸짐한 기프트콘을 드립니다</p>
                        <span class="gift-badge"><i class="fas fa-gift"></i> 기프트콘 증정</span>
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
                    showPrep: false
                };
            },
            methods: {
                goEvent(id) {
                    window.location.href = '/eventDetail.do?eventId=' + id;
                }
            }
        });
        
        app.mount('#app');
    </script>
</body>
</html>