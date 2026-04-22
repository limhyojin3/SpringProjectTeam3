<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터 문의 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 고객센터 문의 목록 페이지 전용 스타일만 --%>
    <style>
        .cs-list-title {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

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

        .status-wait {
            color: #f4a096;
            font-weight: bold;
        }

        .status-done {
            color: #9b8fd4;
            font-weight: bold;
        }

        .cs-list-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

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
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <h3 class="cs-list-title">어떤 도움이 필요하세요?</h3>

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
            fnCsWrite: function() {
                location.href = "/userMyPage-cs-write.do";
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