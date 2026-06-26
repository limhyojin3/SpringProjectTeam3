<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 쿠폰 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <style>
        /* 섹션 */
        .coupon-section {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #f0e0e0;
            width: 100%;
            max-width: 800px;
            height: fit-content;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        }

        /* 탭 */
        .tab-wrap {
            display: flex;
            gap: 0;
            border-bottom: 2px solid #ffc7c2;
            margin-bottom: 24px;
        }

        .tab-btn {
            padding: 10px 28px;
            font-size: 14px;
            font-weight: 700;
            color: #aaa;
            background: none;
            border: none;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: 0.2s;
        }

        .tab-btn.active {
            color: #e07a8a;
            border-bottom: 3px solid #e07a8a;
        }

        /* 쿠폰 목록 */
        .coupon-list {
            margin-top: 10px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .coupon-item {
            border: 1px solid #f0e0e0;
            background-color: #fff9f9;
            padding: 20px 24px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: 0.2s;
        }

        .coupon-item:hover {
            box-shadow: 0 4px 16px rgba(224, 122, 138, 0.15);
            transform: translateY(-2px);
        }

        .coupon-name {
            font-size: 15px;
            font-weight: 700;
            color: #333;
        }

        .coupon-discount {
            margin-left: 10px;
            color: #e07a8a;
            font-weight: 700;
        }

        .coupon-date {
            color: #aaa;
            font-size: 13px;
        }

        /* 쿠폰 등록 */
        .coupon-footer {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 8px;
        }

        .coupon-input-field {
            padding: 10px 15px;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            width: 250px;
            outline: none;
            font-size: 14px;
            color: #555;
        }

        .coupon-input-field:focus {
            border-color: #e07a8a;
        }

        .btn-register {
            background-color: #e07a8a;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-register:hover {
            background-color: #c9606f;
        }

        /* 기프트콘 */
        .giftcon-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 10px;
        }

        .giftcon-card {
            border: 1px solid #f0e0e0;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            background: #fff;
        }

        .giftcon-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(224, 122, 138, 0.25);
        }

        .giftcon-card.used {
            opacity: 0.45;
            cursor: default;
            filter: grayscale(60%);
        }

        .giftcon-card.used:hover {
            transform: none;
            box-shadow: none;
        }

        .giftcon-img {
            width: 100%;
            height: 110px;
            object-fit: cover;
        }

        .giftcon-info {
            padding: 10px 12px 12px;
        }

        .giftcon-name {
            font-size: 13px;
            font-weight: 700;
            color: #333;
            margin-bottom: 4px;
        }

        .giftcon-date {
            font-size: 11px;
            color: #aaa;
        }

        .giftcon-badge {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
            margin-bottom: 4px;
        }

        .badge-unused { background: #fff0f3; color: #e07a8a; }
        .badge-used   { background: #eee;    color: #aaa; }

        /* 모달 */
        .giftcon-modal-bg {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 9000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .giftcon-modal {
            background: #fff;
            border-radius: 16px;
            width: 400px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: modalPop 0.2s ease;
        }

        @keyframes modalPop {
            from { transform: scale(0.92); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
        }

        .giftcon-modal-header {
            background: #e07a8a;
            color: white;
            padding: 14px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 15px;
            font-weight: 700;
        }

        .modal-close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
            line-height: 1;
        }

        .giftcon-modal-body {
            padding: 24px;
            text-align: center;
        }

        .giftcon-modal-body img {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 16px;
        }

        .giftcon-code-box {
            background: #fff9f9;
            border: 1px dashed #ffc7c2;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 12px;
        }

        .giftcon-code-label {
            font-size: 11px;
            color: #aaa;
            margin-bottom: 4px;
        }

        .giftcon-code-value {
            font-size: 16px;
            font-weight: 700;
            color: #333;
            letter-spacing: 0.1em;
        }

        .giftcon-modal-footer {
            font-size: 12px;
            color: #bbb;
            margin-top: 8px;
        }

        /* 페이지네이션 */
        .pagination-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 6px;
        }

        .btn-page-arrow,
        .btn-page-num {
            height: 34px;
            min-width: 34px;
            padding: 0 10px;
            background-color: #fff;
            color: #e07a8a;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-page-arrow:hover,
        .btn-page-num:hover {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        .btn-page-num.active-page {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
            font-weight: bold;
        }

        .btn-page-arrow:disabled { opacity: 0.3; cursor: not-allowed; }

        .empty-msg {
            text-align: center;
            padding: 40px 0;
            color: #bbb;
            font-size: 14px;
            line-height: 1.8;
        }

        .empty-icon {
            font-size: 32px;
            color: #ffc7c2;
            margin-bottom: 12px;
            display: block;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <div id="wrapper">
            <div class="main-content">

                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <section class="coupon-section">

                        <!-- 탭 -->
                        <div class="tab-wrap">
                            <button class="tab-btn" :class="{ active: activeTab === 'coupon' }" @click="activeTab = 'coupon'">
                                <i class="fas fa-ticket-alt"></i> 쿠폰 ({{ couponList.length }})
                            </button>
                            <button class="tab-btn" :class="{ active: activeTab === 'giftcon' }" @click="activeTab = 'giftcon'">
                                <i class="fas fa-gift"></i> 기프트콘 ({{ giftconList.length }})
                            </button>
                        </div>

                        <!-- 쿠폰 탭 -->
                        <div v-show="activeTab === 'coupon'">
                            <div class="coupon-list" v-if="couponList.length > 0">
                                <div v-for="coupon in couponList" :key="coupon.couponCode" class="coupon-item">
                                    <div class="coupon-main-info">
                                        <span class="coupon-name">{{ coupon.couponName }}</span>
                                        <span class="coupon-discount">{{ coupon.discountRate }}% 할인</span>
                                    </div>
                                    <div class="coupon-sub-info">
                                        <span class="coupon-date">만료일 : ~{{ coupon.expiredAt }}</span>
                                    </div>
                                </div>
                            </div>
                            <div v-else class="empty-msg">보유한 쿠폰이 없습니다.</div>

                            <div class="coupon-footer">
                                <input type="text"
                                       v-model="inputCode"
                                       placeholder="쿠폰 번호를 입력하세요"
                                       class="coupon-input-field">
                                <button class="btn-register" @click="fnRegisterCoupon()">쿠폰 등록</button>
                            </div>

                            <!-- 쿠폰 페이지네이션 -->
                            <div class="pagination-wrap" v-if="totalPages > 1">
                                <button class="btn-page-arrow" @click="fetchCoupons(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                                <button class="btn-page-num"
                                        v-for="p in totalPages" :key="p"
                                        :class="p === currentPage ? 'active-page' : ''"
                                        @click="fetchCoupons(p)">{{ p }}</button>
                                <button class="btn-page-arrow" @click="fetchCoupons(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
                            </div>
                        </div>

                        <!-- 기프트콘 탭 -->
                        <div v-show="activeTab === 'giftcon'">
                            <div class="giftcon-grid" v-if="giftconList.length > 0">
                                <div v-for="g in giftconList" :key="g.couponCode"
                                     class="giftcon-card"
                                     :class="{ used: g.status === 'USED' }"
                                     @click="g.status !== 'USED' && openGiftcon(g)">
                                    <img :src="g.giftconImage || '/img/giftcon/default.png'"
                                         class="giftcon-img"
                                         :alt="g.couponName">
                                    <div class="giftcon-info">
                                        <span class="giftcon-badge" :class="g.status === 'USED' ? 'badge-used' : 'badge-unused'">
                                            {{ g.status === 'USED' ? '사용완료' : '미사용' }}
                                        </span>
                                        <div class="giftcon-name">{{ g.couponName }}</div>
                                        <div class="giftcon-date">만료일 ~{{ g.expiredAt }}</div>
                                    </div>
                                </div>
                            </div>
                            <div v-else class="empty-msg">
                                <i class="fas fa-gift empty-icon"></i>
                                보유한 기프트콘이 없습니다.<br>베스트 리뷰에 선정되면 기프트콘이 발급됩니다!
                            </div>
                        </div>

                    </section>
                </div>

            </div>
        </div>

        <!-- 기프트콘 모달 -->
        <div class="giftcon-modal-bg" v-if="selectedGiftcon" @click.self="selectedGiftcon = null">
            <div class="giftcon-modal">
                <div class="giftcon-modal-header">
                    <i class="fas fa-gift"></i> {{ selectedGiftcon.couponName }}
                    <button class="modal-close-btn" @click="selectedGiftcon = null">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="giftcon-modal-body">
                    <img :src="selectedGiftcon.giftconImage || '/img/giftcon/default.png'"
                         :alt="selectedGiftcon.couponName">

                    <div class="giftcon-code-box">
                        <div class="giftcon-code-label">기프트콘 코드</div>
                        <div class="giftcon-code-value">{{ selectedGiftcon.giftconCode }}</div>
                    </div>

                    <div class="giftcon-code-box">
                        <div class="giftcon-code-label">바코드 번호</div>
                        <div class="giftcon-code-value">{{ selectedGiftcon.giftconBarcode }}</div>
                    </div>

                    <div class="giftcon-modal-footer">만료일: {{ selectedGiftcon.expiredAt }}</div>
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
                activeTab: 'coupon',
                couponList: [],
                giftconList: [],
                inputCode: "",
                currentPage: 1,
                totalPages: 0,
                selectedGiftcon: null
            };
        },
        methods: {
            fetchCoupons(page = 1) {
                axios.get('/api/myCoupons.do', { params: { currentPage: page } })
                    .then(res => {
                        this.couponList  = res.data.list       || [];
                        this.totalPages  = res.data.totalPages || 0;
                        this.currentPage = res.data.currentPage || 1;
                    })
                    .catch(err => console.error("쿠폰 로드 에러:", err));
            },
            fetchGiftcons() {
                axios.get('/api/myGiftcons.do')
                    .then(res => { this.giftconList = res.data || []; })
                    .catch(err => console.error("기프트콘 로드 에러:", err));
            },
            openGiftcon(g) {
                this.selectedGiftcon = g;
            },
            fnRegisterCoupon() {
                if (!this.inputCode || this.inputCode.trim() === "") {
                    alert("쿠폰 번호를 입력해주세요.");
                    return;
                }
                axios.post("/coupon/register.do", { couponCode: this.inputCode })
                    .then(res => {
                        if (res.data.result === "success") {
                            alert("쿠폰이 성공적으로 등록되었습니다! 🎉");
                            this.inputCode = "";
                            this.fetchCoupons();
                        } else {
                            alert(res.data.message || "등록에 실패했습니다. 코드를 확인해주세요.");
                        }
                    })
                    .catch(err => { console.error(err); alert("등록 중 오류가 발생했습니다."); });
            }
        },
        mounted() {
            this.fetchCoupons();
            this.fetchGiftcons();
        }
    });
    app.mount('#app');
</script>
</body>
</html>
