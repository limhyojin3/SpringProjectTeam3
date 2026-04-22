<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터 신고 작성</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 신고 작성 페이지 전용 스타일만 --%>
    <style>
        .cs-write-title {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .cs-write-form {
            max-width: 600px;
            margin: 0 auto;
        }

        .cs-form-group {
            margin-bottom: 20px;
        }

        .cs-label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .cs-input-box {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 15px;
            background-color: white;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .cs-input-box input[type="checkbox"] {
            margin-right: 4px;
            cursor: pointer;
        }

        .cs-input-box input[type="text"] {
            width: 100%;
            border: none;
            outline: none;
            font-size: 14px;
        }

        .cs-input-box textarea {
            width: 100%;
            height: 150px;
            border: none;
            outline: none;
            font-size: 14px;
            resize: none;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .cs-write-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

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
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <h3 class="cs-write-title">신고 내용을 작성해주세요</h3>
                    <div class="cs-write-form">
                        <!-- 신고 유형 -->
                        <div class="cs-form-group">
                            <label class="cs-label">*신고 유형</label>
                            <div class="cs-input-box">
                                <input type="radio" v-model="csType" value="COMPANY" name="cs-type"> 불량 업체
                                <input type="radio" v-model="csType" value="POST" name="cs-type"> 광고글/도배
                                <input type="radio" v-model="csType" value="MEMBER" name="cs-type"> 회원 신고
                                <input type="radio" v-model="csType" value="REVIEW" name="cs-type"> 허위 리뷰
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
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                csType: "COMPANY",
                csTitle: "",
                csContent: "",
                csPrivate: false
            };
        },
        methods: {
            // 함수(메소드) - (key : function())

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