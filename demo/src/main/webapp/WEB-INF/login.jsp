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
            width: 380px;
            border: 2px solid #f4a096;
            border-radius: 12px;
            padding: 30px;
            background: white;
            text-align: center;
        }

        /* 탭 버튼 */
        .tab-wrap {
            display: flex;
            margin-bottom: 20px;
        }

        .tab-wrap button {
            flex: 1;
            padding: 10px 0;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            font-size: 14px;
        }

        .tab-wrap button.active-user {
            background: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        .tab-wrap button.active-company {
            background: #9b8fd4;
            color: white;
            border-color: #9b8fd4;
        }
        /* 업체 탭 선택시 th 색상 변경 */
        .company-form th {
            background: #9b8fd4;
            border-color: #9b8fd4;
        }

        .company-form td {
            border-color: #9b8fd4;
        }
        /* 유저 탭 선택시 th 색상 변경 */
        .user-form th {
            background: #f4a096;
            border-color: #f4a096;
        }

        .user-form td {
            border-color: #f4a096;
        }

        /* 폼 테이블 */
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        
        tr { height: 45px; }

        th {
            background: #f4a096;
            color: white;
            padding: 0 15px;    /* 위아래 padding 제거 */
            text-align: left;
            font-weight: normal;
            font-size: 14px;
            width: 100px;
            border: 1px solid #f4a096;
            vertical-align: middle;
        }

        td { 
            border: 1px solid #f4a096; 
            vertical-align: middle;
        }

        td input {
            width: 100%;
            border: none;
            outline: none;
            padding: 0 10px;    /* 위아래 padding 제거 */
            height: 45px;       /* tr 높이랑 맞추기 */
            font-size: 14px;
            display: block;
        }

        /* 로그인 버튼 */
        .login-btn {
            width: 150px;
            padding: 10px 0;
            background: #f0b429;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <!-- 로고 -->
        <div class="logo">
            로고 이미지 자리
        </div>

        <!-- 탭 버튼 -->
        <div class="tab-wrap">
            <button :class="{'active-user': tab === 'user'}" @click="FnswitchTab('user')">일반 로그인</button>
            <button :class="{'active-company': tab === 'company'}" @click="FnswitchTab('company')">업체 로그인</button>
        </div>

        <!-- 일반 로그인 폼 -->
        <div id="userForm" v-show="tab === 'user'" :class="{'user-form': tab === 'user'}">
            <table>
                <tr>
                    <th>아이디</th>
                    <td><input type="text" v-model="userId" placeholder="아이디"></td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td><input type="password" v-model="userPwd" placeholder="비밀번호"></td>
                </tr>
            </table>
        </div>

        <!-- 업체 로그인 폼 -->
        <div id="companyForm" v-show="tab === 'company'" :class="{'company-form': tab === 'company'}">
            <table>
                <tr>
                    <th>기업 아이디</th>
                    <td><input type="text" v-model="companyId" placeholder="아이디"></td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td><input type="password" v-model="companyPwd" placeholder="비밀번호"></td>
                </tr>
            </table>
        </div>

        <button class="login-btn" @click="fnLogin()">로그인</button>

        <div class="link-wrap">
            <a href="/join.do"><span>회원가입</span></a>
            <span>|</span>
            <span>아이디/비밀번호 찾기</span>
        </div>


    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                tab : 'user',
                userId : "",
                userPwd : "",
                companyId : "",
                companyPwd : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnLogin: function () {
                let self = this;
                let param = {
                    userId: this.tab === 'user' ? this.userId : this.companyId,
                    password: this.tab === 'user' ? this.userPwd : this.companyPwd,
                    tab: this.tab  // ← 어떤 탭인지
                };
                $.ajax({
                    url: "http://localhost:8080/login.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.loginResult){
                            location.href=data.url;
                        }
                    }
                });
            },
            FnswitchTab: function(type) {
                this.tab = type;
                if(type === 'user') {
                    document.getElementById('userForm').style.display = 'block';
                    document.getElementById('companyForm').style.display = 'none';
                } else {
                    document.getElementById('userForm').style.display = 'none';
                    document.getElementById('companyForm').style.display = 'block';
                }
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.FnswitchTab('user');
        }
    });

    app.mount('#app');
</script>