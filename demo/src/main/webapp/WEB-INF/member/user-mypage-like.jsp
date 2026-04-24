<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좋아요 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 좋아요 목록 페이지 전용 스타일만 --%>
    <style>
        .write-tab-wrap {
            display: flex;
            gap: 0px;
            margin-bottom: 20px;
        }

        .write-tab {
            flex: 1;
            padding: 12px 0;
            border: 2px solid #f4a096;
            background-color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            border-radius: 6px;
            transition: 0.2s;
        }

        .write-tab.active-tab {
            background-color: #f4a096;
            color: white;
        }

        .write-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .write-table th {
            background-color: #ffc7c2;
            padding: 10px;
            text-align: center;
            border: 1px solid #f4a096;
            font-weight: bold;
        }

        .write-table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #eee;
            color: #555;
        }

        .write-table tr:hover {
            background-color: #fff0ef;
        }

        .col-check { width: 40px; }
        .col-no    { width: 80px; }
        .col-date  { width: 120px; }
        .col-view  { width: 60px; }
        .col-like  { width: 60px; }

        .write-table td.col-title,
        .write-table td.col-product { text-align: left; }

        .write-table td:nth-child(3) {
            text-align: left;
            cursor: pointer;
        }

        .write-table td:nth-child(3):hover {
            color: #f4a096;
            text-decoration: underline;
        }

        .review-index-wrap {
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        .btn-select-all {
            padding: 8px 20px;
            background-color: #f0b429;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
        }

        .btn-delete {
            padding: 8px 20px;
            background-color: #f0b429;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
        }

        .btn-select-all:hover, .btn-delete:hover {
            opacity: 0.85;
        }

        .write-table tbody tr {
            cursor: pointer;
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
                    <h4>좋아요 목록</h4>
                    <!-- 탭 버튼 -->
                    <div class="write-tab-wrap">
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'company'}" @click="switchReviewTab('company')">업체</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'post'}" @click="switchReviewTab('post')">글</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'review'}" @click="switchReviewTab('review')">리뷰</button>
                    </div>
                    <!-- 좋아한 업체 테이블 -->
                    <table class="write-table" v-if="reviewTab === 'company'">
                        <thead>
                            <tr>
                                <th class="col-no">번호</th>
                                <th class="col-title">업체명</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="companyLikeList.length === 0">
                                <td colspan="3">좋아요한 업체가 없습니다.</td>
                            </tr>
                            <tr v-for="like in companyLikeList" :key="like.likeNo"
                            >
                                <td>{{ like.likeNo }}</td>
                                <td class="col-title">{{ like.comName }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 좋아요 글 테이블 -->
                    <table class="write-table" v-if="reviewTab === 'post'">
                        <thead>
                            <tr>
                                <th class="col-no">번호</th>
                                <th class="col-title">제목</th>
                                <th>카테고리</th>
                                <th class="col-view">조회</th>
                                <th class="col-date">작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="postLikeList.length === 0">
                                <td colspan="5">좋아요한 글이 없습니다.</td>
                            </tr>
                            <tr v-for="like in postLikeList" :key="like.likeNo"
                                @click="fnGoPost(like.postNo)">
                                <td>{{ like.likeNo }}</td>
                                <td class="col-title">{{ like.title }}</td>
                                <td>{{ like.category }}</td>
                                <td>{{ like.viewCnt }}</td>
                                <td>{{ like.regDate }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 좋아요 리뷰 테이블 -->
                    <table class="write-table" v-if="reviewTab === 'review'">
                        <thead>
                            <tr>
                                <th class="col-no">번호</th>
                                <th class="col-title">제목</th>
                                <th>평점</th>
                                <th class="col-date">작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="reviewLikeList.length === 0">
                                <td colspan="4">좋아요한 리뷰가 없습니다.</td>
                            </tr>
                            <tr v-for="like in reviewLikeList" :key="like.likeNo"
                                @click="fnGoReview(like.reviewNo)">
                                <td>{{ like.likeNo }}</td>
                                <td class="col-title">{{ like.title }}</td>
                                <td>{{ like.rating }}</td>
                                <td>{{ like.regDate }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 하단 버튼 -->
                    <div class="review-index-wrap">
                        <button class="btn-select-all">전체 선택</button>
                        <button class="btn-delete">삭제</button>
                    </div>
                </div>
            </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                reviewTab: 'company',  // 'company' or 'post' or 'review'
                companyLikeList: [],
                postLikeList: [],
                reviewLikeList: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            fnGoPost: function(postNo) {
                location.href = '/api/community/detail.do?postNo=' + postNo;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            axios.get("/myCompanyLikeList.dox")
                .then(res => { self.companyLikeList = res.data; });
            axios.get("/myPostLikeList.dox")
                .then(res => { self.postLikeList = res.data; });
            axios.get("/myReviewLikeList.dox")
                .then(res => { self.reviewLikeList = res.data; });
        }
    });

    app.mount('#app');
</script>
</body>
</html>