<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메리뷰 소개</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* 히어로 섹션 */
        .about-hero {
            width: 100%;
            height: 420px;
            background-image: url('/img/home_about3.jpg');
            background-size: cover;
            background-position: center;
            background-color: #ffc7c2;
            position: relative;
            display: flex;
            align-items: flex-end;
        }

        .about-hero-overlay {
            width: 100%;
            padding: 40px 60px;
            background: linear-gradient(to top, rgba(0,0,0,0.5), transparent);
        }

        .about-hero-overlay h1 {
            font-family: Georgia, serif;
            font-style: italic;
            font-size: 48px;
            color: white;
            margin: 0;
        }

        .about-hero-overlay p {
            color: rgba(255,255,255,0.85);
            font-size: 16px;
            margin: 8px 0 0;
        }

        /* 본문 */
        .about-body {
            max-width: 860px;
            margin: 0 auto;
            padding: 60px 20px;
        }

        /* 소개 섹션 */
        .about-intro {
            display: flex;
            gap: 40px;
            align-items: center;
            margin-bottom: 35px;
        }

        .about-intro-text {
            flex: 1;
        }

        .about-intro-text h2 {
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f4a096;
        }

        .about-intro-text p {
            font-size: 15px;
            color: #555;
            line-height: 1.9;
        }

        /* 특별한 이유 섹션 */
        .about-special {
            background: linear-gradient(135deg, #fff9f9 0%, #fff0ef 100%);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 45px;
        }

        .about-special h2 {
            font-size: 22px;
            font-weight: bold;
            color: #f4a096;
            margin-bottom: 16px;
        }

        .about-special p {
            font-size: 15px;
            color: #555;
            line-height: 1.9;
        }

        /* 주요 서비스 */
        .about-services {
            margin-bottom: 45px;
        }

        .about-services h2 {
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin-bottom: 24px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f4a096;
        }

        .service-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .service-card {
            background: white;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 24px;
            transition: 0.2s;
        }

        .service-card:hover {
            box-shadow: 0 4px 15px rgba(244, 160, 150, 0.3);
            transform: translateY(-2px);
        }

        .service-card .service-icon {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .service-card h3 {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 6px;
        }

        .service-card p {
            font-size: 13px;
            color: #888;
            margin: 0;
            line-height: 1.6;
        }

        /* 약속 섹션 */
        .about-promise {
            background-color: #fff9f9;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
        }

        .about-promise h3 {
            font-size: 18px;
            color: #f4a096;
            font-style: italic;
            margin-bottom: 10px;
        }

        .about-promise p {
            font-size: 15px;
            color: #555;
            line-height: 1.8;
        }
        /* ✅ 애니메이션 추가 */
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

        .about-hero-overlay,
        .about-intro,
        .about-special,
        .about-services,
        .about-promise {
            animation: fadeUp 0.7s ease forwards;
            opacity: 0;
        }

        /* ✅ 순서대로 딜레이 */
        .about-hero-overlay { animation-delay: 0.1s; }
        .about-intro        { animation-delay: 0.3s; }
        .about-special      { animation-delay: 0.5s; }
        .about-services     { animation-delay: 0.7s; }
        .about-promise      { animation-delay: 0.9s; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 히어로 -->
        <div class="about-hero">
            <div class="about-hero-overlay">
                <h1>MarryView</h1>
                <p>행복을 준비하는 모든 순간을 함께하는 가족 행사 & 웨딩 통합 리뷰 플랫폼</p>
            </div>
        </div>

        <div class="about-body">

            <!-- 소개 -->
            <div class="about-intro">
                <div class="about-intro-text">
                    <h2>인생의 소중한 모든 순간, 메리뷰 (MarryView)</h2>
                    <p>메리뷰는 결혼을 준비하는 설렘부터, 가족이 되어가는 모든 행복한 순간을 함께하는 **라이프 이벤트 리뷰 플랫폼**입니다.</p>
                    <br>
                    <p>
                        <strong>"Marry에서 Merry하게!"</strong><br>
                        결혼(Marry)으로 시작된 인연이 즐거운(Merry) 삶의 기록으로 이어지도록,<br>
                        메리뷰가 여러분의 소중한 선택을 돕는 든든한 가이드가 되어드립니다.
                    </p>
                </div>
            </div>

            <!-- 특별한 이유 (확장된 타겟 반영) -->
            <div class="about-special">
                <h2>✨ 메리뷰가 특별한 이유</h2>
                <p>단순한 웨딩 후기를 넘어 **아이의 첫 돌잔치, 부모님의 환갑/칠순, 가족 및 우정 사진**까지,<br> 
                인생의 주요 이벤트를 아우르는 실제 이용자들의 생생한 리뷰를 한곳에서 확인할 수 있습니다.</p>
                <p>광고성 정보가 아닌 '진짜 경험'을 바탕으로 한 유료/무료 리뷰 시스템을 통해,<br> 
                정보 불균형을 해소하고 신뢰할 수 있는 업체 선택의 기준을 제시합니다.</p>
            </div>

            <!-- 주요 서비스 (서비스 범위 확장) -->
            <div class="about-services">
                <h2>주요 서비스</h2>
                <div class="service-grid">
                    <div class="service-card">
                        <div class="service-icon">💍</div>
                        <h3>웨딩 & 라이프 리뷰</h3>
                        <p>웨딩홀부터 돌잔치, 가족사진까지<br>검증된 업체의 솔직한 후기</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">🤝</div>
                        <h3>경험 공유 커뮤니티</h3>
                        <p>결혼 선배, 육아 선배들이 들려주는<br>현실적인 정보 공유 공간</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">💎</div>
                        <h3>프리미엄 리뷰 패스</h3>
                        <p>견적서와 꿀팁이 담긴 상세 리뷰를<br>합리적인 가격에 열람</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">🎁</div>
                        <h3>리뷰어 보상 시스템</h3>
                        <p>좋아요를 받을수록 쌓이는 혜택과<br>지속적인 리뷰 수익 창출</p>
                    </div>
                </div>
            </div>

            <!-- 약속 -->
            <div class="about-promise">
                <h3>"Marry to Merry, 당신의 모든 특별한 날과 함께"</h3>
                <p>결혼이 끝이 아닌 새로운 시작이듯, 메리뷰는 당신의 모든 순간을 응원합니다.</p>
            </div>

        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

<script>
    const app = Vue.createApp({});
    app.mount('#app');
</script>
</body>
</html>