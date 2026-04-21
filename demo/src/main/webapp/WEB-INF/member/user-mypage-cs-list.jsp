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

        .cs-list-title {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        /* 작성자 컬럼 */
        .col-writer { width: 100px; }

        /* 처리 컬럼 */
        .col-status { width: 80px; }

        /* 처리 상태 - 대기 */
        .status-wait {
            color: #f4a096;
            font-weight: bold;
        }

        /* 처리 상태 - 답변완료 */
        .status-done {
            color: #9b8fd4;
            font-weight: bold;
        }

        /* 하단 버튼 */
        .cs-list-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        /* 테이블 */
        .write-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .write-table th {
            background-color: #ffc7c2;
            padding: 10px;
            text-align: center;
            border: 1px solid #f4a096;
            font-weight: bold;
        }

        .write-table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #eee;
            color: #555;
        }

        .write-table tr:hover {
            background-color: #fff0ef;
        }

        .write-table td.col-title {
            text-align: left;
            cursor: pointer;
        }

        .write-table td.col-title:hover {
            color: #f4a096;
            text-decoration: underline;
        }

        .col-no     { width: 100px; }
        .col-writer { width: 100px; }
        .col-status { width: 80px; }

        /* 문의 작성 버튼 */
        .btn-cs-write {
            padding: 10px 25px;
            background-color: #f0b429;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.2s;
        }
        .btn-cs-write:hover {
            opacity: 0.85;
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
                <div>
                    <h3 class="cs-list-title">어떤 도움이 필요하세요?</h3>
                </div>
                <!-- 문의 목록 테이블 -->
                <table class="write-table">
                    <thead>
                        <tr>
                            <th class="col-no">게시글 번호</th>
                            <th class="col-title">제목</th>
                            <th class="col-writer">작성자</th>
                            <th class="col-status">처리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="i in 6" :key="i">
                            <td>{{ 155 - i + 1 }}</td>
                            <td class="col-title">문의 제목</td>
                            <td>작성자</td>
                            <td><span class="status-wait">대기</span></td>
                        </tr>
                    </tbody>
                </table>
                <!-- 하단 버튼 -->
                <div class="cs-list-bottom">
                    <button class="btn-review-index">상세 리뷰 인덱스</button>
                    <button class="btn-cs-write" @click="fnCsWrite()">문의 작성</button>
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
            fnCsWrite :  function(){
                location.href="/userMyPage-cs-write.do";
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