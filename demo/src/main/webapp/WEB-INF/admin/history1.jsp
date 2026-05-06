<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Perfect Pink History</title>
    <style>
        /* 1. 배경 및 전체 구조 */
        body, html { 
            margin: 0; padding: 0; width: 100%; height: 100%; 
            overflow: hidden; background-color: #fff5f7; 
        }
        
        .history-section {
            width: 100vw; height: 100vh;
            display: flex; flex-direction: column; justify-content: center;
            font-family: 'Pretendard', sans-serif;
            background: radial-gradient(circle at 50% 50%, #fff0f3 0%, #ffe4e9 100%);
            position: relative;
        }

        /* 2. 연혁 아이템 박스 */
        .history-container {
            display: flex;
            align-items: center;
            position: absolute;
            white-space: nowrap; /* 가로로 쭉 나열 */
            will-change: transform;
            left: 0; top: 30%; /* 위치 고정 */
        }

        .history-item {
            display: inline-block;
            width: 500px; /* 고정 너비 사용 (계산 오류 방지) */
            text-align: center;
            transition: all 0.5s ease;
            filter: blur(5px);
            opacity: 0.2;
        }

        .history-item.active {
            filter: blur(0px);
            opacity: 1;
            transform: scale(1.1);
        }

        .year { font-size: 6rem; font-weight: 900; color: #ff4d6d; margin: 0; }
        .text { font-size: 1.5rem; color: #444; margin-top: 10px; font-weight: 500; }

        /* 3. 하단 컨트롤 바 */
        .controls {
            position: absolute;
            bottom: 100px; left: 50%;
            transform: translateX(-50%);
            width: 400px;
        }

        .bar-bg {
            width: 100%; height: 4px; background: rgba(0,0,0,0.05);
            border-radius: 2px; position: relative; cursor: pointer;
        }

        .bar-handle {
            position: absolute; top: -6px; left: 0;
            width: 60px; height: 16px; background: #ff4d6d;
            border-radius: 8px; cursor: grab;
        }
    </style>
</head>
<body>

    <section class="history-section">
        <!-- 연혁 내용들 -->
        <div class="history-container" id="track">
            <div class="history-item">
                <div class="year">2021</div>
                <div class="text">브랜드 시작 및 핵심 가치 정립</div>
            </div>
            <div class="history-item">
                <div class="year">2022</div>
                <div class="text">첫 번째 플래그십 스토어 오픈</div>
            </div>
            <div class="history-item">
                <div class="year">2023</div>
                <div class="text">디지털 혁신 대상 수상</div>
            </div>
            <div class="history-item">
                <div class="year">2024</div>
                <div class="text">글로벌 시장 본격 진출</div>
            </div>
            <div class="history-item">
                <div class="year">2025</div>
                <div class="text">미래를 향한 새로운 도약</div>
            </div>
        </div>

        <!-- 하단 컨트롤 바 -->
        <div class="controls">
            <div class="bar-bg" id="barBg">
                <div class="bar-handle" id="handle"></div>
            </div>
        </div>
    </section>

    <script>
        const track = document.getElementById('track');
        const handle = document.getElementById('handle');
        const barBg = document.getElementById('barBg');
        const items = document.querySelectorAll('.history-item');

        let targetX = 0;   // 우리가 가고 싶은 목표 지점
        let currentX = 0;  // 현재 화면에 그려지는 위치
        let isDragging = false;

        // 1. 휠 스크롤 감지 (위아래 휠을 좌우 이동으로 변환)
        window.addEventListener('wheel', (e) => {
            e.preventDefault();
            targetX -= e.deltaY * 1.5; // 속도 조절
            limitX();
        }, { passive: false });

        // 2. 바 클릭 및 드래그 감지
        function moveByBar(e) {
            const rect = barBg.getBoundingClientRect();
            const clientX = e.clientX || (e.touches && e.touches[0].clientX);
            let percent = (clientX - rect.left) / rect.width;
            percent = Math.max(0, Math.min(percent, 1));
            
            const maxMove = (items.length - 1) * 500; // 카드 너비 500px 기준
            targetX = -percent * maxMove;
        }

        barBg.addEventListener('mousedown', (e) => { isDragging = true; moveByBar(e); });
        window.addEventListener('mousemove', (e) => { if (isDragging) moveByBar(e); });
        window.addEventListener('mouseup', () => isDragging = false);

        function limitX() {
            const maxMove = (items.length - 1) * 500;
            if (targetX > 0) targetX = 0;
            if (targetX < -maxMove) targetX = -maxMove;
        }

        // 3. 애니메이션 업데이트 (가장 중요)
        function update() {
            // 부드러운 감속 효과 (Lerp)
            currentX += (targetX - currentX) * 0.1;

            // 트랙 위치 이동 (기본 중앙 정렬 보정값 포함)
            const centerOffset = (window.innerWidth / 2) - 250; 
            track.style.transform = "translateX(" + (centerOffset + currentX) + "px)";

            // 핸들 위치 계산
            const maxMove = (items.length - 1) * 500;
            const handlePercent = Math.abs(currentX / maxMove) || 0;
            const handleRange = barBg.clientWidth - handle.clientWidth;
            handle.style.left = (handlePercent * handleRange) + "px";

            // 중앙 카드 활성화 체크
            items.forEach(item => {
                const rect = item.getBoundingClientRect();
                const center = window.innerWidth / 2;
                if (Math.abs((rect.left + rect.width / 2) - center) < 200) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            });

            requestAnimationFrame(update);
        }

        update();
    </script>
</body>
</html>
