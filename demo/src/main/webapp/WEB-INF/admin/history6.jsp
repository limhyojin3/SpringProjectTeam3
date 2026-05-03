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
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
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
                left: 160px;
                /* 첫 번째 카드의 중앙(500px의 절반) */
                /* 전체 너비에서 양 끝 카드 절반씩 제외 (카드5개면 500*4 = 2000px) */
                width: calc(100% - 320px);
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
                width: 320px;
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
                font-size: 3rem;
                /* 6rem → 3rem (딱 반) */
                font-weight: 900;
                color: #ff4d6d;
                margin: 0;
                line-height: 1;
            }

            .text {
                font-size: 1rem;
                /* 같이 줄여서 밸런스 맞춤 */
            }

            /* 안의 문장(p)들의 기본 상태: 안 보이고 아래에 있음 */
            .text p {
                margin: 5px 0;
                opacity: 0;
                transform: translateY(20px);
                transition: all 0.6s ease;
            }

            /* 중앙에 왔을 때(active): 문장들이 나타남 */
            .history-item.active .text p {
                opacity: 1;
                transform: translateY(0);
            }

            /* --- 한 줄씩 나타나는 시간차 설정 --- */
            .history-item.active .text p:nth-child(1) {
                transition-delay: 0.2s;
            }

            .history-item.active .text p:nth-child(2) {
                transition-delay: 0.7s;
            }

            .history-item.active .text p:nth-child(3) {
                transition-delay: 1.2s;
            }

            .history-item.active .text p:nth-child(4) {
                transition-delay: 1.7s;
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
        <div id="app" class="history-container">
            <div class="my-history-component" style="position: relative; height: 800px; overflow: hidden;">

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
                            <div class="text">
                                <p>첫 번째 플래그십 스토어 성수동 오픈</p>
                                <p>현지 커뮤니티와 협업한 첫 오프라인 공간으로</p>
                                <p>누적 방문객 10만 명을 기록했습니다.</p>
                            </div>

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
            </div>
        </div>



        <script>
            const track = document.getElementById('track');
            const handle = document.getElementById('handle');
            const barBg = document.getElementById('barBg');
            const items = document.querySelectorAll('.history-item');

            const ITEM_WIDTH = 320;
            const MAX_INDEX = items.length - 1;

            let index = 0;
            let targetIndex = 0;
            let isDragging = false;

            // wheel → index
            window.addEventListener('wheel', (e) => {
                e.preventDefault();

                targetIndex += (e.deltaY > 0 ? 1 : -1);
                targetIndex = Math.max(0, Math.min(MAX_INDEX, targetIndex));
            }, { passive: false });

            // bar move
            function moveByBar(e) {
                const rect = barBg.getBoundingClientRect();
                const x = e.clientX || (e.touches && e.touches.clientX);

                let percent = (x - rect.left) / rect.width;
                percent = Math.max(0, Math.min(1, percent));

                targetIndex = Math.round(percent * MAX_INDEX);
            }

            barBg.addEventListener('mousedown', (e) => {
                isDragging = true;
                moveByBar(e);
            });

            window.addEventListener('mousemove', (e) => {
                if (isDragging) moveByBar(e);
            });

            window.addEventListener('mouseup', () => isDragging = false);

            // render loop
            function update() {
                index += (targetIndex - index) * 0.08;

                // 중앙 고정 + index 이동 (핵심)
                const offset = (window.innerWidth / 2) - (ITEM_WIDTH / 2);
                const x = offset - (index * ITEM_WIDTH);

                track.style.transform = `translateX(${x}px)`;

                // handle
                const percent = index / MAX_INDEX;
                const range = barBg.clientWidth - handle.clientWidth;
                handle.style.left = (percent * range) + "px";

                // active (완전히 안정)
                items.forEach((item, i) => {
                    item.classList.toggle('active', Math.round(index) === i);
                });

                requestAnimationFrame(update);
            }

            update();
        </script>



    </body>

    </html>