<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재확인</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 비밀번호 확인 페이지 전용 스타일만 --%>
    <style>
        .confirm-container {
            width: 400px;
            margin: 100px auto;
            padding: 40px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .confirm-container h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .confirm-container p {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .input-group input[readonly] {
            background-color: #f9f9f9;
            color: #888;
            cursor: not-allowed;
        }

        .btn-confirm {
            width: 100%;
            padding: 15px;
            background-color: #e07a8a;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-confirm:hover {
            background-color: #e07a8a;
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
                    <div class="confirm-container">
                        <h2>비밀번호 재확인</h2>
                        <p>개인정보를 보호하기 위해 비밀번호를 다시 한번 입력해주세요.</p>

                        <form id="confirmForm" method="post" @submit.prevent="fnConfirmPw">
                            <div class="input-group">
                                <label for="userId">아이디</label>
                                <input type="text" id="userId" name="userId" value="${sessionScope.sessionId}" readonly>
                            </div>

                            <div class="input-group">
                                <label for="password">비밀번호</label>
                                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                            </div>

                            <button type="submit" class="btn-confirm">확인</button>
                        </form>
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
            fnConfirmPw : function(event){
                console.log("1. 함수 시작됨!");
                // 변수 선언
                const userId = $("#userId").val();
                const password = $("#password").val();
                console.log("2. 데이터 확인: ", userId, password);
                
                $.ajax({
                    url: "/myPage-checkPw.do",
                    type: "POST",
                    data: {
                        userId: userId,
                        password: password
                    },
                    success: function(response) {
                        console.log("서버 응답값 확인: ", response);
                        if(response.trim() === "success") {
                            location.href = "/myPage-updateForm.do";
                        } else {
                            alert("비밀번호가 틀립니다. 다시 입력해주세요.");
                            $("#password").val("").focus();
                        }
                    },
                    error: function() {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
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