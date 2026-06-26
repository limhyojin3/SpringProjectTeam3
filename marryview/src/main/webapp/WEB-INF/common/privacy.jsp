<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인정보처리방침</title>
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

        /* ── 본문 레이아웃 ── */
        .privacy-body {
            max-width: 860px;
            margin: 0 auto;
            padding: 56px 24px 100px;
        }

        /* ── 상단 타이틀 ── */
        .privacy-header {
            border-bottom: 2px solid #f4a096;
            padding-bottom: 18px;
            margin-bottom: 40px;
        }

        .privacy-header h2 {
            font-size: 24px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 6px;
        }

        .privacy-header .privacy-date {
            font-size: 13px;
            color: #aaa;
        }

        /* ── 안내 배너 ── */
        .privacy-notice {
            background: #fff4f3;
            border-left: 4px solid #f4a096;
            border-radius: 0 8px 8px 0;
            padding: 16px 20px;
            margin-bottom: 40px;
            font-size: 14px;
            color: #666;
            line-height: 1.8;
        }

        /* ── 목차 ── */
        .privacy-toc {
            background: #fff9f9;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 22px 28px;
            margin-bottom: 48px;
        }

        .privacy-toc p {
            font-size: 13px;
            font-weight: 700;
            color: #f4a096;
            margin: 0 0 10px;
            letter-spacing: 0.04em;
        }

        .privacy-toc ol {
            margin: 0;
            padding-left: 18px;
            columns: 2;
            column-gap: 32px;
        }

        .privacy-toc ol li {
            font-size: 13px;
            color: #666;
            line-height: 2;
        }

        .privacy-toc ol li a {
            color: #666;
            text-decoration: none;
            transition: color 0.15s;
        }

        .privacy-toc ol li a:hover {
            color: #f4a096;
        }

        /* ── 개별 조항 ── */
        .privacy-article {
            margin-bottom: 44px;
            scroll-margin-top: 80px;
        }

        .privacy-article h3 {
            font-size: 15px;
            font-weight: 700;
            color: #2c2c2c;
            padding: 10px 16px;
            background: #fff4f3;
            border-left: 4px solid #f4a096;
            border-radius: 0 8px 8px 0;
            margin: 0 0 16px;
        }

        .privacy-article p {
            font-size: 14px;
            color: #555;
            line-height: 1.95;
            margin: 0 0 10px;
            padding-left: 4px;
        }

        .privacy-article ol {
            padding-left: 20px;
            margin: 8px 0 0;
        }

        .privacy-article ol > li {
            font-size: 14px;
            color: #555;
            line-height: 1.9;
            margin-bottom: 8px;
        }

        .privacy-article ul {
            padding-left: 20px;
            margin: 8px 0 0;
        }

        .privacy-article ul > li {
            font-size: 14px;
            color: #555;
            line-height: 1.9;
            margin-bottom: 6px;
        }

        /* ── 표 ── */
        .privacy-table {
            width: 100%;
            border-collapse: collapse;
            margin: 12px 0 0;
            font-size: 13px;
        }

        .privacy-table th {
            background: #fff4f3;
            color: #444;
            font-weight: 700;
            padding: 10px 14px;
            border: 1px solid #ffd1d1;
            text-align: center;
            white-space: nowrap;
        }

        .privacy-table td {
            padding: 10px 14px;
            border: 1px solid #f2e0e0;
            color: #555;
            vertical-align: top;
            line-height: 1.75;
        }

        .privacy-table tr:nth-child(even) td {
            background: #fffafa;
        }

        /* ── 하위 리스트 ── */
        .sub-list {
            list-style: none;
            padding-left: 14px;
            margin: 8px 0 4px;
        }

        .sub-list li {
            font-size: 13px;
            color: #888;
            line-height: 1.85;
            position: relative;
            padding-left: 14px;
        }

        .sub-list li::before {
            content: "–";
            position: absolute;
            left: 0;
            color: #ccc;
        }

        /* ── 맺음말 박스 ── */
        .privacy-footer-box {
            background: linear-gradient(135deg, #fff9f9, #fff0ef);
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 28px 32px;
            text-align: center;
            margin-top: 56px;
        }

        .privacy-footer-box p {
            font-size: 13px;
            color: #888;
            line-height: 1.9;
            margin: 0;
        }

        .privacy-footer-box a {
            color: #f4a096;
            text-decoration: none;
        }

        .privacy-footer-box a:hover {
            text-decoration: underline;
        }

        /* ── 구분선 ── */
        .privacy-divider {
            border: none;
            border-top: 1px solid #f2e8e8;
            margin: 40px 0;
        }

        /* ── 애니메이션 ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .about-hero-overlay { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.1s; }
        .privacy-header     { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.25s; }
        .privacy-notice     { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.35s; }
        .privacy-toc        { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.45s; }
        .privacy-article    { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.55s; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <div id="app">

        <!-- 히어로 -->
        <div class="about-hero">
            <div class="about-hero-overlay">
                <h1>MarryView</h1>
                <p>개인정보처리방침</p>
            </div>
        </div>

        <div class="privacy-body">

            <!-- 타이틀 -->
            <div class="privacy-header">
                <h2>개인정보처리방침</h2>
                <span class="privacy-date">시행일: 2025년 01월 01일 &nbsp;|&nbsp; 최종 수정일: 2025년 01월 01일</span>
            </div>

            <!-- 안내 배너 -->
            <div class="privacy-notice">
                MarryView(이하 "회사")는 「개인정보 보호법」 및 관련 법령을 준수하며, 이용자의 개인정보를 소중히 보호합니다.<br>
                본 방침은 회사가 수집하는 개인정보의 항목, 수집 목적, 보유 기간 및 이용자의 권리에 대해 안내합니다.
            </div>

            <!-- 목차 -->
            <nav class="privacy-toc">
                <p>📋 목차</p>
                <ol>
                    <li><a href="#p1">수집하는 개인정보 항목</a></li>
                    <li><a href="#p2">개인정보 수집 및 이용 목적</a></li>
                    <li><a href="#p3">개인정보 보유 및 이용 기간</a></li>
                    <li><a href="#p4">개인정보 제3자 제공</a></li>
                    <li><a href="#p5">개인정보 처리 위탁</a></li>
                    <li><a href="#p6">이용자의 권리와 행사 방법</a></li>
                    <li><a href="#p7">개인정보 자동 수집 장치</a></li>
                    <li><a href="#p8">개인정보 보호 조치</a></li>
                    <li><a href="#p9">개인정보 파기</a></li>
                    <li><a href="#p10">개인정보 보호책임자</a></li>
                </ol>
            </nav>

            <!-- 제1조 -->
            <div class="privacy-article" id="p1">
                <h3>1. 수집하는 개인정보 항목</h3>
                <p>회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.</p>
                <table class="privacy-table">
                    <thead>
                        <tr>
                            <th>수집 시점</th>
                            <th>필수 항목</th>
                            <th>선택 항목</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>회원가입</td>
                            <td>이름, 이메일 주소, 비밀번호, 혼인 여부</td>
                            <td>결혼 예정일 또는 결혼 기념일, 프로필 사진</td>
                        </tr>
                        <tr>
                            <td>리뷰 작성</td>
                            <td>닉네임, 작성 내용, 첨부 이미지</td>
                            <td>–</td>
                        </tr>
                        <tr>
                            <td>예약 신청</td>
                            <td>이름, 연락처, 예약 일시</td>
                            <td>요청 사항</td>
                        </tr>
                        <tr>
                            <td>서비스 이용 중 자동 수집</td>
                            <td>접속 IP, 방문 일시, 서비스 이용 기록, 쿠키</td>
                            <td>–</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <hr class="privacy-divider">

            <!-- 제2조 -->
            <div class="privacy-article" id="p2">
                <h3>2. 개인정보 수집 및 이용 목적</h3>
                <p>회사는 수집한 개인정보를 다음의 목적으로만 이용합니다.</p>
                <table class="privacy-table">
                    <thead>
                        <tr>
                            <th>이용 목적</th>
                            <th>상세 내용</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>회원 관리</td>
                            <td>본인 확인, 계정 관리, 부정이용 방지</td>
                        </tr>
                        <tr>
                            <td>서비스 제공</td>
                            <td>업체 정보 제공, 리뷰 작성 및 조회, 예약 중개</td>
                        </tr>
                        <tr>
                            <td>쿠폰·기프트콘 발급</td>
                            <td>좋아요 수 집계, 베스트 리뷰 선정, 혜택 발급</td>
                        </tr>
                        <tr>
                            <td>고객 지원</td>
                            <td>문의 응대, 불만 처리, 분쟁 해결</td>
                        </tr>
                        <tr>
                            <td>서비스 개선</td>
                            <td>이용 통계 분석, 신규 서비스 개발</td>
                        </tr>
                        <tr>
                            <td>마케팅·이벤트 안내 (동의 시)</td>
                            <td>이벤트·프로모션 정보 발송, 맞춤 콘텐츠 제공</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <hr class="privacy-divider">

            <!-- 제3조 -->
            <div class="privacy-article" id="p3">
                <h3>3. 개인정보 보유 및 이용 기간</h3>
                <p>회사는 원칙적으로 개인정보 수집 및 이용 목적이 달성된 후 해당 정보를 즉시 파기합니다. 단, 관련 법령에 따라 아래와 같이 보존합니다.</p>
                <table class="privacy-table">
                    <thead>
                        <tr>
                            <th>보존 항목</th>
                            <th>보존 근거</th>
                            <th>보존 기간</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>계약 또는 청약철회 기록</td>
                            <td>전자상거래법</td>
                            <td>5년</td>
                        </tr>
                        <tr>
                            <td>대금결제 및 재화 공급 기록</td>
                            <td>전자상거래법</td>
                            <td>5년</td>
                        </tr>
                        <tr>
                            <td>소비자 불만 및 분쟁처리 기록</td>
                            <td>전자상거래법</td>
                            <td>3년</td>
                        </tr>
                        <tr>
                            <td>로그인 기록</td>
                            <td>통신비밀보호법</td>
                            <td>3개월</td>
                        </tr>
                    </tbody>
                </table>
                <p style="margin-top: 12px;">회원 탈퇴 시 개인정보는 즉시 파기되며, 위 법령 보존 항목은 해당 기간 동안 별도 보관 후 파기됩니다.</p>
            </div>

            <hr class="privacy-divider">

            <!-- 제4조 -->
            <div class="privacy-article" id="p4">
                <h3>4. 개인정보 제3자 제공</h3>
                <p>회사는 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 다만, 아래의 경우는 예외로 합니다.</p>
                <ol>
                    <li>이용자가 사전에 동의한 경우</li>
                    <li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
                    <li>예약 서비스 제공을 위해 업체에 필요 최소한의 정보(이름, 연락처, 예약 일시)를 제공하는 경우</li>
                </ol>
            </div>

            <hr class="privacy-divider">

            <!-- 제5조 -->
            <div class="privacy-article" id="p5">
                <h3>5. 개인정보 처리 위탁</h3>
                <p>회사는 현재 개인정보 처리 업무를 외부에 위탁하고 있지 않습니다. 향후 위탁이 필요한 경우 사전에 본 방침을 통해 공지하겠습니다.</p>
            </div>

            <hr class="privacy-divider">

            <!-- 제6조 -->
            <div class="privacy-article" id="p6">
                <h3>6. 이용자의 권리와 행사 방법</h3>
                <p>이용자는 언제든지 다음의 권리를 행사할 수 있습니다.</p>
                <ol>
                    <li><strong>개인정보 열람 요청</strong> — 회사가 보유한 본인의 개인정보를 확인할 수 있습니다.</li>
                    <li><strong>개인정보 정정·삭제 요청</strong> — 잘못된 정보를 수정하거나 삭제를 요청할 수 있습니다.</li>
                    <li><strong>개인정보 처리 정지 요청</strong> — 개인정보 처리의 정지를 요청할 수 있습니다.</li>
                    <li><strong>동의 철회</strong> — 마케팅 수신 동의 등을 언제든지 철회할 수 있습니다.</li>
                </ol>
                <p>위 권리 행사는 서비스 내 마이페이지 또는 이메일(<a href="mailto:help@marryview.com" style="color:#f4a096;">help@marryview.com</a>)을 통해 요청하실 수 있으며, 회사는 요청 접수 후 10일 이내에 처리합니다.</p>
            </div>

            <hr class="privacy-divider">

            <!-- 제7조 -->
            <div class="privacy-article" id="p7">
                <h3>7. 개인정보 자동 수집 장치 (쿠키)</h3>
                <ol>
                    <li>회사는 이용자에게 최적화된 서비스를 제공하기 위해 쿠키(Cookie)를 사용합니다.</li>
                    <li>쿠키는 웹사이트 운영에 이용되는 서버가 이용자의 브라우저에 보내는 소량의 정보이며, 이용자의 PC에 저장됩니다.</li>
                    <li>이용자는 브라우저 설정을 통해 쿠키 저장을 거부할 수 있으나, 이 경우 일부 서비스 이용이 제한될 수 있습니다.</li>
                    <li>
                        쿠키 설정 거부 방법:
                        <ul class="sub-list">
                            <li>Chrome: 설정 → 개인정보 및 보안 → 쿠키 및 기타 사이트 데이터</li>
                            <li>Edge: 설정 → 쿠키 및 사이트 권한 → 쿠키 및 사이트 데이터 관리</li>
                        </ul>
                    </li>
                </ol>
            </div>

            <hr class="privacy-divider">

            <!-- 제8조 -->
            <div class="privacy-article" id="p8">
                <h3>8. 개인정보 보호 조치</h3>
                <p>회사는 개인정보 보호를 위해 다음의 기술적·관리적 조치를 취하고 있습니다.</p>
                <ol>
                    <li><strong>비밀번호 암호화</strong> — 회원 비밀번호는 단방향 암호화(해시)하여 저장합니다.</li>
                    <li><strong>접근 권한 관리</strong> — 개인정보 처리 시스템 접근 권한을 최소한의 인원으로 제한합니다.</li>
                    <li><strong>보안 프로그램 운영</strong> — 해킹·악성코드로부터 개인정보를 보호하기 위한 보안 프로그램을 설치·운영합니다.</li>
                    <li><strong>내부 교육</strong> — 개인정보를 취급하는 담당자를 대상으로 정기적인 교육을 실시합니다.</li>
                </ol>
            </div>

            <hr class="privacy-divider">

            <!-- 제9조 -->
            <div class="privacy-article" id="p9">
                <h3>9. 개인정보 파기</h3>
                <ol>
                    <li>회사는 개인정보 보유 기간이 경과하거나 처리 목적이 달성된 경우 해당 개인정보를 지체 없이 파기합니다.</li>
                    <li>
                        파기 방법:
                        <ul class="sub-list">
                            <li>전자적 형태의 정보: 복원이 불가능한 방법으로 영구 삭제</li>
                            <li>종이 문서: 분쇄 또는 소각</li>
                        </ul>
                    </li>
                </ol>
            </div>

            <hr class="privacy-divider">

            <!-- 제10조 -->
            <div class="privacy-article" id="p10">
                <h3>10. 개인정보 보호책임자</h3>
                <p>회사는 개인정보 처리에 관한 업무를 총괄하고, 이용자의 개인정보 관련 불만 처리 및 피해 구제를 위해 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</p>
                <table class="privacy-table">
                    <tbody>
                        <tr>
                            <th style="width: 140px;">담당 부서</th>
                            <td>MarryView 개발팀</td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td><a href="mailto:help@marryview.com" style="color:#f4a096;">help@marryview.com</a></td>
                        </tr>
                    </tbody>
                </table>
                <p style="margin-top: 14px;">
                    기타 개인정보 침해에 대한 신고나 상담은 아래 기관에 문의하실 수 있습니다.
                </p>
                <ul class="sub-list">
                    <li>개인정보 분쟁조정위원회: <a href="https://www.kopico.go.kr" target="_blank" style="color:#f4a096;">www.kopico.go.kr</a> / 1833-6972</li>
                    <li>개인정보 침해신고센터: <a href="https://privacy.kisa.or.kr" target="_blank" style="color:#f4a096;">privacy.kisa.or.kr</a> / 118</li>
                    <li>검찰청 사이버범죄 신고: <a href="https://ecrm.police.go.kr/" target="_blank" style="color:#f4a096;">www.spo.go.kr</a> / 1301</li>
                    <li>경찰청 사이버안전국: <a href="https://ecrm.cyber.go.kr" target="_blank" style="color:#f4a096;">ecrm.cyber.go.kr</a> / 182</li>
                </ul>
            </div>

            <!-- 맺음말 -->
            <div class="privacy-footer-box">
                <p>
                    본 개인정보처리방침은 <strong>2026년 04월 01일</strong>부터 시행됩니다.<br>
                    방침 변경 시 서비스 내 공지사항을 통해 사전 안내드립니다.<br><br>
                    문의: <a href="mailto:help@marryview.com">help@marryview.com</a>
                </p>
            </div>

        </div><!-- /privacy-body -->

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div><!-- /#app -->

    <script>
        const app = Vue.createApp({});
        app.mount('#app');
    </script>
</body>
</html>
