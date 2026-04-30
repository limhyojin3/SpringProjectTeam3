<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메리뷰 로그인</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: #fafafa;
            font-family: 'Noto Sans KR', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 60px 16px 40px;
            min-height: 100vh;
        }

        /* ── 로고 영역 ── */
        .logo-wrap {
            margin-bottom: 15px;
            cursor: pointer;
        }
        .logo-wrap img {
            height: 80px;
        }

        /* ── 로그인 카드 ── */
        .login-card {
            width: 100%;
            max-width: 550px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 40px 40px 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        /* ── 탭 ── */
        .tab-wrap {
            display: flex;
            border-bottom: 2px solid #eee;
            margin-bottom: 22px;
        }
        .tab-wrap button {
            flex: 1;
            padding: 14px 0;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 16px;
            font-family: 'Noto Sans KR', sans-serif;
            color: #999;
            font-weight: 500;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            transition: color 0.2s, border-color 0.2s;
        }
        .tab-wrap button.active-user {
            color: #f4a096;
            border-bottom-color: #f4a096;
        }
        .tab-wrap button.active-company {
            color: #9b8fd4;
            border-bottom-color: #9b8fd4;
        }

        /* ── 입력 필드 ── */
        .input-group {
            display: flex;
            flex-direction: column;
            gap: 0;
            margin-bottom: 14px;
        }
        .input-group input {
            width: 100%;
            height: 60px;
            padding: 0 14px;
            font-size: 16px;
            font-family: 'Noto Sans KR', sans-serif;
            border: 1px solid #ddd;
            outline: none;
            transition: border-color 0.2s;
            background: #fff;
        }
        .input-group input:first-child {
            border-radius: 6px 6px 0 0;
            border-bottom: none;
        }
        .input-group input:last-child {
            border-radius: 0 0 6px 6px;
        }
        .input-group input:focus {
            border-color: #f4a096;
            z-index: 1;
            position: relative;
        }
        /* 업체 탭 포커스 색 */
        .company-mode .input-group input:focus {
            border-color: #9b8fd4;
        }
        .company-mode .login-btn {
            background: #9b8fd4;
        }

        /* ── 로그인 버튼 ── */
        .login-btn {
            width: 100%;
            height: 60px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-family: 'Noto Sans KR', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.2s;
            margin-bottom: 20px;
        }
        .login-btn:hover { opacity: 0.88; }

        /* ── 하단 링크 ── */
        .link-wrap {
            display: flex;
            justify-content: center;
            gap: 4px;
        }
        .link-wrap a {
            text-decoration: none;
            color: #888;
            font-size: 15px;
        }
        .link-wrap span.sep {
            color: #ccc;
            font-size: 15px;
        }
        .link-wrap a:hover { color: #f4a096; }

        /* ── 광고 배너 영역 ── */
        .ad-banner {
            width: 100%;
            max-width: 550px;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            background: #fff5f3;
        }
        .kr-bold { font-family: 'Noto Sans KR', sans-serif; font-weight: 700; }
        .kr-reg  { font-family: 'Noto Sans KR', sans-serif; font-weight: 400; }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes floatA {
            0%,100% { transform: translateY(0) rotate(-30deg); }
            50%     { transform: translateY(-7px) rotate(-30deg); }
        }
        @keyframes floatB {
            0%,100% { transform: translateY(0) rotate(20deg); }
            50%     { transform: translateY(-9px) rotate(20deg); }
        }
        @keyframes floatC {
            0%,100% { transform: translateY(0) rotate(60deg); }
            50%     { transform: translateY(-5px) rotate(60deg); }
        }
        @keyframes floatD {
            0%,100% { transform: translateY(0) rotate(-40deg); }
            50%     { transform: translateY(-8px) rotate(-40deg); }
        }
        @keyframes floatE {
            0%,100% { transform: translateY(0) rotate(15deg); }
            50%     { transform: translateY(-6px) rotate(15deg); }
        }
        @keyframes heartBeat  { 0%,100%{transform:scale(1);opacity:0.5;} 50%{transform:scale(1.3);opacity:0.8;} }
        @keyframes heartBeat2 { 0%,100%{transform:scale(1);opacity:0.35;} 50%{transform:scale(1.25);opacity:0.65;} }
        @keyframes heartBeat3 { 0%,100%{transform:scale(1);opacity:0.4;} 50%{transform:scale(1.2);opacity:0.6;} }
        @keyframes starPop    { 0%{opacity:0;transform:scale(0);} 60%{transform:scale(1.3);} 100%{opacity:1;transform:scale(1);} }
        @keyframes btnGlow    { 0%,100%{opacity:1;} 50%{opacity:0.82;} }

        .txt-main1 { animation: fadeSlideUp 0.7s ease 0.20s both; }
        .txt-main2 { animation: fadeSlideUp 0.7s ease 0.45s both; }
        .txt-sub   { animation: fadeSlideUp 0.7s ease 0.65s both; }
        .logo-txt  { animation: fadeIn 0.8s ease 0.1s both; }
        .logo-sub  { animation: fadeIn 0.8s ease 0.3s both; }
        .star1 { animation: starPop 0.4s ease 0.9s  both; transform-origin: 62px  146px; }
        .star2 { animation: starPop 0.4s ease 1.0s  both; transform-origin: 80px  146px; }
        .star3 { animation: starPop 0.4s ease 1.1s  both; transform-origin: 98px  146px; }
        .star4 { animation: starPop 0.4s ease 1.2s  both; transform-origin: 116px 146px; }
        .star5 { animation: starPop 0.4s ease 1.3s  both; transform-origin: 134px 146px; }
        .petal1 { animation: floatA 3.0s ease-in-out 0.0s infinite; transform-origin: 560px  40px; }
        .petal2 { animation: floatB 3.5s ease-in-out 0.4s infinite; transform-origin: 570px  35px; }
        .petal3 { animation: floatC 2.8s ease-in-out 0.8s infinite; transform-origin: 555px  50px; }
        .petal4 { animation: floatD 3.2s ease-in-out 0.2s infinite; transform-origin: 640px 130px; }
        .petal5 { animation: floatE 3.8s ease-in-out 0.6s infinite; transform-origin: 650px 125px; }
        .heart1 { animation: heartBeat  1.4s ease-in-out 0.0s infinite; transform-origin: 588px  33px; }
        .heart2 { animation: heartBeat2 1.8s ease-in-out 0.3s infinite; transform-origin: 642px  67px; }
        .heart3 { animation: heartBeat3 1.6s ease-in-out 0.6s infinite; transform-origin: 612px 156px; }
        .cta-btn { animation: fadeIn 0.6s ease 0.85s both, btnGlow 2s ease-in-out 1.5s infinite; }
        .cta-lbl { animation: fadeIn 0.6s ease 0.85s both; }

        /* ── 푸터 include 영역 ── */
        .footer-wrap {
            width: 100%;
            max-width: 460px;
            margin-top: 20px;
            text-align: left;
            font-size: 10px;
        }
        /* login.jsp의 <style> 안에 추가 */
        .footer-wrap .footer-links a {
            margin-right: 10px;
            color: #bbb;
            text-decoration: none;
            font-size: 12px;
        }
        .footer-wrap .footer-links a:hover {
            color: #f4a096;
        }
    </style>
</head>
<body>
<div id="app">

    <!-- 로고 -->
    <div class="logo-wrap" @click="fnMain()">
        <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
    </div>

    <!-- 로그인 카드 -->
    <div class="login-card" :class="{'company-mode': tab === 'company'}">

        <!-- 탭 -->
        <div class="tab-wrap">
            <button :class="{'active-user': tab === 'user'}" @click="FnswitchTab('user')">일반 로그인</button>
            <button :class="{'active-company': tab === 'company'}" @click="FnswitchTab('company')">업체 로그인</button>
        </div>

        <!-- 일반 로그인 폼 -->
        <div v-show="tab === 'user'">
            <div class="input-group">
                <input type="text" v-model="userId" placeholder="아이디">
                <input type="password" v-model="userPwd" @keyup.enter="fnLogin()" placeholder="비밀번호">
            </div>
        </div>

        <!-- 업체 로그인 폼 -->
        <div v-show="tab === 'company'">
            <div class="input-group">
                <input type="text" v-model="companyId" placeholder="기업 아이디">
                <input type="password" v-model="companyPwd" @keyup.enter="fnLogin()" placeholder="비밀번호">
            </div>
        </div>

        <!-- 로그인 버튼 -->
        <button class="login-btn" @click="fnLogin()">로그인</button>

        <!-- 하단 링크 -->
        <div class="link-wrap">
            <a href="/join.do">회원가입</a>
            <span class="sep">&nbsp;|&nbsp;</span>
            <a href="/find-id.do">아이디 찾기</a>
            <span class="sep">&nbsp;|&nbsp;</span>
            <a href="/find-pwd.do">비밀번호 변경</a>
        </div>

    </div>

    <!-- 광고 배너 -->
    <div class="ad-banner" onclick="location.href='${pageContext.request.contextPath}/api/review/list.do'">
        <svg width="100%" viewBox="0 0 680 230" role="img" xmlns="http://www.w3.org/2000/svg">
            <title>메리뷰 광고 배너</title>

            <rect width="680" height="230" fill="#fff5f3"/>
            <rect x="0" y="0" width="220" height="230" fill="#f4a096"/>

            <circle cx="60"  cy="40"  r="50" fill="#f7b8af" opacity="0.5"/>
            <circle cx="160" cy="190" r="40" fill="#f7b8af" opacity="0.4"/>
            <circle cx="30"  cy="170" r="30" fill="#fad4cf" opacity="0.6"/>

            <text x="110" y="93"  text-anchor="middle" class="kr-bold logo-txt" font-size="35" fill="white" letter-spacing="1">메리뷰</text>
            <text x="110" y="122" text-anchor="middle" class="kr-reg  logo-sub" font-size="17" fill="white" opacity="0.9" letter-spacing="3">M A R R Y V I E W</text>

            <text x="62"  y="158" class="star1" font-size="20" fill="white">★</text>
            <text x="83"  y="158" class="star2" font-size="20" fill="white">★</text>
            <text x="104" y="158" class="star3" font-size="20" fill="white">★</text>
            <text x="125" y="158" class="star4" font-size="20" fill="white">★</text>
            <text x="146" y="158" class="star5" font-size="20" fill="white">★</text>

            <text x="450" y="72"  text-anchor="middle" class="kr-bold txt-main1" font-size="38" fill="#d94f3b" letter-spacing="-0.5">똑부러지게</text>
            <text x="450" y="118" text-anchor="middle" class="kr-bold txt-main2" font-size="38" fill="#333">결혼하고 싶다면?</text>

            <rect x="300" y="152" width="290" height="45" fill="#f4a096" rx="18" class="cta-btn"/>
            <text x="450" y="182" text-anchor="middle" class="kr-bold cta-lbl" font-size="25" fill="white">지금 바로 확인하기 →</text>

            <path class="heart1" d="M598 30 C598 26 593 22 588 26 C583 22 578 26 578 30 C578 36 588 44 588 44 C588 44 598 36 598 30Z" fill="#f4a096"/>
            <path class="heart2" d="M650 65 C650 62 646 58 642 62 C638 58 634 62 634 65 C634 70 642 76 642 76 C642 76 650 70 650 65Z" fill="#f4a096"/>
            <path class="heart3" d="M625 175 C625 172 621 168 617 172 C613 168 609 172 609 175 C609 179 617 184 617 184 C617 184 625 179 625 175Z" fill="#9b8fd4"/>

            <ellipse class="petal1" cx="560" cy="40"  rx="5" ry="9" fill="#f7b8af" opacity="0.6"/>
            <ellipse class="petal2" cx="570" cy="35"  rx="5" ry="9" fill="#fad4cf" opacity="0.6"/>
            <ellipse class="petal3" cx="555" cy="50"  rx="5" ry="9" fill="#f4a096" opacity="0.4"/>
            <ellipse class="petal4" cx="640" cy="145" rx="5" ry="9" fill="#c9bde8" opacity="0.5"/>
            <ellipse class="petal5" cx="652" cy="138" rx="5" ry="9" fill="#9b8fd4" opacity="0.4"/>
        </svg>
    </div>
    <!-- 푸터 include 영역 -->
    <div class="footer-wrap">
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                tab: 'user',
                userId: '',
                userPwd: '',
                companyId: '',
                companyPwd: ''
            };
        },
        methods: {
            fnMain() {
                location.href = '/merryViewHome.do';
            },
            fnLogin() {
                let param = {
                    userId: this.tab === 'user' ? this.userId : this.companyId,
                    password: this.tab === 'user' ? this.userPwd : this.companyPwd,
                    tab: this.tab
                };
                $.ajax({
                    url: '/login.dox',
                    dataType: 'json',
                    type: 'POST',
                    data: param,
                    success(data) {
                        alert(data.message);
                        if (data.loginResult) location.href = '/merryViewHome.do';
                    }
                });
            },
            FnswitchTab(type) {
                this.tab = type;
            }
        },
        mounted() {
            this.FnswitchTab('user');
        }
    });

    app.mount('#app');
</script>
</body>
</html>
