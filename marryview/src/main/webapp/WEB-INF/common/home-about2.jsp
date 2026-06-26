<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찾아오시는 길</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 카카오맵 API -->
    <script type="text/javascript"src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&autoload=false"></script>
    <style>
        /* 히어로 섹션 */
        .about-hero {
            width: 100%;
            height: 420px;
            background-image: url('/img/home_about4.jpg');
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

        /* 지도 영역 */
        .map-wrap {
            width: 100%;
            height: 380px;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #ffd1d1;
            margin-bottom: 36px;
        }
        .map-wrap iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        /* 주소 정보 카드 */
        .location-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 36px;
        }
        .location-card {
            background: white;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 24px;
            transition: 0.2s;
        }
        .location-card:hover {
            box-shadow: 0 4px 15px rgba(244, 160, 150, 0.3);
            transform: translateY(-2px);
        }
        .location-card .loc-icon {
            font-size: 26px;
            margin-bottom: 10px;
        }
        .location-card h3 {
            font-size: 15px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .location-card p {
            font-size: 13px;
            color: #888;
            line-height: 1.8;
            margin: 0;
        }
        .location-card strong {
            color: #f4a096;
        }

        /* 교통 섹션 */
        .transport-section {
            margin-bottom: 36px;
        }
        .transport-section h2 {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f4a096;
        }
        .transport-item {
            display: flex;
            gap: 16px;
            align-items: flex-start;
            margin-bottom: 16px;
            padding: 20px;
            background: #fff9f9;
            border-radius: 12px;
            border: 1px solid #ffd1d1;
        }
        .transport-badge {
            flex-shrink: 0;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            background: #f4a096;
            color: white;
        }
        .transport-badge.subway { background: #3a5fc8; }
        .transport-badge.bus    { background: #2da05a; }
        .transport-badge.car    { background: #f0b429; }
        .transport-item-text h4 {
            font-size: 15px;
            font-weight: bold;
            color: #333;
            margin-bottom: 6px;
        }
        .transport-item-text p {
            font-size: 13px;
            color: #666;
            line-height: 1.8;
            margin: 0;
        }

        /* 애니메이션 추가 */
        .map-wrap,
        .location-info,
        .transport-section {
            animation: fadeUp 0.7s ease forwards;
            opacity: 0;
        }
        .map-wrap          { animation-delay: 0.3s; }
        .location-info     { animation-delay: 0.5s; }
        .transport-section { animation-delay: 0.7s; }

    </style>
</head>
<body>
<jsp:include page="/WEB-INF/common/header.jsp" />
<div id="app">

    <!-- 히어로 -->
    <div class="about-hero">
        <div class="about-hero-overlay">
            <h1>찾아오시는 길</h1>
            <p>메리뷰 오시는 방법을 안내해드립니다</p>
        </div>
    </div>

    <div class="about-body">

        <!-- 지도 -->
        <div class="map-wrap">
            <div id="kakaoMap" style="width:100%; height:100%;"></div>
        </div>

        <!-- 주소 정보 -->
        <div class="location-info">
            <div class="location-card">
                <div class="loc-icon">📍</div>
                <h3>주소</h3>
                <p>
                    인천광역시 부평구 경원대로 1366<br>
                    스테이션타워 7층<br>
                    <strong>(우) 21319</strong>
                </p>
            </div>
            <div class="location-card">
                <div class="loc-icon">🕐</div>
                <h3>운영시간</h3>
                <p>
                    평일 <strong>09:00 ~ 18:00</strong><br>
                    점심시간 <strong>12:00 ~ 13:00</strong><br>
                    토·일·공휴일 휴무
                </p>
            </div>
            <div class="location-card">
                <div class="loc-icon">📞</div>
                <h3>고객센터</h3>
                <p>
                    대표번호 <strong>1588-0000</strong><br>
                    이메일 <strong>help@marryview.com</strong><br>
                    평일 09:00 ~ 18:00
                </p>
            </div>
            <div class="location-card">
                <div class="loc-icon">🅿️</div>
                <h3>주차 안내</h3>
                <p>
                    건물 내 주차 가능<br>
                    <strong>2시간 무료</strong> 제공<br>
                    이후 10분당 1,000원
                </p>
            </div>
        </div>
        <!-- 교통편 -->
        <div class="transport-item">
            <div class="transport-badge subway">🚇</div>
            <div class="transport-item-text">
                <h4>지하철 이용 시</h4>
                <p>
                    1호선 · 7호선 <strong>부평역</strong> 1번 출구 도보 1분<br>
                    역과 건물이 바로 연결되어 있어요
                </p>
            </div>
        </div>
        <div class="transport-item">
            <div class="transport-badge bus">🚌</div>
            <div class="transport-item-text">
                <h4>버스 이용 시</h4>
                <p>
                    <strong>부평역 정류소 (스테이션타워 앞)</strong> 하차<br>
                    광역·시외 2 · 34 · 111 · 112번<br>
                    지선 556 · 557 · 570 · 582번
                </p>
            </div>
        </div>
        <div class="transport-item">
            <div class="transport-badge car">🚗</div>
            <div class="transport-item-text">
                <h4>자가용 이용 시</h4>
                <p>
                    네비게이션에 <strong>"스테이션타워 부평"</strong> 또는<br>
                    <strong>"인천 부평구 경원대로 1366"</strong> 검색
                </p>
            </div>
        </div>
        <!-- 약속 -->
        <div class="about-promise">
            <h3>"언제나 열려있는 메리뷰"</h3>
            <p style="max-width: 460px; margin: 0 auto;">
                궁금한 점이 있으시면 고객센터로 편하게 연락해주세요.<br>
                결혼 준비의 모든 순간, 메리뷰가 함께합니다.
            </p>
        </div>
    </div>
</div>

    <jsp:include page="/WEB-INF/common/footer.jsp" />
</div>

<script>
    const app = Vue.createApp({});
    app.mount('#app');
    // 카카오맵 마커
    kakao.maps.load(function() {
        const container = document.getElementById('kakaoMap');
        if (!container) return;
        const options = {
            center: new kakao.maps.LatLng(37.4877, 126.7218),  // 부평 스테이션타워 좌표
            level: 3
        };
        const map = new kakao.maps.Map(container, options);

        // 마커 생성
        const markerPosition = new kakao.maps.LatLng(37.4877, 126.7218);
        const marker = new kakao.maps.Marker({ position: markerPosition });
        marker.setMap(map);

        // 인포윈도우 (말풍선)
        const infowindow = new kakao.maps.InfoWindow({
            content: `
                <div style="
                    padding: 6px 10px;
                    font-size: 13px;
                    font-family: 'Noto Sans KR', sans-serif;
                    line-height: 1.5;
                    min-width: 170px;
                    border: none;
                    background: #fff;
                ">
                    <strong style="color: #f4a096; font-size: 14px;">📍 메리뷰</strong><br>
                    <span style="font-size: 12px; font-weight: 500;">스테이션타워 7층</span><br>
                    <span style="color: #888; font-size: 11px; display: block; margin-top: 2px;">인천 부평구 경원대로 1366</span>
                </div>
            `
        });

        // 마커 클릭 시 말풍선 열기
        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
        });

        // 처음부터 말풍선 열어두기
        infowindow.open(map, marker);
    });
</script>
</body>
</html>