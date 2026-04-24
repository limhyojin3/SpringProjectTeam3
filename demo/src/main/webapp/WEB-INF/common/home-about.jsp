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
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <!-- 히어로 -->
        <div class="about-hero">
            <div class="about-hero-overlay">
                <h1>MerryView</h1>
                <p>결혼을 준비하는 모든 순간을 함께하는 웨딩 리뷰 전문 플랫폼</p>
            </div>
        </div>

        <div class="about-body">

            <!-- 소개 -->
            <div class="about-intro">
                <div class="about-intro-text">
                    <h2>메리뷰 (MerryView) 소개</h2>
                    <p>메리뷰는 결혼을 준비하는 모든 순간을 함께하는 웨딩 리뷰 전문 플랫폼입니다.</p>
                    <br>
                    <p>'Marry(결혼)'와 'View(보다/리뷰)'를 결합한 이름처럼, 예비 부부들이 웨딩 업체에 대한 솔직한 후기를 나누고 현명한 선택을 할 수 있도록 돕습니다.</p>
                </div>
            </div>

            <!-- 특별한 이유 -->
            <div class="about-special">
                <h2>✨ 메리뷰가 특별한 이유</h2>
                <p>웨딩홀, 드레스, 메이크업, 스튜디오 등 수많은 제휴 업체 정보와 실제 이용자들의 생생한 리뷰를 한곳에서 확인할 수 있습니다.</p>
                <p>광고성 정보가 아닌 진짜 경험담을 바탕으로 한 리뷰를 제공하여, 결혼 준비의 불안함을 줄이고 신뢰할 수 있는 선택을 가능하게 합니다.</p>
            </div>

            <!-- 주요 서비스 -->
            <div class="about-services">
                <h2>주요 서비스</h2>
                <div class="service-grid">
                    <div class="service-card">
                        <div class="service-icon">📝</div>
                        <h3>업체 리뷰</h3>
                        <p>실제 이용자의 솔직한 웨딩 업체 후기</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">💬</div>
                        <h3>커뮤니티</h3>
                        <p>예비 부부들이 자유롭게 정보를 나누는 공간</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">🎟️</div>
                        <h3>리뷰 열람 패스권</h3>
                        <p>프리미엄 리뷰를 합리적인 가격에 열람</p>
                    </div>
                    <div class="service-card">
                        <div class="service-icon">❤️</div>
                        <h3>업체 찜하기</h3>
                        <p>관심 업체를 저장하고 비교</p>
                    </div>
                </div>
            </div>

            <!-- 약속 -->
            <div class="about-promise">
                <h3>"솔직한 웨딩 리뷰의 모든 것"</h3>
                <p>결혼을 준비하는 모든 순간, 메리뷰가 함께합니다.</p>
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