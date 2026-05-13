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
        /* ── 히어로 ── */
        .event-hero {
            width: 100%;
            height: 280px;
            background: linear-gradient(135deg, #ffc7c2 0%, #f4a096 60%, #e8887a 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .event-hero::before {
            content: '🎉';
            position: absolute;
            font-size: 200px;
            opacity: 0.08;
            top: -30px;
            left: -30px;
        }

        .event-hero::after {
            content: '💍';
            position: absolute;
            font-size: 160px;
            opacity: 0.08;
            bottom: -20px;
            right: -10px;
        }

        .event-hero h1 {
            font-family: Georgia, serif;
            font-style: italic;
            font-size: 42px;
            color: white;
            margin: 0 0 8px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .event-hero p {
            font-size: 15px;
            color: rgba(255,255,255,0.9);
            margin: 0;
        }

        /* ── 본문 ── */
        .event-body {
            max-width: 1000px;
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
            border-bottom: 2px solid #f4a096;
        }

        .section-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            background: #f4a096;
            color: white;
            letter-spacing: 0.04em;
        }

        .section-badge.always {
            background: #9b8fd4;
        }

        /* ── 고정 이벤트 그리드 ── */
        .fixed-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
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
        }

        .fixed-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px rgba(244,160,150,0.25);
        }

        .fixed-card:nth-child(1) { animation-delay: 0.1s; }
        .fixed-card:nth-child(2) { animation-delay: 0.2s; }
        .fixed-card:nth-child(3) { animation-delay: 0.3s; }

        .fixed-card-top {
            height: 130px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
        }

        .fixed-card-top .card-emoji {
            font-size: 40px;
        }

        .fixed-card-top .card-brand {
            font-size: 13px;
            font-weight: 700;
            color: white;
            opacity: 0.9;
        }

        .fixed-card-body {
            background: white;
            padding: 18px 20px;
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
            background: #fff4f3;
            color: #f4a096;
            border: 1px solid #ffd1d1;
        }

        /* ── 상시 이벤트 리스트 ── */
        .always-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .always-card {
            background: white;
            border: 1px solid #f0e0e0;
            border-radius: 16px;
            padding: 28px 32px;
            display: flex;
            align-items: center;
            gap: 28px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
            transition: transform 0.2s, box-shadow 0.2s;
            animation: fadeUp 0.6s ease forwards;
            opacity: 0;
            cursor: pointer;
        }

        .always-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 28px rgba(155,143,212,0.2);
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

        .always-content { flex: 1; }

        .always-content .always-tag {
            font-size: 11px;
            font-weight: 700;
            color: #9b8fd4;
            background: #f5f3ff;
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

        .always-reward .reward-icon { font-size: 28px; }

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

    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 준비중 모달 -->
        <div class="prep-modal-bg" v-if="showPrep" @click.self="showPrep = false">
            <div class="prep-modal">
                <div class="prep-icon">🛠️</div>
                <h3>이벤트 준비 중입니다!</h3>
                <p>더 좋은 혜택으로 곧 찾아올게요.<br>조금만 기다려주세요 💕</p>
                <button class="prep-modal-btn" @click="showPrep = false">확인</button>
            </div>
        </div>
        <!-- 히어로 -->
        <div class="event-hero">
            <h1>MarryView Events</h1>
            <p>메리뷰와 함께하는 다양한 이벤트를 만나보세요 💕</p>
        </div>

        <div class="event-body">

            <!-- 고정 이벤트 -->
            <div class="section-title">
                🎁 기프트콘 지급 이벤트
                <span class="section-badge">고정</span>
            </div>

            <div class="fixed-grid">

                <!-- 투썸 -->
                <div class="fixed-card">
                    <div class="fixed-card-top" style="background: linear-gradient(135deg, #7B1C2A, #a83248);">
                        <span class="card-emoji">🎂</span>
                        <span class="card-brand">TWOSOME PLACE</span>
                    </div>
                    <div class="fixed-card-body">
                        <p class="condition">유료 리뷰 좋아요 30개 이상 달성 시</p>
                        <p class="reward">투썸플레이스 케이크 조각 🎁</p>
                        <span class="gift-badge">기프트콘 자동 발급</span>
                    </div>
                </div>

                <!-- CU -->
                <div class="fixed-card">
                    <div class="fixed-card-top" style="background: linear-gradient(135deg, #5B2D8E, #7b3fb5);">
                        <span class="card-emoji">🛒</span>
                        <span class="card-brand">CU</span>
                    </div>
                    <div class="fixed-card-body">
                        <p class="condition">무료 리뷰 좋아요 40개 이상 달성 시</p>
                        <p class="reward">CU 편의점 3,000원권 🎁</p>
                        <span class="gift-badge">기프트콘 자동 발급</span>
                    </div>
                </div>

                <!-- 스타벅스 -->
                <div class="fixed-card">
                    <div class="fixed-card-top" style="background: linear-gradient(135deg, #00704A, #00a86b);">
                        <span class="card-emoji">☕</span>
                        <span class="card-brand">STARBUCKS</span>
                    </div>
                    <div class="fixed-card-body">
                        <p class="condition">결혼 기념일 당일 로그인 시</p>
                        <p class="reward">스타벅스 아메리카노 Tall ☕</p>
                        <span class="gift-badge">기프트콘 자동 발급</span>
                    </div>
                </div>

            </div>

            <!-- 상시 이벤트 -->
            <div class="section-title">
                ✨ 상시 이벤트
                <span class="section-badge always">상시</span>
            </div>

            <div class="always-list">

                <!-- 브라이덜샤워 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-icon" style="background:#fff0f5;">🎀</div>
                    <div class="always-content">
                        <span class="always-tag">BRIDAL SHOWER</span>
                        <h3>브라이덜샤워 이벤트</h3>
                        <p>마이페이지에서 결혼 예정일을 입력하면 특별한 쿠폰 혜택을 드려요!<br>예비 신부님들의 설레는 준비를 메리뷰가 함께합니다 💍</p>
                    </div>
                    <div class="always-reward">
                        <div class="reward-icon">🎟️</div>
                        <div class="reward-text">쿠폰 발급</div>
                    </div>
                </div>

                <!-- 첫돌 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-icon" style="background:#fff9e6;">👶</div>
                    <div class="always-content">
                        <span class="always-tag">FIRST BIRTHDAY</span>
                        <h3>우리 아이 첫돌 사진 리뷰 이벤트</h3>
                        <p>소중한 첫돌 사진을 메리뷰에 리뷰로 남겨주세요!<br>베스트 리뷰로 선정되신 분께 기프트콘을 드립니다 🎁</p>
                    </div>
                    <div class="always-reward">
                        <div class="reward-icon">🎁</div>
                        <div class="reward-text">기프트콘 증정</div>
                    </div>
                </div>

                <!-- 내가 제일 잘나가 -->
                <div class="always-card" @click="showPrep = true">
                    <div class="always-icon" style="background:#f0f5ff;">👑</div>
                    <div class="always-content">
                        <span class="always-tag">BEST WEDDING</span>
                        <h3>내가 제일 잘나가 이벤트</h3>
                        <p>제일로 즐거운 결혼식 사진을 올려주세요!<br>사진 콘테스트 선정 시 푸짐한 기프트콘 혜택을 드립니다 🏆</p>
                    </div>
                    <div class="always-reward">
                        <div class="reward-icon">🏆</div>
                        <div class="reward-text">기프트콘 증정</div>
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
            }
        });
        app.mount('#app');
    </script>
</body>
</html>
