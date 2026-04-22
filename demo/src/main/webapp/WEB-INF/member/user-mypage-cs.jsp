<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 고객센터 페이지 전용 스타일만 --%>
    <style>
        .cs-card {
            background-color: white;
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            width: 550px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .cs-card h3 {
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }

        .cs-img {
            width: 100%;
            margin-bottom: 20px;
            border-radius: 8px;
        }

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

        .cs-btn:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        /* 카드 가운데 정렬 */
        .right-sections {
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <div class="cs-card">
                        <h3>어떤 도움이 필요하세요?</h3>
                        <img src="/img/mypage_require_pic.png" class="cs-img">
                        <button class="cs-btn" @click="fnCsList()">문의하러 가기</button>
                        <button class="cs-btn" @click="fnReport()">신고하러 가기</button>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCsList: function() {
                location.href = "/userMyPage-cs-list.do";
            },
            fnReport: function() {
                location.href = "/userMyPage-cs-report.do";
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>
</body>
</html>