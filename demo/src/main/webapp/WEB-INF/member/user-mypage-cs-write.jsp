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
            /* display: flex 없애기! */
        }

        /* 문의 작성 제목 */
        .cs-write-title {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        /* 폼 전체 감싸는 박스 */
        .cs-write-form {
            max-width: 600px;
            margin: 0 auto;
        }

        /* 각 입력 그룹 */
        .cs-form-group {
            margin-bottom: 20px;
        }

        /* 라벨 */
        .cs-label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        /* 입력 박스 */
        .cs-input-box {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 15px;
            background-color: white;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* 체크박스 간격 */
        .cs-input-box input[type="checkbox"] {
            margin-right: 4px;
            cursor: pointer;
        }

        /* 제목 input */
        .cs-input-box input[type="text"] {
            width: 100%;
            border: none;
            outline: none;
            font-size: 14px;
        }

        /* 내용 textarea */
        .cs-input-box textarea {
            width: 100%;
            height: 150px;
            border: none;
            outline: none;
            font-size: 14px;
            resize: none;
            font-family: 'Noto Sans KR', sans-serif;
        }

        /* 하단 버튼 영역 */
        .cs-write-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

        /* 비공개 유무 체크박스 */
        .cs-checkbox-label {
            font-size: 14px;
            color: #555;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 8px 15px;
            background-color: white;
        }

        /* 등록 버튼 */
        .btn-cs-submit {
            padding: 10px 40px;
            background-color: #f0b429;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-cs-submit:hover {
            opacity: 0.85;
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

            <!-- 문의 작성 메인 영역 -->
            <div class="main">
                <h3 class="cs-write-title">문의 내용을 작성해주세요</h3>
                <div class="cs-write-form">
                    <!-- 문의 유형 -->
                    <div class="cs-form-group">
                        <label class="cs-label">*문의 유형</label>
                        <div class="cs-input-box">
                            <input type="radio" v-model="csType" value="운영" name="cs-type"> 운영
                            <input type="radio" v-model="csType" value="결제" name="cs-type"> 결제
                            <input type="radio" v-model="csType" value="기타" name="cs-type"> 기타
                        </div>
                    </div>
                    <!-- 제목 -->
                    <div class="cs-form-group">
                        <label class="cs-label">*제목</label>
                        <div class="cs-input-box">
                            <input type="text" v-model="csTitle" placeholder="">
                        </div>
                    </div>
                    <!-- 내용 -->
                    <div class="cs-form-group">
                        <label class="cs-label">*내용</label>
                        <div class="cs-input-box">
                            <textarea v-model="csContent"></textarea>
                        </div>
                    </div>
                    <!-- 하단 버튼 -->
                    <div class="cs-write-bottom">
                        <label class="cs-checkbox-label">
                            <input type="checkbox" v-model="csPrivate"> 🔒비공개
                        </label>
                        <button class="btn-cs-submit">등록</button>
                    </div>
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