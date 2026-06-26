<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내가 쓴 글/리뷰/댓글</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <%-- ✅ 마이페이지 공용 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <%-- ✅ 내가 쓴 리뷰/댓글 페이지 전용 스타일만 --%>
    <style>
        /* 탭 */
        .write-tab-wrap {
            display: flex;
            gap: 0;
            margin-bottom: 20px;
        }

        .write-tab {
            flex: 1;
            padding: 12px 0;
            border: 1px solid #ffc7c2;
            background-color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
            color: #e07a8a;
            border-radius: 0;
        }

        .write-tab:first-child { border-radius: 8px 0 0 8px; }
        .write-tab:last-child { border-radius: 0 8px 8px 0; }

        .write-tab.active-tab {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        /* 테이블 */
        .write-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .write-table th {
            background-color: #fff0f3;
            padding: 12px 10px;
            text-align: center;
            border-bottom: 2px solid #f4a096;
            border-top: 1px solid #ffc7c2;
            font-weight: 700;
            color: #555;
        }

        .write-table td {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid #f5f5f5;
            color: #555;
        }

        .write-table tr:hover td {
            background-color: #fff9f9;
            color: #e07a8a;
        }

        .write-table td:nth-child(3) {
            text-align: left;
            cursor: pointer;
        }

        .col-check { width: 40px; }
        .col-no    { width: 60px; }
        .col-date  { width: 120px; }
        .col-view  { width: 60px; }
        .col-title { text-align: left; }

        /* 댓글 */
        .comment-content {
            font-size: 14px;
            color: #555;
        }

        /* 삭제 버튼 */
        .btn-select-all {
            position: absolute;
            left: 0;
            padding: 8px 20px;
            background-color: #fff0f3;
            color: #e07a8a;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s;
            height: 34px;
            line-height: 1;
        }

        .btn-select-all:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        /* 하단 컨트롤 */
        .bottom-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            margin-top: 20px;
            padding: 10px 0;
            min-height: 40px;
        }

        /* 페이지네이션 */
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
            color: #e07a8a;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-review-index:hover {
            background-color: #f4a096;
            color: white;
            border-color: #f4a096;
        }

        .btn-review-index.active-page {
            background-color: #e07a8a;
            color: white;
            border-color: #f4a096;
            font-weight: bold;
        }

        .btn-review-index:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }

        /* 제목 스타일 */
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
                    <h4><i class="fas fa-pen"></i>내가 쓴 글/리뷰/댓글 목록</h4>
                    <!-- 탭 버튼 -->
                    <div class="write-tab-wrap">
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'post'}" @click="switchReviewTab('post')">작성 글</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'review'}" @click="switchReviewTab('review')">작성 리뷰</button>
                        <button class="write-tab" :class="{'active-tab': reviewTab === 'comment'}" @click="switchReviewTab('comment')">작성 댓글</button>
                    </div>

                    <!-- 작성 글 리뷰 테이블 -->
                    <div v-if="reviewTab === 'post'">
                        <table class="write-table" >
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllPosts()"></th>
                                    <th class="col-no">번호</th>
                                    <th class="col-title">제목</th>
                                    <th>카테고리</th>
                                    <th class="col-view">조회</th>
                                    <th class="col-date">작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="postList.length === 0">
                                    <td colspan="6">작성한 글이 없습니다.</td>
                                </tr>
                                <tr v-for="post in postList" :key="post.postNo"
                                    @click="fnGoPost(post.postNo)">
                                    <td @click.stop><input type="checkbox" :value="post.postNo" v-model="selectedPosts"></td>
                                    <td>{{ post.postNo }}</td>
                                    <td class="col-title">{{ post.title }}</td>
                                    <td>{{ post.category }}</td>
                                    <td>{{ post.viewCnt }}</td>
                                    <td>{{ post.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                
                    </div>

                    <!-- 작성 리뷰 테이블 -->
                    <div v-if="reviewTab === 'review'">
                        <table class="write-table" >
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllReviews()"></th>
                                    <th class="col-no">번호</th>
                                    <th class="col-title">제목</th>
                                    <th>평점</th>
                                    <th>승인상태</th>
                                    <th class="col-date">작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="reviewList.length === 0">
                                    <td colspan="6">작성한 리뷰가 없습니다.</td>
                                </tr>
                                <tr v-for="review in reviewList" :key="review.reviewNo"
                                    @click="fnGoReview(review.reviewNo)">
                                    <td @click.stop><input type="checkbox" :value="review.reviewNo" v-model="selectedReviews"></td>
                                    <td>{{ review.reviewNo }}</td>
                                    <td class="col-title">{{ review.title }}</td>
                                    <td>{{ review.rating }}</td>
                                    <td>{{ review.approvalStatus }}</td>
                                    <td>{{ review.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 작성 댓글 테이블 -->
                    <div v-if="reviewTab === 'comment'">
                        <table class="write-table">
                            <thead>
                                <tr>
                                    <th class="col-check"><input type="checkbox" @click="selectAllComments()"></th>
                                    <th class="col-no">번호</th>
                                    <th class="col-title">내용</th>
                                    <th class="col-date">작성일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="commentList.length === 0">
                                    <td colspan="4">작성한 댓글이 없습니다.</td>
                                </tr>
                                <tr v-for="comment in commentList" :key="comment.commentNo"
                                    @click="comment.postNo ? fnGoPost(comment.postNo) : fnGoReview(comment.reviewNo)">
                                    <td @click.stop><input type="checkbox" :value="comment.commentNo" v-model="selectedComments"></td>
                                    <td>{{ comment.commentNo }}</td>
                                    <td class="col-title">
                                        <div class="comment-content">{{ comment.content }}</div>
                                    </td>
                                    <td>{{ comment.regDate }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom-controls">
                        <button class="btn-select-all" @click="deleteSelected()">삭제</button>

                        <div class="review-index-wrap">
                            <template v-if="reviewTab === 'post'">
                                <button class="btn-review-index"
                                        @click="fetchPostList(postCurrentPage - 1)"
                                        :disabled="postCurrentPage === 1">이전</button>
                                <button class="btn-review-index"
                                        v-for="p in Math.ceil(postTotalCount / pageSize)" :key="'post-'+p"
                                        :class="p === postCurrentPage ? 'active-page' : ''"
                                        @click="fetchPostList(p)">
                                    {{ p }}
                                </button>
                                <button class="btn-review-index"
                                        @click="fetchPostList(postCurrentPage + 1)"
                                        :disabled="postCurrentPage === Math.ceil(postTotalCount / pageSize)">다음</button>
                            </template>

                            <template v-else-if="reviewTab === 'review'">
                                <button class="btn-review-index"
                                        @click="fetchReviewList(reviewCurrentPage - 1)"
                                        :disabled="reviewCurrentPage === 1">이전</button>
                                <button class="btn-review-index"
                                        v-for="p in Math.ceil(reviewTotalCount / pageSize)" :key="'review-'+p"
                                        :class="p === reviewCurrentPage ? 'active-page' : ''"
                                        @click="fetchReviewList(p)">
                                    {{ p }}
                                </button>
                                <button class="btn-review-index"
                                        @click="fetchReviewList(reviewCurrentPage + 1)"
                                        :disabled="reviewCurrentPage === Math.ceil(reviewTotalCount / pageSize)">다음</button>
                            </template>

                            <template v-else-if="reviewTab === 'comment'">
                                <button class="btn-review-index"
                                        @click="fetchCommentList(commentCurrentPage - 1)"
                                        :disabled="commentCurrentPage === 1">이전</button>
                                <button class="btn-review-index"
                                        v-for="p in Math.ceil(commentTotalCount / pageSize)" :key="'comment-'+p"
                                        :class="p === commentCurrentPage ? 'active-page' : ''"
                                        @click="fetchCommentList(p)">
                                    {{ p }}
                                </button>
                                <button class="btn-review-index"
                                        @click="fetchCommentList(commentCurrentPage + 1)"
                                        :disabled="commentCurrentPage === Math.ceil(commentTotalCount / pageSize)">다음</button>
                            </template>
                        </div>
                    </div>
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
                reviewTab: 'post',  // 'post' or 'review' or 'comment'
                postList: [],
                reviewList: [],
                commentList: [],
                // 페이지
                postCurrentPage: 1,
                reviewCurrentPage: 1,
                commentCurrentPage: 1,
                postTotalCount: 0,
                reviewTotalCount: 0,
                commentTotalCount: 0,
                pageSize: 5,
                // 체크 박스
                selectedPosts: [],
                selectedReviews: [],
                selectedComments: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            switchReviewTab: function(type) {
                this.reviewTab = type;
            },
            // 클릭 시 해당 리뷰 상세 보기로 이동
            fnGoPost: function(postNo) {
                location.href = '/api/community/detail.do?postNo=' + postNo;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            },
            // 페이지
            fetchPostList: function(page) {
                let self = this;
                axios.get("/myPostList.dox?page=" + page)
                    .then(res => {
                        self.postList = res.data.list;
                        self.postTotalCount = res.data.totalCount;
                        self.postCurrentPage = res.data.currentPage;
                    });
            },
            fetchReviewList: function(page) {
                let self = this;
                axios.get("/myReviewList.dox?page=" + page)
                    .then(res => {
                        self.reviewList = res.data.list;
                        self.reviewTotalCount = res.data.totalCount;
                        self.reviewCurrentPage = res.data.currentPage;
                    });
            },
            fetchCommentList: function(page) {
                let self = this;
                axios.get("/myCommentList.dox?page=" + page)
                    .then(res => {
                        self.commentList = res.data.list;
                        self.commentTotalCount = res.data.totalCount;
                        self.commentCurrentPage = res.data.currentPage;
                    });
            },
            // 전체 선택
            selectAllPosts: function() {
                if(this.selectedPosts.length === this.postList.length) {
                    this.selectedPosts = [];
                } else {
                    this.selectedPosts = this.postList.map(p => p.postNo);
                }
            },
            selectAllReviews: function() {
                if(this.selectedReviews.length === this.reviewList.length) {
                    this.selectedReviews = [];
                } else {
                    this.selectedReviews = this.reviewList.map(r => r.reviewNo);
                }
            },
            selectAllComments: function() {
                if(this.selectedComments.length === this.commentList.length) {
                    this.selectedComments = [];
                } else {
                    this.selectedComments = this.commentList.map(c => c.commentNo);
                }
            },
            // 선택 삭제
            deleteSelected: function() {
                let self = this;
                if(this.reviewTab === 'post') {
                    if(self.selectedPosts.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 글을 삭제하시겠습니까?")) return;
                    Promise.all(self.selectedPosts.map(postNo =>
                        axios.post("/deleteMyPost.dox", { postNo: String(postNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedPosts = [];
                        self.fetchPostList(self.postCurrentPage);
                    });
                } else if(this.reviewTab === 'review') {
                    if(self.selectedReviews.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 리뷰를 삭제하시겠습니까?")) return;
                    Promise.all(self.selectedReviews.map(reviewNo =>
                        axios.post("/deleteMyReview.dox", { reviewNo: String(reviewNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedReviews = [];
                        self.fetchReviewList(self.reviewCurrentPage);
                    });
                } else if(this.reviewTab === 'comment') {
                    if(self.selectedComments.length === 0) { alert("삭제할 항목을 선택해주세요."); return; }
                    if(!confirm("선택한 댓글을 삭제하시겠습니까?")) return;
                    Promise.all(self.selectedComments.map(commentNo =>
                        axios.post("/deleteMyComment.dox", { commentNo: String(commentNo) })
                    )).then(() => {
                        alert("삭제되었습니다.");
                        self.selectedComments = [];
                        self.fetchCommentList(self.commentCurrentPage);
                    });
                }
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            this.fetchPostList(1);
            this.fetchReviewList(1);
            this.fetchCommentList(1);
        }
    });

    app.mount('#app');
</script>
</body>
</html>