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
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; }

        #container {
            width: 500px;
            text-align: center;
            position: relative;
        }

        h1 {
            font-size: 30px;
            margin-bottom: 20px;
            color: #333;
        }

        /* 폼 테이블 */
        th {
            background: #f4a096;
            color: white;
            padding: 0 15px;
            text-align: left;
            font-weight: normal;
            font-size: 14px;
            width: 140px;
            border: 1px solid #f4a096;
            vertical-align: middle;
        }

        td {
            border: 1px solid #f4a096;
            width: 360px;
            vertical-align: middle;
        }

        /* 버튼 들어가는 td */
        .td-btn {
            position: absolute;
            width: 100px; /* 버튼 영역 너비 확보 */
            border: none !important; /* 테이블 테두리 강제 제거 */
            background: transparent;
            padding-left: 10px;
            vertical-align: middle;
        }

        /* 버튼 사이의 간격을 위해 두 번째 버튼이 있는 tr에 패딩이나 높이 조절 */
        tr {
            height: 50px; /* 입력창과 버튼의 높이 정렬을 위해 약간 조정 */
        }

        /* 테이블 자체의 테두리와 버튼 테두리가 겹치지 않게 설정 */
        table {
            border-collapse: collapse; /* 테두리 분리 */
            border-spacing: 0;
            width: auto; 
            margin: 0 auto 20px;
        }

        td input {
            width: 100%;
            border: none;
            outline: none;
            padding: 0 10px;
            height: 45px;
            font-size: 14px;
            display: block;
        }

        /* 중복체크, 인증 버튼 */
        .btn-check {
            background: #f0b429;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            white-space: nowrap;
            width: 100%;
        }

        .btn-check:hover {
            opacity: 0.85;
        }

        /* 아이디 찾기 버튼 */
        .login-btn {
            width: 150px;
            padding: 10px 0;
            background: #f0b429;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            margin-bottom: 15px;
        }

        .login-btn:hover {
            opacity: 0.85;
        }

        /* 하단 링크 */
        .link-wrap {
            font-size: 13px;
            color: #666;
        }

        .link-wrap a {
            color: #666;
            text-decoration: none;
        }

        .link-wrap a:hover {
            color: #f4a096;
        }
        .logo {
            box-sizing: border-box;
            width: 100%;
            max-width: 300px;  /* ← 크기 제한 */
            margin: 0 auto 20px;  /* ← 가운데 정렬 */
            text-align: center;
            margin-bottom: 15px;
        }
        .logo img {
            display: block;
            margin: 0 auto;
            width: 350px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <!-- 로고 -->
        <div id="container">
            <div class="logo">
              <img src="/img/merryview-logo-text.svg" alt="메리뷰 로고">
            </div>
            <h1>비밀번호 찾기</h1>
            <table>
                <tr>
                    <th>아이디</th>
                    <td><input type="text" v-model="userName" placeholder="가입한 아이디"></td>
                    <td class="td-btn"></td> </tr>
                <tr>
                    <th>핸드폰 번호</th>
                    <td><input type="text" v-model="userTel" placeholder="가입시 입력한 번호"></td>
                    <td class="td-btn"><button class="btn-check">인증 요청</button></td>
                </tr>
                <tr>
                    <th>번호 인증</th>
                    <td><input type="text" v-model="authCode"></td>
                    <td class="td-btn"><button class="btn-check">인증 확인</button></td>
                </tr>
            </table>

            <button class="login-btn" @click="fnChangePw()">비밀번호 변경</button>
            <div class="link-wrap">
                <a href="/login.do"><span>로그인 페이지로 돌아가기</span></a>
                <span>|</span>
                <a href=""><span>아이디 찾기</span></a>
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