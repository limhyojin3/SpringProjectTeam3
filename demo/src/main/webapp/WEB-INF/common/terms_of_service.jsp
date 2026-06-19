<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이용약관 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* ── 히어로 ── */
        .about-hero {
            width: 100%;
            height: 320px;
            background-image: url('/img/home_about5.jpg');
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
        .terms-body {
            max-width: 860px;
            margin: 0 auto;
            padding: 56px 24px 100px;
        }

        /* ── 상단 타이틀 + 날짜 ── */
        .terms-header {
            border-bottom: 2px solid #f4a096;
            padding-bottom: 18px;
            margin-bottom: 40px;
        }

        .terms-header h2 {
            font-size: 24px;
            font-weight: 700;
            color: #2c2c2c;
            margin: 0 0 6px;
        }

        .terms-header .terms-date {
            font-size: 13px;
            color: #aaa;
        }

        /* ── 목차 (TOC) ── */
        .terms-toc {
            background: #fff9f9;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 22px 28px;
            margin-bottom: 48px;
        }

        .terms-toc p {
            font-size: 13px;
            font-weight: 700;
            color: #f4a096;
            margin: 0 0 10px;
            letter-spacing: 0.04em;
        }

        .terms-toc ol {
            margin: 0;
            padding-left: 18px;
            columns: 2;
            column-gap: 32px;
        }

        .terms-toc ol li {
            font-size: 13px;
            color: #666;
            line-height: 2;
        }

        .terms-toc ol li a {
            color: #666;
            text-decoration: none;
            transition: color 0.15s;
        }

        .terms-toc ol li a:hover {
            color: #f4a096;
        }

        /* ── 개별 조항 ── */
        .terms-article {
            margin-bottom: 44px;
            scroll-margin-top: 80px;
        }

        .terms-article h3 {
            font-size: 15px;
            font-weight: 700;
            color: #2c2c2c;
            padding: 10px 16px;
            background: #fff4f3;
            border-left: 4px solid #f4a096;
            border-radius: 0 8px 8px 0;
            margin: 0 0 16px;
        }

        .terms-article p {
            font-size: 14px;
            color: #555;
            line-height: 1.95;
            margin: 0 0 10px;
            padding-left: 4px;
        }

        .terms-article ol {
            padding-left: 20px;
            margin: 8px 0 0;
        }

        .terms-article ol > li {
            font-size: 14px;
            color: #555;
            line-height: 1.9;
            margin-bottom: 8px;
        }

        /* 서브 리스트 (들여쓰기 항목) */
        .terms-article .sub-list {
            list-style: none;
            padding-left: 14px;
            margin: 8px 0 4px;
        }

        .terms-article .sub-list li {
            font-size: 13px;
            color: #888;
            line-height: 1.85;
            position: relative;
            padding-left: 14px;
        }

        .terms-article .sub-list li::before {
            content: "–";
            position: absolute;
            left: 0;
            color: #ccc;
        }

        /* ── 맺음말 박스 ── */
        .terms-footer-box {
            background: linear-gradient(135deg, #fff9f9, #fff0ef);
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            padding: 28px 32px;
            text-align: center;
            margin-top: 56px;
        }

        .terms-footer-box p {
            font-size: 13px;
            color: #888;
            line-height: 1.9;
            margin: 0;
        }

        .terms-footer-box a {
            color: #f4a096;
            text-decoration: none;
        }

        .terms-footer-box a:hover {
            text-decoration: underline;
        }

        /* ── 구분선 ── */
        .terms-divider {
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
        .terms-header        { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.25s; }
        .terms-toc           { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.4s; }
        .terms-article       { animation: fadeUp 0.6s ease forwards; opacity: 0; animation-delay: 0.55s; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <div id="app">

        <!-- 히어로 -->
        <div class="about-hero">
            <div class="about-hero-overlay">
                <h1>MarryView</h1>
                <p>서비스 이용약관</p>
            </div>
        </div>

        <div class="terms-body">

            <!-- 타이틀 -->
            <div class="terms-header">
                <h2>MarryView 이용약관</h2>
                <span class="terms-date">시행일: 2025년 01월 01일 &nbsp;|&nbsp; 최종 수정일: 2025년 01월 01일</span>
            </div>

            <!-- 목차 -->
            <nav class="terms-toc">
                <p>📋 목차</p>
                <ol>
                    <li><a href="#art1">제1조 목적</a></li>
                    <li><a href="#art2">제2조 용어 정의</a></li>
                    <li><a href="#art3">제3조 약관의 효력 및 변경</a></li>
                    <li><a href="#art4">제4조 회원가입 및 관리</a></li>
                    <li><a href="#art5">제5조 서비스 제공 및 변경</a></li>
                    <li><a href="#art6">제6조 리뷰 작성 규정</a></li>
                    <li><a href="#art7">제7조 예약 및 취소·환불</a></li>
                    <li><a href="#art8">제8조 쿠폰 및 기프트콘</a></li>
                    <li><a href="#art9">제9조 금지행위</a></li>
                    <li><a href="#art10">제10조 개인정보 보호</a></li>
                    <li><a href="#art11">제11조 회사의 면책</a></li>
                    <li><a href="#art12">제12조 분쟁 해결 및 관할</a></li>
                </ol>
            </nav>

            <!-- 제1조 -->
            <div class="terms-article" id="art1">
                <h3>제1조 (목적)</h3>
                <p>이 약관은 MarryView(이하 "회사")가 운영하는 웨딩 리뷰 플랫폼 MarryView(이하 "서비스")의 이용 조건 및 절차, 회사와 이용자 간의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.</p>
            </div>

            <hr class="terms-divider">

            <!-- 제2조 -->
            <div class="terms-article" id="art2">
                <h3>제2조 (용어 정의)</h3>
                <p>이 약관에서 사용하는 용어의 정의는 다음과 같습니다.</p>
                <ol>
                    <li><strong>"서비스"</strong>란 회사가 제공하는 웨딩 업체 정보 조회, 리뷰 작성, 예약, 쿠폰·기프트콘 발급 등 일체의 온라인 서비스를 말합니다.</li>
                    <li><strong>"회원"</strong>이란 회사와 이용 계약을 체결하고 아이디를 부여받아 서비스를 이용하는 자를 말합니다.</li>
                    <li><strong>"업체"</strong>란 서비스를 통해 웨딩 관련 정보를 등록하고 예약을 받는 사업자를 말합니다.</li>
                    <li><strong>"리뷰"</strong>란 회원이 실제 이용한 업체에 대해 작성하는 평가 및 후기 콘텐츠를 말합니다.</li>
                    <li><strong>"쿠폰"</strong>이란 서비스 내 특정 조건 충족 시 회사가 발급하는 할인 혜택 수단을 말합니다.</li>
                    <li><strong>"기프트콘"</strong>이란 우수 리뷰 선정 또는 좋아요 기준 충족 시 발급되는 교환 가능한 이미지·코드·바코드 형태의 전자 상품권을 말합니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제3조 -->
            <div class="terms-article" id="art3">
                <h3>제3조 (약관의 효력 및 변경)</h3>
                <ol>
                    <li>이 약관은 서비스 내 공지하거나 회원에게 개별 통지함으로써 효력이 발생합니다.</li>
                    <li>회사는 관련 법령을 위배하지 않는 범위에서 약관을 변경할 수 있으며, 변경 시 적용 일자 및 변경 사유를 명시하여 서비스 내 공지합니다.</li>
                    <li>회원은 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다. 변경 약관 공지 후에도 서비스를 계속 이용하면 변경된 약관에 동의한 것으로 간주합니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제4조 -->
            <div class="terms-article" id="art4">
                <h3>제4조 (회원가입 및 관리)</h3>
                <ol>
                    <li>회원가입은 이용자가 약관에 동의한 후 회사가 정한 절차에 따라 신청하고, 회사가 승낙함으로써 완료됩니다.</li>
                    <li>만 14세 미만의 아동은 회원가입을 할 수 없습니다.</li>
                    <li>회원은 가입 시 제공한 정보(이름, 이메일, 결혼 예정일/기념일 등)가 정확해야 하며, 변경 시 즉시 수정하여야 합니다.</li>
                    <li>하나의 이메일 계정으로 하나의 회원 계정만 생성할 수 있습니다.</li>
                    <li>회원은 아이디와 비밀번호를 본인이 직접 관리하여야 하며, 제3자에게 양도하거나 공유할 수 없습니다.</li>
                    <li>
                        다음의 경우 회사는 가입 신청을 거부하거나 기존 계정을 해지할 수 있습니다.
                        <ul class="sub-list">
                            <li>타인 명의 또는 허위 정보로 가입한 경우</li>
                            <li>이 약관을 위반한 전력이 있는 경우</li>
                            <li>기술적 장애 또는 서비스 정책상 승낙이 어려운 경우</li>
                        </ul>
                    </li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제5조 -->
            <div class="terms-article" id="art5">
                <h3>제5조 (서비스 제공 및 변경)</h3>
                <ol>
                    <li>회사는 웨딩 업체 정보 제공, 리뷰 작성 및 조회, 예약 중개, 쿠폰·기프트콘 발급 등의 서비스를 제공합니다.</li>
                    <li>서비스는 연중무휴 24시간 제공을 원칙으로 하나, 시스템 점검·장애·천재지변 등의 사유로 일시 중단될 수 있습니다.</li>
                    <li>회사는 서비스 내용을 변경하거나 종료할 수 있으며, 이 경우 사전에 공지합니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제6조 -->
            <div class="terms-article" id="art6">
                <h3>제6조 (리뷰 작성 규정)</h3>
                <ol>
                    <li>리뷰는 해당 업체를 실제로 예약·이용한 회원만 작성할 수 있습니다.</li>
                    <li>
                        리뷰 작성 시 다음 행위를 금지합니다.
                        <ul class="sub-list">
                            <li>허위 사실 또는 과장된 내용 게재</li>
                            <li>업체로부터 대가를 받고 작성한 광고성 리뷰</li>
                            <li>욕설, 비방, 혐오 표현 포함</li>
                            <li>타인의 개인정보 포함</li>
                            <li>저작권을 침해하는 이미지·텍스트 사용</li>
                        </ul>
                    </li>
                    <li>유료 리뷰 작성 시 드레스 상태, 직원의 전문성, 당일 대기 시간, 추가금 강요 여부 등 항목별 세부 평가를 포함하여야 합니다.</li>
                    <li>회사는 위반 리뷰를 사전 통보 없이 삭제할 수 있으며, 반복 위반 시 계정을 제한할 수 있습니다.</li>
                    <li>게시된 리뷰의 저작권은 작성 회원에게 있으나, 회사는 서비스 운영·홍보 목적으로 이를 사용할 수 있습니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제7조 -->
            <div class="terms-article" id="art7">
                <h3>제7조 (예약 및 취소·환불)</h3>
                <ol>
                    <li>예약은 회원이 서비스 내에서 신청하고 업체가 확정함으로써 성립합니다.</li>
                    <li>취소 및 환불은 업체별 정책을 우선 적용하며, 서비스 내 예약 상세 페이지에서 확인할 수 있습니다.</li>
                    <li>회사는 예약 중개자로서 업체와 회원 간 분쟁에 직접적인 책임을 지지 않으나, 원활한 해결을 위해 협조합니다.</li>
                    <li>천재지변·업체 폐업 등 불가피한 사유로 예약이 취소되는 경우, 회사는 이를 신속히 안내합니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제8조 -->
            <div class="terms-article" id="art8">
                <h3>제8조 (쿠폰 및 기프트콘)</h3>
                <ol>
                    <li>쿠폰 및 기프트콘은 서비스 내 이벤트·조건 달성 시 발급되며, 발급 기준은 서비스 내 공지를 따릅니다.</li>
                    <li>기프트콘은 리뷰 좋아요 수 기준 충족 또는 베스트 리뷰 선정 시 자동 발급되며, 이미지·코드·바코드 형태로 제공됩니다.</li>
                    <li>쿠폰 및 기프트콘은 타인에게 양도하거나 현금으로 환급받을 수 없습니다.</li>
                    <li>유효기간이 경과한 쿠폰 및 기프트콘은 자동 소멸되며, 복구되지 않습니다.</li>
                    <li>부정한 방법으로 쿠폰·기프트콘을 취득한 경우 회사는 이를 회수하고 계정을 제한할 수 있습니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제9조 -->
            <div class="terms-article" id="art9">
                <h3>제9조 (금지행위)</h3>
                <p>회원은 다음 각 호의 행위를 하여서는 안 됩니다.</p>
                <ol>
                    <li>타인의 계정을 도용하거나 허위 정보로 가입하는 행위</li>
                    <li>서비스의 정상적인 운영을 방해하는 크롤링, 자동화 스크립트 사용</li>
                    <li>음란물, 폭력적 콘텐츠, 혐오 표현 게시</li>
                    <li>허위 리뷰 작성, 조직적 리뷰 조작</li>
                    <li>개인정보 무단 수집 또는 유포</li>
                    <li>업체 또는 타 회원에 대한 허위 사실 유포 및 명예훼손</li>
                    <li>회사의 사전 승낙 없이 서비스를 상업적 목적으로 이용하는 행위</li>
                    <li>관련 법령 및 공공질서에 반하는 일체의 행위</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제10조 -->
            <div class="terms-article" id="art10">
                <h3>제10조 (개인정보 보호)</h3>
                <ol>
                    <li>회사는 「개인정보 보호법」 등 관련 법령에 따라 회원의 개인정보를 보호합니다.</li>
                    <li>개인정보의 수집·이용·제공 등에 관한 상세 사항은 별도의 <a href="/privacy" style="color:#f4a096;">개인정보처리방침</a>을 통해 안내합니다.</li>
                    <li>회사는 회원의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 단, 법령에 따른 요청이 있는 경우는 예외로 합니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제11조 -->
            <div class="terms-article" id="art11">
                <h3>제11조 (회사의 면책)</h3>
                <ol>
                    <li>회사는 천재지변·전쟁·시스템 장애 등 불가항력으로 인한 서비스 중단에 대해 책임을 지지 않습니다.</li>
                    <li>회사는 업체가 제공한 정보의 정확성을 보증하지 않으며, 업체와 회원 간 분쟁에 대한 직접적 책임을 부담하지 않습니다.</li>
                    <li>회원이 게시한 리뷰·콘텐츠로 인해 발생한 분쟁의 책임은 해당 회원에게 있습니다.</li>
                    <li>회사는 무료로 제공되는 서비스 이용 중 발생한 손해에 대해 책임을 지지 않습니다.</li>
                </ol>
            </div>

            <hr class="terms-divider">

            <!-- 제12조 -->
            <div class="terms-article" id="art12">
                <h3>제12조 (분쟁 해결 및 관할)</h3>
                <ol>
                    <li>이 약관은 대한민국 법령에 따라 해석됩니다.</li>
                    <li>서비스 이용과 관련하여 분쟁이 발생한 경우, 회사와 회원은 상호 협의를 통해 해결하는 것을 원칙으로 합니다.</li>
                    <li>협의가 이루어지지 않을 경우, 민사소송법에 따른 관할 법원을 제1심 법원으로 합니다.</li>
                </ol>
            </div>

            <!-- 맺음말 -->
            <div class="terms-footer-box">
                <p>
                    본 약관은 <strong>2025년 01월 01일</strong>부터 시행됩니다.<br>
                    이용약관에 관한 문의: <a href="mailto:help@marryview.com">help@marryview.com</a>
                </p>
            </div>

        </div><!-- /terms-body -->

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div><!-- /#app -->

    <script>
        const app = Vue.createApp({});
        app.mount('#app');
    </script>
</body>
</html>
