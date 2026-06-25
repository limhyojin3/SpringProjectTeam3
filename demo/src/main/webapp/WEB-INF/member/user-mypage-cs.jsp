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
            border: 1px solid #f0e0e0;
            border-radius: 16px;
            padding: 40px;
            text-align: center;
            width: 550px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }

        .cs-card h3 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 24px;
            color: #333;
            padding-bottom: 12px;
            border-bottom: 2px solid #e07a8a;
        }

        .cs-img {
            width: 100%;
            height: 200px;  /* 고정 높이 */
            object-fit: contain;
            margin: 0 auto 28px;
            display: block;
            border-radius: 8px;
        }

        .cs-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 16px 0;
            margin-bottom: 12px;
            background-color: white;
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            color: #555;
            cursor: pointer;
            transition: 0.2s;
        }

        .cs-btn:hover {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        .cs-btn:last-child {
            margin-bottom: 0;
        }

        .right-sections {
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <div class="cs-card">
                        <h3>어떤 도움이 필요하세요?</h3>
                        <img src="/img/marry_logo.jfif" class="cs-img">
                        <button class="cs-btn" @click="fnCsList()">
                            <i class="fas fa-headset"></i> 1대1 문의작성/내역조회
                        </button>
                        <button class="cs-btn" @click="fnReport()">
                            <i class="fas fa-flag"></i> 신고내역조회
                        </button>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>
    <script>
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-btn').forEach(btn => {
            const onclick = btn.getAttribute('onclick');
            if (!onclick) return;
            const match = onclick.match(/'([^']+)'/);
            if (!match) return;
            if (currentPath.endsWith(match[1])) {
                btn.classList.add('active');
            }
        });
    </script>
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