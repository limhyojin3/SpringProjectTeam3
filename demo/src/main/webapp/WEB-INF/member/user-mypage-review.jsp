<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 조회 내역</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 리뷰 조회 내역 페이지 전용 스타일만 --%>
    <style>
        .review-tab-wrap {
            display: flex;
            gap: 0;
            margin-bottom: 20px;
        }

        .review-tab {
            flex: 1;
            padding: 12px 0;
            border: 1px solid #ffc7c2;
            background-color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
            color: #e07a8a;
        }

        .review-tab:first-child { border-radius: 8px 0 0 8px; }
        .review-tab:last-child { border-radius: 0 8px 8px 0; }

        .review-tab.active-tab {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        /* 리뷰 카드 */
        .review-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }


        .review-card {
            border: 1px solid #f0e0e0;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            transition: 0.2s;
            display: flex;
            flex-direction: column;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .review-card:hover {
            box-shadow: 0 6px 20px rgba(244, 160, 150, 0.25);
            transform: translateY(-3px);
        }

        .review-thumbnail {
            width: 100%;
            height: 140px;
            background-color: #fff0f3;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .review-card-title {
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            background-color: white;
            color: #444;
            border-top: 1px solid #f5f5f5;
        }

        .review-card-title:last-child {
            font-size: 12px;
            color: #aaa;
            font-weight: 400;
        }


        .review-list-item {
            padding: 12px 15px;
            background-color: #e07a8a;
            color: white;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 8px;
            transition: 0.2s;
        }

        .review-list-item:hover {
            background-color: #e07a8a;
        }

        /* 페이지네이션 */
        .review-index-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 6px;
        }

        .btn-review-index {
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

        .btn-review-index:hover {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        .btn-review-index.active-page {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
            font-weight: bold;
        }

        .btn-review-index:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }

        .thumbnail-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* 빈 메시지 */
        .empty-msg {
            text-align: center;
            padding: 60px 0;
            color: #bbb;
            font-size: 14px;
        }
        h4 {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f4a096;
        }
        i {
            margin-right: 8px;
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
                    <h4><i class="fas fa-book-open"></i> 리뷰 열람 내역</h4>
                    <!-- 탭 버튼 -->
                    <div class="review-tab-wrap">
                        <button class="review-tab" :class="{'active-tab': reviewTab === 'paid'}" @click="switchReviewTab('paid')">유료리뷰</button>
                        <button class="review-tab" :class="{'active-tab': reviewTab === 'free'}" @click="switchReviewTab('free')">무료 리뷰</button>
                    </div>

                    <!-- 유료 리뷰 목록 -->
                    <div v-if="reviewTab === 'paid'">
                        <div class="review-list" v-if="paidReviewList.length > 0">
                            <div class="review-card" v-for="review in paidReviewList" :key="review.reviewNo"
                                @click="fnGoReview(review.reviewNo)">
                                <div class="review-thumbnail">
                                    <img v-if="review.thumbnailUrl" 
                                        :src="review.thumbnailUrl" 
                                        class="thumbnail-img" 
                                        @error="handleImgError">
                                        
                                    <img v-else 
                                        src="/img/default_logo.png" 
                                        class="thumbnail-img">
                                </div>
                                <div class="review-card-title">{{ review.title }}</div>
                                <div class="review-card-title">{{ review.comName }}</div>
                            </div>
                        </div>
                        <div class="empty-msg" v-else>
                            열람 기록이 없습니다.
                        </div>
                         <!-- 페이지 인덱스 -->
                        <div class="review-index-wrap">
                            <button class="btn-review-index" @click="fetchPaidReviews(paidCurrentPage - 1)" :disabled="paidCurrentPage === 1">이전</button>
                            <button class="btn-review-index"
                                v-for="p in Math.ceil(paidTotalCount / pageSize)" :key="p"
                                :class="p === paidCurrentPage ? 'active-page' : ''"
                                @click="fetchPaidReviews(p)">
                                {{ p }}
                            </button>
                            <button class="btn-review-index" @click="fetchPaidReviews(paidCurrentPage + 1)" :disabled="paidCurrentPage === Math.ceil(paidTotalCount / pageSize)">다음</button>
                        </div>
                    </div>
                    
                    <!-- 무료 리뷰 목록 -->
                    <div v-if="reviewTab === 'free'">
                        <div class="review-list">
                            <div class="review-card" v-for="review in freeReviewList" :key="review.reviewNo"
                                @click="fnGoReview(review.reviewNo)">
                                <div class="review-thumbnail">
                                    <img v-if="review.thumbnailUrl" 
                                        :src="review.thumbnailUrl" 
                                        class="thumbnail-img" 
                                        @error="handleImgError">
                                        
                                    <img v-else 
                                        src="/img/default_logo.png" 
                                        class="thumbnail-img">
                                </div>
                                <div class="review-card-title">{{ review.title }}</div> <!--제목-->
                                <div class="review-card-title">{{ review.comName }}</div> <!--업체 명-->
                            </div>
                        </div>
                        <!-- 페이지 -->
                        <div class="review-index-wrap">
                            <button class="btn-review-index" @click="fetchFreeReviews(freeCurrentPage - 1)" :disabled="freeCurrentPage === 1">이전</button>
                            <button class="btn-review-index"
                                v-for="p in Math.ceil(freeTotalCount / pageSize)" :key="p"
                                :class="p === freeCurrentPage ? 'active-page' : ''"
                                @click="fetchFreeReviews(p)">
                                {{ p }}
                            </button>
                            <button class="btn-review-index" @click="fetchFreeReviews(freeCurrentPage + 1)" :disabled="freeCurrentPage === Math.ceil(freeTotalCount / pageSize)">다음</button>
                        </div>
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
                reviewTab: 'paid',  // 'paid' or 'free'
                paidReviewList: [],
                freeReviewList: [],
                // 페이지 사이징
                paidCurrentPage: 1,
                freeCurrentPage: 1,
                paidTotalCount: 0,
                freeTotalCount: 0,
                pageSize: 6
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            // 리뷰 클릭 시 해당 리뷰 상세 보기로 이동
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            },
            // 페이지 로드
            fetchPaidReviews: function(page) {
                let self = this;
                axios.get("/myPaidReviewList.dox?page=" + page)
                    .then(res => {
                        self.paidReviewList = res.data.list;
                        self.paidTotalCount = res.data.totalCount;
                        self.paidCurrentPage = res.data.currentPage;
                    });
            },
            fetchFreeReviews: function(page) {
                let self = this;
                axios.get("myFreeReviewList.dox?page=" + page)
                    .then(res => {
                        self.freeReviewList = res.data.list;
                        self.freeTotalCount = res.data.totalCount;
                        self.freeCurrentPage = res.data.currentPage;
                    });
            },
            handleImgError: function(event) {
                // 이미지가 없으면 해당 이미지만 숨깁니다.
                if (event.target) {
                    event.target.style.display = 'none';
                    
                    // 부모 요소가 있을 때만 배경색을 바꿉니다.
                    const parent = event.target.parentElement;
                    if (parent) {
                        parent.style.backgroundColor = '#ffc7c2';
                    }
                }
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // 유료 리뷰 조회
            this.fetchPaidReviews(1);
            // 무료 리뷰 조회
            this.fetchFreeReviews(1);
        }
    });

    app.mount('#app');
</script>
</body>
</html>