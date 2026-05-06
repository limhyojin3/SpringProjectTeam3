<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView - 마이페이지</title>
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
            bottom: 60px;
            right: 360px;
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
        .weddingDate{
            color: rgb(0, 110, 255);
            cursor: pointer;
        }
        .weddingDate:hover{
            color: rgb(255, 152, 221);
            text-shadow: 1px 1px 1px pink;
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
                    <div class="greeting">
                        안녕하세요, <strong>{{info.name}}님!</strong><br>
                        <span v-if="weddingDate">
                            <span v-if="dDay > 0">본식까지 D-{{dDay}}일 남으셨네요! 🎉</span>
                            <span v-else-if="dDay === 0">오늘이 본식 날이에요! 축하드려요! 💍</span>
                            <span v-else>본식 후 {{Math.abs(dDay)}}일이 지났네요! 🥂</span>
                        </span>
                        <span v-else>
                            결혼 예정일을 입력하고 쿠폰 받으세요! 🎁
                            <span @click="fnEdit()" class="weddingDate">예정일 입력하기</span>
                        </span>
                        <br>
                        <span v-if="dDayMessage">{{ dDayMessage }}</span>
                    </div>
                    <div class="shortcut-wrap">
                        <div class="shortcut-btn" @click="fnEdit()">내 정보 수정</div>
                        <div class="shortcut-btn" @click="fnCoupon()">쿠폰</div>
                        <div class="shortcut-btn" @click="fnReservation()">예약 목록</div>
                    </div>
                    <p class="pass-title">현재 이용 중인 패스</p>
                    <div class="pass-box" v-if="passWallet && passWallet.remainingCount > 0">
                        <h3>{{ passWallet.passName }} 이용 중입니다</h3>
                        <p>잔여 횟수 {{ passWallet.remainingCount }}회</p>
                    </div>
                    <div class="pass-box" v-else>
                        <h3>현재 이용 중인 패스가 없습니다.</h3>
                    </div>
                    <button class="btn-withdraw" @click="fnWithdraw()">탈퇴하기</button>
                </div>
            </div>
            <!-- 탈퇴 비밀번호 확인 모달 -->
            <div v-if="showWithdrawModal" style="position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:999;display:flex;align-items:center;justify-content:center;">
                <div style="background:white;padding:30px;border-radius:12px;width:300px;text-align:center;">
                    <h4 style="margin-bottom:15px;">비밀번호 확인</h4>
                    <p style="font-size:13px;color:#888;margin-bottom:15px;">탈퇴하려면 비밀번호를 입력해주세요.</p>
                    <input type="password" v-model="withdrawPwd" placeholder="비밀번호 입력"
                        style="width:100%;border:1px solid #eee;padding:8px;border-radius:6px;margin-bottom:15px;">
                    <div style="display:flex;gap:10px;justify-content:center;">
                        <button @click="fnConfirmWithdraw()"
                            style="padding:8px 20px;background:#f4a096;color:white;border:none;border-radius:6px;cursor:pointer;">확인</button>
                        <button @click="showWithdrawModal=false; withdrawPwd=''" 
                            style="padding:8px 20px;border:1px solid #eee;border-radius:6px;cursor:pointer;">취소</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
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
                showWithdrawModal: false,
                withdrawPwd: "",
                passWallet: null,
                weddingDate: '${member.weddingDate}',
                dDay: (() => {
                    const w = '${member.weddingDate}';
                    if (!w) return null;
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const wedding = new Date(w);
                    return Math.round((wedding - today) / (1000 * 60 * 60 * 24));
                })()
            };
        },
        computed: {
            dDayMessage() {
                const d = this.dDay;
                if (d === null) return null;
                if (d > 300) return "웨딩홀은 정하셨나요? 인기 있는 곳은 금방 마감돼요! 💒";
                if (d > 200) return "스드메 계약할 시기예요! 스튜디오부터 알아보세요 📸";
                if (d > 100) return "슬슬 신랑 예복을 준비할 시기예요! 👔";
                if (d > 60)  return "사회자, 주례는 정하셨나요? 😊";
                if (d > 30)  return "청첩장 발송하셨나요? 신혼여행도 확정해두세요 ✈️";
                if (d > 14)  return "웨딩 촬영 준비는 되셨나요? 🌸";
                if (d > 0)   return "거의 다 왔어요, 마지막 점검할 시간이에요 💍";
                if (d === 0) return "오늘이 그 날이에요! 행복한 하루 되세요 🎊";
                return "결혼을 축하드려요! 행복한 신혼생활 되세요 🥂";
            }
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
                if (!confirm("탈퇴 후에는 복구가 불가능합니다. 정말 탈퇴하시겠습니까?")) return;
                this.showWithdrawModal = true;  // 모달 열기
            },
            fnConfirmWithdraw: function() {
                let self = this;
                self.showWithdrawModal = false;
                $.ajax({
                    url: "/leaveMember.dox",
                    type: "POST",
                    data: { 
                        userId: self.info.userId,
                        password: self.withdrawPwd
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("탈퇴되었습니다.");
                            location.href = "/marryIntro.do";
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