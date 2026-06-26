<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 수정</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 내 정보 수정 페이지 전용 스타일만 --%>
    <style>
        #edit-box {
            width: 480px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            padding: 36px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
        }

        .edit-title {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 24px;
        }

        .form-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        .form-label {
            font-size: 13px;
            color: #888;
            margin-bottom: 6px;
            font-weight: 500;
            background: none;
            color: #666;
            width: auto;
            height: auto;
            padding: 0;
        }

        .form-input {
            display: flex;
            align-items: center;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            height: 44px;
            padding: 0 12px;
            background: white;
            transition: border-color 0.2s;
        }

        .form-input:focus-within {
            border-color: #f4a096;
        }

        .form-input.disabled {
            background: #f5f5f5;
        }

        input[type="text"],
        input[type="password"],
        input[type="number"],
        input[type="date"] {
            border: none;
            outline: none;
            flex: 1;
            font-size: 14px;
            background: transparent;
            height: 100%;
        }

        .btn-check {
            background: #f4a096;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            white-space: nowrap;
            flex-shrink: 0;
        }

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

        .btn-wrap {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
        }

        .btn-check:hover { background: #e8897d; }

        .btn-submit:hover, .btn-check:hover {
            box-shadow: 1px 1px 2px gray;
        }

        .form-input input[type="radio"]:first-child {
            margin-left: 15px;
        }

        input[type="radio"] {
            margin-right: 5px;
            margin-left: 12px;  /* 0 → 12px */
            accent-color: #f4a096;
        }

        .msg-box {
            height: 18px;
            font-size: 11px;
            padding-left: 4px;
            margin-top: 4px;
            color: transparent;
        }

        .input-wrap {
            flex: 1;
            min-width: 0;
        }

        .email-domain {
            flex: 1;
            min-width: 0;
            max-width: 150px;
            border: none;
            outline: none;
            font-size: 14px;
            background: transparent;
        }

        .email-cancel {
            cursor: pointer;
            padding: 0 5px;
            color: #999;
        }

        .read-only-input {
            background: transparent;
            cursor: not-allowed;
            color: #999;
        }

        .read-only-input:focus {
            border-color: #ddd !important;
            box-shadow: none !important;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        input:disabled {
            background-color: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        .btn-check:disabled {
            background-color: #eaeaea;
            color: #bbb;
            border: none;
        }
        /* 수정하기 버튼 */
        .btn-update {
            padding: 10px 24px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-update:hover {
            background: #e8897d;
        }

        /* 취소 버튼 */
        .btn-cancel {
            padding: 10px 24px;
            background: white;
            color: #888;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-cancel:hover {
            background: #f5f5f5;
            border-color: #bbb;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <input type="hidden" id="maritalStatusVal" value="${member.maritalStatus}">
    <input type="hidden" id="originalMaritalStatusVal" value="${member.maritalStatus}">
    <input type="hidden" id="anniversaryDateVal" value="${member.anniversaryDate}">
    <input type="hidden" id="emailVal" value="${member.email}">
    <input type="hidden" id="userIdVal" value="${member.userId}">
    <input type="hidden" id="nameVal" value="${member.name}">
    <input type="hidden" id="telVal" value="${member.tel}">
    <input type="hidden" id="nicknameVal" value="${member.nickname}">
    <input type="hidden" id="genderVal" value="${member.gender}">
    <input type="hidden" id="weddingDateVal" value="${member.weddingDate}">
    <div id="app">
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <div id="edit-box">
                        <!-- 아이디 -->
                        <div class="form-group">
                            <div class="form-label">아이디</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="text" v-model="info.userId" readonly class="read-only-input">
                                </div>
                            </div>
                        </div>
                        <!-- 이름 -->
                        <div class="form-group">
                            <div class="form-label">이름</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="text" v-model="info.name" readonly class="read-only-input">
                                </div>
                            </div>
                        </div>
                        <!-- 닉네임 -->
                        <div class="form-group">
                            <div class="form-label">닉네임</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="text" v-model="info.nickName"
                                        placeholder="닉네임 미설정 시 아이디가 사용됩니다.">
                                </div>
                            </div>
                        </div>
                        <!-- 이메일 -->
                        <div class="form-row">
                            <div class="form-label">이메일</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="text" v-model="info.emailId" placeholder="이메일 앞부분" @input="fnCheckEmailChange">
                                    <span>@</span>
                                    <template v-if="emailDomainDirect">
                                        <input type="text" v-model="emailDomain" class="email-domain"
                                            placeholder="직접입력" @input="fnCheckEmailChange(); filterEmailDomain">
                                        <span @click="fnCancelDirectEmail()" class="email-cancel">✕</span>
                                    </template>
                                    <template v-else>
                                        <select v-model="emailDomain" @change="fnEmailDomainChange; fnCheckEmailChange();" class="email-domain">
                                            <option value="naver.com">naver.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="kakao.com">kakao.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="direct">직접입력</option>
                                        </select>
                                    </template>
                                    <button class="btn-check" v-if="!isEmailAvailable" @click="fnCheckEmail()">중복체크</button>
                                </div>
                                <div class="msg-box" :style="{color: isEmailAvailable ? 'green' : 'red'}">
                                    {{ emailMsg }}
                                </div>
                            </div>
                        </div>
                        <!-- 성별 -->
                        <div class="form-row">
                            <div class="form-label">성별</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="radio" name="gender" v-model="info.gender" value="M"> 남
                                    <input type="radio" name="gender" v-model="info.gender" value="F"> 여
                                </div>
                                <div class="msg-box"></div>
                            </div>
                        </div>
                        <!-- 전화번호 -->
                        <div class="form-row">
                            <div class="form-label">전화번호</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="text" v-model="info.userTel"
                                        @input="formatTel(); fnCheckTelChange();"
                                        maxlength="13"
                                        placeholder="010 1234 5678">
                                    <button class="btn-check" v-if="!isSmsVerified" @click="fnSendSms()">인증 요청</button>
                                </div>
                                <div class="msg-box"></div>
                            </div>
                        </div>
                        <!-- 인증번호 -->
                        <div class="form-row">
                            <div class="form-label">인증번호</div>
                            <div class="input-wrap">
                                <div class="form-input" :class="{ disabled: !isTelChanged || isSmsVerified }">
                                    <input type="number" v-model="info.authCode"
                                        @input="formatTel"
                                        maxlength="6"
                                        placeholder="6자리 숫자를 입력하세요"
                                        :disabled="!isTelChanged || isSmsVerified">
                                    <button class="btn-check" v-if="isTelChanged && !isSmsVerified" @click="fnCheckSms()">인증 확인</button>
                                </div>
                                <div class="msg-box"></div>
                            </div>
                        </div>
                        <!-- 기혼/미혼 선택 -->
                        <div class="form-row">
                            <div class="form-label">결혼 여부</div>
                            <div class="input-wrap">
                                <div class="form-input">
                                    <input type="radio" name="maritalStatus" v-model="maritalStatus" 
                                        value="SINGLE" :disabled="!!info.anniversaryDate"> 미혼
                                    <input type="radio" name="maritalStatus" v-model="maritalStatus" 
                                        value="MARRIED" :disabled="!!info.anniversaryDate"> 기혼
                                </div>
                                <div class="msg-box" v-if="info.anniversaryDate" style="color:#aaa; height:auto;">
                                    ※ 결혼 기념일 입력 후에는 변경이 불가합니다.
                                </div>
                            </div>
                        </div>
                        <!-- 기혼: 결혼기념일 -->
                        <div class="form-row" v-if="maritalStatus === 'MARRIED'">
                            <div class="form-label">결혼기념일</div>
                            <div class="input-wrap">
                                <div class="form-input" :class="{ disabled: !!info.anniversaryDate }">
                                    <input type="date" v-model="info.anniversaryDate" 
                                        :disabled="!!info.anniversaryDate"
                                        :max="today">
                                </div>
                                <div class="msg-box" v-if="info.anniversaryDate" style="color:#aaa; height:auto;">
                                    ※ 결혼 기념일은 변경이 불가합니다.
                                </div>
                            </div>
                        </div>

                        <!-- 미혼: 결혼예정일 (변경 가능, 오늘 이후만) -->
                        <div class="form-row" v-else>
                            <div class="form-label">결혼예정일</div>
                            <div class="input-wrap">
                                <div class="form-input" >
                                    <input type="date" v-model="info.weddingDate" :min="today">
                                </div>
                                <div class="msg-box"></div>
                            </div>
                        </div>
                        <div class="btn-wrap">
                            <button type="button" class="btn-cancel" @click="fnCancel()">취소</button>
                            <button type="button" class="btn-update" @click="fnUserUpdate()">수정하기</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
    <script>
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-btn').forEach(btn => {
            const onclick = btn.getAttribute('onclick');
            if (!onclick) return;
            const match = onclick.match(/'([^']+)'/);
            if (!match) return;
            if (currentPath.endsWith(match[1])) {
                btn.classList.add('active');
            }
        });
    </script>
<script>
    const app = Vue.createApp({
        el: '#app',
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
                    name : "",
                    userEmail : "",
                    emailId: "",
                    gender : "M",
                    weddingDate: "",
                    anniversaryDate: "",
                    nickName : "",
                    // *문자 인증
                    authCode : "" // 인증번호 입력값
                },
                originTel: "",  // 원래 전화번호 저장용
                isTelChanged: false, // 번호가 바뀌었는지 여부
                isSmsVerified: false, // SMS 인증 완료 여부
                isVerified: false,  // 인증 완료 여부
                originFullEmail: "", // 기존 이메일
                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지
                maritalStatus: "",
                today: new Date().toISOString().split('T')[0],  // 추가
                originalMaritalStatus: "",
                anniversaryDateDisplay: "",
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCancel : function(){
                location.href="/userMyPage.do";
            },
            fnUserUpdate: function () {
                // 1.유효성 검사
                let self = this;
                console.log("maritalStatus:", self.maritalStatus);
                console.log("originalMaritalStatus:", self.originalMaritalStatus);
                console.log("anniversaryDate:", self.info.anniversaryDate);
                // 기혼으로 변경하고 결혼기념일 입력한 경우 확인창
                if (self.maritalStatus === 'MARRIED' && self.originalMaritalStatus !== 'MARRIED') {
                    const dateMsg = self.anniversaryDateDisplay ? self.anniversaryDateDisplay : '미입력';
                    if (!confirm(`결혼기념일을 ${dateMsg}로 등록하시겠습니까?\n한 번 등록하면 변경이 불가합니다.`)) {
                        self.info.anniversaryDate = "";  // 추가
                        return;
                    }
                }
                if(!self.info.userTel) {
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                if(!self.info.emailId || !self.emailDomain) {
                    alert("이메일주소를 입력해주세요.");
                    return;
                }
                if (!self.isEmailAvailable) {
                    alert("이메일 중복체크를 완료해주세요.");
                    return;
                }
                if (self.isTelChanged && !self.isSmsVerified) {
                    alert("변경된 전화번호에 대한 인증이 필요합니다.");
                    return;
                }
                // 2. 이메일 합치기 (조회 시 쪼개놨던 ID와 Domain을 다시 합침)
                let fullEmail = self.info.emailId + "@" + self.emailDomain;

                // 3. 서버로 보낼 파라미터 구성 (컨트롤러의 HashMap에 담길 내용)
                let param = {
                    userId: self.info.userId,      // 수정할 대상 (WHERE절용)
                    userName: self.info.name,  // 이름 (USER_DETAIL)
                    email: fullEmail,              // 이메일 (USER_DETAIL)
                    userTel: self.info.userTel,    // 전화번호 (MEMBER)
                    gender: self.info.gender,      // 성별 (USER_DETAIL)
                    nickName: self.info.nickName,   // 닉네임 (USER_DETAIL)
                    maritalStatus: self.maritalStatus,
                    weddingDate: self.maritalStatus === 'SINGLE' ? self.info.weddingDate : null, // 결혼 예정일
                    anniversaryDate: self.maritalStatus === 'MARRIED' ? self.info.anniversaryDate : null  // 추가
                };
                if(!confirm("회원정보를 수정하시겠습니까?")) return;

                $.ajax({
                    url: "http://localhost:8080/updateMemberInfo.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        if(data.result === "success") {
                            alert("성공적으로 수정되었습니다.");
                            location.href = "${pageContext.request.contextPath}/userMyPage.do";
                        } else {
                            alert("수정에 실패했습니다. 다시 시도해주세요.");
                        }
                    }
                });
            },
            // *휴대폰 번호*
            formatTel: function() {
                let self = this;
                let val = this.info.userTel.replace(/[^0-9]/g, '');
                if(val.length <= 3) {
                    this.info.userTel = val;
                } else if(val.length <= 7) {
                    this.info.userTel = val.slice(0,3) + '-' + val.slice(3);
                } else {
                    this.info.userTel = val.slice(0,3) + '-' + val.slice(3,7) + '-' + val.slice(7,11);
                }
                let param = {
                    ...self.info,
                    userTel: self.info.userTel.replace(/ /g, '')
                }
            },
            fnCheckTelChange: function() {
                let self = this;
                if (self.info.userTel !== self.originTel) {
                    self.isTelChanged = true;
                    self.isSmsVerified = false;
                } else {
                    self.isTelChanged = false;
                    self.authNumber = "";
                    self.isSmsVerified = true;
                }
            },
            // *이메일*
            fnEmailDomainChange: function() {
                if(this.emailDomain === 'direct') {
                    this.emailDomainDirect = true;
                    this.emailDomain = "";
                }
                this.fnCheckEmailChange();
            },
            fnCheckEmailChange: function() {
                let self = this;
                let currentEmail = self.info.emailId + "@" + self.emailDomain;

                console.log("원본:", self.originFullEmail);
                console.log("현재:", currentEmail);

                if (currentEmail !== self.originFullEmail) {
                    self.isEmailAvailable = false; 
                } else {
                    self.isEmailAvailable = true; 
                }
            },
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
                            self.info.userEmail = fullEmail;
                        } else {
                            self.isEmailAvailable = false;
                            self.emailMsg = "해당 이메일로 가입한 이력이 있습니다.";
                        }
                    }
                });
            },
            filterEmailDomain: function() {
                this.emailDomain = this.emailDomain.replace(/[^a-zA-Z.]/g, '');
            },
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
                            alert("인증번호가 발송되었습니다!");
                        } else {
                            alert("발송 실패. 다시 시도해주세요.");
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
                            alert("인증이 완료되었습니다!");
                            self.isVerified = true;
                            self.isSmsVerified = true;
                        } else {
                            alert("인증번호가 틀렸습니다.");
                        }
                    }
                });
            },
        }, // methods
        mounted() {
            let fullEmail = document.getElementById('emailVal').value;
            
            if (fullEmail && fullEmail.includes('@')) {
                let parts = fullEmail.split('@');
                this.info.emailId = parts[0];
                this.emailDomain = parts[1];
                const defaultDomains = ['naver.com', 'gmail.com', 'nate.com', 'kakao.com', 'daum.net'];
                if (!defaultDomains.includes(this.emailDomain)) {
                    this.emailDomainDirect = true;
                }
            }

            this.info.userId = document.getElementById('userIdVal').value;
            this.info.name = document.getElementById('nameVal').value;
            this.info.userEmail = fullEmail;
            this.info.userTel = document.getElementById('telVal').value;
            this.info.nickName = document.getElementById('nicknameVal').value;
            this.info.gender = document.getElementById('genderVal').value;
            this.info.weddingDate = document.getElementById('weddingDateVal').value;

            this.originFullEmail = fullEmail;
            this.originTel = this.info.userTel;

            this.isEmailAvailable = true;
            this.isSmsVerified = !this.info.userId.startsWith('kakao_') && !!this.info.userTel;
            this.maritalStatus = document.getElementById('maritalStatusVal').value;
            this.anniversaryDateDisplay = document.getElementById('anniversaryDateVal').value;
            this.originalMaritalStatus = document.getElementById('originalMaritalStatusVal').value;
        }
    });

    app.mount('#app');
</script>
</body>
</html>