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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home-style.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<style>
    .review-card, .post-card {
    cursor: pointer;
}
</style>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">
                <div class="left-banner">
                    <div class="main-banner-img">
                        <span class="img-placeholder"></span>
                    </div>
                </div>
                <div class="right-sections">
                    <section class="review-section">
                        <div class="section-title-wrap">
                                <h2>이유있는 선택!</h2>
                        </div>

                        <div class="hash-tag-wrap">
                            <span>#감동</span> <span>#행복</span> <span>#결혼준비</span>
                            <div class="review-tag">
                                <span>리얼후기</span>
                            </div>
                        </div>

                        <p class="section-desc">메리뷰를 선택한 소중한 신랑, 신부님들의 리얼한 후기를 확인하세요.</p>
                        <div class="review-grid">
                            <div class="review-card" v-for="review in reviewList" :key="review.reviewNo"
                                @click="fnGoReview(review.reviewNo)">
                                <div class="review-img-thumb">
                                    <img v-if="review.imgUrl" :src="review.imgUrl" 
                                        style="width:100%; height:100%; object-fit:cover;">
                                </div>
                                <p class="review-title">{{ review.title }}</p>
                            </div>
                        </div>
                    </section>

                    <section class="community-section">
                        <div class="section-header">
                            <h2>커뮤니티 인기글</h2>
                            <a href="/api/community/list.do" class="more-link">더보기 ></a>
                        </div>

                        <div class="post-grid">
                            <div class="post-card" v-for="post in postList" :key="post.postNo"
                                @click="fnGoPost(post.postNo)">
                                <p class="post-text">{{ post.title }}</p>
                                <div class="post-info">
                                    <span><i class="icon-thumb">👍</i> {{ post.likeCnt }}</span>
                                    <span class="post-views">조회 {{ post.viewCnt }}</span>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                reviewList: [],
                postList: [],
            };
        },
        methods: {
            fnGoPost: function(postNo) {
                location.href = '/api/community/detail.do?postNo=' + postNo;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            },
        }, // methods
        mounted() {
            let self = this;
            axios.get("/mainReviewList.dox")
                .then(res => { self.reviewList = res.data; });
            axios.get("/mainPostList.dox")
                .then(res => { self.postList = res.data; });
        }
    });

    app.mount('#app');
</script>