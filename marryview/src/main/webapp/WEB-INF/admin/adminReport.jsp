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
            /* 대상 ID */
            .table th:nth-child(3),
            .table td:nth-child(3) {
                width: 100px;
            }

            /* 글 번호 OR ID */
            .table th:nth-child(5),
            .table td:nth-child(5) {
                width: 100px;
            }

            /* 신고 제목 */
            .table th:nth-child(6),
            .table td:nth-child(6) {
                width: 130px;
                min-width: 130px;
                max-width: 130px;
            }

            /* 신고 사유 */
            .table th:nth-child(7),
            .table td:nth-child(7) {
                width: 260px;
                min-width: 260px;
                max-width: 260px;
            }

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

            .status-process {
                background: #fff3e0;
                color: #f57c00;
            }

            .status-complete {
                background: #e8f5e9;
                color: #388e3c;
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

            .type-tag {
                font-size: 11px;
                padding: 3px 6px;
                border-radius: 6px;
                font-weight: 500;
            }

            .tag-user {
                background: #e3f2fd;
                color: #1976d2;
            }

            .tag-review {
                background: #f3e5f5;
                color: #7b1fa2;
            }

            .target-id {
                font-family: 'Courier New', monospace;
                /* ID임을 강조 */
                font-size: 13px;
                color: #333;
            }

            /* 상태 배지 */
            .status-badge {
                padding: 3px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 500;
            }

            /* 처리대기 */
            .waiting {
                background: #f1f3f5;
                color: #868e96;
            }

            /* 승인 */
            .complete {
                background: #e6f4ea;
                color: #2f9e44;
            }

            /* 반려 */
            .status-reject {
                background: #fff1f0;
                color: #d9480f;
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

            .modal-content {
                border-radius: 10px;
                border: none;
            }

            .modal-header {
                border-bottom: 1px solid #eee;
            }

            .modal-body {
                font-size: 14px;
            }

            .BatchPaging {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
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
                        <h2>신고 관리</h2>

                        <div class="header">

                            <div class="keyword-group">
                                <select v-model="searchType">
                                    <option value="all">전체</option>
                                    <option value="reporter">신고자</option>
                                    <option value="uniTargetId">글 번호/ID</option>
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                </select>
                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnGetReportList">
                                <button @click="fnGetReportList">검색</button>
                            </div>
                            <div class="filter-group">
                                <button class="btn btn-dark" @click="fnOpenKillModal">
                                    신고
                                </button>
                                <div>
                                    <select v-model="targetType" @change="fnGetReportList">
                                        <option value="ALL">신고대상</option>
                                        <option value="MEMBER">회원</option>
                                        <option value="REVIEW">리뷰</option>
                                        <option value="COMPANY">업체</option>
                                        <option value="POST">게시글</option>
                                        <option value="COMMENT">댓글</option>
                                    </select>
                                </div>
                                <div>
                                    <select v-model="processStatus" @change="fnGetReportList">
                                        <option value="ALL">처리상태</option>
                                        <option value="WAIT_ACTION">처리대기</option>
                                        <option value="WAIT_ANSWER">답변대기</option>
                                        <option value="COMPLETED">처리완료</option>
                                    </select>
                                </div>
                                <div>
                                    <select v-model="sortType" @change="fnGetReportList">
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
                                    <th><input type="checkbox" v-model="isAllChecked" @change="toggleAll"></th>
                                    <th>번호</th>
                                    <th>대상 ID</th>
                                    <th>대상(유형)</th>
                                    <th>글 번호/ID</th>
                                    <th>신고 제목</th>
                                    <th>신고 사유</th>
                                    <th>등록일</th>
                                    <th>처리</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="r in reportList" :key="r.reportNo">

                                    <td><input type="checkbox" :value="r.reportNo" v-model="selectedReports"></td>
                                    <td>{{ r.reportNo }}</td>
                                    <td class="admin-id-cell">
                                        <span class="admin-id-text" :title="r.targetUserId">
                                            {{ r.targetUserId }}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="type-tag" :class="'tag-' + r.targetType.toLowerCase()">
                                            {{ r.targetType }}
                                        </span>
                                    </td>
                                    <td>{{ r.uniTargetId }}</td>
                                    <td class="text-left" :title="r.reportContent">
                                        {{ r.reportTitle }}
                                    </td>
                                    <td class="text-left" :title="r.reportContent">
                                        {{ r.reportContent }}
                                    </td>
                                    <td>{{ formatDate(r.regDate) }}</td>
                                    <td>
                                        <span class="status-badge" :class="getStatusClass(r)">
                                            {{ getStatusText(r) }}
                                        </span>
                                    </td>
                                    <td>
                                        <button @click="fnSelectReport(r.reportNo)">보기</button>
                                    </td>
                                </tr>
                                <tr v-for="n in emptyRows" class="empty-row">
                                    <td colspan="9">&nbsp;</td>
                                </tr>
                                <tr v-if="reportList.length === 0">
                                    <td colspan="9">신고 내역 없음</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="BatchPaging">
                            <div>
                                <button @click="fnBatchApprove" class="btn btn-success">일괄 승인</button>
                                <button @click="fnBatchReject" class="btn btn-danger">일괄 반려</button>
                            </div>
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
                        <div class="modal fade" id="reportModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h5 class="modal-title">신고 상세</h5>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <div class="modal-body" v-if="selectedReport">
                                        <p>
                                            <b>신고자:</b> {{ selectedReport.reporterId }}
                                            <span style="margin-left: 100px;"></span>
                                            <b>대상:</b> {{ selectedReport.targetUserId }}
                                        </p>
                                        <p>
                                            <b>대상유형:</b> {{ selectedReport.targetType }}
                                            <span style="margin-left: 100px;"></span>
                                            <b>번호:</b> {{ selectedReport.uniTargetId }}
                                        </p>
                                        <p><b>제목:</b> {{ selectedReport.reportTitle }}</p>
                                        <p><b>내용:</b> {{ selectedReport.reportContent }}</p>
                                        <!-- 반려 사유 -->
                                        <div class="reject-box">
                                            <label>신고자에게 보낼 처리 답변</label>
                                            <textarea v-model.trim="answerContent" maxlength="500"
                                                placeholder="승인 또는 반려 사유와 처리 결과를 입력하세요."
                                                class="form-control"></textarea>
                                            <small class="text-muted">
                                                이 내용은 신고 처리 알림과 마이페이지에 표시됩니다.
                                            </small>
                                        </div>
                                    </div>
                                    <!-- 버튼 -->
                                    <div class="modal-footer" v-if="selectedReport">
                                        <button class="btn btn-success"
                                            @click="fnView(selectedReport.targetType, selectedReport.uniTargetId)">
                                            관련 글 보기
                                        </button>

                                        <button class="btn btn-success" @click="fnApprove(selectedReport)">
                                            {{ selectedReport.actionStatus == 0 ? '승인' : '승인으로 수정' }}
                                        </button>

                                        <button class="btn btn-danger" @click="fnReject(selectedReport)">
                                            {{ selectedReport.actionStatus == 0 ? '반려' : '반려로 수정' }}
                                        </button>

                                        <button
                                            v-if="selectedReport.actionStatus != 0 && selectedReport.answerStatus == 0"
                                            class="btn btn-warning" @click="fnRetryAnswer(selectedReport)">
                                            답변 알림 재전송
                                        </button>

                                        <button class="btn btn-secondary" data-dismiss="modal">
                                            닫기
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal fade" id="killModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h5>신고 2회 이상</h5>
                                        <button class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <div class="modal-body">
                                        <table class="table">
                                            <tr v-for="(item, i) in killList" :key="i">
                                                <td>{{ item.targetUserId }}</td>
                                                <td>{{ item.killCount }}</td>
                                            </tr>
                                        </table>
                                    </div>

                                </div>
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
                        reportList: [],
                        selectedReport: null,
                        selectedReports: [],
                        isAllChecked: false,
                        answerContent: "",
                        reportNo: 0,
                        reporterId: "",
                        keyword: "",
                        sortType: "latest",
                        searchType: "all",
                        targetType: "ALL",
                        processStatus: "ALL",
                        uniTargetId: "",
                        reportTitle: "",
                        reportContent: "",
                        actionStatus: "",
                        answerStatus: "",
                        regDate: "",
                        sessionId: "${sessionScope.sessionId}",
                        rejectReason: "",
                        pageSize: 8,
                        index: 1,
                        currentPage: 1,
                        emptyRows: 0,
                        killList: [],
                        showKillModal: false

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnView: function (targetType, uniTargetId) {
                        if (targetType === "REVIEW") {
                            window.open("http://localhost:8080/api/review/detail.do?reviewNo=" + uniTargetId, '_blank', 'width=1000, height=1000');
                        } else if (targetType === "POST") {
                            window.open("http://localhost:8080/api/community/detail.do?postNo=" + uniTargetId, '_blank', 'width=1000, height=1000');
                        } else if (targetType === "COMMENT") {

                            $.ajax({
                                url: "http://localhost:8080/adminCommentTargetPost.dox",
                                type: "POST",
                                dataType: "json",
                                data: { commentNo: uniTargetId },

                                success: function (res) {
                                    console.log(res);
                                    if (res.result == "success") {
                                        if (res.postNo != null) {
                                            window.open(
                                                "http://localhost:8080/api/community/detail.do?postNo=" + res.postNo,
                                                "_blank",
                                                "width=1300,height=1300"
                                            )
                                        }
                                        if (res.reviewNo != null) {
                                            window.open(
                                                "http://localhost:8080/api/review/detail.do?reviewNo=" + res.reviewNo,
                                                "_blank",
                                                "width=1300,height=1300"
                                            )
                                        }
                                    } else {
                                        alert("댓글 원본 게시글을 찾을 수 없습니다.");
                                    }
                                }
                            });

                        } else {
                            alert("게시글 조회 실패");
                        }
                    },

                    toggleAll() {
                        let self = this;
                        if (self.isAllChecked) {
                            self.selectedReports = self.reportList.map(item => item.reportNo);
                        } else {
                            self.selectedReports = [];
                        }
                    },

                    getStatusClass(r) {
                        if (r.actionStatus == 0) return "waiting";
                        if (r.answerStatus == 0) return "waiting";
                        if (r.actionStatus == 2) return "status-reject";
                        return "complete";
                    },

                    getStatusText(r) {
                        if (r.actionStatus == 0) return "처리대기";
                        if (r.actionStatus == 1 && r.answerStatus == 0) return "승인·답변대기";
                        if (r.actionStatus == 2 && r.answerStatus == 0) return "반려·답변대기";
                        if (r.actionStatus == 1 && r.answerStatus == 1) return "승인완료";
                        if (r.actionStatus == 2 && r.answerStatus == 1) return "반려완료";
                        return "상태확인";
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnSelectReport(reportNo) {
                        let self = this;

                        $.ajax({
                            url: "http://localhost:8080/reportDetail.dox",
                            type: "POST",
                            dataType: "json",
                            data: { reportNo: reportNo },
                            success: function (res) {
                                console.log(res);
                                if (res.result !== "success" || !res.info) {
                                    alert("신고 상세 정보를 불러오지 못했습니다.");
                                    return;
                                }
                                self.selectedReport = res.info;
                                self.answerContent = res.info.answerContent || "";
                                $("#reportModal").modal("show");
                            }
                        });
                    },

                    fnResetSearch() {
                        this.keyword = "";
                        this.currentPage = 1;
                        this.searchType = "all";
                        this.targetType = "ALL"
                        this.processStatus = "ALL";
                        this.sortType = "latest"
                        this.fnGetReportList();
                    },

                    fnGetReportList: function () {
                        let self = this;
                        self.selectedReports = [];
                        self.isAllChecked = false;
                        let param = {
                            targetType: self.targetType,
                            processStatus: self.processStatus,
                            keyword: self.keyword,
                            searchType: self.searchType,
                            sortType: self.sortType,
                            uniTargetId: self.uniTargetId,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1)
                        };
                        $.ajax({
                            url: "http://localhost:8080/viewReport.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.reportList = data.list || [];
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                                self.emptyRows = 8 - data.list.length;
                                self.killList = data.killList;
                            }
                        });
                    },

                    fnPageMove(p) {
                        if (p < 1 || p > this.index) return;
                        this.currentPage = p;
                        this.fnGetReportList();
                    },

                    fnBatchApprove() {
                        let self = this;

                        if (self.selectedReports.length == 0) {
                            alert("선택된 신고 없음");
                            return;
                        }

                        if (!confirm("일괄 승인하시겠습니까?")) {
                            return
                        };


                        console.log(self.selectedReports);

                        $.ajax({
                            url: "http://localhost:8080/reportBatchApprove.dox",
                            type: "POST",
                            traditional: true, // 배열 보낼 때 필요
                            data: {
                                reportNos: self.selectedReports,
                                admin_id: self.sessionId
                            },
                            success: function (res) {
                                alert("일괄 처리 완료");
                                console.log(res);
                                self.selectedReports = [];
                                self.isAllChecked = false;
                                self.fnGetReportList();
                            }
                        });
                    },
                    fnBatchReject() {
                        let self = this;

                        if (self.selectedReports.length === 0) {
                            alert("선택된 신고 없음");
                            return;
                        }

                        if (!confirm("일괄 반려하시겠습니까?")) {
                            return;
                        }

                        console.log(self.selectedReports);

                        $.ajax({
                            url: "http://localhost:8080/reportBatchReject.dox",
                            type: "POST",
                            traditional: true,
                            data: {
                                reportNos: self.selectedReports,
                                rejectReason: "일괄 반려 처리",
                            },
                            success: function () {
                                alert("일괄 반려 완료");
                                self.selectedReports = [];
                                self.isAllChecked = false;
                                self.fnGetReportList();
                            }
                        });
                    },

                    fnApprove(r) {
                        let self = this;

                        if (!self.answerContent.trim()) {
                            alert("신고자에게 보낼 답변을 입력해주세요.");
                            return;
                        }

                        let confirmMessage = r.actionStatus == 0
                            ? "신고를 승인하고 답변 알림을 보내시겠습니까?"
                            : "기존 처리 결과를 승인으로 수정하고 다시 알리시겠습니까?";

                        if (!confirm(confirmMessage)) {
                            return;
                        }

                        $.ajax({
                            url: "/reportApprove.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                reportNo: r.reportNo,
                                answerContent: self.answerContent,
                                target_id: r.uniTargetId,
                                target_type: r.targetType,
                                admin_id: self.sessionId
                            },
                            success: function (res) {
                                if (res.result !== "success") {
                                    alert(res.message || "승인 처리에 실패했습니다.");
                                    return;
                                }

                                if (res.notificationResult === "fail") {
                                    alert("승인 처리는 완료됐지만 알림 전송에 실패했습니다.");
                                } else {
                                    alert("승인 및 답변 전송이 완료되었습니다.");
                                }

                                self.fnGetReportList();
                                $("#reportModal").modal("hide");
                            },
                            error: function () {
                                alert("서버 통신 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    fnReject(r) {
                        let self = this;

                        if (!self.answerContent.trim()) {
                            alert("신고자에게 보낼 반려 답변을 입력해주세요.");
                            return;
                        }

                        let confirmMessage = r.actionStatus == 0
                            ? "신고를 반려하고 답변 알림을 보내시겠습니까?"
                            : "기존 처리 결과를 반려로 수정하고 다시 알리시겠습니까?";

                        if (!confirm(confirmMessage)) {
                            return;
                        }

                        $.ajax({
                            url: "/reportReject.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                reportNo: r.reportNo,
                                answerContent: self.answerContent,

                                // 기존 로직 호환용
                                rejectReason: self.answerContent,
                                target_id: r.uniTargetId,
                                target_type: r.targetType,
                                admin_id: self.sessionId
                            },
                            success: function (res) {
                                if (res.result !== "success") {
                                    alert(res.message || "반려 처리에 실패했습니다.");
                                    return;
                                }

                                if (res.notificationResult === "fail") {
                                    alert("반려 처리는 완료됐지만 알림 전송에 실패했습니다.");
                                } else {
                                    alert("반려 및 답변 전송이 완료되었습니다.");
                                }

                                self.fnGetReportList();
                                self.answerContent = "";
                                $("#reportModal").modal("hide");
                            },
                            error: function () {
                                alert("서버 통신 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    fnRetryAnswer(r) {
                        let self = this;

                        if (!confirm("저장된 답변으로 알림을 다시 보내시겠습니까?")) {
                            return;
                        }

                        $.ajax({
                            url: "/reportAnswerRetry.dox",
                            type: "POST",
                            dataType: "json",
                            data: { reportNo: r.reportNo },
                            success: function (res) {
                                alert(res.message || "처리가 완료되었습니다.");

                                if (res.result === "success") {
                                    self.fnGetReportList();
                                    $("#reportModal").modal("hide");
                                }
                            },
                            error: function () {
                                alert("답변 알림 재전송 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    fnOpenKillModal() {
                        $("#killModal").modal("show");
                    }
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
                    self.fnGetReportList();
                }
            });

            app.mount('#app');
        </script>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

    </html>