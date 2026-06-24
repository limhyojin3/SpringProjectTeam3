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

            .btn-receipt-review {
                border: 1px solid #7057d9;
                background: #f6f3ff;
                color: #5940bd;
                font-weight: 600;
            }

            .receipt-review-modal .modal-dialog {
                max-width: 920px;
            }

            .receipt-preview {
                min-height: 320px;
                border: 1px solid #e7e7ed;
                border-radius: 10px;
                background: #f8f8fb;

                display: flex;
                align-items: center;
                justify-content: center;

                overflow: hidden;
            }

            .receipt-preview img {
                max-width: 100%;
                max-height: 520px;
                cursor: zoom-in;
            }

            .review-scope-card,
            .review-policy-card {
                border: 1px solid #e4e2ed;
                border-radius: 10px;
                padding: 16px;
                background: #fff;
            }

            .review-scope-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 999px;

                background: #eee9ff;
                color: #5337bb;

                font-size: 12px;
                font-weight: 700;
            }

            .receipt-data-grid {
                display: grid;
                grid-template-columns: 120px 1fr;
                gap: 8px 12px;
                font-size: 14px;
            }

            .receipt-data-grid dt {
                color: #777;
                margin: 0;
            }

            .receipt-data-grid dd {
                margin: 0;
                font-weight: 600;
                word-break: break-all;
            }

            .receipt-warning {
                border-left: 4px solid #8b72e8;
                background: #f7f5ff;
                border-radius: 4px;

                padding: 10px 12px;
                margin-bottom: 8px;

                font-size: 13px;
            }

            .receipt-warning.warning-high {
                border-left-color: #dc3545;
                background: #fff4f5;
            }

            .receipt-checklist {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .receipt-checklist li {
                padding: 7px 0;
                border-bottom: 1px dashed #e5e5e5;
                font-size: 13px;
            }

            .receipt-checklist li:last-child {
                border-bottom: 0;
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
                                        <button class="btn-receipt-review" @click="fnOpenReceiptReview(r)">
                                            영수증 검토
                                        </button>
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
                                    <button
                                        v-if="p > Math.floor((currentPage - 1) / 5) * 5 && p <= Math.ceil(currentPage / 5) * 5"
                                        :key="p" @click="fnPageMove(p)" :class="{active: currentPage === p}">
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
            <div class="modal fade receipt-review-modal" id="receiptReviewModal" tabindex="-1" role="dialog"
                aria-hidden="true">

                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">

                    <div class="modal-content">

                        <div class="modal-header">
                            <div>
                                <h5 class="modal-title mb-1">
                                    영수증 검토 보조
                                </h5>

                                <p class="small text-muted mb-0">
                                    진위 판정이 아니라 증빙과 리뷰 사이의
                                    명백한 모순을 확인합니다.
                                </p>
                            </div>

                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>

                        <div class="modal-body">

                            <div v-if="receiptReview.loading" class="text-center py-5">

                                <div class="spinner-border text-secondary">
                                </div>

                                <p class="text-muted mt-3 mb-0">
                                    영수증 검토 정보를 불러오는 중입니다.
                                </p>
                            </div>

                            <div v-else-if="receiptReview.error" class="alert alert-danger mb-0">
                                {{ receiptReview.error }}
                            </div>

                            <div v-else-if="receiptReview.detail" class="row">

                                <div class="col-md-6 mb-3 mb-md-0">

                                    <div class="receipt-preview">

                                        <img v-if="receiptReview.detail.receiptUrl"
                                            :src="receiptReview.detail.receiptUrl" alt="제출 영수증"
                                            @click="fnOpenReceiptImage">

                                        <div v-else class="text-center text-muted px-4">

                                            <i class="fas fa-receipt fa-3x mb-3"></i>

                                            <p class="mb-0">
                                                첨부된 영수증을 찾을 수 없습니다.
                                            </p>
                                        </div>
                                    </div>

                                    <p class="small text-muted mt-2 mb-0">
                                        이미지를 누르면 원본 크기로
                                        확인할 수 있습니다.
                                    </p>
                                </div>

                                <div class="col-md-6">

                                    <div class="review-scope-card mb-3">

                                        <span class="review-scope-badge">
                                            {{ receiptReview.detail.evidenceLabel }}
                                        </span>

                                        <p class="small mt-2 mb-3">
                                            {{ receiptReview.detail.evidenceDescription }}
                                        </p>

                                        <dl class="receipt-data-grid">

                                            <dt>리뷰 번호</dt>
                                            <dd>
                                                <span>#</span>{{ receiptReview.detail.reviewNo }}
                                            </dd>

                                            <dt>대상 업체</dt>
                                            <dd>
                                                {{ displayCompanyName(
                                                receiptReview.detail
                                                ) }}
                                            </dd>

                                            <dt>대상 상품</dt>
                                            <dd>
                                                {{
                                                receiptReview.detail.productName
                                                || '등록 정보 없음'
                                                }}
                                            </dd>

                                            <dt>신고 비용</dt>
                                            <dd>
                                                {{ formatAmount(
                                                receiptReview.detail.totalCost
                                                ) }}
                                            </dd>

                                            <dt>예약 경로</dt>
                                            <dd>
                                                {{
                                                receiptReview.detail.bookingSource
                                                || '입력 정보 없음'
                                                }}
                                            </dd>

                                            <template v-if="
                                    receiptReview.detail.reservationLinked
                                ">
                                                <dt>예약 이용일</dt>
                                                <dd>
                                                    {{
                                                    receiptReview.detail
                                                    .reservationUseDate
                                                    || '정보 없음'
                                                    }}
                                                </dd>

                                                <dt>연동 결제액</dt>
                                                <dd>
                                                    {{ formatAmount(
                                                    receiptReview.detail
                                                    .linkedPaymentAmount
                                                    ) }}
                                                </dd>
                                            </template>

                                        </dl>
                                    </div>

                                    <div class="mb-3">

                                        <h6 class="font-weight-bold">
                                            자동 확인 결과
                                        </h6>

                                        <div v-if="
                                receiptReview.detail.warnings
                                && receiptReview.detail.warnings.length
                            ">

                                            <div v-for="warning
                                             in receiptReview.detail.warnings" :key="warning.type"
                                                class="receipt-warning" :class="{
                                         'warning-high':
                                             warning.level === 'HIGH'
                                     }">

                                                <strong>
                                                    {{
                                                    warning.level === 'HIGH'
                                                    ? '확인 필요'
                                                    : '안내'
                                                    }}
                                                </strong>

                                                <div>{{ warning.message }}</div>
                                            </div>
                                        </div>

                                        <div v-else class="receipt-warning">
                                            자동 확인 항목이 없습니다.
                                            증빙 원본은 관리자가 직접 확인해주세요.
                                        </div>
                                    </div>

                                    <div class="review-policy-card">

                                        <h6 class="font-weight-bold">
                                            관리자 검토 기준
                                        </h6>

                                        <ul class="receipt-checklist">
                                            <li>
                                                □ 증빙이 첨부되어 있고
                                                내용을 알아볼 수 있는가
                                            </li>
                                            <li>
                                                □ 대상 업체·상품과
                                                관련 있어 보이는가
                                            </li>
                                            <li>
                                                □ 날짜·금액·리뷰 내용에
                                                명백한 모순이 없는가
                                            </li>
                                            <li>
                                                □ 동일 증빙 재사용이
                                                명백하지 않은가
                                            </li>
                                            <li>
                                                □ 편집 흔적 또는 무관한
                                                이미지가 명백하지 않은가
                                            </li>
                                        </ul>

                                        <p class="small text-danger mt-3 mb-0">
                                            {{ receiptReview.detail.policyNotice }}
                                        </p>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">

                            <button type="button" class="btn btn-outline-secondary" @click="fnOpenSelectedReview">
                                원글 보기
                            </button>

                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                닫기
                            </button>

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
                        receiptReview: {
                            review: null,
                            loading: false,
                            error: "",
                            detail: null
                        },

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

                    fnOpenReceiptReview(r) {
                        this.receiptReview.review = r;
                        this.receiptReview.loading = true;
                        this.receiptReview.error = "";
                        this.receiptReview.detail = null;

                        this.$nextTick(() => {
                            $('#receiptReviewModal').modal('show');
                        });

                        $.ajax({
                            url: "/receiptReviewDetail.dox",
                            type: "POST",
                            dataType: "json",

                            data: {
                                reviewNo: r.reviewNo
                            },

                            success: (data) => {
                                if (data.result === "success") {
                                    this.receiptReview.detail =
                                        data.detail;
                                } else {
                                    this.receiptReview.error =
                                        data.message
                                        || "영수증 검토 정보를 불러오지 못했습니다.";
                                }
                            },

                            error: () => {
                                this.receiptReview.error =
                                    "영수증 검토 정보를 불러오지 못했습니다.";
                            },

                            complete: () => {
                                this.receiptReview.loading = false;
                            }
                        });
                    },

                    fnOpenReceiptImage() {
                        const detail =
                            this.receiptReview.detail;

                        const url =
                            detail && detail.receiptUrl;

                        if (url) {
                            window.open(
                                url,
                                "_blank",
                                "noopener"
                            );
                        }
                    },

                    fnOpenSelectedReview() {
                        const review =
                            this.receiptReview.review;

                        if (review) {
                            this.fnSelectReview(
                                review.reviewNo
                            );
                        }
                    },

                    displayCompanyName(detail) {
                        return detail.companyName
                            || detail.externalName
                            || "업체 정보 없음";
                    },

                    formatAmount(amount) {
                        if (amount === null
                            || amount === undefined
                            || amount === "") {

                            return "정보 없음";
                        }

                        return Number(amount)
                            .toLocaleString("ko-KR") + "원";
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
                            WAIT: "대기",
                            APPROVED: "승인",
                            REJECTED: "반려",
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