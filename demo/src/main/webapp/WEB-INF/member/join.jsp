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
            background: linear-gradient(135deg, #ffe8e6, #f5f0ff);
            font-family: 'Noto Sans KR', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        #app {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            width: 100%; 
        }

        .signup-container {
            display: flex;
            gap: 30px;
            justify-content: center;
            padding: 20px;
            width: 100%;        
            max-width: 900px;   
        }

        .signup-box {
            flex: 1;
            max-width: 300px;
            min-height: 360px;  /* 높이 통일 */
            border: 2px solid #eee;
            border-radius: 16px;
            padding: 30px 20px;
            text-align: center;
            cursor: pointer;
            background: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .signup-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        #inner-box-user {
            width: 100%;
            border-radius: 10px;
            border: 2px solid #d18d84;
            background: linear-gradient(135deg, #ffada2, #f4a096);
            box-shadow: 1px 1px 3px rgba(0,0,0,0.1);
            padding: 12px;
        }

        #inner-box-company {
            width: 100%;
            border-radius: 10px;
            border: 2px solid #a564cd;
            background: linear-gradient(135deg, #cc7aff, #a855f7);
            box-shadow: 1px 1px 3px rgba(0,0,0,0.1);
            padding: 12px;
        }

        #inner-box-user h3, #inner-box-company h3 {
            color: white;
            font-size: 16px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.15);
        }

        .company-txt-color { color: #a81bff !important; }
        .user-txt-color { color: #ff1ba8 !important; }
        .txt-bold { font-weight: bold;}

        .signup-box p {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
        }

        .link-login {
            margin-top: 20px;
            text-decoration: none;
            color: #767676;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
        }

        .link-login:hover {
            color: #f15443;
            text-shadow: 1px 1px 1px pink;
        }
        .signup-box-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;  /* 세로 중앙 */
            align-items: center;
            gap: 8px;
        }
        .content-left{
            text-align: left;
        }
        .content-left p {
            padding-bottom: 5px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="signup-container">
        <div class="signup-box user" @click="fnUserJoin()">
            <div id="inner-box-user">
                <h3>일반 회원가입</h3>
            </div>
            <div class="signup-box-content">
                <p class="txt-bold user-txt-color">♥똑똑한 결혼 준비♥</p>
                <p>메리뷰와 함께 하세요!</p>
                <div class="content-left">
                    <p>✅ 결혼 예정일 입력시 쿠폰</p>
                    <p>✅ 결혼 준비 커뮤니티 참여</p>
                    <p>✅ 내 리뷰 작성으로 얻는 혜택</p>
                    <p>✅ 거품없는 솔직한 리얼 후기 열람</p>
                </div>
            </div>
        </div>
        <div class="signup-box company" @click="fnCompanyJoin()">
            <div id="inner-box-company">
                <h3>업체 가입</h3>
            </div>
            <div class="signup-box-content">
                <div class="txt-bold">
                    <p class="company-txt-color">♥메리뷰와 제휴를 맺어♥</p>
                    <p class="company-txt-color">♥결혼 준비 파트너가 되어보세요!♥</p>
                </div>
                <p class="txt-bold">파트너가 되면 이런 혜택을 받을 수 있어요!</p>
                <div class="content-left">
                    <div class="company-txt-color">
                        <p class="txt-bold">✅ 예약 수수료 5%</p>
                        <p>🔺 일반 업체의 경우 10%</p>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <span @click="fnLogin()" class="link-login cusor">로그인 페이지로 돌아가기</span>
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
            // 함수(메소드) - (key : function())
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