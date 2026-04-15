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
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        .login-btn{
            width: 100px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div id="container">
            <button @click="FnswitchTab('user')">일반 로그인</button>
            <button @click="FnswitchTab('company')">업체 로그인</button>
            <!-- 일반 로그인 폼 -->
            <div id="userForm">
                <table>
                    <tr>
                        <label><th>아이디</th></label>
                        <td><input type="text" v-model="userId" placeholder="아이디"></td>
                    </tr>
                    <tr>
                        <label><th>비밀번호</th></label>
                        <td><input type="password" v-model="userPwd" placeholder="비밀번호"></td>
                    </tr>
                </table>
            </div>
            <!-- 업체 로그인 폼 -->
             <div id="companyForm">
                <table>
                    <tr>
                        <label><th>업체 아이디</th></label>
                        <td><input type="text" v-model="companyId" placeholder="아이디"></td>
                    </tr>
                    <tr>
                        <label><th>비밀번호</th></label>
                        <td><input type="password" v-model="companyPwd" placeholder="비밀번호"></td>
                    </tr>
                </table>
            </div>
            <button class="login-btn" @click="fnLogin()">로그인</button>
            <div>
                <a href="/join.do"><span>회원가입</span></a><span>아이디/비밀번호 찾기</span>
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
                    userId : self.userId,
                    userPwd : self.pwd
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