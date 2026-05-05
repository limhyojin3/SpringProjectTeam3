<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home-style.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;1,300;1,400&family=Noto+Serif+KR:wght@300;400&display=swap" rel="stylesheet">
</head>
<style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
        --rose: #e8a0b0;
        --rose-deep: #c9647e;
        --cream: #fdf6f0;
        --text-light: rgba(255,255,255,0.92);
    }

    html, body {
        width: 100%; height: 100%;
        overflow: hidden;
        background: #1a0a0f;
    }

    /* ── 슬라이드 컨테이너 ── */
    .slideshow {
        position: fixed;
        inset: 0;
        z-index: 0;
    }

    .slide {
        position: absolute;
        inset: 0;
        opacity: 0;
        background-size: cover;
        background-position: center;
        transition: opacity 1s ease-in-out;
    }

    /* 각 슬라이드 딜레이 (5장 × 5s) */
    .slide:nth-child(1) { animation-delay: 0s;   background-image: url('/img/willyoumarry2.jpg'); }
    .slide:nth-child(2) { animation-delay: 5s;   background-image: url('/img/willyoumarry5.jpg');}
    .slide:nth-child(3) { animation-delay: 10s;  background-image: url('/img/willyoumarry6.jpg');}
    .slide:nth-child(4) { animation-delay: 15s;  background-image: url('/img/willyoumarry4.jpg');}

    /* Ken Burns: 페이드인→유지→페이드아웃 + 줌 */
    @keyframes fadeSlide {
        0%        { opacity: 0;   transform: scale(1.08) translate(0, 0); }
        8%        { opacity: 1; }
        80%       { opacity: 1;   transform: scale(1.16) translate(-1%, -0.5%); }
        92%, 100% { opacity: 0;   transform: scale(1.18) translate(-1.5%, -1%); }
    }

    /* 슬라이드마다 다른 방향 */
    .slide:nth-child(2) { animation-name: fadeSlide2; }
    .slide:nth-child(3) { animation-name: fadeSlide3; }
    .slide:nth-child(4) { animation-name: fadeSlide4; }

    @keyframes fadeSlide2 {
        0%        { opacity: 0;   transform: scale(1.1) translate(1%, 0.5%); }
        4%        { opacity: 1; }
        16%       { opacity: 1;   transform: scale(1.18) translate(-0.5%, 0.5%); }
        20%, 100% { opacity: 0;   transform: scale(1.2) translate(-1%, 1%); }
    }
    @keyframes fadeSlide3 {
        0%        { opacity: 0;   transform: scale(1.05) translate(-1%, 0.5%); }
        8%        { opacity: 1; }
        80%       { opacity: 1;   transform: scale(1.14) translate(0.5%, -0.5%); }
        92%, 100% { opacity: 0;   transform: scale(1.16) translate(1%, -1%); }
    }
    @keyframes fadeSlide4 {
        0%        { opacity: 0;   transform: scale(1.12) translate(0.5%, -0.5%); }
        8%        { opacity: 1; }
        80%       { opacity: 1;   transform: scale(1.2) translate(-0.5%, 0.5%); }
        92%, 100% { opacity: 0;   transform: scale(1.22) translate(-1%, 1%); }
    }
    

    /* ── 어두운 오버레이 ── */
    .overlay {
        position: fixed;
        inset: 0;
        z-index: 1;
        background: linear-gradient(
        to bottom,
        rgba(15, 5, 8, 0.35) 0%,
        rgba(15, 5, 8, 0.2) 40%,
        rgba(15, 5, 8, 0.55) 100%
        );
    }

    /* ── 중앙 콘텐츠 ── */
    .content {
        position: fixed;
        inset: 0;
        z-index: 3;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 0;
        text-align: center;
        padding: 2rem;
    }

    .eyebrow {
        font-family: 'Cormorant Garamond', serif;
        font-style: italic;
        font-weight: 300;
        font-size: clamp(0.85rem, 1.5vw, 1.05rem);
        color: var(--rose);
        letter-spacing: 0.35em;
        text-transform: uppercase;
        margin-bottom: 1.2rem;
        opacity: 0;
        animation: fadeUp 1.2s 0.4s forwards;
    }

    /* 로고 shimmer */
    .logo {
        font-family: 'Cormorant Garamond', serif;
        font-weight: 300;
        font-size: clamp(3.5rem, 10vw, 8rem);
        letter-spacing: 0.12em;
        line-height: 1;
        opacity: 0;
        background: linear-gradient(
            90deg,
            rgba(255,255,255,0.92) 0%,
            rgba(255,255,255,0.92) 40%,
            rgba(232,160,176,1) 50%,
            rgba(255,255,255,0.92) 60%,
            rgba(255,255,255,0.92) 100%
        );
        background-size: 200% auto;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        animation: fadeUp 1.4s 0.7s forwards, shimmer 3s 2s infinite linear;
    }

    .divider {
        width: 80px;
        height: 1px;
        background: linear-gradient(to right, transparent, var(--rose), transparent);
        margin: 1.8rem auto;
        opacity: 0;
        animation: fadeUp 1s 1.1s forwards;
    }

    .tagline {
        font-family: 'Noto Serif KR', serif;
        font-weight: 300;
        font-size: clamp(0.85rem, 1.8vw, 1.1rem);
        color: rgba(255,255,255,0.75);
        letter-spacing: 0.2em;
        margin-bottom: 3rem;
        opacity: 0;
        animation: fadeUp 1.2s 1.3s forwards;
    }

    /* 입장 버튼 */
    .enter-btn {
        display: inline-block;
        font-family: 'Cormorant Garamond', serif;
        font-style: italic;
        font-size: clamp(0.9rem, 1.6vw, 1.05rem);
        font-weight: 400;
        color: var(--text-light);
        letter-spacing: 0.3em;
        text-transform: uppercase;
        text-decoration: none;
        padding: 1rem 3rem;
        border: 1px solid rgba(232, 160, 176, 0.6);
        background: rgba(255,255,255,0.04);
        backdrop-filter: blur(4px);
        cursor: pointer;
        position: relative;
        overflow: hidden;
        transition: color 0.4s, border-color 0.4s;
        opacity: 0;
        animation: fadeUp 1.2s 1.6s forwards;
    }

    .enter-btn::before {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(135deg, var(--rose-deep), var(--rose));
        transform: translateX(-101%);
        transition: transform 0.45s cubic-bezier(0.77, 0, 0.175, 1);
        z-index: -1;
    }

    .enter-btn:hover {
        color: #fff;
        border-color: transparent;
        text-decoration: none !important
    }
    .enter-btn:hover::before {
        transform: translateX(0);
    }

    /* 하단 스크롤 힌트 */
    .scroll-hint {
        position: fixed;
        bottom: 2.5rem;
        left: 50%;
        transform: translateX(-50%);
        z-index: 2;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
        opacity: 0;
        animation: fadeUp 1s 2.2s forwards;
    }

    .scroll-hint span {
        font-family: 'Cormorant Garamond', serif;
        font-style: italic;
        font-size: 0.75rem;
        color: rgba(255,255,255,0.45);
        letter-spacing: 0.2em;
    }

    .scroll-line {
        width: 1px;
        height: 40px;
        background: linear-gradient(to bottom, var(--rose), transparent);
        animation: scrollPulse 2s 2.5s infinite;
    }
    @keyframes shimmer {
    from { background-position: 200% center; }
    to   { background-position: -200% center; }
    }

    @keyframes scrollPulse {
        0%, 100% { opacity: 0.4; transform: scaleY(1); }
        50%       { opacity: 1;   transform: scaleY(1.15); }
    }

    /* ── 공통 등장 애니메이션 ── */
    @keyframes fadeUp {
        from { opacity: 0; transform: translateY(18px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    /* 좌측 하단 장식 텍스트 */
    .deco-text {
        position: fixed;
        left: 2.5rem;
        bottom: 2.5rem;
        z-index: 2;
        font-family: 'Cormorant Garamond', serif;
        font-style: italic;
        font-size: 0.72rem;
        color: rgba(255,255,255,0.3);
        letter-spacing: 0.15em;
        writing-mode: vertical-rl;
        opacity: 0;
        animation: fadeUp 1s 2s forwards;
    }

</style>
<body>
    <div id="app">
        <!-- 슬라이드쇼 -->
        <div class="slideshow">
        <div class="slide"></div>
        <div class="slide"></div>
        <div class="slide"></div>
        <div class="slide"></div>
        </div>

        <!-- 오버레이 -->
        <div class="overlay"></div>

        <!-- 메인 콘텐츠 -->
        <div class="content">
        <p class="eyebrow">Wedding Review Platform</p>
        <h1 class="logo">Marry<span>View</span></h1>
        <div class="divider"></div>
        <p class="tagline">당신의 특별한 날, 진심을 담은 리뷰</p>
        <a href="/merryViewHome.do" class="enter-btn">입장하기</a>
        </div>

        <!-- 하단 장식 -->
        <div class="scroll-hint">
        <div class="scroll-line"></div>
        </div>

        <p class="deco-text">© 2026 MarryView</p>
    </div>
</body>
<script>
    const slides = document.querySelectorAll('.slide');
    let current = 0;

    slides[0].style.opacity = 1;

    setInterval(() => {
        const next = (current + 1) % slides.length;
        slides[next].style.opacity = 1;
        setTimeout(() => {
            slides[current].style.opacity = 0;
            current = next;
        }, 500);
    }, 5000);
    
</script>
</html>

