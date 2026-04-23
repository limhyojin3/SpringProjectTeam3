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
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">

                <%-- ✅ 사이드바 공용 include --%>
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />
                <div class="right-sections">
                    <h4>리뷰 열람 내역</h4>
                    <!-- 탭 버튼 -->
                    <div class="review-tab-wrap">
                        <button class="review-tab" :class="{'active-tab': reviewTab === 'paid'}" @click="switchReviewTab('paid')">유료리뷰</button>
                        <button class="review-tab" :class="{'active-tab': reviewTab === 'free'}" @click="switchReviewTab('free')">무료 리뷰</button>
                    </div>

                    <!-- 유료 리뷰 목록 -->
                    <div class="review-list" v-show="reviewTab === 'paid'">
                        <div class="review-card" v-for="review in paidReviewList" :key="review.reviewNo"
                            @click="fnGoReview(review.reviewNo)">
                            <div class="review-thumbnail">
                                <img v-if="review.imgUrl" 
                                    :src="review.imgUrl" 
                                    style="width:100%; height:100%; object-fit:cover;">
                                <span v-else>썸네일</span>
                            </div>
                            <div class="review-card-title">{{ review.title }}</div> <!--제목-->
                            <div class="review-card-title">{{ review.comName }}</div> <!--업체 명-->
                        </div>
                    </div>

                    <!-- 무료 리뷰 목록 -->
                    <div v-show="reviewTab === 'free'">
                        <div class="review-list-item" v-for="review in freeReviewList" :key="review.reviewNo"
                            @click="fnGoReview(review.reviewNo)">
                            {{ review.title }} - {{ review.comName }}
                        </div>
                    </div>

                    <!-- 인덱스 버튼 -->
                    <div class="review-index-wrap">
                        <button class="btn-review-index">상세 리뷰 인덱스</button>
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
                freeReviewList: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            }
            
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // 유료 리뷰 조회
            axios.get("/myPaidReviewList.dox")
                .then(res => {
                    self.paidReviewList = res.data;
                });
            // 무료 리뷰 조회
            axios.get("/myFreeReviewList.dox")
                .then(res => {
                    self.freeReviewList = res.data;
                });
        }
    });

    app.mount('#app');
</script>
</body>
</html>