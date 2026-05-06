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
            justify-content: center;
            align-items: center;
            gap: 6px;
        }

        .btn-review-index {
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

        .btn-review-index:hover {
            background-color: #f4a096;
            color: white;
        }

        .btn-review-index.active-page {
            background-color: #f4a096;
            color: white;
            font-weight: bold;
        }

        .btn-review-index:disabled {
            opacity: 0.3;
            cursor: not-allowed;
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
        .bottom-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            margin-top: 30px;
            padding: 10px 0;
            min-height: 40px;
        }
        .bottom-controls .btn-delete {
            position: absolute;
            left: 0;
            background-color: #f0b429;
            color: white;
            border: none;
            padding: 0 15px;
            border-radius: 4px;
            cursor: pointer;
            height: 32px;
            line-height: 1;
            font-size: 14px;
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
                    <h4>좋아요 목록</h4>
                    <!-- 탭 버튼 -->
                    <div class="write-tab-wrap">
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'company'}" @click="switchReviewTab('company')">업체</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'post'}" @click="switchReviewTab('post')">글</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'review'}" @click="switchReviewTab('review')">리뷰</button>
                    </div>
                    <!-- 좋아한 상품 테이블 -->
                    <div v-if="reviewTab === 'company'">
                        <table class="write-table" >
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllCompanyLikes()"></th>
                                    <th class="col-no">번호</th>
                                    <th class="col-title">업체명</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="companyLikeList.length === 0">
                                    <td colspan="3">좋아요한 업체가 없습니다.</td>
                                </tr>
                                <tr v-for="like in companyLikeList" :key="like.likeNo">
                                    <td @click.stop><input type="checkbox" :value="like.likeNo" v-model="selectedCompanyLikes"></td>
                                    <td>{{ like.likeNo }}</td>
                                    <td class="col-title">{{ like.comName }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 좋아요 글 테이블 -->
                    <div v-if="reviewTab === 'post'">
                        <table class="write-table" >
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllPostLikes()"></th>
                                    <th class="col-no">번호</th>
                                    <th class="col-title">제목</th>
                                    <th>카테고리</th>
                                    <th class="col-view">조회</th>
                                    <th class="col-date">작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="postLikeList.length === 0">
                                    <td colspan="6">좋아요한 글이 없습니다.</td>
                                </tr>
                                <tr v-for="like in postLikeList" :key="like.likeNo"
                                    @click="fnGoPost(like.postNo)">
                                    <td @click.stop><input type="checkbox" :value="like.likeNo" v-model="selectedPostLikes"></td>
                                    <td>{{ like.likeNo }}</td>
                                    <td class="col-title">{{ like.title }}</td>
                                    <td>{{ like.category }}</td>
                                    <td>{{ like.viewCnt }}</td>
                                    <td>{{ like.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 좋아요 리뷰 테이블 -->
                    <div v-if="reviewTab === 'review'">
                        <table class="write-table">
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllReviewLikes()"></th>
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
                                    <td @click.stop><input type="checkbox" :value="like.likeNo" v-model="selectedReviewLikes"></td>
                                    <td>{{ like.likeNo }}</td>
                                    <td class="col-title">{{ like.title }}</td>
                                    <td>{{ like.rating }}</td>
                                    <td>{{ like.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 하단 버튼 -->
                    <div class="review-index-wrap">
                        <template v-if="reviewTab === 'company'">
                            <button class="btn-review-index"
                                    @click="fetchCompanyLikeList(companyCurrentPage - 1)"
                                    :disabled="companyCurrentPage === 1">이전</button>
                            <button class="btn-review-index"
                                    v-for="p in Math.ceil(companyTotalCount / pageSize)" :key="'company-'+p"
                                    :class="p === companyCurrentPage ? 'active-page' : ''"
                                    @click="fetchCompanyLikeList(p)">
                                {{ p }}
                            </button>
                            <button class="btn-review-index"
                                    @click="fetchCompanyLikeList(companyCurrentPage + 1)"
                                    :disabled="companyCurrentPage === Math.ceil(companyTotalCount / pageSize)">다음</button>
                        </template>

                        <template v-else-if="reviewTab === 'post'">
                            <button class="btn-review-index"
                                    @click="fetchPostLikeList(postCurrentPage - 1)"
                                    :disabled="postCurrentPage === 1">이전</button>
                            <button class="btn-review-index"
                                    v-for="p in Math.ceil(postTotalCount / pageSize)" :key="'post-'+p"
                                    :class="p === postCurrentPage ? 'active-page' : ''"
                                    @click="fetchPostLikeList(p)">
                                {{ p }}
                            </button>
                            <button class="btn-review-index"
                                    @click="fetchPostLikeList(postCurrentPage + 1)"
                                    :disabled="postCurrentPage === Math.ceil(postTotalCount / pageSize)">다음</button>
                        </template>

                        <template v-else-if="reviewTab === 'review'">
                            <button class="btn-review-index"
                                    @click="fetchReviewLikeList(reviewCurrentPage - 1)"
                                    :disabled="reviewCurrentPage === 1">이전</button>
                            <button class="btn-review-index"
                                    v-for="p in Math.ceil(reviewTotalCount / pageSize)" :key="'review-'+p"
                                    :class="p === reviewCurrentPage ? 'active-page' : ''"
                                    @click="fetchReviewLikeList(p)">
                                {{ p }}
                            </button>
                            <button class="btn-review-index"
                                    @click="fetchReviewLikeList(reviewCurrentPage + 1)"
                                    :disabled="reviewCurrentPage === Math.ceil(reviewTotalCount / pageSize)">다음</button>
                        </template>
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
                reviewTab: 'company',  // 'company' or 'post' or 'review'
                companyLikeList: [],
                postLikeList: [],
                reviewLikeList: [],
                // 페이지
                companyCurrentPage: 1,
                postCurrentPage: 1,
                reviewCurrentPage: 1,
                companyTotalCount: 0,
                postTotalCount: 0,
                reviewTotalCount: 0,
                pageSize: 5,
                // 체크 박스
                selectedCompanyLikes: [],
                selectedPostLikes: [],
                selectedReviewLikes: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            // 클릭 시 해당 상세 보기로 이동
            fnGoPost: function(postNo) {
                location.href = '/api/community/detail.do?postNo=' + postNo;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            },
            // 페이지
            fetchCompanyLikeList: function(page) {
                let self = this;
                axios.get("/myCompanyLikeList.dox?page=" + page)
                    .then(res => {
                        self.companyLikeList = res.data.list;
                        self.companyTotalCount = res.data.totalCount;
                        self.companyCurrentPage = res.data.currentPage;
                    });
            },
            fetchPostLikeList: function(page) {
                let self = this;
                axios.get("/myPostLikeList.dox?page=" + page)
                    .then(res => {
                        self.postLikeList = res.data.list;
                        self.postTotalCount = res.data.totalCount;
                        self.postCurrentPage = res.data.currentPage;
                    });
            },
            fetchReviewLikeList: function(page) {
                let self = this;
                axios.get("/myReviewLikeList.dox?page=" + page)
                    .then(res => {
                        self.reviewLikeList = res.data.list;
                        self.reviewTotalCount = res.data.totalCount;
                        self.reviewCurrentPage = res.data.currentPage;
                    });
            },
            // 체크 박스 선택
            selectAllCompanyLikes: function() {
                if(this.selectedCompanyLikes.length === this.companyLikeList.length) {
                    this.selectedCompanyLikes = [];
                } else {
                    this.selectedCompanyLikes = this.companyLikeList.map(l => l.likeNo);
                }
            },
            selectAllPostLikes: function() {
                if(this.selectedPostLikes.length === this.postLikeList.length) {
                    this.selectedPostLikes = [];
                } else {
                    this.selectedPostLikes = this.postLikeList.map(l => l.likeNo);
                }
            },
            selectAllReviewLikes: function() {
                if(this.selectedReviewLikes.length === this.reviewLikeList.length) {
                    this.selectedReviewLikes = [];
                } else {
                    this.selectedReviewLikes = this.reviewLikeList.map(l => l.likeNo);
                }
            },
            // 선택 삭제
            deleteLikeSelected: function() {
                let self = this;
                if(this.reviewTab === 'company') {
                    if(self.selectedCompanyLikes.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 업체 좋아요를 취소하시겠습니까?")) return;
                    Promise.all(self.selectedCompanyLikes.map(likeNo =>
                        axios.post("/deleteMyCompanyLike.dox", { likeNo: String(likeNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedCompanyLikes = [];
                        self.fetchCompanyLikeList(self.companyCurrentPage);
                    });
                } else if(this.reviewTab === 'post') {
                    if(self.selectedPostLikes.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 글 좋아요를 취소하시겠습니까?")) return;
                    Promise.all(self.selectedPostLikes.map(likeNo =>
                        axios.post("/deleteMyPostLike.dox", { likeNo: String(likeNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedPostLikes = [];
                        self.fetchPostLikeList(self.postCurrentPage);
                    });
                } else if(this.reviewTab === 'review') {
                    if(self.selectedReviewLikes.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 리뷰 좋아요를 취소하시겠습니까?")) return;
                    Promise.all(self.selectedReviewLikes.map(likeNo =>
                        axios.post("/deleteMyReviewLike.dox", { likeNo: String(likeNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedReviewLikes = [];
                        self.fetchReviewLikeList(self.reviewCurrentPage);
                    });
                }
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            this.fetchCompanyLikeList(1);
            this.fetchPostLikeList(1);
            this.fetchReviewLikeList(1);
        }
    });

    app.mount('#app');
</script>
</body>
</html>