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
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> <!--주소 api-->
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
            align-items: flex-start; 
            margin-bottom: 2px;   
        }
        /* 왼쪽 라벨 (핑크 배경) */
        .form-label {
            background: #f4a096;
            color: white;
            width: 120px;
            min-height: 45px;
            height: 45px;        /* ← 고정 높이 */
            align-self: flex-start;  /* ← 위쪽 정렬 */
            display: flex;
            align-items: center;
            padding-left: 15px;
            font-size: 14px;
            flex-shrink: 0;
        }
        /* 사업장 주소 라벨 (2칸짜리) */
        .form-label-2 {
            background: #f4a096;
            color: white;
            width: 120px;
            min-height: 45px;
            height: 90px;        /* ← 고정 높이 */
            align-self: flex-start;  /* ← 위쪽 정렬 */
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
            margin-left: 5px;
            background: #f0b429;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            white-space: nowrap;
            flex-shrink: 0;
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
        .msg-box {
            height: 18px;
            font-size: 11px;
            padding-left: 5px;
            color: transparent;  /* 내용 없을 때 투명 */
        }
        .input-wrap {
            flex: 1;
            min-width: 0;  /* ← 이게 핵심! flex 안에서 넘치는 거 방지 */
        }
        .email-domain {
            flex: 1;
            min-width: 0;    /* ← 추가 */
            max-width: 150px; /* ← 최대 너비 제한 */
            border: none;
            outline: none;
            font-size: 14px;
            background: transparent;
        }
        .email-cancel {
            cursor: pointer;
            padding: 0 5px;
            color: #999;
            flex-shrink: 0;
        }
        .form-input + .form-input {
            border-top: none;
        }
    </style>
</head>
<body>
    <div id="app">
        <div class="form-row">
            <div class="form-label">업체명</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.comName"
                        :disabled="isComNameAvailable"
                        @chage="filterComName"
                        placeholder="정확한 업체명을 입력해주세요.">
                    <button class="btn-check" @click="fnCheckComName()">중복체크</button>
                </div>
                <div class="msg-box" :style="{color: isComNameAvailable ? 'green' : 'red'}">
                    {{ comNameMsg }}
                </div>
            </div>
        </div>
        <!-- 아이디 -->
        <div class="form-row">
            <div class="form-label">아이디</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.userId"
                        :disabled="isUserIdAvailable"
                        @input="filterUserId"
                        maxlength="20"
                        placeholder="영문 + 숫자의 조합만 허용합니다.">
                    <button class="btn-check" @click="fnCheckUserId()">중복체크</button>
                </div>
                <div class="msg-box" :style="{color: isUserIdAvailable ? 'green' : 'red'}">
                    {{ userIdMsg }}
                </div>
            </div>
        </div>

        <!-- 이름 -->
        <div class="form-row">
            <div class="form-label">대표자명</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" 
                        v-model="info.ceoName"
                        @input="filterName"
                        placeholder="이름은 한글만 입력 가능합니다.">
                </div>
                <div class="msg-box"></div>
            </div>
        </div>

        <!-- 이메일 -->
        <div class="form-row">
            <div class="form-label">대표 이메일</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.emailId" placeholder="이메일 앞부분">
                    <span>@</span>
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
                    <button class="btn-check" @click="fnCheckEmail()">중복체크</button>
                </div>
                <div class="msg-box" :style="{color: isEmailAvailable ? 'green' : 'red'}">
                    {{ emailMsg }}
                </div>
            </div>
        </div>

        <!-- 업체 분류 -->
        <div class="form-row">
            <div class="form-label">업체 분류</div>
            <div class="input-wrap">
                <div class="form-input">
                    <select v-model="info.comType" class="email-domain">
                        <option value="">선택해주세요</option>
                        <option value="STUDIO">스튜디오</option>
                        <option value="DRESS">드레스</option>
                        <option value="MAKEUP">메이크업</option>
                        <option value="SNAP">스냅</option>
                    </select>
                </div>
                <div class="msg-box"></div>
            </div>
        </div>

        <!-- 전화번호 -->
        <div class="form-row">
            <div class="form-label">대표 전화번호</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.comTel"
                        @input="formatTel"
                        maxlength="13"
                        placeholder="010 1234 5678">
                    <button class="btn-check">본인 인증</button>
                </div>
                <div class="msg-box"></div>
            </div>
        </div>
        <!-- 사업자 번호 인증 -->
        <div class="form-row">
            <div class="form-label">사업자 번호</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.bizNo"
                        @input="formatBizNo"
                        placeholder="000-00-0000">
                    <button class="btn-check">번호 인증</button>
                </div>
                <div class="msg-box"></div>
            </div>
        </div>
        <!-- 비밀번호 -->
        <div class="form-row">
            <div class="form-label">비밀번호</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="password" v-model="info.password" @input="filterPassword">
                </div>
                <div class="msg-box" :style="{color: isPwdMatch ? 'green' : 'red'}">
                    {{ pwdMsg }}
                </div>
            </div>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-row">
            <div class="form-label">비밀번호 확인</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="password" v-model="info.passwordConfirm">
                </div>
                <div class="msg-box"></div>
            </div>
        </div>

        <!-- 사업장 주소 api -->
        <div class="form-row">
            <div class="form-label-2">사업장 주소</div>
            <div class="input-wrap">
                <div class="form-input">
                    <input type="text" v-model="info.comAddress" placeholder="주소 검색 버튼을 눌러주세요." readonly>
                    <button class="btn-check" @click="fnSearchAddress()">주소 검색</button>
                </div>
                <div class="form-input">
                    <input type="text" v-model="info.comAddressDetail" placeholder="상세 주소를 입력해주세요.">
                </div>
                <div class="msg-box"></div>
            </div>
        </div>
        <button class="btn-submit" @click="fnCompanyJoin()">가입 하기</button>
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
                    comTel : "",
                    // *company table
                    comName : "",
                    ceoName : "",
                    comType : "STUDIO",
                    comAddress : "",
                    comAddressDetail: "",
                    comEmail : "",
                    bizNo : "",
                    gender : "M",
                },
                isVerified: false,  // 인증 완료 여부
                isComNameAvailable: false, // 업체명 중복체크 통과 여부 (true  → 사용 가능한 업체명)
                comNameMsg: "",            // 아이디 중복체크 결과 메시지
                isUserIdAvailable: false,  // 아이디 중복체크 통과 여부 (true  → 사용 가능한 아이디)
                userIdMsg: "",             // 아이디 중복체크 결과 메시지
                
                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지

                pwdMsg: "", // 비밀번호 확인
                isPwdMatch: false, // 비밀번호 일치체크
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCompanyJoin: function () {
                let self = this;
                console.log("comTel 길이:", self.info.comTel.replace(/ /g, '').length);
                console.log("comTel 값:", self.info.comTel);
                // 유효성 검사
                if(!self.info.comName) {
                    alert("업체명을 입력해주세요.");
                    return;
                }
                if(!self.info.userId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }
                if(!self.isUserIdAvailable) {
                    alert("아이디 중복체크를 해주세요.");
                    return;
                }
                if(!self.info.ceoName) {
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
                if(self.info.comTel.replace(/-/g, '').length !== 11) {
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                if(self.info.bizNo.replace(/-/g, '').length !== 10) {
                    alert("사업자 번호를 인증해주세요.");
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
                    comTel: self.info.comTel.replace(/ /g, ''),

                    // company 테이블
                    comName: self.info.comName,
                    comType: self.info.comType,
                    comAddress: self.info.comAddress + ' ' + self.info.comAddressDetail,
                    bizNo: self.info.bizNo.replace(/-/g, ''),  // 하이픈 제거
                    ceoName: self.info.ceoName,
                    comEmail: self.info.comEmail
                }
                $.ajax({
                    url: "http://localhost:8080/joinCompany.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result === 'success') {
                            alert(self.info.comName + "님 가입을 축하합니다!");
                            window.location.href = "/company10.do";  // 업체 마이페이지로 이동
                        } else {
                            alert(data.message);
                        }
                    }
                });
            },
            // *업체명*
            // 업체명 필터 (한글, 영어, 숫자만)
            filterComName: function() {
                this.info.comName = this.info.comName.replace(/[^가-힣a-zA-Z0-9]/g, '');
            },
            // 업체명 중복체크
            fnCheckComName: function() {
                let self = this;
                if(!self.info.comName) {
                    alert("업체명을 입력해주세요.");
                    return;
                }
                $.ajax({
                    url: "http://localhost:8080/checkComName.dox",
                    dataType: "json",
                    type: "POST",
                    data: { comName: self.info.comName },
                    success: function(data) {
                        if(data.available) {
                            self.isComNameAvailable = true;
                            self.comNameMsg = "✅ 사용가능한 업체명입니다.";
                        } else {
                            self.isComNameAvailable = false;
                            self.comNameMsg = "❌ 이미 등록된 업체명입니다.";
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
            // *대표 휴대폰 번호*
            // 휴대폰 번호 입력 
            formatTel: function() {
                let self = this;
                let val = this.info.comTel.replace(/[^0-9]/g, ''); // 숫자만 입력 가능
                if(val.length <= 3) {
                    this.info.comTel = val;
                } else if(val.length <= 7) {
                    this.info.comTel = val.slice(0,3) + '-' + val.slice(3);
                } else {
                    this.info.comTel = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
                }
                let param = {
                    ...self.info,
                    comTel: self.info.comTel.replace(/ /g, '')  // 공백 제거 후 전송
                }
            },
            // *사업자 번호*
            formatBizNo: function() {
                let val = this.info.bizNo.replace(/[^0-9]/g, '');
                if(val.length <= 3) {
                    this.info.bizNo = val;
                } else if(val.length <= 5) {
                    this.info.bizNo = val.slice(0,3) + '-' + val.slice(3);
                } else {
                    this.info.bizNo = val.slice(0,3) + '-' + val.slice(3,5) + '-' + val.slice(5,10);
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
                            self.info.comEmail = fullEmail;  // 전체 이메일 저장
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
            fnSearchAddress: function() {
                new daum.Postcode({
                    oncomplete: (data) => {
                        this.info.comAddress = data.roadAddress;
                    }
                }).open();
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