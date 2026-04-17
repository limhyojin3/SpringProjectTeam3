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
        /* 탭 버튼 */
        .review-tab-wrap {
            display: flex;
            gap: 0;
            margin-bottom: 20px;
        }

        .review-tab {
            flex: 1;
            padding: 12px 0;
            border: 2px solid #f4a096;
            background-color: white;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            transition: 0.2s;
        }

        .review-tab:first-child {
            border-radius: 8px 0 0 8px;
        }

        .review-tab:last-child {
            border-radius: 0 8px 8px 0;
        }

        .review-tab.active-tab {
            background-color: #f4a096;
            color: white;
        }

        /* 카드형 리뷰 목록 */
        .review-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .review-card {
            border: 1px solid #ffc7c2;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: 0.2s;
        }

        .review-card:hover {
            box-shadow: 0 4px 10px rgba(244, 160, 150, 0.4);
            transform: translateY(-2px);
        }

        .review-thumbnail {
            width: 100%;
            aspect-ratio: 4/3;
            background-color: #ffc7c2;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            color: #999;
        }

        .review-card-title {
            padding: 10px;
            font-size: 13px;
            font-weight: bold;
            text-align: center;
            background-color: #ff69b4;
            color: white;
        }

        /* 리스트형 리뷰 목록 */
        .review-list-item {
            padding: 12px 15px;
            background-color: #ff69b4;
            color: white;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 8px;
            transition: 0.2s;
        }

        .review-list-item:hover {
            background-color: #f4a096;
        }

        /* 인덱스 버튼 */
        .review-index-wrap {
            text-align: center;
            margin-top: 20px;
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
    <!-- 헤더 include 예정 -->
    <div id="app">
        <div class="container">
            <!-- 사이드바 -->
            <div class="nav">
                <div class="nav-title">마이페이지</div>
                <button class="nav-btn">마이페이지</button>
                <button class="nav-btn">결제 멤버십 내역</button>
                <button class="nav-btn active">리뷰 조회 내역</button>
                <button class="nav-btn">내가 쓴 리뷰/댓글</button>
                <button class="nav-btn">좋아요 목록</button>
                <button class="nav-btn">고객센터</button>
            </div>

            <!-- 리뷰 조회 내역 메인 영역 -->
            <div class="main">

                <!-- 탭 버튼 -->
                <div class="review-tab-wrap">
                    <button class="review-tab active-tab" @click="switchReviewTab('paid')">유료리뷰</button>
                    <button class="review-tab" @click="switchReviewTab('free')">무료 리뷰</button>
                </div>

                <!-- 리뷰 목록 -->
                <div class="review-list">
                    <!-- 카드형 (왼쪽 디자인) -->
                    <div class="review-card" v-for="i in 6" :key="i">
                        <div class="review-thumbnail">썸네일</div>
                        <div class="review-card-title">리뷰 제목</div>
                    </div>
                </div>

                <!-- 상세 리뷰 인덱스 버튼 -->
                <div class="review-index-wrap">
                    <button class="btn-review-index">상세 리뷰 인덱스</button>
                </div>

            </div>
        </div>
    </div>
    <!-- 푸터 include 예정 -->
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                 reviewTab: 'paid'  // 'paid' or 'free'
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
            },
            switchReviewTab: function(type) {
                this.reviewTab = type;
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