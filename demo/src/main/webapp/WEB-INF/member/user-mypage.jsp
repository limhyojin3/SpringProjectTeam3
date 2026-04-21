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

        /* 인사말 */
        .greeting {
            background-color: white;
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            padding: 20px 25px;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.8;
            color: #555;
        }

        .greeting strong {
            color: #f4a096;
            font-size: 16px;
        }

        /* 바로가기 버튼 */
        .shortcut-wrap {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .shortcut-btn {
            flex: 1;
            padding: 20px;
            background-color: white;
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
        }

        .shortcut-btn:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        /* 패스 정보 */
        .pass-box {
            background-color: #ffc7c2;
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            margin-bottom: 20px;
        }

        .pass-box h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
        }

        .pass-box p {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        .pass-title {
            font-size: 20px;
            font-weight: bold;
            color: #555;
            margin-bottom: 15px;
            position: relative;
        }

        .btn-withdraw {
            position: absolute;  /* ← 추가 */
            bottom: 20px;        /* ← 추가 */
            right: 20px;;         
            padding: 8px 20px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            color: #666;
            transition: 0.2s;
        }

        .btn-withdraw:hover {
            background-color: #f44336;
            color: white;
            border-color: #f44336;
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
                <!-- 인사말 -->
                <div class="greeting">
                    안녕하세요, <strong>000님!</strong><br> <!--이름은 user이름으로 변경-->
                    본식까지 D-100일 남으셨네요!<br> <!--현재 날짜 -유저가 입력한 예식일로 변경/없으면 ..흠 생각안함-->
                    사회자, 주례는 정하셨나요? 슬슬 신랑 예복을 준비할 시기예요!
                </div>

                <!-- 바로가기 -->
                <div class="shortcut-wrap">
                    <div class="shortcut-btn" @click="fnEdit()">내 정보 수정</div>
                    <div class="shortcut-btn">쿠폰</div>
                    <div class="shortcut-btn">예약 목록</div>
                </div>

                <!-- 패스 정보 -->
                <p class="pass-title">현재 이용 중인 패스</p> 
                <div class="pass-box">
                    <h3>베이직 패스 이용 중입니다</h3>
                    <p>잔여 횟수 2회</p>
                </div>
                <button class="btn-withdraw">탈퇴하기</button>
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
                // 변수 - (key : value)

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnEdit : function(){
                location.href="/userMyPage-confirmPw.do";
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