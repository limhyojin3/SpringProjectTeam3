<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>메리뷰 소개</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <style>
            .about-hero {
                width: 100%;
                height: 420px;
                background-image: url('../../img/historyImg3.jpg');
                background-size: cover;
                background-position: center;
                position: relative;
                display: flex;
                align-items: flex-end;
            }

            .about-hero-overlay {
                width: 100%;
                padding: 40px 60px;
                background: linear-gradient(to top, rgba(0, 0, 0, 0.5), transparent);
            }

            .about-hero-overlay h1 {
                font-family: Georgia, serif;
                font-style: italic;
                font-size: 48px;
                color: white;
                margin: 0;
            }

            .about-hero-overlay p {
                color: rgba(255, 255, 255, 0.85);
                font-size: 16px;
                margin: 8px 0 0;
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

            .about-hero-overlay {
                animation: fadeUp 0.7s ease forwards;
                opacity: 0;
            }

            .about-hero-overlay {
                animation-delay: 0.1s;
            }

            .history-section {
                padding: 80px 20px;
                max-width: 1100px;
                margin: 0 auto;
                position: relative;
            }

            /* 원앙 이미지 */
            .history-deco-img {
                position: absolute;
                top: 0px;
                left: -240px;
                width: 400px;
                z-index: 0;
                /* 글자 뒤로 배치 */
                pointer-events: none;
                /* 클릭 방지 */
            }

            .history-deco-img2 {
                position: absolute;
                top: 865px;
                left: 937px;
                width: 400px;
                z-index: 0;
                /* 글자 뒤로 배치 */
                pointer-events: none;
            }

            @media (max-width: 1200px) {

                .history-deco-img,
                .history-deco-img2 {
                    display: none;
                    /* 화면이 좁아지면 글자와 겹칠 수 있으므로 숨김 처리 */
                }
            }

            .history-title {
                text-align: center;
                font-size: 32px;
                margin-bottom: 60px;
                font-weight: bold;
            }

            /* 중앙 라인 */
            .history-line {
                position: absolute;
                left: 50%;
                top: 140px;
                width: 2px;
                height: calc(100% - 140px);
                background: #ddd;
                transform: translateX(-50%);
            }

            /* 전체 컨테이너 */
            .history-container {
                position: relative;
            }

            /* 카드 기본 */
            .history-card {
                width: 50%;
                padding: 20px 40px;
                position: relative;
                margin-bottom: 40px;
            }

            /* 왼쪽 */
            .history-card.left {
                left: 0;
                text-align: right;
            }

            /* 오른쪽 */
            .history-card.right {
                left: 50%;
            }

            /* 점 */
            .history-dot {
                width: 14px;
                height: 14px;
                background: #ff6b81;
                border-radius: 50%;
                position: absolute;
                top: 28px;
                z-index: 2;
            }

            /* 위치 조정 */
            .history-card.left .history-dot {
                right: -7px;
            }

            .history-card.right .history-dot {
                left: -7px;
            }

            /* 카드 내용 */
            .history-content {
                background: white;
                padding: 20px;
                border-radius: 14px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                display: inline-block;
                max-width: 380px;
            }

            .history-content .year {
                font-size: 13px;
                color: #888;
                display: block;
                margin-bottom: 5px;
            }

            .history-content h3 {
                margin: 0 0 8px;
                font-size: 18px;
            }

            .history-content p {
                margin: 0;
                font-size: 14px;
                color: #555;
            }

            /* 반응형 */
            @media (max-width: 900px) {

                .history-line {
                    left: 20px;
                }

                .history-card {
                    width: 100%;
                    padding-left: 50px;
                    text-align: left !important;
                    left: 0 !important;
                }

                .history-dot {
                    left: 12px !important;
                    right: auto !important;
                }
            }

            .history-card {
                opacity: 0;
                transform: translateY(60px);
                transition: all 0.8s ease;
            }

            /* 활성화될 때 */
            .history-card.show {
                opacity: 1;
                transform: translateY(0);
            }

            .history-card.left.show {
                transform: translateY(0) translateX(0);
            }

            .history-card.right.show {
                transform: translateY(0) translateX(0);
            }

            .history-content {
                transition: all 0.3s ease;
            }

            .history-card.show .history-content {
                transform: scale(1.02);
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <!-- 히어로 -->
            <div class="about-hero">
                <div class="about-hero-overlay">
                    <h1>MarryViewHistory</h1>
                    <p>더 나은 출발을 꿈꾸는 수많은 목소리를 담아, 메리뷰만의 정직한 길을 만들었습니다</p>
                </div>
            </div>

            <div class="about-body">
                <div class="about-body">
                    <div class="history-section">
                        <img src="../../img/duck.png" class="history-deco-img" alt="decoration">
                        <div class="history-line"></div>

                        <div class="history-container">

                            <div class="history-card left">
                                <div class="history-dot"></div>
                                <div class="history-content">
                                    <span class="year">2024</span>
                                    <h3>서비스 기획 시작</h3>
                                    <p>웨딩 리뷰 기반 플랫폼인 MarryView 프로젝트는</p>
                                    <p>웨딩 산업 내 정보 비대칭 문제 해결을 목표로 시작되었습니다</p>
                                </div>
                            </div>

                            <div class="history-card right">
                                <div class="history-dot"></div>
                                <div class="history-content">
                                    <span class="year">2025 1Q</span>
                                    <h3>베타 서비스 오픈</h3>
                                    <p>스드메 후기 데이터 기반 리뷰 시스템을 개발하고</p>
                                    <p>회원 리뷰 시스템 및 업체 등록 기능 포함 베타 버전을 출시하였습니다</p>
                                </div>
                            </div>

                            <div class="history-card left">
                                <div class="history-dot"></div>
                                <div class="history-content">
                                    <span class="year">2025 3Q</span>
                                    <h3>리뷰 시스템 고도화</h3>
                                    <p>실제 영수증 인증을 통해 신뢰도 기반 리뷰 시스템을</p>
                                    <p>구축하고 회원간의 자유로운 정보 공유를 위해 커뮤니티를 만들었습니다</p>
                                </div>
                            </div>

                            <div class="history-card right">
                                <div class="history-dot"></div>
                                <div class="history-content">
                                    <span class="year">2026</span>
                                    <h3>정식 서비스 런칭</h3>
                                    <p>스드메 업체와의 제휴계약과 상품 예약 중개를 통해</p>
                                    <p>단순한 리뷰 플랫폼을 넘어 결혼식의 전 과정을</p>
                                    <p>통합하는 웨딩 플랫폼으로의 성장을 목표로 하고 있습니다</p>
                                </div>
                            </div>
                        </div>
                        <img src="../../img/duck2.png" class="history-deco-img2" alt="decoration">
                    </div>

                </div>
            </div>

            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const cards = document.querySelectorAll(".history-card");

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach((entry) => {

                        if (entry.isIntersecting) {
                            entry.target.classList.add("show");
                        }

                    });
                }, {
                    threshold: 0.2
                });

                cards.forEach((card) => {
                    observer.observe(card);
                });

            });
        </script>
    </body>

    </html>