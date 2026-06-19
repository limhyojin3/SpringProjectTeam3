<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파트너 입점문의</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* ── 히어로 ── */
        .about-hero {
            width: 100%;
            height: 320px;
            background-image: url('/img/home_about3.jpg');
            background-size: cover;
            background-position: center;
            background-color: #ffc7c2;
            position: relative;
            display: flex;
            align-items: flex-end;
        }

        .about-hero-overlay {
            width: 100%;
            padding: 40px 60px;
            background: linear-gradient(to top, rgba(0,0,0,0.5), transparent);
        }

        .about-hero-overlay h1 {
            font-family: Georgia, serif;
            font-style: italic;
            font-size: 48px;
            color: white;
            margin: 0;
        }

        .about-hero-overlay p {
            color: rgba(255,255,255,0.85);
            font-size: 15px;
            margin: 6px 0 0;
        }

        /* ── 본문 ── */
        .partner-body {
            max-width: 860px;
            margin: 0 auto;
            padding: 56px 24px 100px;
        }

        /* ── 헤더 ── */
        .partner-header {
            border-bottom: 2px solid #f4a096;
            padding-bottom: 18px;
            margin-bottom: 36px;
        }

        .partner-header h2 {
            font-size: 24px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 6px;
        }

        .partner-header p {
            font-size: 14px;
            color: #999;
            margin: 0;
        }

        /* ── 혜택 배너 ── */
        .partner-benefits {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 48px;
        }

        .benefit-card {
            background: #fff9f9;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 24px 20px;
            text-align: center;
        }

        .benefit-card .benefit-icon {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .benefit-card h4 {
            font-size: 14px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 6px;
        }

        .benefit-card p {
            font-size: 12px;
            color: #999;
            margin: 0;
            line-height: 1.7;
        }

        /* ── 폼 영역 ── */
        .partner-form-wrap {
            background: #fff;
            border: 1px solid #ffd1d1;
            border-radius: 16px;
            padding: 40px 48px;
        }

        .partner-form-wrap h3 {
            font-size: 17px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 28px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f2e8e8;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #444;
        }

        .form-group label span.required {
            color: #f4a096;
            margin-left: 2px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            border: 1px solid #e0d0d0;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
            color: #333;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fff;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #f4a096;
            box-shadow: 0 0 0 3px rgba(244, 160, 150, 0.15);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #ccc;
            font-size: 13px;
        }

        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23bbb' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            cursor: pointer;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 140px;
            line-height: 1.7;
        }

        /* ── 동의 체크박스 ── */
        .form-agree {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 28px;
            padding: 16px;
            background: #fff9f9;
            border-radius: 8px;
            border: 1px solid #ffd1d1;
        }

        .form-agree input[type="checkbox"] {
            margin-top: 2px;
            accent-color: #f4a096;
            width: 15px;
            height: 15px;
            flex-shrink: 0;
            cursor: pointer;
        }

        .form-agree label {
            font-size: 13px;
            color: #666;
            line-height: 1.7;
            cursor: pointer;
        }

        .form-agree label a {
            color: #f4a096;
            text-decoration: none;
        }

        .form-agree label a:hover {
            text-decoration: underline;
        }

        /* ── 제출 버튼 ── */
        .submit-btn {
            width: 100%;
            padding: 14px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            letter-spacing: 0.02em;
        }

        .submit-btn:hover {
            background: #e8887a;
        }

        .submit-btn:active {
            transform: scale(0.99);
        }

        .submit-btn:disabled {
            background: #ddd;
            cursor: not-allowed;
        }

        /* ── 완료 메시지 ── */
        .submit-done {
            display: none;
            text-align: center;
            padding: 60px 20px;
        }

        .submit-done .done-icon {
            font-size: 52px;
            margin-bottom: 16px;
        }

        .submit-done h3 {
            font-size: 20px;
            font-weight: 700;
            color: #2c2c2c;
            margin-bottom: 10px;
            border: none;
            padding: 0;
        }

        .submit-done p {
            font-size: 14px;
            color: #999;
            line-height: 1.8;
        }

        /* ── 애니메이션 ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .about-hero-overlay  { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.1s; }
        .partner-header      { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.25s; }
        .partner-benefits    { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.4s; }
        .partner-form-wrap   { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.55s; }

        /* ── 반응형 ── */
        @media (max-width: 600px) {
            .partner-benefits { grid-template-columns: 1fr; }
            .partner-form-wrap { padding: 28px 20px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <div id="app">

        <!-- 히어로 -->
        <div class="about-hero">
            <div class="about-hero-overlay">
                <h1>MarryView</h1>
                <p>파트너 입점문의</p>
            </div>
        </div>

        <div class="partner-body">

            <!-- 헤더 -->
            <div class="partner-header">
                <h2>파트너 입점문의</h2>
                <p>MarryView와 함께 더 많은 예비 부부를 만나보세요.</p>
            </div>

            <!-- 혜택 카드 -->
            <div class="partner-benefits">
                <div class="benefit-card">
                    <div class="benefit-icon">💍</div>
                    <h4>검증된 리뷰 노출</h4>
                    <p>실제 이용 고객의 리뷰로<br>신뢰도를 높이세요</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">📅</div>
                    <h4>간편한 예약 관리</h4>
                    <p>예약 접수부터 확정까지<br>한 곳에서 관리</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">📈</div>
                    <h4>타겟 마케팅</h4>
                    <p>결혼을 준비 중인<br>예비 부부에게 직접 노출</p>
                </div>
            </div>

            <!-- 문의 폼 -->
            <div class="partner-form-wrap" id="formArea">
                <h3>✉️ 입점 문의 작성</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label>업체명 <span class="required">*</span></label>
                        <input type="text" id="companyName" placeholder="업체명을 입력해주세요" maxlength="50">
                    </div>
                    <div class="form-group">
                        <label>업종 <span class="required">*</span></label>
                        <select id="category">
                            <option value="" disabled selected>업종을 선택해주세요</option>
                            <option value="hall">웨딩홀</option>
                            <option value="dress">드레스</option>
                            <option value="studio">스튜디오</option>
                            <option value="makeup">메이크업</option>
                            <option value="etc">기타</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>담당자명 <span class="required">*</span></label>
                        <input type="text" id="managerName" placeholder="담당자 성함을 입력해주세요" maxlength="20">
                    </div>
                    <div class="form-group">
                        <label>연락처 <span class="required">*</span></label>
                        <input type="tel" id="phone" placeholder="010-0000-0000" maxlength="13">
                    </div>
                </div>

                <div class="form-group">
                    <label>이메일 <span class="required">*</span></label>
                    <input type="email" id="email" placeholder="회신 받으실 이메일 주소를 입력해주세요">
                </div>

                <div class="form-group">
                    <label>문의 내용 <span class="required">*</span></label>
                    <textarea id="message" placeholder="입점 관련 문의 사항을 자유롭게 작성해주세요.&#10;(업체 위치, 규모, 궁금한 점 등)"></textarea>
                </div>

                <div class="form-agree">
                    <input type="checkbox" id="agreeCheck">
                    <label for="agreeCheck">
                        <a href="/privacy.do" target="_blank">개인정보처리방침</a>에 동의하며, 입점 문의를 위한 개인정보(업체명, 담당자명, 연락처, 이메일) 수집 및 이용에 동의합니다. <span class="required">*</span>
                    </label>
                </div>

                <button class="submit-btn" id="submitBtn" onclick="submitForm()">문의 접수하기</button>

                <!-- 완료 메시지 -->
                <div class="submit-done" id="doneMsg">
                    <div class="done-icon">💌</div>
                    <h3>문의가 접수되었습니다!</h3>
                    <p>
                        소중한 문의 감사합니다.<br>
                        입력하신 이메일로 영업일 기준 <strong>2~3일 이내</strong> 답변 드리겠습니다.
                    </p>
                </div>
            </div>

        </div><!-- /partner-body -->

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div><!-- /#app -->

    <script>
        const app = Vue.createApp({});
        app.mount('#app');

        /* 연락처 자동 하이픈 */
        document.getElementById('phone').addEventListener('input', function () {
            let val = this.value.replace(/\D/g, '');
            if (val.length <= 3) {
                this.value = val;
            } else if (val.length <= 7) {
                this.value = val.slice(0, 3) + '-' + val.slice(3);
            } else {
                this.value = val.slice(0, 3) + '-' + val.slice(3, 7) + '-' + val.slice(7, 11);
            }
        });

        function submitForm() {
            const companyName = document.getElementById('companyName').value.trim();
            const category    = document.getElementById('category').value;
            const managerName = document.getElementById('managerName').value.trim();
            const phone       = document.getElementById('phone').value.trim();
            const email       = document.getElementById('email').value.trim();
            const message     = document.getElementById('message').value.trim();
            const agree       = document.getElementById('agreeCheck').checked;

            if (!companyName) { alert('업체명을 입력해주세요.'); return; }
            if (!category)    { alert('업종을 선택해주세요.'); return; }
            if (!managerName) { alert('담당자명을 입력해주세요.'); return; }
            if (!phone)       { alert('연락처를 입력해주세요.'); return; }
            if (!email)       { alert('이메일을 입력해주세요.'); return; }
            if (!message)     { alert('문의 내용을 입력해주세요.'); return; }
            if (!agree)       { alert('개인정보 수집 및 이용에 동의해주세요.'); return; }

            /* 폼 숨기고 완료 메시지 표시 */
            document.querySelectorAll('.form-row, .form-group, .form-agree, #submitBtn, h3').forEach(el => {
                el.style.display = 'none';
            });
            document.getElementById('doneMsg').style.display = 'block';
        }
    </script>
</body>
</html>
