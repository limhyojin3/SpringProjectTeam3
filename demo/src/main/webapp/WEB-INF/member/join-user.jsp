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
        background: #fafafa;
        font-family: 'Noto Sans KR', sans-serif;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 30px 16px;
        min-height: 100vh;
    }

    .logo-wrap {
        text-align: center;
        margin-bottom: 18px;
        cursor: pointer;
    }
    .logo-wrap img { height: 64px; }

    .join-card {
        width: 100%;
        max-width: 480px;
        background: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 10px;
        padding: 24px 28px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }

    .join-card h2 {
        font-size: 16px;
        font-weight: 600;
        color: #555;
        text-align: center;
        margin-bottom: 18px;
    }

    /* 한 행 전체 */
    .form-row {
        display: flex;
        align-items: stretch;
        margin-bottom: 6px;
    }

    /* 왼쪽 핑크 라벨 */
    .form-label {
        background: #f4a096;
        color: white;
        width: 90px;
        min-width: 90px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 0 8px;
        font-size: 12px;
        font-weight: 700;
        border-radius: 6px 0 0 6px;
        line-height: 1.4;
    }

    /* 라벨 + input + msg + 버튼 묶음 */
    .row-body {
        flex: 1;
        min-width: 0;
        display: flex;
        flex-direction: column;
        border: 1px solid #f4a096;
        border-left: none;
        border-radius: 0 6px 6px 0;
        overflow: hidden;
    }

    /* 버튼 있을 때 row-body 오른쪽 radius 제거 */
    .has-btn .row-body {
        border-radius: 0;
    }

    /* input 영역 */
    .form-input {
        display: flex;
        align-items: center;
        height: 44px;
        border-bottom: none; 
        background: #fff;
    }
    .form-input:last-child,
    .form-input.no-msg {
        border-bottom: none;
    }
    .form-input.disabled { background: #f5f5f5; }

    input[type="text"],
    input[type="password"],
    input[type="number"],
    input[type="date"] {
        border: none;
        outline: none;
        flex: 1;
        font-size: 13px;
        background: transparent;
        padding: 6px 12px 0;
        height: 100%;
        font-family: 'Noto Sans KR', sans-serif;
    }
    input:disabled { cursor: not-allowed; color: #aaa; }

    input[type="radio"] {
        margin-left: 12px;
        margin-right: 4px;
        accent-color: #f4a096;
    }

    /* 이메일 앞부분 고정 너비 */
    .email-id-input {
        width: 110px;
        flex: none !important;
    }

    .email-domain {
        flex: 1;
        min-width: 0;
        border: none;
        outline: none;
        font-size: 12px;
        background: transparent;
        font-family: 'Noto Sans KR', sans-serif;
        padding-left: 4px;
    }
    .email-cancel {
        cursor: pointer;
        padding: 0 6px;
        color: #bbb;
        flex-shrink: 0;
    }

    /* msg 영역 */
    .msg-box {
        font-size: 11px;
        padding: 3px 10px 4px;
        min-height: 20px;
        color: transparent;
        background: white;
        line-height: 1.3;
    }
    .msg-box.show { color: inherit; }
    .msg-box.disabled { background: #f5f5f5; }

    /* 노란 버튼 */
    .btn-check {
        align-self: stretch;
        padding: 0 14px;
        background: #f0b429;
        color: white;
        border: none;
        border-radius: 0 6px 6px 0;
        font-size: 12px;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
        cursor: pointer;
        white-space: nowrap;
        transition: opacity 0.2s;
        flex-shrink: 0;
    }
    .btn-check:hover { opacity: 0.88; }

    /* 가입하기 버튼 */
    .btn-submit {
        width: 100%;
        height: 48px;
        background: #f4a096;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
        cursor: pointer;
        margin-top: 16px;
        transition: opacity 0.2s;
    }
    .btn-submit:hover { opacity: 0.88; }
    .step-indicator {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 8px;
        gap: 0;
    }
    .step-dot {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: #eee;
        color: #bbb;
        font-size: 12px;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }
    .step-dot.active { background: #f4a096; color: white; }
    .step-dot.done   { background: #f4a096; color: white; opacity: 0.5; }
    .step-line {
        width: 40px;
        height: 2px;
        background: #eee;
        transition: background 0.3s;
    }
    .step-line.done { background: #f4a096; opacity: 0.5; }
    .step-label {
        font-size: 11px;
        color: #bbb;
        text-align: center;
    }
    .step-btn-wrap {
        display: flex;
        gap: 8px;
        margin-top: 16px;
    }
    .btn-prev {
        flex: 1;
        height: 48px;
        background: #eee;
        color: #888;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
        cursor: pointer;
        transition: opacity 0.2s;
    }
    .btn-prev:hover { opacity: 0.8; }
    .btn-next {
        flex: 2;
        height: 48px;
        background: #f4a096;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        font-family: 'Noto Sans KR', sans-serif;
        font-weight: 500;
        cursor: pointer;
        transition: opacity 0.2s;
    }
    .btn-next:hover { opacity: 0.88; }
    </style>
</head>
<body>
    <div id="app">
        <div class="logo-wrap" @click="fnMain()">
            <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
        </div>

        <div class="join-card">
            <h2>회원가입</h2>

            <!-- 스텝 인디케이터 -->
            <div>
                <div class="step-indicator">
                    <div class="step-dot" :class="{active: step===1, done: step>1}">1</div>
                    <div class="step-line" :class="{done: step>1}"></div>
                    <div class="step-dot" :class="{active: step===2, done: step>2}">2</div>
                    <div class="step-line" :class="{done: step>2}"></div>
                    <div class="step-dot" :class="{active: step===3}">3</div>
                </div>
                <div style="display:flex; justify-content:center; gap:25px; margin-bottom:20px;">
                    <span class="step-label" :style="{color: step>=1 ? '#f4a096' : '#bbb'}">기본정보</span>
                    <span class="step-label" :style="{color: step>=2 ? '#f4a096' : '#bbb'}">본인인증</span>
                    <span class="step-label" :style="{color: step>=3 ? '#f4a096' : '#bbb'}">비밀번호</span>
                </div>
            </div>

            <!-- STEP 1: 기본정보 -->
            <div v-if="step === 1">

                <!-- 아이디 -->
                <div class="form-row has-btn">
                    <div class="form-label">아이디</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.userId"
                                :disabled="isUserIdAvailable"
                                @input="filterUserId" maxlength="20"
                                placeholder="영문 + 숫자 조합">
                        </div>
                        <div class="msg-box" :class="{'show': userIdMsg}"
                            :style="{color: isUserIdAvailable ? 'green' : 'red'}">{{ userIdMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnCheckUserId()">중복체크</button>
                </div>

                <!-- 이름 -->
                <div class="form-row">
                    <div class="form-label">이름</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.userName"
                                @input="filterName" placeholder="한글만 입력 가능합니다">
                        </div>
                    </div>
                </div>

                <!-- 이메일 -->
                <div class="form-row has-btn">
                    <div class="form-label">이메일</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.emailId"
                                class="email-id-input" placeholder="이메일 앞부분">
                            <span style="flex-shrink:0; color:#aaa; font-size:13px;">@</span>
                            <template v-if="emailDomainDirect">
                                <input type="text" v-model="emailDomain" class="email-domain"
                                    placeholder="직접입력" @input="filterEmailDomain">
                                <span @click="fnCancelDirectEmail()" class="email-cancel">✕</span>
                            </template>
                            <template v-else>
                                <select v-model="emailDomain" @change="fnEmailDomainChange" class="email-domain">
                                    <option value="naver.com">naver.com</option>
                                    <option value="gmail.com">gmail.com</option>
                                    <option value="nate.com">nate.com</option>
                                    <option value="kakao.com">kakao.com</option>
                                    <option value="daum.net">daum.net</option>
                                    <option value="direct">직접입력</option>
                                </select>
                            </template>
                        </div>
                        <div class="msg-box" :class="{'show': emailMsg}"
                            :style="{color: isEmailAvailable ? 'green' : 'red'}">{{ emailMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnCheckEmail()">중복체크</button>
                </div>

                <!-- 성별 -->
                <div class="form-row">
                    <div class="form-label">성별</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="radio" name="gender" v-model="info.gender" value="M"> 남
                            <input type="radio" name="gender" v-model="info.gender" value="F"> 여
                        </div>
                    </div>
                </div>

                <div class="step-btn-wrap">
                    <button class="btn-next" @click="step=2">다음 →</button>
                </div>
            </div>

            <!-- STEP 2: 본인인증 -->
            <div v-if="step === 2">

                <!-- 전화번호 -->
                <div class="form-row has-btn">
                    <div class="form-label">전화번호</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.userTel"
                                @input="formatTel" maxlength="13" placeholder="010-1234-5678">
                        </div>
                        <div class="msg-box" :class="{'show': telMsg}"
                            :style="{color: isUserTelAvailable ? 'green' : 'red'}">{{ telMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnSendSms()">인증 요청</button>
                </div>

                <!-- 인증번호 -->
                <div class="form-row has-btn">
                    <div class="form-label">인증번호</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="number" v-model="info.authCode"
                                maxlength="6" placeholder="6자리 숫자를 입력하세요">
                        </div>
                        <div class="msg-box" :class="{'show': authCodeMsg}"
                            :style="{color: isVerified ? 'green' : 'red'}">{{ authCodeMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnCheckSms()">인증 확인</button>
                </div>

                <div class="step-btn-wrap">
                    <button class="btn-prev" @click="step=1">← 이전</button>
                    <button class="btn-next" @click="step=3">다음 →</button>
                </div>
            </div>

            <!-- STEP 3: 비밀번호 + 결혼예정일 -->
            <div v-if="step === 3">

                <!-- 비밀번호 + 확인 묶음 -->
                <div class="form-row">
                    <div class="form-label">비밀번호</div>
                    <div class="row-body">
                        <div class="form-input" :class="{'disabled': !isVerified}">
                            <input type="password" v-model="info.password"
                                @input="filterPassword" :disabled="!isVerified"
                                placeholder="영문+숫자 8자 이상">
                        </div>
                        <div class="form-input" :class="{'disabled': !isVerified}">
                            <input type="password" v-model="info.passwordConfirm"
                                :disabled="!isVerified"
                                placeholder="비밀번호 확인">
                        </div>
                        <div class="msg-box"
                            :class="{'show': pwdMsg, 'disabled': !isVerified}"
                            :style="{color: isPwdMatch ? 'green' : 'red'}">{{ pwdMsg }}</div>
                    </div>
                </div>

                <!-- 결혼예정일 -->
                <div class="form-row">
                    <div class="form-label">결혼예정일</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="date" v-model="info.weddingDate">
                        </div>
                    </div>
                </div>

                <div class="step-btn-wrap">
                    <button class="btn-prev" @click="step=2">← 이전</button>
                    <button class="btn-next" @click="fnUserJoin()">가입하기</button>
                </div>
            </div>

        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                step: 1,
                info : {
                    // *member table
                    userId : "",
                    password: "",
                    passwordConfirm: "",  // 비밀번호 확인
                    userTel : "",
                    // *user detail table
                    userName : "",
                    userEmail : "", // [저장용] 중복체크 통과 시 합쳐진 전체 이메일 저장
                    emailId : "", // [입력용] 화면의 input 창과 연결 (v-model)
                    gender : "M",
                    weddingDate: "",
                    // *문자 인증
                    authCode : "" // 인증번호 입력값
                },
                isVerified: false,  // 인증 완료 여부
                isUserIdAvailable: false,  // 아이디 중복체크 통과 여부 (true  → 사용 가능한 아이디)
                userIdMsg: "",             // 아이디 중복체크 결과 메시지

                authCodeMsg : "",

                telMsg : "",
                isUserTelAvailable: false,
                
                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지

                pwdMsg: "", // 비밀번호 확인
                isPwdMatch: false, // 비밀번호 일치체크
            };
        },
        methods: {
            fnMain() {
                location.href = '/merryViewHome.do';
            },
            fnUserJoin: function () {
                let self = this;
                // 유효성 검사
                if(!self.info.userId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }
                if(!self.isUserIdAvailable) {
                    alert("아이디 중복체크를 해주세요.");
                    return;
                }
                if(!self.info.userName) {
                    alert("이름을 입력해주세요.");
                    return;
                }
                if(!self.info.emailId || !self.emailDomain) {
                    alert("이메일을 입력해주세요.");
                    return;
                }
                if(!self.isEmailAvailable) {
                    alert("이메일 중복체크를 해주세요.");
                    return;
                }
                if(self.info.userTel.replace(/-/g, '').length !== 11) {
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                if(!self.isVerified) {
                    alert("전화번호 인증을 완료해주세요.");
                    return;
                }
                if(!self.info.password) {
                    alert("비밀번호를 입력해주세요.");
                    return;
                }
                if(!self.isPwdMatch) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return;
                }

                let param = {
                        // member 테이블
                    userId: self.info.userId,
                    password: self.info.password,
                    userTel: self.info.userTel.replace(/ /g, ''),  // 공백 제거
                    
                    // user_detail 테이블
                    name: self.info.userName,
                    gender: self.info.gender,
                    email: self.info.userEmail,
                    weddingDate: self.info.weddingDate ? self.info.weddingDate : null
                }
                $.ajax({
                    url: "http://localhost:8080/joinUser.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result === 'success') {
                            alert(self.info.userName + "님 가입을 축하합니다!");
                            location.href = "/login.do";  // 로그인으로 이동
                        } else {
                            alert(data.message);
                        }
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
                if(self.info.userId.length < 6) {
                    alert("아이디는 6자 이상이어야 합니다.");
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
                // 가-힣(완성형) 뿐만 아니라 ㄱ-ㅎ(자음), ㅏ-ㅣ(모음)까지 허용
                const val = event.target.value.replace(/[^ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
                // 데이터와 화면 값 동기화
                this.info.ceoName = val;
                event.target.value = val;
            },
            // *휴대폰 번호*
            // 휴대폰 번호 입력 
            formatTel: function() {
                let self = this;
                let val = this.info.userTel.replace(/[^0-9]/g, ''); // 숫자만 입력 가능
                if(val.length <= 3) {
                    this.info.userTel = val;
                } else if(val.length <= 7) {
                    this.info.userTel = val.slice(0,3) + '-' + val.slice(3);
                } else {
                    this.info.userTel = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
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
            // 이메일 도메인 직접 입력시 영어+.만 허용 (ex) naver.com
            filterEmailDomain: function() {
                this.emailDomain = this.emailDomain.replace(/[^a-zA-Z.]/g, '');
            },
            // 도메인 직접입력 취소
            fnCancelDirectEmail: function() {
                this.emailDomainDirect = false;
                this.emailDomain = "naver.com";
            },
            // *휴대폰 문자인증*
            fnSendSms: function() {
                let self = this;
                if(!self.info.userTel) {
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                $.ajax({
                    url: "http://localhost:8080/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { tel: self.info.userTel.replace(/-/g, '') },
                    success: function(data) {
                        if(data.result === 'success') {
                            self.telMsg = "✅ 인증번호가 발송되었습니다.";  // 추가
                            self.isUserTelAvailable = true;
                        } else {
                            self.telMsg = "❌ 발송에 실패했습니다.";  // 추가
                            self.isUserTelAvailable = false;
                        }
                    }
                });
            },

            fnCheckSms: function() {
                let self = this;
                $.ajax({
                    url: "http://localhost:8080/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { 
                        tel: self.info.userTel.replace(/-/g, ''),
                        authCode: self.info.authCode
                    },
                    success: function(data) {
                        if(data.result === 'success') {
                            self.isVerified = true;
                            self.authCodeMsg = "✅ 인증이 완료되었습니다.";  // 추가
                        } else {
                            self.isVerified = false;
                            self.authCodeMsg = "❌ 인증번호가 틀렸습니다.";  // 추가
                        }
                    }
                });
            },
            // 비밀번호 확인
            fnCheckPwd: function() {
                let pwd = this.info.password;
                if(!pwd) {
                    this.pwdMsg = "";
                    return;
                }
                // 1. 규칙 먼저 체크 (비밀번호 확인 없어도 보여줌)
                let hasLetter = /[a-zA-Z]/.test(pwd);
                let hasNumber = /[0-9]/.test(pwd);

                if(pwd.length < 8) {
                    this.isPwdMatch = false;
                    this.pwdMsg = "비밀번호는 8자 이상이어야 합니다.";
                    return;
                }
                if(!hasLetter || !hasNumber) {
                    this.isPwdMatch = false;
                    this.pwdMsg = "영문자와 숫자를 모두 포함해야 합니다.";
                    return;
                }
                
                // 2. 규칙 통과 후 비밀번호 확인 체크
                if(!this.info.passwordConfirm) {
                    this.pwdMsg = "";
                    return;
                }
                if(this.info.password === this.info.passwordConfirm) {
                    this.isPwdMatch = true;
                    this.pwdMsg = "비밀번호가 일치합니다.";
                } else {
                    this.isPwdMatch = false;
                    this.pwdMsg = "비밀번호가 일치하지 않습니다.";
                }
            },
            // 비밀번호 입력 조건 (영문+숫자 필수 / 한글, 띄어쓰기 입력 불가 / 특수기호 허용)
            filterPassword: function() {
                // 한글, 띄어쓰기 제거
                this.info.password = this.info.password.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣\s]/g, '');
            },
        }, // methods
        watch: {
            'info.password': function() {
                this.fnCheckPwd();
            },
            'info.passwordConfirm': function() {
                this.fnCheckPwd();
            }
        },
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>