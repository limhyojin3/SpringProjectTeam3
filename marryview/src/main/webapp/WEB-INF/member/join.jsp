<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView - 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
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

        .logo-wrap {
            text-align: center;
            margin-bottom: 28px;
            cursor: pointer;
        }
        .logo-wrap img { height: 80px; }

        .signup-container {
            display: flex;
            gap: 20px;
            justify-content: center;
            width: 100%;
            max-width: 800px;
            margin-bottom: 20px;
        }

        .signup-box {
            flex: 1;
            min-width: 240px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 28px 20px;
            text-align: center;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .signup-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(244,160,150,0.25);
        }

        /* 상단 타이틀 배너 */
        .box-header {
            width: 100%;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 4px;
        }
        .box-header.user    { background: #f4a096; }
        .box-header.company { background: #9b8fd4; }
        .box-header h3 {
            color: white;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        /* 내용 */
        .signup-box-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        .box-slogan {
            font-size: 13px;
            font-weight: 700;
            color: #f4a096;
        }
        .box-slogan.company { color: #9b8fd4; }

        .box-sub {
            font-size: 13px;
            color: #666;
            margin-bottom: 4px;
        }

        .content-list {
            width: 100%;
            text-align: left;
            border-top: 1px solid #f0f0f0;
            padding-top: 12px;
            display: flex;
            flex-direction: column;
            gap: 7px;
        }
        .content-list p {
            font-size: 12px;
            color: #666;
            line-height: 1.5;
        }
        .content-list p.highlight {
            color: #f4a096;
            font-weight: 700;
        }
        .content-list p.highlight.company { color: #9b8fd4; }
        .content-list p.muted {
            color: #aaa;
            font-size: 11px;
            padding-left: 4px;
        }

        /* 하단 링크 */
        .link-wrap {
            display: flex;
            justify-content: center;
        }
        .link-login {
            text-decoration: none;
            color: #888;
            font-size: 13px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .link-login:hover { color: #f4a096; }
    </style>
</head>
<body>
    <div id="app">
        <div class="logo-wrap" @click="fnMain()">
            <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
        </div>
        <div class="signup-container">
            <!-- 일반 회원가입 -->
            <div class="signup-box" @click="fnUserJoin()">
                <div class="box-header user">
                    <h3>일반 회원가입</h3>
                </div>
                <div class="signup-box-content">
                    <p class="box-slogan">♥ 똑똑한 결혼 준비 ♥</p>
                    <p class="box-sub">메리뷰와 함께 하세요!</p>
                    <div class="content-list">
                        <p>✅ 결혼 예정일 입력 시 쿠폰 제공</p>
                        <p>✅ 결혼 준비 커뮤니티 참여</p>
                        <p>✅ 내 리뷰 작성으로 얻는 혜택</p>
                        <p>✅ 솔직한 리얼 후기 열람</p>
                    </div>
                </div>
            </div>

            <!-- 업체 가입 -->
            <div class="signup-box" @click="fnCompanyJoin()">
                <div class="box-header company">
                    <h3>업체 가입</h3>
                </div>
                <div class="signup-box-content">
                    <p class="box-slogan company">♥ 결혼 준비 파트너 ♥</p>
                    <p class="box-sub">메리뷰와 제휴를 맺어보세요!</p>
                    <div class="content-list">
                        <p>✅ 파트너 혜택</p>
                        <p class="highlight company">✅ 예약 수수료 5%</p>
                        <p class="muted">🔺 일반 업체의 경우 10%</p>
                        <p>✅ 업체 페이지 무료 등록</p>
                        <p>✅ 리뷰 관리 시스템 제공</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="link-wrap">
            <span @click="fnLogin()" class="link-login">로그인 페이지로 돌아가기</span>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            fnMain() {
                location.href = '/merryViewHome.do';
            },
            fnLogin: function () {
                window.location.href = '/login.do';
            },
            fnUserJoin : function(){
                window.location.href = '/joinUser.do';
            },
            fnCompanyJoin : function(){
                window.location.href = '/joinCompany.do';
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>