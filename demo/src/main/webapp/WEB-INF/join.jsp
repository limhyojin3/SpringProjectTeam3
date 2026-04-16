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
    <style>
        /* 두 박스 감싸는 컨테이너 */
        .signup-container {
            display: flex;
            gap: 20px;
            justify-content: center;
            padding: 30px;
        }

        /* 각 박스 */
        .signup-box {
            flex: 1;
            max-width: 300px;
            border: 2px solid #ccc;
            border-radius: 10px;
            padding: 30px 20px;
            text-align: center;
            cursor: pointer;
        }
        :hover.signup-box{
            box-shadow: 1px 1px 2px gray;
        }
        /* 업체 박스 내부 글자 색 */
        .company-txt-color{
            color: #a81bff;
        }
        /* 업체 박스 내부 글자 색 */
        .user-txt-color{
            color: #ff1ba8;
        }
        /* 글자 bold 효과 */
        .txt-bold{
            font-weight: bold;
        }
        /* 일반 회원가입 상단 박스 */
        #inner-box-user{
            border-radius: 10px;
            border: 2px solid black;
            background-color: #ffada2;
            box-shadow: 1px 1px 1px gray;
        }
        /* 업체 회원가입 상단 박스 */
        #inner-box-company{
            border-radius: 10px;
            border: 2px solid black;
            background-color: #cc7aff;
            box-shadow: 1px 1px 1px gray;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="signup-container">
        <div class="signup-box user" @click="fnUserJoin()">
            <div id="inner-box-user">
                <h3>일반 회원가입</h3>
            </div>
            <p class="txt-bold user-txt-color">똑똑한 결혼 준비</p>
            <p>메리뷰와 함께 하세요!</p>
        </div>
        <div class="signup-box company" @click="fnCompanyJoin()">
            <div id="inner-box-company">
                <h3>업체 가입</h3>
            </div>
            <p>메리뷰와 제휴를 맺어</p>
            <p>결혼 준비 파트너가 되어보세요!</p>
            <div class="company-txt-color">
                <p>파트너가 되면 이런 혜택을 받을 수 있어요!</p>
                <p class="txt-bold">예약 수수료 5%</p>
                <p>일반 업체의 경우 10%</p>
            </div>
        </div>
        </div>


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
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            },
            fnUserJoin : function(){
                window.location.href = '/userJoin.do';
            },
            fnCompanyJoin : function(){
                window.location.href = '/companyJoin.do';
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>