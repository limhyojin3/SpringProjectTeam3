<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Perfect Pink History - Limited Line</title>
        <style>
            body,
            html {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                overflow: hidden;
                background-color: #fff5f7;
            }

            .history-section {
                width: 100vw;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                font-family: 'Pretendard', sans-serif;
                background: radial-gradient(circle at 50% 50%, #fff0f3 0%, #ffe4e9 100%);
                position: relative;
            }

            .history-container {
                display: flex;
                align-items: center;
                position: absolute;
                white-space: nowrap;
                will-change: transform;
                left: 0;
                top: 0;
                height: 100%;
                z-index: 2;
            }

            /* [핵심] 첫 번째 점부터 마지막 점까지만 연결되는 선 */
            .inner-line {
                position: absolute;
                top: 50%;
                /* 화면 중앙(점 위치) */
                left: 250px;
                /* 첫 번째 카드의 중앙(500px의 절반) */
                /* 전체 너비에서 양 끝 카드 절반씩 제외 (카드5개면 500*4 = 2000px) */
                width: calc(100% - 500px);
                height: 1.5px;
                background: rgba(255, 77, 109, 0.3);
                z-index: 1;
                transform: translateY(-50%);
            }

            .history-item {
                display: inline-flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                width: 500px;
                height: 100%;
                text-align: center;
                transition: all 0.6s cubic-bezier(0.2, 1, 0.3, 1);
                filter: blur(5px);
                opacity: 0.2;
                position: relative;
                z-index: 2;
                /* 선보다 위에 오도록 */
            }

            .history-item.active {
                filter: blur(0px);
                opacity: 1;
                transform: scale(1.05);
            }

            .timeline-dot {
                width: 12px;
                height: 12px;
                background-color: #fff;
                border: 2px solid #ffd1dc;
                border-radius: 50%;
                margin: 30px 0;
                position: relative;
                z-index: 3;
                transition: all 0.4s ease;
            }

            .active .timeline-dot {
                background-color: #ff4d6d;
                border-color: #ff4d6d;
                box-shadow: 0 0 15px rgba(255, 77, 109, 0.5);
                transform: scale(1.3);
            }

            .year {
                font-size: 6rem;
                font-weight: 900;
                color: #ff4d6d;
                margin: 0;
                line-height: 1;
            }

            /* 기본 상태: 글자가 안 보이고 약간 아래에 위치 */
            .text {
                font-size: 1.5rem;
                color: #444;
                font-weight: 500;
                line-height: 1.5;

                /* 추가된 부분 */
                opacity: 0;
                /* 안 보이게 */
                transform: translateY(20px);
                /* 20px 아래에 대기 */
                transition: all 0.6s ease;
                /* 부드럽게 변하도록 */
            }

            /* 중앙에 왔을 때(active): 글자가 나타나면서 위로 슥 올라옴 */
            .history-item.active .text {
                opacity: 1;
                /* 보이게 */
                transform: translateY(0);
                /* 원래 위치로 */
            }


            .controls {
                position: absolute;
                bottom: 80px;
                left: 50%;
                transform: translateX(-50%);
                width: 350px;
                z-index: 10;
            }

            .bar-bg {
                width: 100%;
                height: 2px;
                background: rgba(0, 0, 0, 0.05);
                position: relative;
                cursor: pointer;
            }

            .bar-handle {
                position: absolute;
                top: -5px;
                left: 0;
                width: 60px;
                height: 12px;
                background: #ff4d6d;
                border-radius: 6px;
                cursor: grab;
            }
        </style>
    </head>

    <body>

        <section class="history-section">
            <div class="history-container" id="track">
                <!-- 내부 연결 선 -->
                <div class="inner-line"></div>

                <!-- 항목들 -->
                <div class="history-item">
                    <div class="year">2021</div>
                    <div class="timeline-dot"></div>
                    <div class="text">브랜드 시작 및 핵심 가치 정립</div>
                </div>
                <div class="history-item">
                    <div class="year">2022</div>
                    <div class="timeline-dot"></div>
                    <div class="text">첫 번째 플래그십 스토어 오픈</div>
                </div>
                <div class="history-item">
                    <div class="year">2023</div>
                    <div class="timeline-dot"></div>
                    <div class="text">디지털 혁신 대상 수상</div>
                </div>
                <div class="history-item">
                    <div class="year">2024</div>
                    <div class="timeline-dot"></div>
                    <div class="text">글로벌 시장 본격 진출</div>
                </div>
                <div class="history-item">
                    <div class="year">2025</div>
                    <div class="timeline-dot"></div>
                    <div class="text">미래를 향한 새로운 도약</div>
                </div>
            </div>

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

            let targetX = 0;
            let currentX = 0;
            let isDragging = false;

            // 휠 이동
            window.addEventListener('wheel', (e) => {
                e.preventDefault();
                targetX -= e.deltaY * 1.5;
                limitX();
            }, { passive: false });

            // 스크롤바 드래그/클릭
            function moveByBar(e) {
                const rect = barBg.getBoundingClientRect();
                const clientX = e.clientX || (e.touches && e.touches.clientX);
                let percent = (clientX - rect.left) / rect.width;
                percent = Math.max(0, Math.min(percent, 1));
                const maxMove = (items.length - 1) * 500;
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

            function update() {
                currentX += (targetX - currentX) * 0.1;

                const centerOffset = (window.innerWidth / 2) - 250;
                track.style.transform = "translateX(" + (centerOffset + currentX) + "px)";

                const maxMove = (items.length - 1) * 500;
                const handlePercent = Math.abs(currentX / maxMove) || 0;
                const handleRange = barBg.clientWidth - handle.clientWidth;
                handle.style.left = (handlePercent * handleRange) + "px";

                const center = window.innerWidth / 2;
                items.forEach(item => {
                    const rect = item.getBoundingClientRect();
                    const itemCenter = rect.left + rect.width / 2;
                    if (Math.abs(itemCenter - center) < 200) {
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