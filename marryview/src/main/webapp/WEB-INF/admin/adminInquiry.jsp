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
            /* 상태 배지 */
            .status-badge {
                padding: 4px 9px;
                border-radius: 30px;
                font-size: 11px;
                font-weight: 600;
            }

            .waiting {
                background: #f1f3f5;
                color: #868e96;
            }

            .complete {
                background: #e6f4ea;
                color: #2f9e44;
            }

            /* 모달 */
            .modal-content {
                border-radius: 12px;
                border: none;
            }

            .modal-header {
                border-bottom: 1px solid #eee;
            }

            .modal-title {
                font-weight: 700;
            }

            .modal-body p {
                margin-bottom: 8px;
                font-size: 14px;
            }

            .content-box {
                background: #f5f5f5;
                padding: 14px;
                border-radius: 8px;
                min-height: 120px;
                white-space: pre-wrap;
                line-height: 1.6;
            }

            .modal textarea.form-control {
                resize: none;
                border-radius: 8px;
            }

            .modal-footer .btn {
                min-width: 90px;
            }

            /* 반응형 */
            @media (max-width: 1100px) {
                .middle {
                    grid-template-columns: 1fr;
                    grid-template-areas:
                        "main";
                }

                .header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .filter-group {
                    flex-wrap: wrap;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="container admin-fade-up delay-1">
                        <h2>문의 관리</h2>
                        <div class="header">
                            <div class="filter-group">
                                <div>
                                    <select v-model="status" @change="fnGetList">
                                        <option value="ALL">처리상태</option>
                                        <option value="WAIT">WAIT</option>
                                        <option value="DONE">DONE</option>
                                    </select>
                                </div>
                                <div>
                                    <select v-model="sortType" @change="fnGetList">
                                        <option value="latest">최신순</option>
                                        <option value="old">오래된순</option>
                                    </select>
                                </div>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <!-- 리스트 -->
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>유형</th>
                                    <th>ID</th>
                                    <th>제목</th>
                                    <th>등록일</th>
                                    <th>상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="item in inquirylist" :key="item.inquiryNo">

                                    <td>{{item.inquiryNo}}</td>
                                    <td>{{item.inquiryType}}</td>
                                    <td class="admin-id-cell">
                                        <span class="admin-id-text" :title="item.userId">
                                            {{ item.userId }}
                                        </span>
                                    </td>

                                    <td class="text-left">
                                        {{item.title}}
                                    </td>

                                    <td>{{item.regDate}}</td>

                                    <td>
                                        <span class="status-badge"
                                            :class="item.status == 'WAIT' ? 'waiting' : 'complete'">
                                            {{item.status}}
                                        </span>
                                    </td>

                                    <td>
                                        <button @click="fnselectInquiry(item)">보기</button>
                                    </td>

                                </tr>
                                <tr v-for="n in emptyRows" class="empty-row">
                                    <td colspan="7">&nbsp;</td>
                                </tr>
                                <tr v-if="inquirylist.length == 0">
                                    <td colspan="6">문의 내역 없음</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징  -->
                        <div class="page-box">
                            <button @click="fnPageMove(currentPage-1)" :disabled="currentPage==1">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <template v-for="p in index">
                                <button
                                    v-if="p > Math.floor((currentPage - 1) / 5) * 5 && p <= Math.ceil(currentPage / 5) * 5"
                                    :key="p" @click="fnPageMove(p)" :class="{active: currentPage === p}">
                                    {{ p }}
                                </button>
                            </template>
                            <button @click="fnPageMove(currentPage+1)" :disabled="currentPage==index">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 모달 -->
                <div class="modal fade" id="inquiryModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">

                            <div class="modal-header">
                                <h5 class="modal-title">문의 상세</h5>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>

                            <div class="modal-body" v-if="selected">

                                <p><b>작성자 :</b> {{selected.userId}}</p>
                                <p><b>제목 :</b> {{selected.title}}</p>
                                <p><b>등록일 :</b> {{selected.regDate}}</p>

                                <hr>

                                <p><b>문의 내용</b></p>

                                <div class="content-box">
                                    {{selected.content}}
                                </div>

                                <hr>

                                <p><b>답변</b></p>

                                <textarea class="form-control" rows="6" v-model="answerContent"
                                    placeholder="답변을 입력하세요"></textarea>

                            </div>

                            <div class="modal-footer">

                                <!-- 대기 중인 문의 -->
                                <button class="btn btn-success" v-if="selected && selected.status === 'WAIT'"
                                    @click="completeAnswer">
                                    답변 완료
                                </button>

                                <!-- 이미 완료된 문의 -->
                                <button class="btn btn-primary" v-if="selected && selected.status === 'DONE'"
                                    @click="updateAnswer">
                                    수정 저장
                                </button>

                                <button class="btn btn-warning" v-if="selected && selected.status === 'DONE'"
                                    @click="reopenInquiry">
                                    재처리하기
                                </button>

                                <button class="btn btn-secondary" data-dismiss="modal">
                                    닫기
                                </button>

                            </div>

                        </div>

                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        inquirylist: [],
                        selected: null,
                        answerContent: "",
                        status: "ALL",
                        sortType: "latest",
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

                    fnPageMove(p) {
                        if (p < 1 || p > this.index) return;

                        this.currentPage = p;
                        this.fnGetList();
                    },

                    fnResetSearch() {
                        this.status = "ALL";
                        this.sortType = "latest";
                        this.currentPage = 1;
                        this.fnGetList();
                    },

                    fnGetList() {
                        let self = this;
                        let param = {
                            status: self.status,
                            sortType: self.sortType,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1)
                        };
                        $.ajax({
                            url: "http://localhost:8080/inquiry.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (data) {
                                self.inquirylist = data.list || [];
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                                self.emptyRows = 8 - data.list.length;
                            }
                        });
                    },

                    fnselectInquiry(item) {
                        this.selected = item;
                        this.answerContent = item.answerContent || "";
                        console.log(this.selected);
                        $('#inquiryModal').modal('show');
                    },

                    fnchangeStatus(status) {
                        let self = this;
                        let param = {
                            inquiryNo: self.selected.inquiryNo,
                            answerContent: self.answerContent,
                            status: status
                        }
                        $.ajax({
                            url: "http://localhost:8080/changeAnswer.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: function (res) {
                                self.selected.status = status;
                                self.fnGetList(); // 왼쪽 리스트 갱신
                                alert("상태 변경 완료");
                            }
                        });
                    },
                    saveAnswer() {
                        let self = this;

                        if (!self.answerContent) {
                            alert("답변 입력하세요");
                            return;
                        }

                        $.ajax({
                            url: "http://localhost:8080/inquiryAnswer.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                inquiryNo: self.selected.inquiryNo,
                                answerContent: self.answerContent,
                                status: self.selected.status
                            },
                            success: function () {
                                alert("저장 완료");

                                // 목록 새로고침
                                self.fnGetList();

                                // 선택 유지하고 싶으면 아래 유지
                                // self.selected.answerContent = self.answerContent;
                            }
                        });
                    },

                    completeAnswer() {
                        let self = this;

                        if (!self.answerContent.trim()) {
                            alert("답변을 입력하세요.");
                            return;
                        }

                        if (!confirm("답변을 등록하고 문의를 완료 처리하시겠습니까?")) {
                            return;
                        }

                        $.ajax({
                            url: "/inquiryAnswer.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                inquiryNo: self.selected.inquiryNo,
                                answerContent: self.answerContent
                            },
                            success: function (res) {
                                if (res.result === "success") {
                                    self.selected.answerContent = self.answerContent;
                                    self.selected.status = "DONE";
                                    self.fnGetList();

                                    if (res.notificationResult === "fail") {
                                        alert("답변은 저장됐지만 알림 발송에 실패했습니다.");
                                    } else {
                                        alert("답변이 등록되고 완료 처리되었습니다.");
                                    }
                                } else {
                                    alert(res.message || "답변 처리에 실패했습니다.");
                                }
                            },
                            error: function () {
                                alert("서버 통신 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    updateAnswer() {
                        let self = this;

                        if (!self.answerContent.trim()) {
                            alert("답변을 입력하세요.");
                            return;
                        }

                        $.ajax({
                            url: "/inquiryAnswerUpdate.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                inquiryNo: self.selected.inquiryNo,
                                answerContent: self.answerContent
                            },
                            success: function (res) {
                                if (res.result === "success") {
                                    self.selected.answerContent = self.answerContent;
                                    self.fnGetList();
                                    alert("답변이 수정되었습니다.");
                                } else {
                                    alert(res.message || "답변 수정에 실패했습니다.");
                                }
                            },
                            error: function () {
                                alert("서버 통신 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    reopenInquiry() {
                        let self = this;

                        if (!confirm("이 문의를 다시 처리 대기 상태로 변경하시겠습니까?")) {
                            return;
                        }

                        $.ajax({
                            url: "/changeAnswer.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                inquiryNo: self.selected.inquiryNo,
                                status: "WAIT"
                            },
                            success: function (res) {
                                if (res.result === "success") {
                                    self.selected.status = "WAIT";
                                    self.fnGetList();
                                    alert("다시 처리 대기 상태로 변경되었습니다.");
                                } else {
                                    alert(res.message || "상태 변경에 실패했습니다.");
                                }
                            },
                            error: function () {
                                alert("서버 통신 중 오류가 발생했습니다.");
                            }
                        });
                    }
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    const path = location.pathname;
                    this.fnGetList();
                }
            });

            app.mount('#app');
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>