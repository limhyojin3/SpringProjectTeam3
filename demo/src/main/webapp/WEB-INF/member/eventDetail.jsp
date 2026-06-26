<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이벤트 상세 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        body {
           background: linear-gradient(180deg, #eaf6fb 0%, #ffffff 400px, #ffffff 100%)!important;
        }
        .event-detail-wrap {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 24px 100px;
        }
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #888;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 30px;
            text-decoration: none;
        }
        .back-btn:hover { color: #5bbdd0; }

        .event-img {
            width: 100%;
            height: 380px;
            object-fit: cover;
            border-radius: 20px;
            margin-bottom: 32px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
        }
        .event-tag {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            background: #eaf6fb;
            color: #5bbdd0;
            margin-bottom: 12px;
        }
        .event-title {
            font-size: 28px;
            font-weight: 800;
            color: #2c2c2c;
            margin-bottom: 16px;
        }
        .event-desc {
            font-size: 15px;
            color: #666;
            line-height: 1.8;
            margin-bottom: 32px;
            padding: 24px;
            background: #f4fafc;
            border-radius: 12px;
            border-left: 4px solid #7ec8d8;
        }
        .event-info-box {
            background: white;
            border: 1px solid #d6eef5;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 32px;
            box-shadow: 0 4px 16px rgba(94,189,208,0.08);
        }
        .event-info-box h4 {
            font-size: 15px;
            font-weight: 700;
            color: #333;
            margin-bottom: 16px;
        }
        .event-info-row {
            display: flex;
            gap: 12px;
            margin-bottom: 10px;
            font-size: 14px;
            color: #555;
        }
        .event-info-label {
            font-weight: 700;
            color: #5bbdd0;
            min-width: 80px;
        }
        .apply-btn {
            display: block;
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #7ec8d8, #5bbdd0);
            color: white;
            border: none;
            border-radius: 999px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            text-align: center;
            transition: background 0.2s;
        }
        .apply-btn:hover { background: linear-gradient(135deg, #5bbdd0, #4aafc2); }

        /* 준비중 모달 */
        .prep-modal-bg {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 999;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .prep-modal {
            background: white;
            border-radius: 20px;
            padding: 48px 40px;
            text-align: center;
            width: 340px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        }
        .prep-modal .prep-icon { font-size: 52px; margin-bottom: 16px; }
        .prep-modal h3 { font-size: 20px; font-weight: 700; color: #2c2c2c; margin-bottom: 8px; }
        .prep-modal p { font-size: 13px; color: #aaa; line-height: 1.7; margin-bottom: 24px; }
        .prep-modal-btn {
            padding: 10px 32px;
            background: linear-gradient(135deg, #7ec8d8, #5bbdd0);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
        }

        .summer-deco-wrap {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }

        .summer-deco {
            position: absolute;
            color: #a8dde9;
            opacity: 0.3;
        }

        .event-detail-wrap {
            position: relative;
            z-index: 1;
        }

        .reward-highlight {
            display: flex;
            justify-content: center;
            background: linear-gradient(135deg, #eaf6fb, #d6eef5);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 24px;
        }

        .reward-highlight-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }

        .reward-emoji {
            font-size: 80px;
            line-height: 1.2;
        }

        .reward-amount {
            font-size: 26px;
            font-weight: 900;
            color: #2c2c2c;
            background: #e0f4ff;
            padding: 4px 20px;
            border-radius: 8px;
        }

        .reward-label {
            font-size: 15px;
            font-weight: 800;
            color: #333;
            background: #e0f4ff;
            padding: 3px 16px;
            border-radius: 8px;
        }

        .reward-sub {
            font-size: 12px;
            color: #888;
        }

        .reward-img {
            width: 160px;
            height: 160px;
            object-fit: contain;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <!-- 여름 배경 데코 -->
        <div class="summer-deco-wrap">
            <i class="fas fa-fish summer-deco" style="top:8%; left:3%; font-size:120px; transform:rotate(20deg);"></i>
            <i class="fas fa-sun summer-deco" style="top:15%; right:5%; font-size:150px;"></i>
            <i class="fas fa-water summer-deco" style="top:40%; left:1%; font-size:100px;"></i>
            <i class="fas fa-umbrella-beach summer-deco" style="top:55%; right:2%; font-size:130px;"></i>
            <i class="fas fa-fish summer-deco" style="top:70%; left:5%; font-size:90px; transform:rotate(-15deg) scaleX(-1);"></i>
            <i class="fas fa-sun summer-deco" style="top:80%; right:6%; font-size:110px;"></i>
            <i class="fas fa-water summer-deco" style="top:90%; left:2%; font-size:80px;"></i>
        </div>
        <!-- 준비중 모달 -->
        <div class="prep-modal-bg" v-if="showPrep" @click.self="showPrep = false">
            <div class="prep-modal">
                <div class="prep-icon">🛠️</div>
                <h3>응모 준비 중입니다!</h3>
                <p>더 좋은 혜택으로 곧 찾아올게요.<br>조금만 기다려주세요 💙</p>
                <button class="prep-modal-btn" @click="showPrep = false">확인</button>
            </div>
        </div>

        <div class="event-detail-wrap">
            <a href="/event.do" class="back-btn">
                <i class="fas fa-arrow-left"></i> 이벤트 목록으로
            </a>

            <!-- 이벤트 1: 가족 사진 자랑 -->
            <div v-if="eventId === 1">
                <img src="/img/event/event_img1.jpg" class="event-img" alt="가족 사진 자랑">
                <span class="event-tag">FAMILY PHOTO</span>
                <h1 class="event-title">Team 가족 모여라! 가족 사진 자랑</h1>
                <div class="event-desc">
                    소중한 가족과 함께한 특별한 순간을 메리뷰에 올려주세요!<br>
                    가장 많은 사랑을 받은 가족 사진에 제주도 비행기 티켓을 드립니다. ✈️<br><br>
                    가족과의 행복한 추억을 나눠주시면, 메리뷰가 더 특별한 여행을 선물해드릴게요!
                </div>
                <div class="event-info-box">
                    <h4>이벤트 안내</h4>
                    <div class="event-info-row">
                        <span class="event-info-label">기간</span>
                        <span>2026. 07. 01 ~ 2026. 08. 31</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">대상</span>
                        <span>메리뷰 회원 누구나</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">혜택</span>
                        <span>제주도 비행기 티켓 (왕복 2매)</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">당첨</span>
                        <span>좋아요 수 상위 1팀</span>
                    </div>
                </div>
                <button class="apply-btn" @click="showPrep = true">
                    <i class="fas fa-paper-plane"></i> 지금 응모하기
                </button>
            </div>

            <!-- 이벤트 2: 여름 휴가비 지원 -->
            <div v-if="eventId === 2">
                <img src="/img/event/event_img5.jpg" class="event-img" alt="여름 휴가비 지원">
                <span class="event-tag">SUMMER VACATION</span>
                <h1 class="event-title">여름 휴가비 지원 이벤트</h1>
                <div class="event-desc">
                    여름 휴가 사진을 리뷰로 남겨주세요!<br>
                    베스트 리뷰로 선정되신 분께 휴가비 50만원을 지원해드립니다. 🌊<br><br>
                    신나는 여름 추억을 메리뷰와 함께 나눠주세요!
                </div>
                <!-- 이벤트 2 혜택 카드 - event-desc 아래, event-info-box 위에 추가 -->
                <div class="reward-highlight">
                    <div class="reward-highlight-item">
                        <img src="/img/event/dollar-icon.png" class="reward-img" alt="휴가비 지원">
                        <span class="reward-amount">50만원</span>
                        <span class="reward-label">추첨 1명</span>
                        <span class="reward-sub">베스트 리뷰 선정</span>
                    </div>
                </div>
                <div class="event-info-box">
                    <h4>이벤트 안내</h4>
                    <div class="event-info-row">
                        <span class="event-info-label">기간</span>
                        <span>2026. 07. 01 ~ 2026. 08. 31</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">대상</span>
                        <span>메리뷰 회원 누구나</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">혜택</span>
                        <span>휴가비 50만원 지원</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">당첨</span>
                        <span>베스트 리뷰 선정 1명</span>
                    </div>
                </div>
                <button class="apply-btn" @click="showPrep = true">
                    <i class="fas fa-paper-plane"></i> 지금 응모하기
                </button>
            </div>

            <!-- 이벤트 3: 신혼부부 응모 -->
            <div v-if="eventId === 3">
                <img src="/img/event/event_img6.jpg" class="event-img" alt="신혼부부 응모">
                <span class="event-tag">NEWLYWEDS</span>
                <h1 class="event-title">신혼부부 응모! 신혼가전 지원!</h1>
                <div class="event-desc">
                    신혼부부 인증 후 응모하시면 LG 냉장고를 드립니다! 🎉<br>
                    새로운 시작을 함께하는 신혼부부님들을 메리뷰가 응원합니다.<br><br>
                    행복한 신혼 생활의 시작을 메리뷰와 함께해주세요!
                </div>
                <div class="event-info-box">
                    <h4>이벤트 안내</h4>
                    <div class="event-info-row">
                        <span class="event-info-label">기간</span>
                        <span>2026. 07. 01 ~ 2026. 08. 31</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">대상</span>
                        <span>2026년 결혼 예정 또는 신혼부부</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">혜택</span>
                        <span>LG 냉장고 (디오스 870L)</span>
                    </div>
                    <div class="event-info-row">
                        <span class="event-info-label">당첨</span>
                        <span>추첨 1팀</span>
                    </div>
                </div>
                <button class="apply-btn" @click="showPrep = true">
                    <i class="fas fa-paper-plane"></i> 지금 응모하기
                </button>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
    <input type="hidden" id="eventIdVal" value="${eventId}">
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    eventId: parseInt(document.getElementById('eventIdVal').value),
                    showPrep: false
                };
            },
        }).mount('#app');
    </script>
</body>
</html>