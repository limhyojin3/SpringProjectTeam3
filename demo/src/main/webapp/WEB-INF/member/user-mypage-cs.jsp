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
            display: flex;           /* 가운데 정렬을 위한 flex */
            justify-content: center; /* 가로 가운데 */
            align-items: center;     /* 세로 가운데 */
        }

        /* 고객센터 카드 전체 박스 */
        .cs-card {
            background-color: white;
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            width: 550px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); /* 살짝 그림자 */
        }

        /* 카드 제목 */
        .cs-card h3 {
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }

        /* 캐릭터 이미지 */
        .cs-img {
            width: 100%;
            margin-bottom: 20px;
            border-radius: 8px;
        }

        /* 문의하기 / 신고하기 버튼 */
        .cs-btn {
            display: block;
            width: 100%;
            padding: 14px 0;
            margin-bottom: 10px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 20px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
        }

        /* 버튼 호버 효과 */
        .cs-btn:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
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

            <!-- 메인 -->
            <div class="main">
                <div class="cs-card">
                    <h3>어떤 도움이 필요하세요?</h3>
                    <img src="/img/mypage_require_pic.png" class="cs-img">
                    <button class="cs-btn" @click="fnCsList()">문의하러 가기</button>
                    <button class="cs-btn" @click="fnReport()">신고하러 가기</button>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCsList : function(){
                location.href="/userMyPage-cs-list.do";
            },
            fnReport : function(){
                location.href="/userMyPage-cs-report.do";
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
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>