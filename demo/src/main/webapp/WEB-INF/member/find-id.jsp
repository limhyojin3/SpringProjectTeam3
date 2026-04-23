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
    </style>
</head>
<body>
    <div id="app">
        <div id="container">
            <div class="logo">
                <img src="/img/merryview-logo-text.svg" alt="메리뷰 로고" @click="fnMain()">
            </div>
            <div v-if="!isVerified">
                <h1>아이디 찾기</h1>
                <table>
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
                <h1>아이디 찾기</h1>
                <br>
                '{{userName}}'님의 아이디는
                '{{userId}}'입니다.
            </div>
            <div class="link-wrap">
                <a href="/login.do"><span>로그인 페이지로 돌아가기</span></a>
                <span>|</span>
                <a href="/find-pwd.do"><span>비밀번호 변경</span></a>
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
            // 본인 확인 단계
            fnCheckUser: function() {
                if(!this.userName || !this.userTel) {
                    alert("정보를 모두 입력해주세요.");
                    return;
                }
            
                 let self = this;
                // ✅ 먼저 DB에서 이름+번호 확인
                axios.post("/find-id-result.dox", {
                    userName: self.userName,
                    userTel: self.userTel.replace(/-/g, '')
                }).then(res => {
                    if(res.data.result === "success") {
                        self.userId = res.data.userId;
                        console.log("저장된 userId:", self.userId);
                        // 일치하면 문자 발송
                        $.ajax({
                            url: "/sendSms.dox",
                            dataType: "json",
                            type: "POST",
                            data: { tel: self.userTel.replace(/-/g, '') },
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
                    },
                    success: function(data) {
                        if(data.result === 'success') {
                            self.isVerified = true;
                        } else {
                            alert("인증번호가 틀렸습니다.");
                        }
                    }
                });
            }
        },// methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
     });
    app.mount('#app');
</script>