<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
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

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 쿠폰 페이지 전용 스타일만 남김 --%>
    <style>
        .coupon-section {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            border: 1px solid #eee;
            width: 100%;
            max-width: 800px;
            height: fit-content;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }

        .coupon-list {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .coupon-item {
            border: 1px solid #ffd1d1;
            background-color: #fff9f9;
            padding: 25px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .coupon-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .coupon-discount {
            margin-left: 10px;
            color: #ff6b6b;
            font-weight: bold;
        }

        .coupon-date {
            color: #888;
            font-size: 13px;
        }

        .coupon-footer {
            margin-top: 30px;
            text-align: right;
        }

        .btn-register {
            background-color: #ffc107;
            color: #333;
            padding: 12px 25px;
            border-radius: 6px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .coupon-input-field {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-right: 10px;
            width: 250px;
            outline: none;
        }

        .coupon-input-field:focus {
            border-color: #f4a096;
        }

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
            color: #f4a096;
            border: 1.5px solid #f4a096;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-page-arrow:hover,
        .btn-page-num:hover {
            background-color: #f4a096;
            color: white;
        }

        .btn-page-num.active-page {
            background-color: #f4a096;
            color: white;
            font-weight: bold;
        }

        .btn-page-arrow:disabled {
            opacity: 0.3;
            cursor: not-allowed;
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
                    <section class="coupon-section">
                        <div class="section-header">
                            <h2>내 쿠폰 목록({{ couponList.length }}개)</h2>
                        </div>

                        <div class="coupon-list">
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

                        <div class="coupon-footer">
                            <input type="text"
                                   v-model="inputCode"
                                   placeholder="쿠폰 번호를 입력하세요"
                                   class="coupon-input-field">
                            <button class="btn-register" @click="fnRegisterCoupon()">쿠폰 등록</button>
                        </div>
                        <!-- 쿠폰 없을 때 -->
                        <div v-if="couponList.length === 0" style="text-align:center; padding:30px 0; color:#999;">
                            보유한 쿠폰이 없습니다.
                        </div>
                    </section>
                    <!-- 페이징 -->
                    <div class="pagination-wrap">
                        <button class="btn-page-arrow" @click="fetchCoupons(currentPage - 1)" :disabled="currentPage === 1">이전</button>
                        <button class="btn-page-num"
                                v-for="p in totalPages" :key="p"
                                :class="p === currentPage ? 'active-page' : ''"
                                @click="fetchCoupons(p)">
                            {{ p }}
                        </button>
                        <button class="btn-page-arrow" @click="fetchCoupons(currentPage + 1)" :disabled="currentPage === totalPages">다음</button>
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
                couponList: [],
                inputCode: "",
                currentPage: 1,
                totalPages: 0
            };
        },
        methods: {
            fetchCoupons(page = 1) {
                let self = this;
                axios.get('/api/myCoupons.do', {
                    params: { currentPage: page }
                })
                .then(function(response) {
                    self.couponList = response.data.list || [];
                    self.totalPages = response.data.totalPages || 0;
                    self.currentPage = response.data.currentPage || 1;
                })
                .catch(function(error) {
                    console.error("쿠폰 로드 중 에러 발생:", error);
                });
            },
            fnRegisterCoupon: function() {
                const self = this;
                if (!self.inputCode || self.inputCode.trim() === "") {
                    alert("쿠폰 번호를 입력해주세요.");
                    return;
                }
                axios.post("/coupon/register.do", { couponCode: self.inputCode })
                    .then(res => {
                        if (res.data.result === "success") {
                            alert("쿠폰이 성공적으로 등록되었습니다! 🎉");
                            self.inputCode = "";
                            self.fetchCoupons();
                        } else {
                            alert(res.data.message || "등록에 실패했습니다. 코드를 확인해주세요.");
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        alert("등록 중 오류가 발생했습니다.");
                    });
            }
        },
        mounted() {
            this.fetchCoupons();
        }
    });

    app.mount('#app');
</script>
</body>
</html>