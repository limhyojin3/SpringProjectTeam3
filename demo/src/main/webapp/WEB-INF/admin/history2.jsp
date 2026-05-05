<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Fixed History</title>
    <style>
        /* 1. 기본 설정 */
        body, html { 
            margin: 0; padding: 0; width: 100%; height: 100%; 
            overflow: hidden; background-color: #fff5f7; 
            font-family: sans-serif;
        }

        /* 2. 가로로 밀 수 있는 큰 박스 */
        .scroll-wrapper {
            width: 100vw; height: 100vh;
            overflow-x: auto; overflow-y: hidden;
            display: flex; align-items: center;
        }

        /* 3. [중요] 화면 한가운데를 관통하는 '진한 검정색' 선 */
        .center-line-bg {
            position: absolute;
            top: 50%; left: 0;
            width: 5000px; /* 아주 길게 설정 */
            height: 4px;   /* 선 두께 굵게 */
            background-color: #333; /* 배경이 핑크니 선은 검정색 */
            z-index: 1;
        }

        /* 4. 내용들이 담긴 트랙 */
        .history-track {
            display: flex;
            position: relative;
            z-index: 2; /* 선보다 위에 표시 */
            padding-left: 20vw;
        }

        .item {
            width: 400px;
            margin-right: 150px;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex-shrink: 0;
        }

        /* 연도 (선보다 한참 위) */
        .year {
            font-size: 5rem;
            font-weight: 900;
            color: #ff4d6d;
            margin-bottom: 50px; /* 선과 안 겹치게 위로 밀기 */
        }

        /* 선 위에 박히는 점 */
        .dot {
            width: 20px; height: 20px;
            background-color: #333;
            border: 4px solid #fff;
            border-radius: 50%;
        }

        /* 설명 (선보다 한참 아래) */
        .desc {
            font-size: 1.5rem;
            color: #333;
            font-weight: bold;
            margin-top: 50px; /* 선과 안 겹치게 아래로 밀기 */
            text-align: center;
            white-space: normal;
        }

        /* 스크롤바 디자인 */
        .scroll-wrapper::-webkit-scrollbar { height: 10px; }
        .scroll-wrapper::-webkit-scrollbar-thumb { background: #333; border-radius: 10px; }
    </style>
</head>
<body>

    <div class="scroll-wrapper" id="scrollBox">
        <!-- 배경에 깔리는 선 -->
        <div class="center-line-bg"></div>

        <!-- 실제 연혁 내용 -->
        <div class="history-track">
            
            <div class="item">
                <div class="year">2021</div>
                <div class="dot"></div>
                <div class="desc">브랜드의 첫 시작</div>
            </div>

            <div class="item">
                <div class="year">2022</div>
                <div class="dot"></div>
                <div class="desc">서비스 확장 및 성장</div>
            </div>

            <div class="item">
                <div class="year">2023</div>
                <div class="dot"></div>
                <div class="desc">글로벌 시장 진출</div>
            </div>

            <div class="item">
                <div class="year">2024</div>
                <div class="dot"></div>
                <div class="desc">디지털 혁신상 수상</div>
            </div>

            <div class="item">
                <div class="year">2025</div>
                <div class="dot"></div>
                <div class="desc">미래를 향한 도약</div>
            </div>

        </div>
    </div>

    <script>
        const scrollBox = document.getElementById('scrollBox');

        // 마우스 휠을 굴리면 가로로 이동 (엣지 포함 모든 브라우저 공통)
        scrollBox.addEventListener('wheel', (e) => {
            if (e.deltaY !== 0) {
                e.preventDefault();
                scrollBox.scrollLeft += e.deltaY;
            }
        }, { passive: false });
    </script>

</body>
</html>
