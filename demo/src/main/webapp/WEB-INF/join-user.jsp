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
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; }

        #app {
            width: 550px;
            margin: 50px auto;
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        /* 행 하나 감싸는 컨테이너 */
        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 2px;
        }
        /* 왼쪽 라벨 (핑크 배경) */
        .form-label {
            background: #f4a096;
            color: white;
            width: 120px;
            min-height: 45px;
            display: flex;
            align-items: center;
            padding-left: 15px;
            font-size: 14px;
            flex-shrink: 0;
        }
        /* 오른쪽 입력 영역 */
        .form-input {
            flex: 1;
            padding: 0;
            display: flex;
            align-items: center;
            height: 45px;
            overflow: hidden;
            border: 1px solid #eee;
        }
        /* 비활성화 행 */
        .form-input.disabled {
            background: #e0e0e0;
        }
        input[type="text"],
        input[type="password"],
        input[type="number"] {
            box-sizing: border-box;
            border: none;
            outline: none;
            flex: 1;
            font-size: 14px;
            background: transparent;
            padding-left: 15px;
            height: 100%;  
        }
        /* 중복체크, 본인인증 버튼 */
        .btn-check {
            background: #f0b429;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            white-space: nowrap;
        }
        /* 가입하기 버튼 */
        .btn-submit {
            display: block;
            margin: 20px auto 0;
            background: #f0b429;
            color: white;
            border: none;
            padding: 10px 40px;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }
        /* 버튼에 호버처리 */
        .btn-submit:hover, .btn-check:hover {
            box-shadow: 1px 1px 2px gray;
        }
        input:disabled {
            width: 100%;
            background: transparent;
            cursor: not-allowed;
        }
        /* 성별 칸처럼 라디오 버튼이 들어가는 경우를 위해 */
        .form-input input[type="radio"]:first-child {
            margin-left: 15px; /* 아이디 입력창 글자 위치와 맞추기 위해 15px 추천 */
        }

        /* 추가로 버튼과 글자(남, 여) 사이도 너무 붙어 있다면 아래도 살짝 추가 */
        input[type="radio"] {
            margin-left: 15px;  /* 첫 번째 버튼의 왼쪽 여백 (벽과의 거리) */
            margin-right: 5px;  /* 버튼과 글자(남, 여) 사이 간격 */
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="form-row">
        <div class="form-label">아이디</div>
        <div class="form-input">
            <input type="text" v-model="info.userId"
            :disabled="isUserIdAvailable"
            @input="filterUserId"
            maxlength="20"
            placeholder="영문 + 숫자의 조합만 허용합니다.">
            <button class="btn-check" @click="fnCheckUserId()">중복체크</button>
        </div>
    </div>
    <!-- 아이디 메시지 -->
    <div v-if="userIdMsg" :style="{color: isUserIdAvailable ? 'green' : 'red'}" 
        style="font-size:12px; padding-left:130px; margin-bottom:5px;">
        {{ userIdMsg }}
    </div>
    <div class="form-row">
        <div class="form-label">이름</div>
        <div class="form-input">
            <input type="text" v-model="info.userName"
                @input="filterName"
                placeholder="이름을 입력하세요">
        </div>
    </div>
    <div class="form-row">
        <div class="form-label">이메일</div>
        <div class="form-input">
        <input type="text" v-model="info.emailId" placeholder="이메일 앞부분">
        <span>@</span>
        <input type="text" v-if="emailDomainDirect" v-model="emailDomain" placeholder="직접입력">
        <select v-else v-model="emailDomain" @change="fnEmailDomainChange">
            <option value="naver.com">naver.com</option>
            <option value="gmail.com">gmail.com</option>
            <option value="nate.com">nate.com</option>
            <option value="kakao.com">kakao.com</option>
            <option value="daum.net">daum.net</option>
            <option value="direct">직접입력</option>
        </select>
        <button class="btn-check" @click="fnCheckEmail()">중복체크</button>
        </div>
    </div>
    <div v-if="emailMsg" 
        :style="{color: isEmailAvailable ? 'green' : 'red'}"
        style="font-size:12px; padding-left:130px; margin-bottom:5px;">
        {{ emailMsg }}
    </div>
    <div class="form-row">
        <div class="form-label">성별</div>
        <div class="form-input">
            <input type="radio" name="gender" v-model="info.gender" value="M"> 남
            <input type="radio" name="gender" v-model="info.gender" value="F"> 여
        </div>
    </div>
    <div class="form-row">
        <div class="form-label">전화번호</div>
        <div class="form-input">
            <input type="text" v-model="info.userTel"
            @input="formatTel"
            maxlength="13"
            placeholder="010 1234 5678"
            >
            <button class="btn-check">본인 인증</button>
        </div>
    </div>
    <div class="form-row">
        <div class="form-label">비밀번호</div>
        <div class="form-input">
            <div class="form-input" :class="{'disabled': !isVerified}">
                <!-- 본인 인증이 끝난 뒤에 활성화 -->
        <input type="password" v-model="info.password" :disabled="!isVerified"> 
    </div>
        </div>
    </div>
    <div class="form-row">
        <div class="form-label">비밀번호 확인</div>
        <div class="form-input" :class="{'disabled': !isVerified}">
            <input type="password" v-model="info.passwordConfirm" :disabled="!isVerified">
        </div>
    </div>
    <div class="form-row">
        <div class="form-label">결혼예정일</div>
        <div class="form-input">
            <input type="date" v-model="info.weddingDate">
        </div>
    </div>
    <button class="btn-submit" @click="fnUserJoin()">가입 하기</button>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                info : {
                    // *member table
                    userId : "",
                    password: "",
                    passwordConfirm: "",  // 비밀번호 확인
                    userTel : "",
                    // *user detail table
                    userName : "",
                    userEmail : "",
                    gender : "M",
                    weddingDate: ""
                },
                isVerified: false,  // 인증 완료 여부
                isUserIdAvailable: false,  // 아이디 중복체크 통과 여부 (true  → 사용 가능한 아이디)
                userIdMsg: "",             // 아이디 중복체크 결과 메시지
                
                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnUserJoin: function () {
                let self = this;
                // 전화번호 11자리 검증
                if(self.info.userTel.length !== 11) {
                    alert("전화번호 11자리를 입력해주세요.");
                    return;
                }

                let param = self.info;
                $.ajax({
                    url: "http://localhost:8080/joinUser.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                    }
                });
            },
            // *아이디*
            // 아이디 한글, 특수문자 입력 막기
            filterUserId: function() {
                // 한글, 특수문자 제거
                this.info.userId = this.info.userId.replace(/[^a-zA-Z0-9]/g, '');
                
                // 영어만 or 영어+숫자 체크
                let val = this.info.userId;
                if(val.length > 0) {
                    let hasLetter = /[a-zA-Z]/.test(val);
                    
                    if(val.length < 6) {
                        this.userIdMsg = "아이디는 6자 이상이어야 합니다.";
                        this.isUserIdAvailable = false;
                    } else if(val.length > 20) {
                        this.userIdMsg = "아이디는 20자 이하여야 합니다.";
                        this.isUserIdAvailable = false;
                    } else if(!hasLetter) {
                        this.userIdMsg = "영문자 또는 영문과 숫자를 모두 포함해야 합니다.";
                        this.isUserIdAvailable = false;
                    } else {
                        this.userIdMsg = "";
                    }
                }
            },
            // 아이디 중복체크
            fnCheckUserId: function() {
                let self = this;
                
                if(!self.info.userId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }
                let hasLetter = /[a-zA-Z]/.test(self.info.userId);
                if(!hasLetter) {
                    alert("영문자 또는 영문과 숫자를 모두 포함해야 합니다.");
                    return;
                }
                $.ajax({
                    url: "http://localhost:8080/checkUserId.dox",
                    dataType: "json",
                    type: "POST",
                    data: { userId: self.info.userId },
                    success: function(data) {
                        if(data.available) {
                            self.isUserIdAvailable = true;
                            self.userIdMsg = "✅ 사용가능한 아이디입니다.";
                        } else {
                            self.isUserIdAvailable = false;
                            self.userIdMsg = "❌ 이미 사용중인 아이디입니다.";
                        }
                    }
                });
            },
            // *이름*
            // 이름 서식 제한(한글만 입력 허용)
            filterName: function() {
                this.info.userName = this.info.userName.replace(/[^가-힣]/g, '');
            },
            // *휴대폰 번호*
            // 휴대폰 번호 입력 
            formatTel: function() {
                let self = this;
                let val = this.info.userTel.replace(/[^0-9]/g, ''); // 숫자만 입력 가능
                if(val.length <= 3) {
                    this.info.userTel = val;
                } else if(val.length <= 7) {
                    this.info.userTel = val.slice(0,3) + ' ' + val.slice(3);
                } else {
                    this.info.userTel = val.slice(0,3) + ' ' + val.slice(3,7) + ' ' + val.slice(7,11);
                }
                let param = {
                    ...self.info,
                    userTel: self.info.userTel.replace(/ /g, '')  // 공백 제거 후 전송
                }
            },
            // *이메일*
            // 이메일 도메인
            fnEmailDomainChange: function() {
                if(this.emailDomain === 'direct') {
                    this.emailDomainDirect = true;
                    this.emailDomain = "";
                }
            },
            // 이메일 중복체크
            fnCheckEmail: function() {
                let self = this;
                if(!self.info.emailId || !self.emailDomain) {
                    alert("이메일을 입력해주세요.");
                    return;
                }
                let fullEmail = self.info.emailId + "@" + self.emailDomain;
                $.ajax({
                    url: "http://localhost:8080/checkEmail.dox",
                    dataType: "json",
                    type: "POST",
                    data: { email: fullEmail },
                    success: function(data) {
                        if(data.available) {
                            self.isEmailAvailable = true;
                            self.emailMsg = "사용가능한 이메일입니다.";
                            self.info.userEmail = fullEmail;  // 전체 이메일 저장
                        } else {
                            self.isEmailAvailable = false;
                            self.emailMsg = "해당 이메일로 가입한 이력이 있습니다.";
                        }
                    }
                });
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>