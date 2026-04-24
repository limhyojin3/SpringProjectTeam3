<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 마이페이지 메인 전용 스타일만 --%>
    <style>
        .greeting {
            background-color: white;
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            padding: 20px 25px;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.8;
            color: #555;
        }

        .greeting strong {
            color: #f4a096;
            font-size: 16px;
        }

        .shortcut-wrap {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .shortcut-btn {
            flex: 1;
            padding: 20px;
            background-color: white;
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
        }

        .shortcut-btn:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        .pass-box {
            background-color: #ffc7c2;
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            margin-bottom: 20px;
        }

        .pass-box h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
        }

        .pass-box p {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        .pass-title {
            font-size: 20px;
            font-weight: bold;
            color: #555;
            margin-bottom: 15px;
            position: relative;
        }

        .btn-withdraw {
            position: absolute;
            bottom: 20px;
            right: 20px;
            padding: 8px 20px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            color: #666;
            transition: 0.2s;
        }

        .btn-withdraw:hover {
            background-color: #f44336;
            color: white;
            border-color: #f44336;
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
                    <div class="greeting">
                        안녕하세요, <strong>{{info.name}}님!</strong><br>
                        본식까지 D-100일 남으셨네요!<br>
                        사회자, 주례는 정하셨나요? 슬슬 신랑 예복을 준비할 시기예요!
                    </div>
                    <div class="shortcut-wrap">
                        <div class="shortcut-btn" @click="fnEdit()">내 정보 수정</div>
                        <div class="shortcut-btn" @click="fnCoupon()">쿠폰</div>
                        <div class="shortcut-btn" @click="fnReservation()">예약 목록</div>
                    </div>
                    <p class="pass-title">현재 이용 중인 패스</p>
                    <div class="pass-box" v-if="passWallet">
                        <h3>{{ passWallet.passName }} 이용 중입니다</h3>
                        <p>잔여 횟수 {{ passWallet.remainingCount }}회</p>
                    </div>
                    <div class="pass-box" v-else>
                        <h3>현재 이용 중인 패스가 없습니다.</h3>
                    <button class="btn-withdraw" @click="fnWithdraw()">탈퇴하기</button>
                    </div>
                </div>
            </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
    </div>
</body>
<script>
    const app = Vue.createApp({
        data() {
            return {
                 info: {
                    userId: "",
                    name: "",
                },
                passWallet: null
            };
        },
        methods: {
            fnEdit: function() {
                location.href = "/userMyPage-confirmPw.do";
            },
            fnCoupon: function() {
                location.href = "/myCouponPage.do";
            },
            fnReservation: function() {
                location.href = "/myReservation.do";
            },
            fnWithdraw: function() {
                if (!confirm("정말 탈퇴하시겠습니까?")) return;
                let self = this;
                $.ajax({
                    url: "/leaveMember.dox",
                    type: "POST",
                    data: { userId: self.info.userId },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("탈퇴되었습니다.");
                            location.href = "/merryViewHome.do";
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            let self = this;
        
            this.info.userId = "${member.userId}";
            this.info.name = "${member.name}";
            
            // 잔여 횟수 조회
            axios.get("/myPassWallet.dox")
                .then(res => {
                    console.log("패스 지갑:", res.data);
                    self.passWallet = res.data;
                })
                .catch(err => {
                    console.error(err);
                });
        }
    });

    app.mount('#app');
</script>
</body>
</html>