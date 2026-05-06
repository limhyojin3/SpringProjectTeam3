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
        .logo-wrap img {
            height: 80px;
        }

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

        /* 입력 그룹 */
        .input-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 0;
        }
        .input-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 14px;
        }
        .input-group .input-row:first-child input {
            border-radius: 6px 6px 0 0;
        }
        .input-group .input-row:not(:first-child):not(:last-child) input {
            border-radius: 0;
            border-top: none;         /* ← 중간 행 아래 선 제거 */
        }
        .input-group .input-row:last-child input {
            border-radius: 0 0 6px 6px;
            border-top: none;
        }
        .input-group .input-row:only-child input {
            border-radius: 6px;
        }

        .input-row input {
            flex: 1;
            height: 56px;
            padding: 0 14px;
            font-size: 15px;
            font-family: 'Noto Sans KR', sans-serif;
            border: 1px solid #ddd;
            outline: none;
            transition: border-color 0.2s;
            background: #fff;
        }
        .input-row input:focus {
            border-color: #f4a096;
            position: relative;
            z-index: 1;
        }

        /* 인증 버튼 */
        .btn-check {
            flex-shrink: 0;
            height: 45px;
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

        /* 메인 버튼 */
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

        /* 결과 영역 */
        .result-box {
            text-align: center;
            padding: 20px 0 10px;
            color: #555;
            font-size: 15px;
            line-height: 2;
        }
        .result-box strong {
            color: #f4a096;
            font-size: 18px;
        }

        /* 하단 링크 */
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
        /* 비밀번호 메시지 */
        .msg-box {
            font-size: 12px;
            padding: 6px 2px 0;
            min-height: 24px;
        }
    </style>
</head>
<body>
    <div id="app">
        <div class="logo-wrap" @click="fnMain()">
            <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
        </div>
        <div class="find-card">
            <!-- 인증 전: 본인 확인 -->
            <div v-if="!isVerified">
                <h2>비밀번호 변경</h2>
                <div class="input-group">
                    <div class="input-row">
                        <input type="text" v-model="userId" @input="filterUserId" placeholder="가입한 아이디">
                    </div>
                    <div class="input-row">
                        <input type="text" v-model="userName" @input="filterName" placeholder="이름 또는 대표자명">
                    </div>
                    <div class="input-row">
                        <input type="text" v-model="userTel" @input="formatTel" maxlength="13" placeholder="010-1234-5678">
                        <button class="btn-check" @click="fnCheckUser()">인증 요청</button>
                    </div>
                    <div class="input-row">
                        <input type="number" v-model="authCode" placeholder="인증번호 6자리">
                        <button class="btn-check" @click="fnCheckSms()">인증 확인</button>
                    </div>
                </div>
            </div>

            <!-- 인증 후: 비밀번호 재설정 -->
            <div v-if="isVerified">
                <h2>비밀번호 재설정</h2>
                <div class="input-group">
                    <div class="input-row">
                        <input type="password" v-model="newPw" @input="filterPassword" placeholder="새 비밀번호 (영문+숫자 8자 이상)">
                    </div>
                    <div class="input-row">
                        <input type="password" v-model="confirmPw" placeholder="비밀번호 다시 입력">
                    </div>
                </div>
                <div class="msg-box" :style="{color: isPwdValid ? 'green' : 'red'}">
                    {{ pwdMsg }}
                </div>
                <button class="main-btn" @click="fnChangePw()">비밀번호 변경</button>
            </div>
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