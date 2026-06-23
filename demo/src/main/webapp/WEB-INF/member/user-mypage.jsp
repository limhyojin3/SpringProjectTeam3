<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView - 마이페이지</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>
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
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 16px rgba(255, 100, 130, 0.08);
            backdrop-filter: blur(8px);
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            padding: 20px 25px;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.8;
            color: #555;
            display: flex;
            align-items: center;
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
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 16px rgba(255, 100, 130, 0.08);
            backdrop-filter: blur(8px);
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
            color: #e07a8a;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .shortcut-btn i {
            font-size: 22px;
        }

        .shortcut-btn:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        .pass-box {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 16px rgba(255, 100, 130, 0.08);
            backdrop-filter: blur(8px);
            border: 1px solid #ffc7c2;
            border-radius: 10px;
            padding: 20px 25px;
            margin-bottom: 20px;
        }

        .pass-box-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .pass-box-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .pass-box h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 4px;
        }

        .pass-box p {
            font-size: 13px;
            color: #888;
            margin: 0;
        }

        .pass-box p strong {
            font-size: 16px;
            color: #e07a8a;
            font-weight: 700;
        }

        .btn-buy-pass {
            padding: 8px 16px;
            background: #e07a8a;
            color: white;
            border-radius: 20px;
            font-size: 13px;
            text-decoration: none;
            white-space: nowrap;
        }
        .btn-buy-pass:hover {
            background: #c9606f;
            color: white;
        }

        .pass-title {
            font-size: 20px;
            font-weight: bold;
            color: #555;
            margin-bottom: 15px;
            position: relative;
        }

        .btn-withdraw {
            display: block;
            margin-top: 10px;
            margin-left: auto;
            padding: 8px 20px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            color: #aaa;
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

        .profile-img {
            width: 55px;
            height: 55px;
            object-fit: contain;
            border-radius: 50%;
            border: 2px solid #ffb6c1;
            padding: 4px;
            background: #fff0f3;
        }

        .profile-img-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            margin-right: 16px;
            flex-shrink: 0;
        }

        .btn-profile-change {
            font-size: 11px;
            padding: 1px 8px;
            border: 1px solid #ffb6c1;
            border-radius: 20px;
            background: white;
            color: #e07a8a;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-profile-change:hover {
            background: #fff0f3;
        }

        .greeting-text {
            flex: 1;
        }

        .profile-img-list {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 16px;
        }

        .profile-img-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            border: 2px solid transparent;
        }

        .profile-img-item.selected {
            border: 2px solid #f4a096;
            background: #fff0f3;
        }

        .profile-img-item img {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

        .profile-img-item span {
            font-size: 12px;
            color: #666;
        }

        .incomplete-banner {
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 16px rgba(255, 100, 130, 0.08);
            border: 1px solid #ffb3c1;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 16px;
            font-size: 13px;
            color: #e05a7a;
        }
        .incomplete-banner i {
            margin-right: 6px;
        }
        .incomplete-link {
            text-decoration: underline;
            cursor: pointer;
            font-weight: 600;
        }
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-box {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 300px;
            text-align: center;
        }
        .modal-box-wide {
            width: 420px;
        }
        .modal-title {
            margin-bottom: 15px;
        }
        .modal-desc {
            font-size: 13px;
            color: #888;
            margin-bottom: 15px;
        }
        .modal-input {
            width: 100%;
            border: 1px solid #eee;
            padding: 8px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        .modal-btn-wrap {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 16px;
        }
        .btn-confirm {
            padding: 8px 20px;
            background: #f4a096;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn-cancel {
            padding: 8px 20px;
            border: 1px solid #eee;
            border-radius: 6px;
            cursor: pointer;
            background: white;
        }
        .profile-img-option {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }

        .pass-icon {
            font-size: 28px;
            color: #e07a8a;
        }
        .remaining-count strong {
            font-size: 20px;
            color: #e07a8a;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <input type="hidden" id="sessionIdVal" value="${sessionId}">
    <input type="hidden" id="memberTelVal" value="${member.tel}">
    <div id="app">
        <div id="wrapper">
            <div class="main-content">
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <!-- 미입력 안내 배너 -->
                    <div v-if="hasIncomplete" class="incomplete-banner">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        미입력된 정보가 있어요.
                        <span @click="fnEdit()" class="incomplete-link">내 정보 수정</span>에서 완성해보세요!
                    </div>
                    
                    <div class="greeting">
                        <div class="profile-img-wrap">
                            <img :src="'/img/profile/' + (info.profileImg || 'heart.png')" 
                                class="profile-img" alt="프로필 이미지">
                            <button class="btn-profile-change" @click="showProfileModal = true">변경</button>
                        </div>
                        <div class="greeting-text">
                            안녕하세요, <strong>{{info.name}}님!</strong><br>
                            <span v-if="anniversaryDate">
                                <span v-if="anniversaryDDay === 0">오늘이 결혼 기념일이에요! 🎊 축하드려요!</span>
                                <span v-else-if="anniversaryDDay > 0">결혼 기념일까지 D-{{anniversaryDDay}}일 남았어요! 💍</span>
                                <span v-else>{{anniversaryYears}}주년 기념일이 {{Math.abs(anniversaryDDay)}}일 지났어요! 🥂</span>
                            </span>
                            <span v-else>
                                <span v-if="weddingDate">
                                    <span v-if="dDay > 0">본식까지 D-{{dDay}}일 남으셨네요! 🎉</span>
                                    <span v-else-if="dDay === 0">오늘이 본식 날이에요! 축하드려요! 💍</span>
                                    <span v-else>본식 후 {{Math.abs(dDay)}}일이 지났네요! 🥂</span>
                                </span>
                                <span v-else>
                                    결혼 예정일을 입력하고 쿠폰 받으세요! 🎁
                                    <span @click="fnEdit()" class="weddingDate">예정일 입력하기</span>
                                </span>
                            </span>
                            <br>
                            <span v-if="dDayMessage && !anniversaryDate">{{ dDayMessage }}</span>
                        </div>
                    </div>

                    <div class="shortcut-wrap">
                        <div class="shortcut-btn" @click="fnEdit()">
                            <i class="fa-solid fa-user-pen"></i>
                            <span>내 정보 수정</span>
                        </div>
                        <div class="shortcut-btn" @click="fnCoupon()">
                            <i class="fa-solid fa-ticket"></i>
                            <span>쿠폰</span>
                        </div>
                        <div class="shortcut-btn" @click="fnReservation()">
                            <i class="fa-solid fa-calendar-check"></i>
                            <span>예약 목록</span>
                        </div>
                    </div>
                    <p class="pass-title">현재 이용 중인 패스</p>
                    <div class="pass-box" v-if="passWallet && passWallet.remainingCount > 0">
                        <div class="pass-box-inner">
                            <div class="pass-box-left">
                                <i class="fa-solid fa-star pass-icon"></i>
                                <div>
                                    <h3>{{ passWallet.passName }} 이용 중</h3>
                                    <p>잔여 <strong>{{ passWallet.remainingCount }}</strong>회 남았어요</p>
                                </div>
                            </div>
                            <div class="pass-box-right">
                                <a href="/adminPass.do" class="btn-buy-pass">패스 추가 구매</a>
                            </div>
                        </div>
                    </div>
                    <div class="pass-box pass-box-empty" v-else>
                        <div class="pass-box-inner">
                            <div class="pass-box-left">
                                <i class="fa-solid fa-box-open pass-icon"></i>
                                <div>
                                    <h3>이용 중인 패스가 없어요</h3>
                                    <p>패스를 구매하고 유료 리뷰를 열람해보세요!</p>
                                </div>
                            </div>
                            <div class="pass-box-right">
                                <a href="/adminPass.do" class="btn-buy-pass">패스 구매하기</a>
                            </div>
                        </div>
</div>
                    <button class="btn-withdraw" @click="fnWithdraw()">탈퇴하기</button>
                </div>
            </div>

            <!-- 탈퇴 모달 -->
            <div v-if="showWithdrawModal" class="modal-overlay">
                <div class="modal-box">
                    <h4 class="modal-title">비밀번호 확인</h4>
                    <p class="modal-desc">탈퇴하려면 비밀번호를 입력해주세요.</p>
                    <input type="password" v-model="withdrawPwd" placeholder="비밀번호 입력" class="modal-input">
                    <div class="modal-btn-wrap">
                        <button @click="fnConfirmWithdraw()" class="btn-confirm">확인</button>
                        <button @click="showWithdrawModal=false; withdrawPwd=''" class="btn-cancel">취소</button>
                    </div>
                </div>
            </div>

            <!-- 프로필 이미지 선택 모달 -->
            <div v-if="showProfileModal" class="modal-overlay">
                <div class="modal-box modal-box-wide">
                    <h4 class="modal-title">프로필 이미지 선택</h4>
                    <div class="profile-img-list">
                        <div v-for="img in profileImgList" :key="img.file"
                            class="profile-img-item"
                            :class="{'selected': info.profileImg === img.file}"
                            @click="selectProfileImg(img.file)">
                            <img :src="'/img/profile/' + img.file" :alt="img.label" class="profile-img-option">
                            <span>{{img.label}}</span>
                        </div>
                    </div>
                    <div class="modal-btn-wrap">
                        <button @click="fnSaveProfileImg" class="btn-confirm">저장</button>
                        <button @click="showProfileModal=false" class="btn-cancel">취소</button>
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
                sessionId: '${sessionId}',
                 info: {
                    userId: "",
                    name: "",
                },
                anniversaryDDay: null,
                anniversaryYears: null,
                showWithdrawModal: false,
                withdrawPwd: "",
                passWallet: null,
                weddingDate: '${member.weddingDate}',
                anniversaryDate: '${member.anniversaryDate}' || null,  // ✅ JSP EL로 받기
                dDay: (() => {
                    const w = '${member.weddingDate}';
                    if (!w) return null;
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const wedding = new Date(w);
                    return Math.round((wedding - today) / (1000 * 60 * 60 * 24));
                })(),
                hasIncomplete: false,
                showProfileModal: false,
                profileImgList: [
                    { file: 'bride.png', label: '신부' },
                    { file: 'groom.png', label: '신랑' },
                    { file: 'woman.png', label: '여성' },
                    { file: 'man.png', label: '남성' },
                    { file: 'old-woman.png', label: '여성' },
                    { file: 'old-man.png', label: '남성' },
                    { file: 'wedding-ring.png', label: '웨딩링' },
                    { file: 'heart.png', label: '하트' },
                ],
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
                if (this.sessionId && (this.sessionId.startsWith('kakao_') || this.sessionId.startsWith('naver_'))) {
                    location.href = "/myPage-updateForm.do";  // 바로 수정 페이지로
                } else {
                    location.href = "/userMyPage-confirmPw.do";  // 일반 유저는 비밀번호 확인
                }
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
            },
            fnCalcAnniversary() {
                if (!this.anniversaryDate) return;

                const today = new Date();
                today.setHours(0, 0, 0, 0);

                // ✅ 하이픈 대신 슬래시로 파싱 (브라우저 호환성)
                const parts = this.anniversaryDate.split('-');
                const anni = new Date(parts[0], parts[1] - 1, parts[2]);

                this.anniversaryYears = today.getFullYear() - anni.getFullYear();

                const thisYearAnniv = new Date(
                    today.getFullYear(),
                    anni.getMonth(),
                    anni.getDate()
                );

                const diff = Math.ceil((thisYearAnniv - today) / (1000 * 60 * 60 * 24));
                this.anniversaryDDay = diff;
            },
            selectProfileImg: function(file) {
                this.info.profileImg = file;
            },
            fnSaveProfileImg: function() {
                let self = this;
                $.ajax({
                    url: '/saveProfileImg.dox',
                    type: 'POST',
                    data: { profileImg: self.info.profileImg },
                    success: function(data) {
                        if (data.result === 'success') {
                            self.showProfileModal = false;
                            alert('프로필 이미지가 변경되었습니다.');
                        }
                    }
                });
            },
        },
        mounted() {
            // hidden input으로 읽기
            const userId = document.getElementById('sessionIdVal').value;
            const tel = document.getElementById('memberTelVal').value;
            
            // 카카오/네이버 소셜 유저이고 전화번호 없으면 배너 표시
            if ((userId.startsWith('kakao_') || userId.startsWith('naver_')) && !tel) {
                this.hasIncomplete = true;
            }

            let self = this;

            this.info.userId = "${member.userId}";
            this.info.name = "${member.name}";
            this.info.profileImg = "${member.profileImg}";

            this.anniversaryDate = '${member.anniversaryDate}' || null;
            this.fnCalcAnniversary();

            axios.get("/myPassWallet.dox")
                .then(res => {
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