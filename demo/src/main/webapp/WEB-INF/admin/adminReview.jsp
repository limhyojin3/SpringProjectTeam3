<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminNavi.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">

        <style>

            /* 상태 배지 스타일 */
            .badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
            }

            .status-waiting {
                background: #ffebee;
                color: #d32f2f;
            }

            /* 빨간색 */
            .status-process {
                background: #fff3e0;
                color: #f57c00;
            }

            /* 주황색 */
            .status-complete {
                background: #e8f5e9;
                color: #388e3c;
            }

            /* 초록색 */

            /* 강조 항목 */
            .text-left {
                text-align: left !important;
                /*텍스트 왼쪽 정렬인데 최우선 적용*/
                max-width: 250px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .count-high {
                color: red;
                font-weight: bold;
            }

            .btn-sm {
                padding: 4px 10px;
                border: 1px solid #ddd;
                background: #fff;
                cursor: pointer;
                border-radius: 3px;
            }

            .btn-batch {
                background: #333;
                color: #fff;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn-batch:hover {
                background: #222;
            }

            .detail-box p {
                margin-bottom: 8px;
                font-size: 14px;
            }

            .reject-box {
                margin-top: 15px;
            }

            .reject-box textarea {
                height: 80px;
                resize: none;
            }

        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="container">
                        <!-- 상단 필터 영역 -->
                        <h2>리뷰 관리</h2>
                        <div class="header">
                            <div class="keyword-group">
                                <select v-model="searchType">
                                    <option value="all">전체</option>
                                    <option value="userId">작성자</option>
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                </select>
                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnGetReviewList">
                                <button @click="fnGetReviewList">검색</button>
                            </div>
                            <div class="filter-group">
                                <div>                              
                                    <select v-model="approvalStatus" @change="fnGetReviewList">
                                        <option value="ALL">상태</option>
                                        <option value="WAIT">대기</option>
                                        <option value="APPROVED">승인</option>
                                        <option value="REJECTED">반려</option>
                                    </select>
                                </div>
                                <div>                              
                                    <select v-model="sortType" @change="fnGetReviewList">
                                        <option value="latest">최신순</option>
                                        <option value="old">오래된순</option>
                                    </select>
                                </div>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>
                        <!-- 리스트 바디 -->
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>작성자</th>
                                    <th>제목</th>
                                    <th>승인상태</th>
                                    <th>작성일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="r in reviewList" :key="r.reviewNo">
                                    <td>{{ r.reviewNo }}</td>
                                    <td>{{ r.userId }}</td>
                                    <td class="text-left" :title="r.reviewContent">
                                        {{ r.title }}
                                    </td>
                                    <td class="status-text">{{ getStatusText(r.approvalStatus) }}</td>
                                    <td>{{ formatDate(r.regDate) }}</td>
                                    <td>
                                        <button @click="fnSelectReview(r.reviewNo)">보기</button>
                                        <button class="btn-done" @click="fnApprove(r)">승인</button>
                                        <button class="btn-warn" @click="fnReject(r)">반려</button>
                                    </td>
                                </tr>
                                <tr v-for="n in emptyRows" class="empty-row" style="height: 56.5px !important;">
                                    <td colspan="7">&nbsp;</td>
                                </tr>

                            </tbody>
                        </table>
                        <div class="Paging">
                            <div class="page-box">
                                <button @click="fnPageMove(currentPage-1)" :disabled="currentPage===1">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <template v-for="p in index">
                                    <button v-if="p > Math.floor((currentPage - 1) / 5) * 5 && p <= Math.ceil(currentPage / 5) * 5" :key="p" @click="fnPageMove(p)"
                                        :class="{active: currentPage === p}">
                                        {{ p }}
                                    </button>
                                </template>
                                <button @click="fnPageMove(currentPage+1)" :disabled="currentPage===index">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
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
                        // 변수 - (key : value)
                        activeMenu: "",
                        reviewList: [],
                        selectedReview: null,
                        selectedReviews: [],
                        isAllChecked: false,
                        answerContent: "",
                        reviewNo: 0,
                        reporterId: "",
                        keyword: "",
                        sortType: "latest",
                        searchType: "all",
                        targetType: "ALL",
                        approvalStatus: "ALL",
                        uniTargetId: "",
                        reviewTitle: "",
                        reviewContent: "",
                        regDate: "",
                        sessionId: "${sessionScope.sessionId}",
                        rejectReason: "",
                        pageSize: 8,
                        index: 1,
                        currentPage: 1,
                        emptyRows: 0,

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnSelectReview(reviewNo) {
                        window.open('http://localhost:8080/api/review/detail.do?reviewNo=' + reviewNo, '_blank', 'width=1200, height=1200');
                    },

                    toggleAll() {
                        if (this.isAllChecked) {
                            this.selectedReviews = this.reviewList;
                        } else {
                            this.selectedReviews = [];
                        }
                    },

                    getStatusClass(r) {
                        if (r.actionStatus == 0) return "waiting";     // 처리대기
                        if (r.actionStatus == 1) return "complete";    // 승인
                        if (r.actionStatus == 2) return "status-reject"; // 반려
                    },

                    getStatusText(r) {
                        const map = {
                            WAIT : "대기",
                            APPROVED : "승인",
                            REJECTED : "반려",
                        };
                        return map[r] || r;
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnResetSearch() {
                        this.keyword = "";
                        this.currentPage = 1;
                        this.searchType = "all";
                        this.targetType = "ALL"
                        this.approvalStatus = "ALL";
                        this.sortType = "latest"
                        this.fnGetReviewList();
                    },

                    fnGetReviewList: function () {
                        let self = this;
                        let param = {
                            targetType: self.targetType,
                            approvalStatus: self.approvalStatus,
                            keyword: self.keyword,
                            searchType: self.searchType,
                            sortType: self.sortType,
                            uniTargetId: self.uniTargetId,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1)
                        };
                        $.ajax({
                            url: "http://localhost:8080/viewReview.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.reviewList = data.list || [];
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                                self.emptyRows = 8 - data.list.length;

                            }
                        });
                    },

                    fnPageMove(p) {
                        if (p < 1 || p > this.index) return;
                        this.currentPage = p;
                        this.fnGetReviewList();
                    },

                    fnApprove(r) {
                        let self = this;

                        if (!confirm("승인하시겠습니까?")) {
                            return
                        };

                        $.ajax({
                            url: "http://localhost:8080/reviewApprove.dox",
                            type: "POST",
                            data: {
                                reviewNo: r.reviewNo,
                                target_id: r.uniTargetId,
                                target_type: r.targetType,
                                admin_id: self.sessionId
                            },
                            success: function () {
                                alert("승인 완료");
                                self.fnGetReviewList();
                            }
                        });
                    },

                    fnReject(r) {
                        let self = this;

                        if (!confirm("반려하시겠습니까?")) {
                            return
                        };

                        $.ajax({
                            url: "http://localhost:8080/reviewReject.dox",
                            type: "POST",
                            data: {
                                reviewNo: r.reviewNo,
                                rejectReason: self.rejectReason
                            },
                            success: function () {
                                alert("반려 완료");
                                self.fnGetReviewList();
                                self.rejectReason = "";
                            }
                        });
                    },

                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    const path = location.pathname;

                    this.activeMenu =
                        path.includes('adminMain') ? 'main' :
                            path.includes('adminUser') ? 'user' :
                                path.includes('adminCompany') ? 'company' :
                                    path.includes('adminBoard') ? 'board' :
                                        path.includes('adminReview') ? 'review' :
                                            path.includes('adminPayment') ? 'payment' :
                                                path.includes('adminReport') ? 'report' :
                                                    path.includes('adminInquiry') ? 'inquiry' :
                                                        path.includes('adminStatistics') ? 'stats' :
                                                            '';
                    self.fnGetReviewList();
                }
            });

            app.mount('#app');
        </script>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

    </html>