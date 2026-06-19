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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
       * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: #1a1a2e;
            font-family: 'Noto Sans KR', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;  /* 추가 */
            min-height: 100vh;
        }

        .logo-wrap {
            margin-bottom: 15px;
            cursor: pointer;
        }
        .logo-wrap img {
            height: 80px;
        }

        .login-card {
            width: 100%;
            max-width: 550px;
            background: #16213e;
            border: 1px solid #0f3460;
            border-radius: 10px;
            padding: 40px 40px 32px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.3);
        }

        .login-card-title {
            color: white;
            text-align: center;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 24px;
        }

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
            border: 1px solid #1a4a8a;
            outline: none;
            background: #0f3460;
            color: white;
            transition: border-color 0.2s;
        }
        .input-group input::placeholder {
            color: #888;
        }
        .input-group input:first-child {
            border-radius: 6px 6px 0 0;
            border-bottom: none;
        }
        .input-group input:last-child {
            border-radius: 0 0 6px 6px;
        }
        .input-group input:focus {
            border-color: #e94560;
            z-index: 1;
            position: relative;
        }

        .login-btn {
            width: 100%;
            height: 60px;
            background: #e94560;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-family: 'Noto Sans KR', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .login-btn:hover { opacity: 0.88; }

        .login-card-title i {
            color: #e94560;
        }

        .admin-label {
            color: #888;
            font-size: 18px;
            letter-spacing: 4px;
            margin-bottom: 20px;
            text-transform: uppercase;
            text-align: center;
        }

    </style>
</head>
<body>
<div id="app">

    <!-- 로그인 카드 -->
    <p class="admin-label">MarryView Admin</p>
    <div class="login-card">
        <p class="login-card-title">
            <i class="fa-solid fa-lock"></i> 관리자 로그인
        </p>
        <div class="input-group">
            <input type="text" v-model="userId" @input="fnFilterId('user')" placeholder="관리자 아이디">
            <input type="password" v-model="userPwd" @keyup.enter="fnLogin()" placeholder="비밀번호">
        </div>
        <button class="login-btn" @click="fnLogin()">로그인</button>
    </div>
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                tab: 'user',
                userId: '',
                userPwd: '',
            };
        },
        methods: {
            fnMain() {
                location.href = '/merryViewHome.do';
            },
            fnLogin() {
                let param = {
                    userId: this.userId,
                    password: this.userPwd,
                    tab: 'user'
                };
                $.ajax({
                    url: '/login.dox',
                    dataType: 'json',
                    type: 'POST',
                    data: param,
                    success: (data) => {
                        if (data.loginResult) {
                            if (data.url === '/admin/main.do') {
                                location.href = '/adminMain.do';
                            } else {
                                $.ajax({
                                    url: '/logout.do',
                                    type: 'GET',
                                    success() {
                                        alert('관리자 계정이 아닙니다.');
                                        location.href = '/admin/login.do';
                                    }
                                });
                            }
                        } else {
                            if (data.message && data.message.includes('업체')) {
                                alert('관리자 계정이 아닙니다.');
                            } else {
                                alert('아이디 또는 비밀번호가 올바르지 않습니다.');
                            }
                            this.userPwd = '';  // 비밀번호 초기화
                        }
                    }
                });
            },
            FnswitchTab(type) {
                this.tab = type;
            },
            // 영문 + 숫자만 허용
            fnFilterId(type) {
                if (type === 'user') {
                    this.userId = this.userId.replace(/[^a-zA-Z0-9]/g, '');
                } else { // 업체 아이디는 _ 허용
                    this.companyId = this.companyId.replace(/[^a-zA-Z0-9_]/g, '');
                }
            },
        },
        mounted() {
            this.FnswitchTab('user');
        }
    });

    app.mount('#app');
</script>
</body>
</html>
