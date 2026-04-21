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
        /* 탭 버튼 */
        .review-tab-wrap {
            display: flex;
            gap: 0;
            margin-bottom: 20px;
        }
        .review-tab {
            flex: 1;
            padding: 12px 0;
            border: 2px solid #f4a096;
            background-color: white;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            transition: 0.2s;
        }
        .review-tab:first-child {
            border-radius: 8px 0 0 8px;
        }
        .review-tab:last-child {
            border-radius: 0 8px 8px 0;
        }
        .review-tab.active-tab {
            background-color: #f4a096;
            color: white;
        }
        /* 카드형 리뷰 목록 */
        .review-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }
        .review-card {
            border: 1px solid #ffc7c2;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: 0.2s;
        }
        .review-card:hover {
            box-shadow: 0 4px 10px rgba(244, 160, 150, 0.4);
            transform: translateY(-2px);
        }
        .review-thumbnail {
            width: 100%;
            aspect-ratio: 4/3;
            background-color: #ffc7c2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            color: #999;
        }
        .review-card-title {
            padding: 10px;
            font-size: 13px;
            font-weight: bold;
            text-align: center;
            background-color: #ff69b4;
            color: white;
        }
        /* 리스트형 리뷰 목록 */
        .review-list-item {
            padding: 12px 15px;
            background-color: #ff69b4;
            color: white;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 8px;
            transition: 0.2s;
        }
        .review-list-item:hover {
            background-color: #f4a096;
        }
        /* 인덱스 버튼 */
        .review-index-wrap {
            text-align: center;
            margin-top: 20px;
        }
        .btn-review-index {
            padding: 10px 30px;
            background-color: #9b8fd4;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.2s;
        }
        .btn-review-index:hover {
            background-color: #7b6db4;
        }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div class="mypage-container">
            <!-- 사이드바 -->
            <div class="nav">
                <button class="nav-btn" @click="fnMypage()">마이페이지</button>
                <button class="nav-btn" @click="fnuserMyPagePay()">결제 멤버십 내역</button>
                <button class="nav-btn" @click="fnuserMyPageReview()">리뷰 조회 내역</button>
                <button class="nav-btn" @click="fnuserMyPageWrite()">내가 쓴 리뷰/댓글</button>
                <button class="nav-btn" @click="fnuserMyPageLike()">좋아요 목록</button>
                <button class="nav-btn" @click="fnuserMyPageCS()">고객센터</button>
            </div>

            <!-- 리뷰 조회 내역 메인 영역 -->
            <div class="main">

                <!-- 탭 버튼 -->
                <div class="review-tab-wrap">
                    <button class="review-tab" :class="{'active-tab': reviewTab === 'paid'}" @click="switchReviewTab('paid')">유료리뷰</button>
                    <button class="review-tab" :class="{'active-tab': reviewTab === 'free'}" @click="switchReviewTab('free')">무료 리뷰</button>
                </div>

                <!-- 유료 리뷰 목록 -->
                <div class="review-list" v-show="reviewTab === 'paid'">
                    <div class="review-card" v-for="i in 6" :key="i">
                        <div class="review-thumbnail">썸네일</div>
                        <div class="review-card-title">리뷰 제목</div>
                    </div>
                </div>

                <!-- 무료 리뷰 목록 -->
                <div v-show="reviewTab === 'free'">
                    <div class="review-list-item" v-for="i in 6" :key="i">리뷰 제목</div>
                </div>

                <!-- 인덱스 버튼 -->
                <div class="review-index-wrap">
                    <button class="btn-review-index">상세 리뷰 인덱스</button>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
    <!-- 푸터 include 예정 -->
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                 reviewTab: 'paid'  // 'paid' or 'free'
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            // *사이드 바*
            // 마이페이지 메인
            fnMypage : function(){
                location.href="/userMyPage.do";
            },
            // 결제 멤버십 내역
            fnuserMyPagePay : function(){
                location.href="/userMyPage-pay.do";
            },
            // 리뷰 조회 내역
            fnuserMyPageReview : function(){
                location.href="/userMyPage-review.do";
            },
            // 내가 쓴 리뷰 조회 내역
            fnuserMyPageWrite : function(){
                location.href="/userMyPage-write.do";
            },
            // 좋아요 목록
            fnuserMyPageLike : function(){
                location.href="/userMyPage-like.do";
            },
            // 고객 센터 홈
            fnuserMyPageCS : function(){
                location.href="/userMyPage-cs.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>