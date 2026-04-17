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

    </style>
</head>
<body>
    <div id="app">
    <!-- html 코드는 id가 app인 태그 안에서 작업 -->
    <!-- 상단 메뉴 -->
    <div class="top-menu">
        <button>회사소개</button>
        <button>제휴업체</button>
        <button>커뮤니티</button>
        <button>헤스쿠폰</button>
        <button>고객센터</button>
        <span>000님</span>
    </div>

    <div class="mypage-wrap">
        <!-- 왼쪽 사이드바 -->
        <div class="sidebar">
            <div class="sidebar-title">마이페이지</div>
            <ul>
                <li>결제 편버십 내역</li>
                <li>리뷰 조회 내역</li>
                <li>내가 쓴 리뷰/댓글</li>
                <li>좋아요 목록</li>
                <li>고객센터</li>
            </ul>
        </div>

        <!-- 오른쪽 메인 -->
        <div class="main-content">
            <!-- 인사말 -->
            <div class="greeting">
                <p>안녕하세요, 000님!</p>
                <p>결혼식까지 D-100일 남으셨네요!</p>
                <p>사혼자, 주례는 정하셨나요?...</p>
            </div>

            <!-- 바로가기 버튼 -->
            <div class="shortcut">
                <button>내 정보 수정</button>
                <button>쿠폰</button>
                <button>예약 목록</button>
            </div>

            <!-- 현재 이용 중인 패스 -->
            <div class="pass-box">
                <p>현재 이용 중인 패스</p>
                <div class="pass-info">
                    <p>베이직 패스 이용 중입니다</p>
                    <p>잔여 횟수 2회</p>
                </div>
                <button class="btn-withdraw">탈퇴하기</button>
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