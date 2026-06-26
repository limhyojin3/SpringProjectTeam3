<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>메리뷰 정책</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <style>
        .policy-hero {
            width: 100%;
            height: 280px;
            position: relative;
            display: flex;
            align-items: flex-end;
            background:
                linear-gradient(to top, rgba(58, 32, 40, 0.65), rgba(58, 32, 40, 0.05)),
                url('${pageContext.request.contextPath}/img/home_about5.jpg') center/cover;
        }

        .policy-hero-content {
            width: 100%;
            padding: 42px 60px;
            color: #fff;
        }

        .policy-hero-content h1 {
            margin: 0;
            font-family: Georgia, serif;
            font-size: 46px;
            font-style: italic;
            font-weight: 700;
        }

        .policy-hero-content p {
            margin: 8px 0 0;
            color: rgba(255, 255, 255, 0.88);
            font-size: 15px;
        }

        .policy-body {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            padding: 56px 24px 100px;
        }

        .policy-header {
            margin-bottom: 36px;
            padding-bottom: 18px;
            border-bottom: 2px solid #f4a096;
        }

        .policy-header h2 {
            margin: 0 0 8px;
            color: #2c2c2c;
            font-size: 25px;
            font-weight: 700;
        }

        .policy-date {
            color: #999;
            font-size: 13px;
        }

        .policy-notice {
            margin-bottom: 36px;
            padding: 20px 22px;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            background: #fff9f9;
            color: #66585c;
            font-size: 14px;
            line-height: 1.8;
        }

        .policy-toc {
            margin-bottom: 48px;
            padding: 22px 28px;
            border: 1px solid #eee2e4;
            border-radius: 12px;
            background: #fff;
        }

        .policy-toc strong {
            display: block;
            margin-bottom: 10px;
            color: #f08086;
            font-size: 13px;
        }

        .policy-toc ol {
            margin: 0;
            padding-left: 20px;
            columns: 2;
            column-gap: 36px;
        }

        .policy-toc li {
            color: #666;
            font-size: 13px;
            line-height: 2;
        }

        .policy-toc a {
            color: inherit;
            text-decoration: none;
        }

        .policy-toc a:hover {
            color: #f08086;
        }

        .policy-article {
            margin-bottom: 38px;
            scroll-margin-top: 90px;
        }

        .policy-article h3 {
            margin: 0 0 16px;
            padding: 11px 16px;
            border-left: 4px solid #f4a096;
            border-radius: 0 8px 8px 0;
            background: #fff4f3;
            color: #2c2c2c;
            font-size: 16px;
            font-weight: 700;
        }

        .policy-article p,
        .policy-article li {
            color: #555;
            font-size: 14px;
            line-height: 1.9;
        }

        .policy-article p {
            margin: 0 4px 10px;
        }

        .policy-article ol,
        .policy-article ul {
            margin: 8px 0 0;
            padding-left: 24px;
        }

        .policy-article li {
            margin-bottom: 7px;
        }

        .policy-point {
            margin-top: 14px;
            padding: 16px 18px;
            border-radius: 10px;
            background: #f8f9fa;
            color: #666;
            font-size: 13px;
            line-height: 1.8;
        }

        .policy-divider {
            margin: 38px 0;
            border: 0;
            border-top: 1px solid #f1e6e8;
        }

        .policy-footer-box {
            margin-top: 52px;
            padding: 26px 30px;
            border: 1px solid #ffd1d1;
            border-radius: 12px;
            background: linear-gradient(135deg, #fff9f9, #fff0ef);
            color: #777;
            font-size: 13px;
            line-height: 1.9;
            text-align: center;
        }

        .policy-footer-box a {
            color: #e97982;
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .policy-hero {
                height: 220px;
            }

            .policy-hero-content {
                padding: 30px 24px;
            }

            .policy-hero-content h1 {
                font-size: 34px;
            }

            .policy-toc ol {
                columns: 1;
            }
        }
		
		@keyframes fadeUp {
		    from {
		        opacity: 0;
		        transform: translateY(20px);
		    }
		    to {
		        opacity: 1;
		        transform: translateY(0);
		    }
		}

		.policy-hero-content {
		    opacity: 0;
		    animation: fadeUp 0.6s ease forwards;
		    animation-delay: 0.1s;
		}

		.policy-header {
		    opacity: 0;
		    animation: fadeUp 0.6s ease forwards;
		    animation-delay: 0.25s;
		}

		.policy-notice {
		    opacity: 0;
		    animation: fadeUp 0.6s ease forwards;
		    animation-delay: 0.35s;
		}

		.policy-toc {
		    opacity: 0;
		    animation: fadeUp 0.6s ease forwards;
		    animation-delay: 0.45s;
		}

		.policy-article {
		    opacity: 0;
		    animation: fadeUp 0.6s ease forwards;
		    animation-delay: 0.55s;
		}
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <main>
        <section class="policy-hero">
            <div class="policy-hero-content">
                <h1>MarryView Policy</h1>
                <p>신뢰할 수 있는 리뷰 환경을 위한 메리뷰 운영 기준입니다.</p>
            </div>
        </section>

        <div class="policy-body">
            <div class="policy-header">
                <h2>메리뷰 정책</h2>
                <span class="policy-date">
                    시행일: 2026년 6월 24일 &nbsp;|&nbsp;
					최종 수정일: 2026년 06월 25일
                </span>
            </div>

            <div class="policy-notice">
                본 정책은 메리뷰의 리뷰와 게시물 운영 기준을 안내하기 위한 것입니다.
                메리뷰는 제출된 증빙과 서비스 내 정보를 참고하여 콘텐츠를 검토하지만,
                특히 외부 업체에서 이루어진 거래의 진위나 서비스 품질을 보증하지 않습니다.
            </div>

            <nav class="policy-toc" aria-label="운영정책 목차">
                <strong>목차</strong>
                <ol>
                    <li><a href="#policy1">목적 및 적용 범위</a></li>
                    <li><a href="#policy2">리뷰 작성 기준</a></li>
                    <li><a href="#policy3">영수증·결제 증빙</a></li>
                    <li><a href="#policy4">리뷰 확인 수준</a></li>
                    <li><a href="#policy5">확인 표기의 의미</a></li>
                    <li><a href="#policy6">금지 콘텐츠</a></li>
                    <li><a href="#policy7">승인·반려·노출 제한</a></li>
                    <li><a href="#policy8">신고 접수 및 처리</a></li>
					<li><a href="#policy9">일반회원 이용 제한</a></li>
					<li><a href="#policy10">업체회원 및 상품 제재</a></li>
                    <li><a href="#policy9">자동화·OCR 검토</a></li>
                    <li><a href="#policy10">영수증 개인정보</a></li>
                    <li><a href="#policy11">이의제기 및 문의</a></li>
                    <li><a href="#policy12">정책 변경</a></li>
                </ol>
            </nav>

            <section class="policy-article" id="policy1">
                <h3>1. 서비스 목적 및 적용 범위</h3>
                <p>
                    메리뷰는 웨딩 관련 업체와 상품을 탐색하고, 이용 경험을 공유할 수 있도록
                    업체 정보, 예약 및 리뷰 기능을 제공하는 서비스입니다.
                </p>
                <p>
                    본 정책은 메리뷰에 등록되는 리뷰, 사진, 영수증·결제 증빙,
                    커뮤니티 게시물, 댓글 및 신고 콘텐츠에 적용됩니다.
                </p>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy2">
                <h3>2. 리뷰 작성 기준</h3>
                <ol>
                    <li>리뷰는 작성자가 직접 경험한 예약, 상담, 구매 또는 이용 내용을 바탕으로 작성해야 합니다.</li>
                    <li>사실과 개인적인 평가를 가능한 한 구분하여 작성해야 합니다.</li>
                    <li>업체나 상품을 오인하게 할 수 있는 과장, 조작 또는 중요한 사실의 누락을 피해야 합니다.</li>
                    <li>동일한 이용 경험을 반복하여 등록하거나 다른 사람의 리뷰를 복사해서는 안 됩니다.</li>
                    <li>업체로부터 대가나 혜택을 제공받은 경우 해당 사실을 숨기거나 일반 이용 후기처럼 작성해서는 안 됩니다.</li>
                </ol>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy3">
                <h3>3. 영수증·결제 증빙 제출과 검토 범위</h3>
                <p>
                    리뷰 작성 과정에서 영수증, 결제 내역 또는 이에 준하는 자료를
                    이용 경험의 참고 자료로 제출할 수 있습니다.
                </p>
                <ol>
                    <li>제출 자료는 리뷰에 기재된 업체, 상품, 이용 시기 및 금액과 명백한 모순이 있는지 확인하는 데 활용될 수 있습니다.</li>
                    <li>업체명이 다른 경우에도 법인명, 가맹점명 또는 결제대행사명이 표시될 수 있으므로 업체명 차이만으로 허위라고 판단하지 않습니다.</li>
                    <li>증빙이 흐리거나 일부 정보가 가려져 확인하기 어려운 경우에는 “확인할 수 없음”으로 판단할 수 있습니다.</li>
                    <li>확인할 수 없다는 사정만으로 해당 리뷰나 증빙이 허위라고 단정하지 않습니다.</li>
                    <li>메리뷰의 검토는 제출 자료의 위조 여부나 외부 거래의 진위를 보증하는 절차가 아닙니다.</li>
                </ol>

                <div class="policy-point">
                    메리뷰는 증빙과 리뷰 사이의 명백한 모순을 중심으로 검토하며,
                    문서 자체의 법적 효력이나 진위를 감정하지 않습니다.
                </div>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy4">
                <h3>4. 등록 업체와 외부 업체 리뷰의 확인 수준</h3>
                <ol>
                    <li>
                        <strong>메리뷰 예약 연동 리뷰</strong>는 서비스에 저장된 예약·결제 정보와
                        제출 내용을 비교하여 확인할 수 있습니다.
                    </li>
                    <li>
                        <strong>메리뷰 등록 업체 리뷰</strong>는 등록된 업체·상품 정보와
                        제출된 증빙을 참고하여 검토할 수 있습니다.
                    </li>
                    <li>
                        <strong>외부 업체 리뷰</strong>는 메리뷰가 외부 업체의 예약·결제 시스템에
                        접근할 수 없으므로 이용자가 제출한 정보와 증빙 범위 안에서만 검토합니다.
                    </li>
                </ol>
                <p>
                    외부 업체 리뷰가 승인되거나 노출되더라도 메리뷰가 해당 거래의 성립,
                    증빙의 진위 또는 업체의 서비스 품질을 확인하거나 보증했다는 의미는 아닙니다.
                </p>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy5">
                <h3>5. ‘구매 확인’과 ‘증빙 제출’ 표기의 의미</h3>
                <ol>
                    <li>
                        <strong>구매 확인</strong>은 메리뷰 내부의 예약 또는 결제 정보와
                        리뷰 작성자의 이용 정보가 연결된 경우 표시할 수 있습니다.
                    </li>
                    <li>
                        <strong>증빙 제출</strong>은 작성자가 영수증 또는 결제 관련 자료를
                        제출했다는 의미입니다.
                    </li>
                    <li>
                        두 표기는 리뷰 내용 전체가 사실임을 보증하거나,
                        제출 자료의 위조 가능성이 없음을 인증하는 표시가 아닙니다.
                    </li>
                    <li>
                        증빙 제출 표시는 구매 확인보다 제한된 수준의 참고 정보로 제공됩니다.
                    </li>
                </ol>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy6">
                <h3>6. 금지되는 리뷰와 게시물</h3>
                <p>다음에 해당하는 콘텐츠는 등록이 거절되거나 노출이 제한될 수 있습니다.</p>
                <ul>
                    <li>실제 경험하지 않은 내용을 경험한 것처럼 작성한 콘텐츠</li>
                    <li>증빙이나 사진을 위조·변조하거나 타인의 자료를 도용한 콘텐츠</li>
                    <li>욕설, 모욕, 혐오 표현, 협박 또는 과도한 비방을 포함한 콘텐츠</li>
                    <li>전화번호, 주소, 계좌번호 등 타인의 개인정보를 포함한 콘텐츠</li>
                    <li>저작권, 초상권, 상표권 등 제3자의 권리를 침해하는 콘텐츠</li>
                    <li>광고, 홍보, 도배 또는 서비스 목적과 무관한 콘텐츠</li>
                    <li>불법행위를 조장하거나 관련 법령 및 서비스 약관을 위반하는 콘텐츠</li>
                </ul>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy7">
                <h3>7. 리뷰 승인·반려·노출 제한 기준</h3>
                <ol>
                    <li>운영 기준을 충족한 리뷰는 관리자 검토 후 승인될 수 있습니다.</li>
                    <li>필수 정보나 증빙이 누락되었거나 리뷰와 증빙 사이에 명백한 모순이 있는 경우 반려될 수 있습니다.</li>
                    <li>개인정보 또는 권리 침해 우려가 있는 경우 일부 내용이 가려지거나 노출이 제한될 수 있습니다.</li>
                    <li>신고가 접수되었거나 추가 확인이 필요한 경우 검토가 끝날 때까지 임시로 노출을 제한할 수 있습니다.</li>
                    <li>확인이 어렵다는 이유만으로 허위 리뷰라고 단정하지 않으며, 확인 가능한 자료와 전체 정황을 함께 검토합니다.</li>
                </ol>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy8">
                <h3>8. 신고 접수 및 처리 절차</h3>
                <ol>
                    <li>회원은 권리 침해, 허위 정보 의심, 개인정보 노출 등 운영정책 위반이 의심되는 콘텐츠를 신고할 수 있습니다.</li>
                    <li>관리자는 신고 사유, 대상 콘텐츠, 제출 자료 및 서비스 기록을 확인합니다.</li>
                    <li>검토 결과에 따라 신고를 승인하거나 반려하고, 필요한 경우 콘텐츠 삭제 또는 노출 제한 등의 조치를 할 수 있습니다.</li>
                    <li>처리 결과와 답변은 서비스 알림 또는 고객센터를 통해 안내될 수 있습니다.</li>
                    <li>신고가 접수되었다는 사실만으로 대상 콘텐츠가 허위이거나 정책을 위반했다고 판단하지 않습니다.</li>
                </ol>
            </section>

            <hr class="policy-divider">
	
			<section class="policy-article" id="policy9">
			    <h3>9. 일반회원 이용 제한 기준</h3>

			    <p>
			        신고가 접수되었다는 사실만으로 회원에게 제재가 적용되지는 않습니다.
			        관리자가 신고 내용과 관련 자료를 검토하여 운영정책 위반으로 승인한 경우에만
			        제재 횟수에 반영합니다.
			    </p>

			    <ol>
			        <li>누적 3회: 3일간 서비스 이용 제한</li>
			        <li>누적 5회: 7일간 서비스 이용 제한</li>
			        <li>누적 7회: 30일간 서비스 이용 제한</li>
			        <li>누적 10회: 계정 영구 이용 제한</li>
			    </ol>

			    <p>
			        개인정보 침해, 증빙 위조, 반복적인 리뷰 조작 등 위반 정도가 중대한 경우에는
			        누적 횟수와 관계없이 콘텐츠 노출 제한 또는 계정 이용 제한이 적용될 수 있습니다.
			    </p>
			</section>

			<hr class="policy-divider">

			<section class="policy-article" id="policy10">
			    <h3>10. 업체회원 및 상품 제재 기준</h3>

			    <p>
			        업체회원이 허위 상품 정보를 등록하거나 리뷰 조작, 이용자 권리 침해 등
			        운영정책을 위반한 경우 위반 정도와 반복 여부를 검토하여 조치할 수 있습니다.
			    </p>

			    <ol>
			        <li>위반 상품의 판매 및 노출을 중단할 수 있습니다.</li>
			        <li>확인이 필요한 경우 해당 상품 또는 업체 페이지를 임시로 비공개 처리할 수 있습니다.</li>
			        <li>같은 위반이 반복되거나 위반 정도가 중대한 경우 업체회원의 서비스 이용을 영구 제한할 수 있습니다.</li>
			        <li>상품 노출 중단이나 계정 제한이 적용된 경우 처리 사유를 해당 업체회원에게 안내할 수 있습니다.</li>
			    </ol>

			    <p>
			        단순 신고 접수나 확인되지 않은 주장만으로 상품을 영구 삭제하거나
			        업체회원의 이용을 영구 제한하지 않습니다.
			    </p>
			</section>
			
			<hr class="policy-divider">
			
            <section class="policy-article" id="policy9">
                <h3>11. 자동화 및 OCR 검토</h3>
                <p>
                    메리뷰는 향후 OCR 또는 자동화 기능을 사용하여 영수증의 날짜, 금액 등
                    일부 정보를 추출하고 관리자에게 참고 정보로 제공할 수 있습니다.
                </p>
                <p>
                    자동 추출 결과는 이미지 품질이나 문서 형식에 따라 부정확할 수 있으며,
                    자동화 결과만으로 리뷰를 승인·반려하거나 증빙의 진위를 판단하지 않습니다.
                    최종 운영 판단은 관리자가 확인 가능한 자료와 전체 정황을 검토하여 수행합니다.
                </p>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy10">
                <h3>12. 개인정보가 포함된 영수증의 취급</h3>
                <ol>
                    <li>이용자는 영수증 제출 전 카드번호, 승인번호, 주소 등 불필요한 개인정보를 가리는 것을 권장합니다.</li>
                    <li>제출된 영수증은 원칙적으로 일반 이용자에게 공개하지 않으며, 권한이 있는 관리자 검토 화면에서만 확인합니다.</li>
                    <li>영수증이 리뷰 사진이나 본문에 잘못 노출된 경우 개인정보 보호를 위해 노출을 제한하거나 삭제할 수 있습니다.</li>
                    <li>영수증 및 개인정보의 구체적인 처리 기준은 개인정보처리방침을 따릅니다.</li>
                </ol>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy11">
                <h3>13. 이의제기 및 문의</h3>
                <p>
                    리뷰 반려, 노출 제한 또는 신고 처리 결과에 이의가 있는 이용자는
                    마이페이지의 고객센터 기능을 통해 문의할 수 있습니다.
                </p>
                <p>
                    이의제기 시 대상 리뷰 또는 게시물, 문의 사유 및 확인에 필요한 자료를
                    함께 제출하면 검토에 도움이 됩니다.
                </p>
            </section>

            <hr class="policy-divider">

            <section class="policy-article" id="policy12">
                <h3>14. 정책 변경 고지</h3>
                <p>
                    메리뷰는 서비스 기능이나 운영 기준의 변경에 따라 본 정책을 변경할 수 있습니다.
                    중요한 변경이 있는 경우 적용일과 주요 변경 내용을 서비스 공지사항 등을 통해 안내합니다.
                </p>
            </section>

            <div class="policy-footer-box">
                본 운영정책은 <strong>2026년 6월 24일</strong>부터 시행됩니다.<br>
                문의: <a href="mailto:help@marryview.com">help@marryview.com</a>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>