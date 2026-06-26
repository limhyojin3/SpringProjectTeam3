<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
            margin-bottom: 28px;
            cursor: pointer;
        }
        .logo-wrap img { height: 80px; }

        .find-card {
            width: 100%;
            max-width: 550px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 40px 40px 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .find-card h2 {
            font-size: 18px;
            font-weight: 600;
            color: #555;
            text-align: center;
            margin-bottom: 28px;
        }

        .input-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 14px;
        }
        .input-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .input-row input {
            flex: 1;
            height: 56px;
            padding: 0 14px;
            font-size: 15px;
            font-family: 'Noto Sans KR', sans-serif;
            border: 1px solid #f4a096;
            outline: none;
            transition: border-color 0.2s;
            background: #fff;
        }
        .input-row input:focus {
            border-color: #e8836f;
            position: relative;
            z-index: 1;
        }
        .input-group .input-row:first-child input {
            border-radius: 6px 6px 0 0;
            border-bottom: none;
        }
        .input-group .input-row:not(:first-child):not(:last-child) input {
            border-radius: 0;
            border-bottom: none;
        }
        .input-group .input-row:last-child input {
            border-radius: 0 0 6px 6px;
        }
        .input-group .input-row:only-child input {
            border-radius: 6px;
            border-bottom: 1px solid #f4a096;
        }

        .btn-check {
            flex-shrink: 0;
            height: 56px;
            padding: 0 16px;
            background: #f0b429;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Noto Sans KR', sans-serif;
            font-weight: 500;
            cursor: pointer;
            white-space: nowrap;
            transition: opacity 0.2s;
        }
        .btn-check:hover { opacity: 0.88; }

        .main-btn {
            width: 100%;
            height: 56px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-family: 'Noto Sans KR', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.2s;
            margin-top: 8px;
            margin-bottom: 20px;
        }
        .main-btn:hover { opacity: 0.88; }

        .link-wrap {
            display: flex;
            justify-content: center;
            gap: 4px;
        }
        .link-wrap a {
            text-decoration: none;
            color: #888;
            font-size: 13px;
        }
        .link-wrap span.sep {
            color: #ccc;
            font-size: 13px;
        }
        .link-wrap a:hover { color: #f4a096; }
    </style>
</head>
<body>
    <div id="app">
        <div class="logo-wrap" @click="fnMain()">
            <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
        </div>
        <div class="find-card">
            <h2>비밀번호 찾기</h2>
            <div class="input-group">
                <div class="input-row">
                    <input type="text" v-model="userName" placeholder="가입한 아이디">
                </div>
                <div class="input-row">
                    <input type="text" v-model="userTel" placeholder="가입 시 입력한 번호">
                    <button class="btn-check">인증 요청</button>
                </div>
                <div class="input-row">
                    <input type="text" v-model="authCode" placeholder="인증번호 6자리">
                    <button class="btn-check">인증 확인</button>
                </div>
            </div>
            <button class="main-btn" @click="fnChangePw()">비밀번호 변경</button>
            <div class="link-wrap">
                <a href="/login.do">로그인으로 돌아가기</a>
                <span class="sep">&nbsp;|&nbsp;</span>
                <a href="/find-id.do">아이디 찾기</a>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userName: '',
                userTel: '',
                authCode: ''

            };
        },
        methods: {
            fnMain : function(){
                location.href="/merryViewHome.do";
            },
            // 1단계: 정보 일치 확인
            fnCheckUser: function() {
                if(!this.userId || !this.userName || !this.phone) return alert("입력란을 채워주세요.");
                
                axios.post("/check-user.dox", { 
                    userId: this.userId, userName: this.userName, phone: this.phone 
                }).then(res => {
                    if(res.data.count > 0) {
                        this.isVerified = true; // 확인되면 화면 교체!
                    } else {
                        alert("정보가 일치하지 않습니다.");
                    }
                });
            },
            // 2단계: 실제 변경
            fnChangePw: function() {
                if(this.newPw !== this.confirmPw) return alert("비밀번호 불일치!");
                
                axios.post("/change-pw.dox", {
                    userId: this.userId, newPw: this.newPw
                }).then(res => {
                    if(res.data.result === "success") {
                        alert("변경 완료! 로그인하러 가요~");
                        location.href = "/login.do";
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>