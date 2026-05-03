<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>멤버십 결제 내역</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <style>
            .main-content {
                display: flex;
                justify-content: center;
                align-items: flex-start;
                gap: 24px;
                width: 100%;
            }

            .right-sections {
                width: 100%;
                max-width: 950px;
                padding: 30px;
            }

            .wallet-page {
                display: flex;
                flex-direction: column;
                gap: 18px;
            }

            /* 상단 카드 */
            .wallet-card {
                background: linear-gradient(135deg, #f7b7c3 0%, #f48ca8 45%, #e96b8f 100%);
                color: #fff;
                border-radius: 24px;
                padding: 28px;
                box-shadow: 0 18px 34px rgba(244, 63, 125, .22);
            }

            .wallet-label {
                font-size: 14px;
            }

            .wallet-count {
                font-size: 52px;
                font-weight: 800;
                margin-top: 10px;
            }

            .wallet-desc {
                margin-top: 8px;
                font-size: 14px;
                opacity: .9;
            }

            /* 중앙 퀵메뉴 */
            .quick-grid {
                display: grid;
                grid-template-columns: repeat(5, 1fr);
                gap: 10px;
            }

            .quick-card {
                background: #fff;
                border: 1px solid #fde2ec;
                border-radius: 16px;
                padding: 14px 8px;
                text-align: center;
                cursor: pointer;
                transition: all .22s ease;
                min-height: 78px;
            }

            .quick-card:hover {
                transform: translateY(-4px);
                border-color: #f9a8c3;
                background: linear-gradient(180deg, #fff1f6 0%, #ffe4ee 100%);
            }

            .quick-icon {
                font-size: 20px;
                margin-bottom: 6px;
            }

            .quick-card p {
                font-size: 13px;
                margin: 0;
                font-weight: 600;
                color: #333;
            }

            @media(max-width:1000px) {
                .quick-grid {
                    grid-template-columns: repeat(3, 1fr);
                }
            }

            @media(max-width:700px) {
                .quick-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            /* 하단 박스 */
            .content-box {
                background: #fff;
                border-radius: 22px;
                padding: 24px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, .05);
            }

            .tab-menu {
                display: flex;
                gap: 8px;
                margin-bottom: 20px;
            }

            .tab-menu button {
                border: none;
                background: #f2f4f7;
                padding: 10px 16px;
                border-radius: 10px;
                cursor: pointer;
            }

            .tab-menu button.active {
                background: #2b6fff;
                color: #fff;
            }

            .history-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 0;
                border-bottom: 1px solid #f1f1f1;
            }

            .history-item strong {
                font-size: 15px;
            }

            .history-item p {
                margin-top: 4px;
                font-size: 12px;
                color: #999;
            }

            .plus-count {
                font-weight: 700;
                color: #16a34a;
            }

            .pay-info {
                text-align: right;
            }

            .pay-info span {
                display: block;
                font-weight: 700;
            }

            .pay-info small {
                color: #888;
            }

            .empty-box {
                text-align: center;
                padding: 40px 0;
                color: #aaa;
            }

            /* 쿠폰함 */
            /* 상단 제목줄 */
            .title-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                min-height: 48px;
                margin-bottom: 18px;
                padding-bottom: 10px;
                border-bottom: 1px solid #f1f3f5;
            }

            .title-right {
                min-width: 120px;
                display: flex;
                justify-content: flex-end;
            }

            .title-row select {
                padding: 8px 10px;
                border: 1px solid #ddd;
                border-radius: 8px;
            }

            .title-row select:focus {
                outline: none;
                border-color: #f9a8c3;
            }

            /* 제목 */
            .pass-title {
                margin: 0;
                font-size: 20px;
                font-weight: 700;
                color: #e11d74;
            }

            /* 공통 박스 */
            .pass-box {
                background: #fff;
                border: 1px solid #edf0f4;
                border-radius: 16px;
                padding: 18px 22px;
                margin-bottom: 14px;
                box-shadow: 0 6px 14px rgba(0, 0, 0, .04);
                transition: .2s;
            }

            .pass-box:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 18px rgba(0, 0, 0, .06);
            }

            /* 모바일 */
            @media(max-width:768px) {

                .title-row {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 6px;
                }

                .pass-title {
                    font-size: 18px;
                }

                .pass-box {
                    padding: 16px;
                }
            }

            /* 페이지 */
            .page-box {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 20px;
            }

            .page-box button {
                border: none;
                background: #f2f4f7;
                min-width: 36px;
                height: 36px;
                border-radius: 10px;
            }

            .page-box button.active {
                background: #f43f7d;
                color: #fff;
            }

            /* 모달 */
            .modal-wrap {
                position: fixed;
                inset: 0;
                z-index: 99999;

                display: flex !important;
                justify-content: center !important;
                align-items: center !important;

                padding: 20px;

                background: rgba(0, 0, 0, 0.45);
                backdrop-filter: blur(6px);
                -webkit-backdrop-filter: blur(6px);
            }

            .guide-modal {
                width: 100%;
                max-width: 520px;
                background: #fff;
                border-radius: 22px;
                padding: 26px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, .18);

                position: relative;
            }

            /* 등장 */
            @keyframes modalFade {
                from {
                    opacity: 0;
                    transform: translateY(12px) scale(.98);
                }

                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            /* 헤더 */
            .modal-head {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 22px;
            }

            .modal-head h3 {
                margin: 0;
                font-size: 22px;
                font-weight: 800;
                color: #111827;
            }

            /* 닫기 버튼 */
            .close-btn {
                width: 36px;
                height: 36px;
                border: none;
                border-radius: 50%;
                background: #f3f4f6;
                cursor: pointer;
                font-size: 16px;
                transition: .2s;
            }

            .close-btn:hover {
                background: #e5e7eb;
            }

            /* 본문 */
            .guide-body {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            /* 항목 */
            .guide-item {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 14px 16px;
                background: #f8fafc;
                border-radius: 14px;
            }

            .guide-num {
                min-width: 34px;
                height: 34px;
                border-radius: 50%;
                background: #f43f7d;
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 700;
            }

            .guide-item p {
                margin: 0;
                font-size: 14px;
                line-height: 1.5;
                color: #374151;
                padding-top: 4px;
            }

            /* 하단 */
            .guide-footer {
                margin-top: 22px;
            }

            /* 버튼 */
            .cs-btn {
                width: 100%;
                height: 48px;
                border: none;
                border-radius: 14px;
                background: linear-gradient(135deg, #ff5f95, #f43f7d);
                color: #fff;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                transition: .2s;
            }

            .cs-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 12px 22px rgba(244, 63, 125, .24);
            }

            /* 모바일 */
            @media(max-width:768px) {

                .guide-modal {
                    padding: 22px 18px;
                    border-radius: 20px;
                }

                .modal-head h3 {
                    font-size: 20px;
                }

                .guide-item {
                    padding: 12px;
                }

                .cs-btn {
                    height: 46px;
                }
            }

            .empty-row {
                height: 95.5px;
                visibility: hidden;
                pointer-events: none;
                border-bottom: 1px solid transparent;

            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div id="wrapper">
                <div class="main-content">
                    <div class="right-sections">

                        <section class="wallet-page">

                            <!-- 상단 보유 카드 -->
                            <div class="wallet-card">
                                <div class="wallet-count">
                                    내 열람권 : {{ remainingCount }}회
                                </div>

                                <p class="wallet-desc">
                                    필요한 순간마다 자유롭게 사용 가능한 열람권입니다.
                                    패스를 구매하시면 열람권이 즉시 지급됩니다.
                                </p>

                            </div>

                            <!-- 퀵 메뉴 -->
                            <div class="quick-grid">
                                <button class="quick-card" @click="fnChangeTab('charge')">
                                    <span>⚡</span>
                                    <p>최근 충전내역</p>
                                </button>

                                <div class="quick-card" @click="fnChangeTab('payment')">
                                    <div class="quick-icon">🧾</div>
                                    <p>결제내역</p>
                                </div>

                                <div class="quick-card" @click="fnChangeTab('coupon')">
                                    <div class="quick-icon">🎁</div>
                                    <p>쿠폰함</p>
                                </div>

                                <div class="quick-card" @click="fnMove('passBuy')">
                                    <div class="quick-icon">💳</div>
                                    <p>패스 구매</p>
                                </div>

                                <div class="quick-card" @click="showGuide = true">
                                    <div class="quick-icon">❓</div>
                                    <p>이용안내</p>
                                </div>

                            </div>

                            <!-- 하단 컨텐츠 -->
                            <div class="content-box">
                                <!-- 최근 충전내역 -->
                                <div v-if="currentTab == 'charge'">
                                    <div class="title-row">
                                        <p class="pass-title">최근 충전 내역</p>
                                    </div>
                                    <div class="history-item" v-for="item in passList2" :key="item.payNo">
                                        <div>
                                            <strong>{{ item.itemName }}</strong>
                                            <p>{{ item.payDate }}</p>
                                        </div>
                                        <div class="pay-info plus-count">
                                            <span>열람권 +{{ item.reviewCnt }}회</span>
                                            <small>{{ fnStatusText(item.payStatus) }}</small>
                                        </div>
                                    </div>
                                    <div class="history-item empty-row" v-for="n in (pageSize - passList2.length)"
                                        :key="'empty'+n">
                                    </div>
                                    <div v-if="passList2.length == 0" class="empty-box">
                                        충전 내역이 없습니다.
                                    </div>
                                    <div class="page-box dummy-page">
                                        <button disabled>‹</button>
                                        <button class="active">1</button>
                                        <button disabled>›</button>
                                    </div>
                                </div>

                                <!-- 결제내역 -->
                                <div v-if="currentTab == 'payment'">
                                    <!-- 필터 -->
                                    <div class="title-row">
                                        <p class="pass-title">결제내역</p>
                                        <div class="title-right">
                                            <select v-model="payStatus" @change="fnGetMyPassList()">
                                                <option value="ALL">결제상태</option>
                                                <option value="SUCCESS">결제완료</option>
                                                <option value="CANCEL">취소/환불</option>
                                                <option value="FAIL">결제실패</option>
                                            </select>
                                        </div>
                                    </div>
                                    <!-- 내역 -->
                                    <div class="history-item" v-for="item in passList" :key="item.payNo">
                                        <div>
                                            <strong>{{ item.itemName }}</strong>
                                            <p>{{ item.payDate }}</p>
                                        </div>

                                        <div class="pay-info">
                                            <span>{{ item.amount.toLocaleString() }}원</span>
                                            <small>{{ fnStatusText(item.payStatus) }}</small>
                                        </div>
                                    </div>
                                    <div class="history-item empty-row" v-for="n in (pageSize - passList.length)"
                                        :key="'empty'+n">
                                    </div>
                                    
                                    <div v-if="passList.length == 0" class="empty-box">
                                        결제 내역이 없습니다.
                                    </div>
                                    <!-- 페이지 -->
                                    <div class="page-box">
                                        <button @click="fnPageMove(currentPage-1)" :disabled="currentPage==1">‹</button>
                                        <button v-for="p in index" :key="p" @click="fnPageMove(p)"
                                            :class="{active : currentPage == p}">
                                            {{ p }}
                                        </button>
                                        <button @click="fnPageMove(currentPage+1)"
                                            :disabled="currentPage==index">›</button>
                                    </div>
                                </div>
                                <!-- 쿠폰함 -->
                                <div v-if="currentTab=='coupon'">
                                    <div class="title-row">
                                        <p class="pass-title">쿠폰함</p>
                                        <div class="title-right">
                                            <select v-model="status" @change="fnGetMyCouponList">
                                                <option value="ALL">사용여부</option>
                                                <option value="UNUSED">미사용</option>
                                                <option value="USED">사용</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div v-if="couponList.length > 0">

                                        <div class="history-item" v-for="coupon in couponList" :key="coupon.couponNo">

                                            <div>
                                                <strong>{{ coupon.couponName }}</strong>
                                                <p>만료일 {{ coupon.expiredAt }}</p>
                                            </div>
                                            <div class="pay-info">
                                                <span>{{ coupon.discountRate }}%</span>
                                                <small>{{ fnStatusText(coupon.status) }}</small>
                                            </div>

                                        </div>
                                        <div class="history-item empty-row" v-for="n in (pageSize - couponList.length)"
                                            :key="'empty'+n">
                                        </div>
                                    </div>

                                    <div v-else class="empty-box">
                                        보유 쿠폰이 없습니다.
                                    </div>
                                    <!-- 페이지 -->
                                    <div class="page-box">
                                        <button @click="fnCouponPageMove(couponPage-1)"
                                            :disabled="couponPage==1">‹</button>
                                        <button v-for="p in couponIndex" :key="p" @click="fnCouponPageMove(p)"
                                            :class="{active : couponPage == p}">
                                            {{ p }}
                                        </button>
                                        <button @click="fnCouponPageMove(couponPage+1)"
                                            :disabled="couponPage==couponIndex">›</button>
                                    </div>
                                </div>


                            </div>

                        </section>
                    </div>
                </div>
            </div>
            <!-- 이용안내모달 -->
            <div v-if="showGuide" class="modal-wrap" @click="showGuide=false">

                <div class="guide-modal" @click.stop>
                    <!-- 헤더 -->
                    <div class="modal-head">
                        <h3>이용안내</h3>
                        <button class="close-btn" @click="showGuide=false">✕</button>
                    </div>

                    <!-- 설명 -->
                    <div class="guide-body">

                        <div class="guide-item">
                            <span class="guide-num">01</span>
                            <p>패스 구매 시 열람권이 즉시 지급됩니다.</p>
                        </div>

                        <div class="guide-item">
                            <span class="guide-num">02</span>
                            <p>유료리뷰 열람 시 1회 차감됩니다.</p>
                        </div>

                        <div class="guide-item">
                            <span class="guide-num">03</span>
                            <p>보유 열람권은 마이페이지에서 확인 가능합니다.</p>
                        </div>

                        <div class="guide-item">
                            <span class="guide-num">04</span>
                            <p>쿠폰은 결제성공 시 즉시 소멸되며, 환불 처리 되더라도 복구되지 않습니다.</p>
                        </div>

                        <div class="guide-item">
                            <span class="guide-num">05</span>
                            <p>환불/문의는 고객센터를 이용해주세요.</p>
                        </div>

                    </div>
                    <!-- 하단 버튼 -->
                    <div class="guide-footer">
                        <button class="cs-btn" @click="fnMove('cs')">
                            고객센터 문의하기
                        </button>
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
                    passList: [],
                    passList2: [],
                    couponList: [],
                    sessionId: "${sessionScope.sessionId}",
                    sessionRole: "${sessionScope.sessionRole}",
                    remainingCount: 0,
                    showGuide: false,
                    currentTab: "charge",
                    payStatus: "ALL",
                    status: "ALL",
                    pageSize: 3,
                    index: 1,
                    currentPage: 1,
                    couponIndex: 1,
                    couponPage: 1,
                };
            },
            methods: {
                fnGetMyPassList: function () {
                    let self = this;
                    let param = {
                        userId: self.sessionId,
                        pageSize: self.pageSize,
                        offSet: self.pageSize * (self.currentPage - 1),
                        payStatus: self.payStatus,

                    };
                    $.ajax({
                        url: "http://localhost:8080/MyPassList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            console.log(data.list);
                            self.passList = data.list || [];
                            self.passList2 = self.passList.slice(0, 3);  //자동으로 0번부터 2번, 3개까지 있는만큼만 잘라줌

                            self.index = Math.ceil(data.totalCount / self.pageSize);
                            self.remainingCount = data.remainingCount;

                        }
                    });
                },
                fnGetMyCouponList: function () {
                    let self = this;
                    let param = {
                        userId: self.sessionId,
                        pageSize: self.pageSize,
                        offSet: self.pageSize * (self.couponPage - 1),
                        status: self.status,
                    };
                    $.ajax({
                        url: "http://localhost:8080/couponUseList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            console.log(data.list);
                            self.couponList = data.list || [];
                            self.couponIndex = Math.ceil(data.totalCount / self.pageSize);
                        }
                    });
                },
                fnPageMove(p) {
                    if (p < 1 || p > this.index) return;
                    this.currentPage = p;
                    this.fnGetMyPassList();
                },
                fnCouponPageMove(p) {

                    if (p < 1 || p > this.couponIndex) return;

                    this.couponPage = p;
                    this.fnGetMyCouponList();
                },
                fnMove(page) {

                    const path = {
                        passBuy: "/adminPass.do",
                        cs: "/userMyPage-cs-list.do"
                    };

                    if (path[page]) {
                        location.href = "${pageContext.request.contextPath}" + path[page];
                    }
                },
                fnChangeTab(type) {

                    this.currentTab = type;
                    this.currentPage = 1;

                    if (type == "charge") {
                        this.fnGetMyPassList();
                    }

                    if (type == "payment") {
                        this.fnGetMyPassList();
                    }

                    if (type == "coupon") {
                        this.couponPage = 1;
                        this.fnGetMyCouponList();
                    }
                },
                fnStatusText(status) {

                    if (status == "SUCCESS") return "결제완료";
                    if (status == "CANCEL") return "취소/환불";
                    if (status == "FAIL") return "결제실패";
                    if (status == "UNUSED") return "미사용";
                    if (status == "USED") return "사용";
                    return status;
                },

            }, // methods
            mounted() {
                let self = this;
                self.fnGetMyPassList();
            },

        });

        app.mount('#app');
    </script>
    </body>

    </html>