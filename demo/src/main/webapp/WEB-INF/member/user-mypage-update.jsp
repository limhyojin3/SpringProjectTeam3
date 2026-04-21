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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        * { box-sizing: border-box;}
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; }

        .mypage-container {
            width: 100%;
            display: grid;
            grid-template-areas:
                "nav main";
            grid-template-columns: 200px 1fr;
            min-height: calc(100vh - 160px); /* 헤더+푸터 제외 */
            gap: 0;
        }

        /* 사이드바 */
        .nav {
            grid-area: nav;
            background-color: #ffc7c2;
            padding: 20px 10px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .nav-title {
            font-size: 16px;
            font-weight: bold;
            color: white;
            text-align: center;
            padding: 12px 0;
            margin-bottom: 5px;
            background-color: #f4a096;
            border-radius: 6px;
        }

        .nav-btn {
            width: 100%;
            padding: 12px 10px;
            text-align: left;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
        }

        .nav-btn:hover {
            background-color: #f4a096;
            border-color: #f4a096;
            color: white;
        }

        .nav-btn.active {
            background-color: #f4a096;
            border-color: #f4a096;
            color: white;
        }

        /* 메인 영역 */
        .main {
            grid-area: main;
            padding: 30px;
            background-color: #fff9f9;
            position: relative;
        }

        #edit-box {
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
        /* 수정 불가능한 입력창 스타일 */
        .read-only-input {
            /* 배경색을 살짝 다르게 하여 수정 불가임을 암시 (선택 사항) */
            background-color: #f9f9f9 !important; 
            /* 마우스 커서 모양 변경 */
            cursor: not-allowed;
            /* 클릭 시 나타나는 강조 효과(아웃라인) 제거 */
            outline: none !important;
        }
        /* 포커스가 가더라도 테두리 색이 변하지 않도록 고정 */
        .read-only-input:focus {
            border-color: #ddd !important; /* 기존 테두리 색상으로 고정 */
            box-shadow: none !important;
        }
        .form-group {
            display: flex !important;
            align-items: center; /* 라벨과 입력창의 높낮이 중앙 맞춤 */
            width: 100%;
        }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div class="mypage-container">
            <!-- 사이드바 -->
            <div class="nav">
                <div class="nav-title">마이페이지</div>
                <button class="nav-btn" @click="fnMypage()">마이페이지</button>
                <button class="nav-btn" @click="fnuserMyPagePay()">결제 멤버십 내역</button>
                <button class="nav-btn" @click="fnuserMyPageReview()">리뷰 조회 내역</button>
                <button class="nav-btn" @click="fnuserMyPageWrite()">내가 쓴 리뷰/댓글</button>
                <button class="nav-btn" @click="fnuserMyPageLike()">좋아요 목록</button>
                <button class="nav-btn" @click="fnuserMyPageCS()">고객센터</button>
            </div>
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
                                @input="formatTel"
                                maxlength="13"
                                placeholder="010 1234 5678">
                            <button class="btn-check" @click="fnSendSms()">인증 요청</button>
                        </div>
                        <div class="msg-box"></div>
                    </div>
                </div>
                <!-- 인증번호 입력 -->
                <div class="form-row">
                    <div class="form-label">인증번호</div>
                    <div class="input-wrap">
                        <div class="form-input">
                            <input type="number" v-model="info.authCode"
                                @input="formatTel"
                                maxlength="6"
                                placeholder="6자리 숫자를 입력하세요">
                            <button class="btn-check" @click="fnCheckSms()">인증 확인</button>
                        </div>
                        <div class="msg-box"></div>
                    </div> 
                </div>

                <!-- 결혼예정일 -->
                <div class="form-row">
                    <div class="form-label">결혼예정일</div>
                    <div class="input-wrap">
                        <div class="form-input">
                            <input type="date" v-model="info.weddingDate">
                        </div>
                        <div class="msg-box"></div>
                    </div>
                </div>
                <button type="button" @click="fnUserUpdate">수정하기</button>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
</body>
</html>

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
                    nickName : "",
                    // *문자 인증
                    authCode : "" // 인증번호 입력값
                },
                isVerified: false,  // 인증 완료 여부
                
                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnUserUpdate: function () {
                let self = this;
                // 아직 구현 중인 기능, 에러를 방지용 알림창.
                alert("정보 수정 기능은 현재 구현 중입니다.");
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
                        } else {
                            alert("인증번호가 틀렸습니다.");
                        }
                    }
                });
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // 1. 서버에서 전체 이메일을 가져옵니다. (예: hyejin04@naver.com)
            let fullEmail = "${member.email}"; 
            
            if (fullEmail && fullEmail.includes('@')) {
                let parts = fullEmail.split('@');
                
                // HTML이 보고 있는 'info.emailId'에 앞부분 대입
                this.info.emailId = parts[0]; 
                
                // HTML이 보고 있는 'emailDomain'에 뒷부분 대입
                this.emailDomain = parts[1];
                
                // 만약 도메인이 기본 리스트(naver, gmail 등)에 없는 거라면?
                // '직접입력' 모드를 켜줘야 input 박스가 보입니다.
                const defaultDomains = ['naver.com', 'gmail.com', 'nate.com', 'kakao.com', 'daum.net'];
                if (!defaultDomains.includes(this.emailDomain)) {
                    this.emailDomainDirect = true;
                }
            }

            this.info.userId = "${member.userId}";
            this.info.name = "${member.name}";      // userName이 아니라 name!
            this.info.userEmail = "${member.email}";    // userEmail이 아니라 email!
            this.info.userTel = "${member.tel}";        // userTel이 아니라 tel!
            this.info.nickName = "${member.nickname}";  // nickname (소문자 확인)
            this.info.gender = "${member.gender}";
            this.info.weddingDate = "${member.weddingDate}";
        }
    });

    app.mount('#app');
</script>