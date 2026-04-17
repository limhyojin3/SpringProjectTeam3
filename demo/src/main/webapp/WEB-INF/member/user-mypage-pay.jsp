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
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; }

        .container {
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
        /* 패스 정보 */
        .pass-box {
            background-color: #ffc7c2;
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            margin-bottom: 20px;
        }

        .pass-box h3 {
            font-size: 25px;
            color: #333;
            margin-bottom: 10px;
        }

        .pass-box p {
            font-size: 20px;
            color: #666;
            margin-bottom: 15px;
        }

        .pass-title {
            font-size: 30px;
            font-weight: bold;
            color: #555;
            margin-bottom: 15px;
            position: relative;
        }
        .sold{
            background-color: #ccc;
        }
    
    </style>
</head>
<body>
    <!-- 헤더 include 예정 -->
    <div id="app">
        <div class="container">
            <!-- 사이드바 -->
            <div class="nav">
                <div class="nav-title">마이페이지</div>
                <button class="nav-btn">마이페이지</button>
                <button class="nav-btn active">결제 멤버십 내역</button>
                <button class="nav-btn">리뷰 조회 내역</button>
                <button class="nav-btn">내가 쓴 리뷰/댓글</button>
                <button class="nav-btn">좋아요 목록</button>
                <button class="nav-btn">고객센터</button>
            </div>

            <!-- 메인 -->
            <div class="main">
                <!-- 멤버십 내역 -->
                <p class="pass-title">멤버십 결제 내역</p> 
                <div class="pass-box"> <!--우선 하드코딩 했어요.-->
                    <h3>베이직 5회권</h3>
                    <p>결제 : 25.02.02 ~ 잔여 2회</p>
                </div>
                <div class="pass-box sold"> <!-- 소진 완료는 #ccc 컬러로-->
                    <h3>체험 2회권</h3>
                    <p>결제 : 25.02.02 ~ 소진완료</p>
                </div>
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
                tab : 'user',
                userId : "",
                userPwd : "",
                companyId : "",
                companyPwd : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnLogin: function () {
                let self = this;
                let param = {
                    userId: this.tab === 'user' ? this.userId : this.companyId,
                    password: this.tab === 'user' ? this.userPwd : this.companyPwd,
                    tab: this.tab  // ← 어떤 탭인지
                };
                $.ajax({
                    url: "http://localhost:8080/login.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.loginResult){
                            location.href=data.url;
                        }
                    }
                });
            },
            FnswitchTab: function(type) {
                this.tab = type;
                if(type === 'user') {
                    document.getElementById('userForm').style.display = 'block';
                    document.getElementById('companyForm').style.display = 'none';
                } else {
                    document.getElementById('userForm').style.display = 'none';
                    document.getElementById('companyForm').style.display = 'block';
                }
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.FnswitchTab('user');
        }
    });

    app.mount('#app');
</script>