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
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
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
            cursor: pointer;
        }
        .logo img {
            display: block;
            margin: 0 auto;
            width: 350px;
        }
        .link-wrap a{
            margin-top: 5px;
            text-decoration: none;
            color: #767676;
            font-size: 15px;
            font-weight: 500;
        }
        .link-login:hover , .link-find:hover{
            color: #f15443;
            text-shadow: 1px 1px 1px pink;
        }
        .msg-box {
            height: 40px;
            font-size: 11px;
            padding-left: 5px;
            color: transparent;
        }

        /* msg-box 감싸는 td border 제거 */
        .msg-box-row td {
            border: none !important;
        }
    </style>
</head>
<body>
    <div id="app">
        <div id="container">
            <div class="logo">
                <img src="/img/marryview-logo-text.svg" alt="메리뷰 로고" @click="fnMain()">
            </div>
            <div v-if="!isVerified">
                <h1>비밀번호 변경</h1>
                <table>
                    <tr>
                        <th>아이디</th>
                        <td><input type="text" v-model="userId" @input="filterUserId" placeholder="가입한 아이디"></td>
                    </tr>
                    <tr>
                        <th>이름(대표자명)</th>
                        <td><input type="text" v-model="userName" @input="filterName" placeholder="이름 또는 대표자명"></td>
                    </tr>
                    <tr>
                        <th>핸드폰 번호</th>
                        <td><input type="text" 
                            v-model="userTel" 
                            @input="formatTel" 
                            maxlength="13"
                            placeholder="010 1234 5678"></td>
                        <td class="td-btn"><button class="btn-check" @click="fnCheckUser()">인증 요청</button></td>
                    </tr>
                    <!-- 인증번호 입력 -->
                    <tr>
                        <th>인증 번호</th>
                        <td>
                            <input type="number" v-model="authCode"
                                maxlength="6"
                                placeholder="6자리 숫자를 입력하세요">
                        </td>
                        <td class="td-btn"><button class="btn-check" @click="fnCheckSms()">인증 확인</button></td>
                    </tr>

                </table>
            </div>

            <div v-if="isVerified">
                <h1>비밀번호 재설정</h1>
                <table>
                    <tr>
                        <th>새 비밀번호</th>
                        <td><input type="password" v-model="newPw" @input="filterPassword" placeholder="새 비밀번호 입력"></td>
                    </tr>
                    <tr>
                        <th>비밀번호 확인</th>
                        <td><input type="password" v-model="confirmPw" placeholder="비밀번호 다시 입력"></td>
                    </tr>
                    <tr class="msg-box-row">
                        <td colspan="2">
                            <div class="msg-box" :style="{color: isPwdValid ? 'green' : 'red'}">
                                {{ pwdMsg }}
                            </div>
                        </td>
                    </tr>
                </table>
                <button class="login-btn" @click="fnChangePw()">비밀번호 변경</button>
            </div>

            <div class="link-wrap">
                <a href="/login.do"><span class="link-login">로그인 페이지로 돌아가기  | </span></a>
                <a href="/find-id.do"><span class="link-find">아이디 찾기</span></a>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                userId: '',
                userName: '',
                userTel: '',
                authCode: '', // 인증번호 입력값
                newPw : "",
                confirmPw : "",
                isVerified: false,
                pwdMsg: "", // 비밀번호 확인
                isPwdMatch: false, // 비밀번호 일치체크
                isPwdValid: false, 

            };
        },
        methods: {
            fnMain : function(){
                location.href="/merryViewHome.do";
            },
            // 1. 본인 확인 단계
            fnCheckUser: function() {
                if(!this.userId || !this.userName || !this.userTel) {
                    alert("정보를 모두 입력해주세요.");
                    return;
                }
                axios.post("/check-user.dox", { 
                    userId: this.userId, 
                    userName: this.userName, 
                    userTel: this.userTel.replace(/-/g, '')

                }).then(res => {
                    if(res.data.count > 0) {
                        // 회원 확인 성공 시 문자 발송 API 추가 호출
                        $.ajax({
                            url: "http://localhost:8080/sendSms.dox",
                            dataType: "json",
                            type: "POST",
                            data: { tel: this.userTel.replace(/-/g, '') },
                            success: function(data) {
                                if(data.result === 'success') {
                                    alert("인증번호가 발송되었습니다.");
                                } else {
                                    alert("문자 발송에 실패했습니다.");
                                }
                            }
                        });
                    } else {
                        alert("일치하는 회원 정보가 없습니다.");
                    }
                });
            },
            // 2. 비밀번호 변경 단계
            fnChangePw: function() {
                console.log("userId 확인:", this.userId);  // ← 이거 추가해서 콘솔 확인
                console.log("newPw 확인:", this.newPw);
                if(this.newPw !== this.confirmPw) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return;
                }
                axios.post("/change-pw.dox", {
                    userId: this.userId,
                    newPw: this.newPw,
                    userName: this.userName, 
                    userTel: this.userTel 
                }).then(res => {
                    if(res.data.result === "success") {
                        alert("비밀번호 변경 완료! 로그인 페이지로 이동합니다.");
                        location.href = "/login.do";
                    } else {
                        alert("변경에 실패했습니다. 다시 시도해주세요.");
                    }
                });
            },
            // * 아이디 서식 제한 (한글, 특수문자 차단) *
            filterUserId: function() {
                this.userId = this.userId.replace(/[^a-zA-Z0-9]/g, '');
            },

            // * 이름 서식 제한 (한글만 입력 허용) *
            filterName: function() {
                this.userName = this.userName.replace(/[^가-힣ㄱ-ㅎㅏ-ㅣ]/g, '');
            },

            // * 휴대폰 번호 자동 하이픈 (-) 생성 *
            formatTel: function() {
                let val = this.userTel.replace(/[^0-9]/g, ''); // 숫자만 남기기
                if (val.length <= 3) {
                    this.userTel = val;
                } else if (val.length <= 7) {
                    this.userTel = val.slice(0, 3) + '-' + val.slice(3);
                } else {
                    this.userTel = val.slice(0, 3) + '-' + val.slice(3, 7) + '-' + val.slice(7, 11);
                }
            },
            // * 비밀번호 입력 제한 (한글, 공백 차단) *
            filterPassword: function() {
                this.newPw = this.newPw.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
            },
            // * 비밀번호 유효성 및 일치 확인 *
            fnCheckPwd: function() {
                let pwd = this.newPw;
                let pwdConf = this.confirmPw;

                if (!pwd) {
                    this.pwdMsg = "";
                    return;
                }

                let hasLetter = /[a-zA-Z]/.test(pwd);
                let hasNumber = /[0-9]/.test(pwd);

                // 규칙 검사
                if (pwd.length < 8) {
                    this.pwdMsg = "비밀번호는 8자 이상이어야 합니다.";
                    this.isPwdValid = false;
                } else if (!hasLetter || !hasNumber) {
                    this.pwdMsg = "영문자와 숫자를 모두 포함해야 합니다.";
                    this.isPwdValid = false;
                } else {
                    // 일치 여부 검사
                    if (!pwdConf) {
                        this.pwdMsg = "비밀번호 확인을 입력해주세요.";
                        this.isPwdValid = false;
                    } else if (pwd === pwdConf) {
                        this.pwdMsg = "✅ 비밀번호가 일치하며 사용 가능합니다.";
                        this.isPwdValid = true;
                    } else {
                        this.pwdMsg = "❌ 비밀번호가 일치하지 않습니다.";
                        this.isPwdValid = false;
                    }
                }
            },
            // 인증번호
            fnCheckSms: function() {
                let self = this;
                $.ajax({
                    url: "http://localhost:8080/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { 
                        tel: self.userTel.replace(/-/g, ''),
                        authCode: self.authCode,
                        userId: self.userId 
                    },
                    success: function(data) {
                        if(data.result === 'success') {
                            alert("인증이 완료되었습니다!");
                            self.isVerified = true;
                        } else {
                            alert("인증번호가 틀렸습니다.");
                        }
                    }
                });
            },
        },
        watch: {
                newPw: function() {
                    this.fnCheckPwd();
                },
                confirmPw: function() {
                    this.fnCheckPwd();
                }
        },
        // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>