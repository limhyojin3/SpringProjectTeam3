<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView - 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> <!--주소 api-->
    <style>
       * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: #fafafa;
            font-family: 'Noto Sans KR', sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px 16px;
            min-height: 100vh;
        }

        .logo-wrap {
            text-align: center;
            margin-bottom: 18px;
            cursor: pointer;
        }
        .logo-wrap img { 
            height: 64px;
            filter: hue-rotate(200deg);
        }

        .join-card {
            width: 100%;
            max-width: 480px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .join-card h2 {
            font-size: 16px;
            font-weight: 600;
            color: #555;
            text-align: center;
            margin-bottom: 18px;
        }

        .form-row {
            display: flex;
            align-items: stretch;
            margin-bottom: 4px;
        }

        .form-label {
            background: #9b8fd4;
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

        .row-body {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            border: 1px solid #9b8fd4;
            border-left: none;
            border-radius: 0 6px 6px 0;
            overflow: hidden;
        }

        .has-btn .row-body {
            border-radius: 0;
        }

        .form-input {
            display: flex;
            align-items: center;
            height: 38px;
            background: #fff;
        }
        .form-input + .form-input {
            border-top: 1px solid #9b8fd4;
        }
        .form-input.disabled { background: #f5f5f5; }

        input[type="text"],
        input[type="password"],
        input[type="number"] {
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

        select {
            border: none;
            outline: none;
            flex: 1;
            font-size: 13px;
            background: transparent;
            padding: 0 12px;
            height: 100%;
            font-family: 'Noto Sans KR', sans-serif;
            cursor: pointer;
        }

        input[type="radio"] {
            margin-left: 12px;
            margin-right: 4px;
            accent-color: #9b8fd4;
        }

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
            max-width: 100%;
        }

        .email-cancel {
            cursor: pointer;
            padding: 0 6px;
            color: #bbb;
            flex-shrink: 0;
        }

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

        .btn-check {
            align-self: stretch;
            padding: 0 14px;
            background: #98b5fd;
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

        .btn-submit {
            width: 100%;
            height: 48px;
            background: #9b8fd4;
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
        /* 스텝 인디케이터 */
        .step-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
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
        .step-dot.active {
            background: #9b8fd4;
            color: white;
        }
        .step-dot.done {
            background: #9b8fd4;
            color: white;
            opacity: 0.5;
        }
        .step-line {
            width: 40px;
            height: 2px;
            background: #eee;
            transition: background 0.3s;
        }
        .step-line.done {
            background: #9b8fd4;
            opacity: 0.5;
        }
        .step-label {
            font-size: 11px;
            color: #bbb;
            text-align: center;
            margin-top: 4px;
        }

        /* 스텝 버튼 영역 */
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
            background: #9b8fd4;
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

        /* ── 약관 동의 ── */
        .terms-wrap {
             margin: 16px 0 8px; 
        }
        .terms-box { 
            border: 1px solid #9b8fd4; 
            border-radius: 6px; 
            overflow: hidden; 
        }
        .terms-header {
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 10px 14px; 
            background: #fff8f8; 
        }
        .terms-header span {
             font-size: 13px; 
             color: #555; 
        }
        .terms-view-btn {
             font-size: 12px; 
             color: #9b8fd4; 
             cursor: pointer; 
             text-decoration: underline; 
        }
        .terms-check-row {
             padding: 10px 14px; 
             display: flex; 
             align-items: center; 
             gap: 8px; 
             border-top: 1px solid #f9ddd9; 
        }
        .terms-check-row input[type="checkbox"] {
             accent-color: #9b8fd4; 
             width: 16px; 
             height: 16px; 
        }
        .terms-check-row label {
             font-size: 13px; 
             color: #555; 
             cursor: pointer; 
        }
        .terms-modal-overlay {
            position: fixed; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            background: rgba(0,0,0,0.4); 
            z-index: 9999; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
        }
        .terms-modal {
            background: #fff; 
            width: 90%; 
            max-width: 520px; 
            max-height: 80vh; 
            border-radius: 12px; 
            overflow: hidden; 
            display: flex; 
            flex-direction: column; 
        }
        .terms-modal-header {
             padding: 16px 20px; 
             border-bottom: 1px solid #eee; 
             display: flex; 
             justify-content: space-between; 
             align-items: center; 
        }
        .terms-modal-header span {
             font-weight: 700; 
             font-size: 15px; 
             color: #333;
        }
        .terms-modal-close {
             cursor: pointer; 
             color: #aaa; 
             font-size: 20px; 
            }
        .terms-modal-body {
             padding: 20px; 
             overflow-y: auto; 
             flex: 1; 
             font-size: 13px; 
             color: #555; 
             line-height: 1.8; 
        }
        .terms-date {
             color: #aaa; 
             font-size: 12px; 
             margin-bottom: 16px; 
        }
        .terms-section-title {
             font-weight: 700; 
             color: #333; 
             margin-bottom: 6px; 
        }
        .terms-section-content {
             margin-bottom: 16px; 
        }
        .terms-section-content p {
             margin-bottom: 4px; 
        }
        .terms-modal-footer {
             border-top: 1px solid #eee; 
             padding-top: 16px; 
             display: flex; 
             align-items: center; 
             gap: 10px; 
        }
        .terms-modal-footer input[type="checkbox"] {
             accent-color: #9b8fd4; 
             width: 16px; 
             height: 16px; 
        }
        .terms-modal-footer label {
             font-size: 13px; 
             color: #555; 
             cursor: pointer; 
        }
        .terms-modal-confirm {
             margin-left: auto; 
             padding: 8px 20px; 
             background: #9b8fd4; 
             color: white; 
             border: none; 
             border-radius: 6px; 
             font-size: 13px; 
             cursor: pointer; 
        }
        .terms-modal-confirm:hover {
             opacity: 0.88; 
        }
        .pwd-strength-bar {
            width: 100%;
            height: 4px;
            background: #eee;
            border-radius: 4px;
            margin-top: 4px;
        }
        .pwd-strength-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.3s;
        }
        .pwd-strength-fill.weak { width: 33%; background: #ff4d4d; }
        .pwd-strength-fill.normal { width: 66%; background: #ffaa00; }
        .pwd-strength-fill.strong { width: 100%; background: #4caf50; }

        .weak { color: #ff4d4d; }
        .normal { color: #ffaa00; }
        .strong { color: #4caf50; }
    </style>
</head>
<body>
    <div id="app">
        <div class="logo-wrap" @click="fnMain()">
            <img src="/img/marryview-logo-en.svg" alt="메리뷰 로고">
        </div>

        <div class="join-card">
            <h2>업체 회원가입</h2>

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
                    <span class="step-label" :style="{color: step>=1 ? '#9b8fd4' : '#bbb'}">기본정보</span>
                    <span class="step-label" :style="{color: step>=2 ? '#9b8fd4' : '#bbb'}">본인인증</span>
                    <span class="step-label" :style="{color: step>=3 ? '#9b8fd4' : '#bbb'}">비밀번호</span>
                </div>
            </div>

            <!-- STEP 1: 기본정보 -->
            <div v-if="step === 1">

                <!-- 업체명 -->
                <div class="form-row has-btn">
                    <div class="form-label">업체명</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.comName"
                                :disabled="isComNameAvailable"
                                @change="filterComName"
                                placeholder="정확한 업체명을 입력해주세요">
                        </div>
                        <div class="msg-box" :class="{'show': comNameMsg}"
                            :style="{color: isComNameAvailable ? 'green' : 'red'}">{{ comNameMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnCheckComName()">중복체크</button>
                </div>

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

                <!-- 대표자명 -->
                <div class="form-row">
                    <div class="form-label">대표자명</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.ceoName"
                                @input="filterName" placeholder="한글만 입력 가능합니다">
                        </div>
                    </div>
                </div>

                <!-- 대표 이메일 -->
                <div class="form-row has-btn">
                    <div class="form-label">대표<br>이메일</div>
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
                <div class="step-btn-wrap">
                    <button class="btn-next" @click="step=2">다음 →</button>
                </div>
            </div>

            <!-- STEP 2: 본인인증 -->
            <div v-if="step === 2">

                <!-- 대표 전화번호 -->
                <div class="form-row has-btn">
                    <div class="form-label">대표<br>전화번호</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.comTel"
                                @input="formatTel" maxlength="13" placeholder="010-1234-5678">
                        </div>
                        <div class="msg-box" :class="{'show': comTelMsg}"
                            :style="{color: isComTelVerified ? 'green' : 'red'}">{{ comTelMsg }}</div>
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

                <!-- 사업자 번호 -->
                <div class="form-row has-btn">
                    <div class="form-label">사업자<br>번호</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.bizNo"
                                @input="formatBizNo" placeholder="000-00-00000">
                        </div>
                        <div class="msg-box" :class="{'show': bizMsg}"
                            :style="{color: isBizVerified ? 'green' : 'red'}">{{ bizMsg }}</div>
                    </div>
                    <button class="btn-check" @click="fnCheckBizNo()">번호 인증</button>
                </div>

                <div class="step-btn-wrap">
                    <button class="btn-prev" @click="step=1">← 이전</button>
                    <button class="btn-next" @click="step=3">다음 →</button>
                </div>
            </div>

            <!-- STEP 3: 비밀번호 + 주소 -->
            <div v-if="step === 3">

                <!-- 비밀번호 + 확인 묶음 -->
                <div class="form-row">
                    <div class="form-label">비밀번호</div>
                    <div class="row-body">
                        <div class="form-input" :class="{'disabled': !(isVerified && isBizVerified)}">
                            <input type="password" v-model="info.password"
                                @input="filterPassword"
                                :disabled="!(isVerified && isBizVerified)"
                                placeholder="영문+숫자 8자 이상">
                        </div>
                        <!-- ✅ 추가 -->
                        <div class="msg-box" :class="{'show': pwdStrengthMsg, 'disabled': !(isVerified && isBizVerified)}">
                            <span :class="pwdStrengthClass">{{ pwdStrengthMsg }}</span>
                        </div>
                        <div class="form-input" :class="{'disabled': !(isVerified && isBizVerified)}">
                            <input type="password" v-model="info.passwordConfirm"
                                :disabled="!(isVerified && isBizVerified)"
                                placeholder="비밀번호 확인">
                        </div>
                        <div class="msg-box"
                            :class="{'show': pwdMsg, 'disabled': !(isVerified && isBizVerified)}"
                            :style="{color: isPwdMatch ? 'green' : 'red'}">{{ pwdMsg }}</div>
                    </div>
                </div>

                <!-- 사업장 주소 -->
                <div class="form-row">
                    <div class="form-label">사업장<br>주소</div>
                    <div class="row-body">
                        <div class="form-input">
                            <input type="text" v-model="info.comAddress"
                                placeholder="주소 검색 버튼을 눌러주세요" readonly>
                            <button class="btn-check" style="border-radius:0;"
                                @click="fnSearchAddress()">주소 검색</button>
                        </div>
                        <div class="form-input">
                            <input type="text" v-model="info.comAddressDetail"
                                placeholder="상세 주소를 입력해주세요">
                        </div>
                        <div class="msg-box" :class="{'show': addressMsg}"
                            :style="{color: isAddressMatch ? 'green' : 'red'}">{{ addressMsg }}</div>
                    </div>
                </div>
                <!-- 약관 동의 -->
                <div class="terms-wrap">
                    <div class="terms-box">
                        <div class="terms-header">
                            <span>MarryView 이용약관 (필수)</span>
                            <span class="terms-view-btn" @click="showTermsModal=true">약관 보기</span>
                        </div>
                        <div class="terms-check-row">
                            <input type="checkbox" id="agreeTerms" v-model="isTermsAgreed">
                            <label for="agreeTerms">이용약관에 동의합니다.</label>
                        </div>
                    </div>
                </div>

                <!-- 약관 모달 -->
                <div class="terms-modal-overlay" v-if="showTermsModal">
                    <div class="terms-modal">
                        <div class="terms-modal-header">
                            <span>MarryView 이용약관</span>
                            <span class="terms-modal-close" @click="showTermsModal=false">✕</span>
                        </div>
                        <div class="terms-modal-body">
                            <p class="terms-date">시행일: 2025년 01월 01일</p>
                            <p class="terms-section-title">제1조 (목적)</p>
                            <div class="terms-section-content">
                                <p>이 약관은 MarryView가 운영하는 웨딩 리뷰 플랫폼의 이용 조건 및 절차, 회사와 이용자 간의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.</p>
                            </div>
                            <p class="terms-section-title">제4조 (회원가입 및 관리)</p>
                            <div class="terms-section-content">
                                <p>· 만 14세 미만의 아동은 회원가입을 할 수 없습니다.</p>
                                <p>· 하나의 이메일 계정으로 하나의 회원 계정만 생성할 수 있습니다.</p>
                                <p>· 아이디와 비밀번호는 본인이 직접 관리하여야 하며, 제3자에게 양도하거나 공유할 수 없습니다.</p>
                            </div>
                            <p class="terms-section-title">제6조 (리뷰 작성 규정)</p>
                            <div class="terms-section-content">
                                <p>· 리뷰는 해당 업체를 실제로 예약·이용한 회원만 작성할 수 있습니다.</p>
                                <p>· 허위 리뷰, 광고성 리뷰, 욕설·비방 등이 포함된 리뷰는 삭제될 수 있습니다.</p>
                            </div>
                            <p class="terms-section-title">제9조 (금지행위)</p>
                            <div class="terms-section-content">
                                <p>· 타인의 계정 도용, 허위 정보 가입 금지</p>
                                <p>· 크롤링·자동화 스크립트 사용 금지</p>
                                <p>· 허위 리뷰 작성 및 조직적 리뷰 조작 금지</p>
                            </div>
                            <p class="terms-section-title">제10조 (개인정보 보호)</p>
                            <div class="terms-section-content">
                                <p>· 회사는 관련 법령에 따라 회원의 개인정보를 보호하며, 동의 없이 제3자에게 제공하지 않습니다.</p>
                            </div>
                            <div class="terms-modal-footer">
                                <input type="checkbox" id="modalAgree" v-model="isTermsAgreed">
                                <label for="modalAgree">동의합니다.</label>
                                <button class="terms-modal-confirm" @click="showTermsModal=false">확인</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="step-btn-wrap">
                    <button class="btn-prev" @click="step=2">← 이전</button>
                    <button class="btn-next" @click="fnCompanyJoin()">가입하기</button>
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
                // 변수 - (key : value)
                step: 1,
                info : {
                    // *member table
                    userId : "",
                    password: "",
                    passwordConfirm: "",  // 비밀번호 확인
                    comTel : "",
                    // *company table
                    comName : "",
                    ceoName : "",
                    comAddress : "",
                    comAddressDetail: "",
                    comEmail : "", // [저장용] 중복체크 통과 시 합쳐진 전체 이메일 저장
                    emailId : "", // [입력용] 화면의 input 창과 연결 (v-model)
                    bizNo : "",
                    gender : "M",
                    // *번호 인증
                    authCode : ""
                },
                authCodeMsg : "",

                isVerified: false,  // 인증 완료 여부
                isBizVerified: false, // 사업자번호 확인 완료
                bizMsg: "", 
                isComNameAvailable: false, // 업체명 중복체크 통과 여부 (true  → 사용 가능한 업체명)
                comNameMsg: "",            // 아이디 중복체크 결과 메시지
                isUserIdAvailable: false,  // 아이디 중복체크 통과 여부 (true  → 사용 가능한 아이디)
                userIdMsg: "",             // 아이디 중복체크 결과 메시지
                
                comTypeMsg: "",
                comTelMsg: "",
                isComTelVerified: false,  // 전화번호 입력 여부
                isComTypeSelected: false,  // 업체 분류 선택 여부

                emailDomain: "naver.com",      // 선택된 도메인
                emailDomainDirect: false,      // 직접입력 여부
                isEmailAvailable: false,       // 중복체크 결과
                emailMsg: "",                  // 이메일 메시지

                pwdMsg: "", // 비밀번호 확인
                isPwdMatch: false, // 비밀번호 일치체크

                addressMsg : "",
                isAddressMatch:false, // 사업장 위치 입력 여부

                isTermsAgreed: false, // 약관 동의
                showTermsModal: false, // 약관 동의 모달
                pwdStrengthMsg: '',
                pwdStrengthClass: '',
            };
        },
        methods: {
            fnMain() {
                location.href = '/merryViewHome.do';
            },
            fnCompanyJoin: function () {
                let self = this;
                console.log("comTel 길이:", self.info.comTel.replace(/ /g, '').length);
                console.log("comTel 값:", self.info.comTel);
                // 유효성 검사
                if(!self.info.comName) {
                    alert("업체명을 입력해주세요.");
                    return;
                }
                if(!self.isComNameAvailable) {
                    alert("업체명 중복체크를 해주세요.");
                    return;
                }
                // 추가
                if(!self.info.comType) {
                    alert("업체 분류를 선택해주세요.");
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
                if(!self.isVerified) {
                    alert("전화번호 인증을 완료해주세요.");
                    return;
                }
                if(self.info.bizNo.replace(/-/g, '').length !== 10) {
                    alert("사업자 번호를 인증해주세요.");
                    return;
                }
                if(!self.isBizVerified) {
                    alert("사업자 번호을 완료해주세요.");
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
                if(!self.info.comAddress) {
                    alert("사업장 주소를 입력해주세요.");
                    return;
                }
                if(!self.info.comAddressDetail) {
                    alert("상세 주소를 입력해주세요.");
                    return;
                }
                if(!self.isTermsAgreed) {
                    alert("이용약관에 동의해주세요.");
                    return;
                }

                let param = {
                    // member 테이블
                    userId: self.info.userId,
                    password: self.info.password,
                    comTel: self.info.comTel.replace(/ /g, ''),

                    // company 테이블
                    comName: self.info.comName,
                    comType: JSON.stringify([self.info.comType]),
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
                            window.location.href = "/login.do";  // 로그인으로 이동
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

                 // 보안 단계 체크
                let pwd = this.info.password;
                let hasLetter = /[a-zA-Z]/.test(pwd);
                let hasNumber = /[0-9]/.test(pwd);
                let hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pwd);
                
                if (!pwd) {
                    this.pwdStrengthMsg = '';
                    this.pwdStrengthClass = '';
                } else if (pwd.length < 8 || !hasLetter || !hasNumber) {
                    this.pwdStrengthMsg = '🔴 취약 - 영문+숫자 8자리 이상 입력해주세요.';
                    this.pwdStrengthClass = 'weak';
                } else if (hasSpecial) {
                    this.pwdStrengthMsg = '🟢 강함 - 안전한 비밀번호입니다.';
                    this.pwdStrengthClass = 'strong';
                } else {
                    this.pwdStrengthMsg = '🟡 보통 - 특수문자 추가 시 보안이 강해져요.';
                    this.pwdStrengthClass = 'normal';
                }
            },
            fnSearchAddress: function() {
                new daum.Postcode({
                    oncomplete: (data) => {
                        this.info.comAddress = data.roadAddress;
                        this.addressMsg = "✅ 주소가 입력되었습니다.";
                        this.isAddressMatch = true; 
                    }
                }).open();
            },
            // *휴대폰 문자인증*
            fnSendSms: function() {
                let self = this;
                if(!self.info.comTel) {
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                $.ajax({
                    url: "http://localhost:8080/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { tel: self.info.comTel.replace(/-/g, '') },
                    success: function(data) {
                        if(data.result === 'success') {
                            self.comTelMsg = "✅ 인증번호가 발송되었습니다.";  // 추가
                            self.isComTelVerified = true;  // 추가
                        } else {
                            self.comTelMsg = "❌ 발송에 실패했습니다.";  // 추가
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
                        tel: self.info.comTel.replace(/-/g, ''),
                        authCode: self.info.authCode
                    },
                    success: function(data) {
                        if(data.result === 'success') {
                            self.isVerified = true;
                            self.comTelMsg = "✅ 인증이 완료되었습니다.";  // 추가
                            self.isComTelVerified = true;
                            self.authCodeMsg = "✅ 인증이 완료되었습니다.";
                        } else {
                            self.comTelMsg = "❌ 인증번호가 틀렸습니다.";  // 추가
                            self.isComTelVerified = false;
                            self.authCodeMsg = "❌ 인증번호가 틀렸습니다."; 
                        }
                    }
                });
            },
            // *사업자 번호 입력(사업자 번호 api는 실제 사업자가 없어서 이용 불가 \)
            fnCheckBizNo: function() {
                let self = this;
                let bizNo = self.info.bizNo.replace(/-/g, '');
                
                // 10자리 숫자인지만 체크
                if(bizNo.length !== 10) {
                    alert("사업자번호 10자리를 입력해주세요.");
                    return;
                }
                
                // 형식만 통과시키기
                alert("사업자번호 인증이 완료되었습니다.");
                self.isBizVerified = true;
                self.bizMsg = "✅ 사업자번호 인증이 완료되었습니다.";
            }
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