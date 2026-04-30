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
        <style>
            body {
                background-color: #f5f6f7;
                font-size: 14px;
                color: #333;
            }

            .middle {
                width: 100%;
                display: grid;
                grid-template-areas: "nav main";
                grid-template-columns: 300px 1fr;
                gap: 5px;
            }

            .main {
                grid-area: main;
                background: #f5f6f7;
                padding: 20px;
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }

            .inquiry-container {

                padding: 20px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }

            .inquiry-container h2 {
                margin-bottom: 18px;
                font-size: 24px;
                font-weight: 700;
            }

            /* 상단 헤더 */
            .inquiry-header {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 18px;
            }

            .inquiry-header h2 {
                margin: 0;
                font-size: 26px;
                font-weight: 700;
                color: #222;
            }

            .filter-group {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .filter-group div {
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .filter-group span {
                font-size: 14px;
                font-weight: 600;
                color: #555;
            }

            .filter-group select {
                border: 1px solid #ddd;
                padding: 6px 10px;
                border-radius: 8px;
                min-width: 110px;
                outline: none;
            }

            .filter-group button {
                border: none;
                background: #007bff;
                color: #fff;
                padding: 7px 14px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 13px;
            }

            .filter-group button:hover {
                background: #0069d9;
            }

            /* 테이블 */
            .inquiry-table {
                width: 1000px;
                border-collapse: collapse;
                background: #fff;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

            }

            .inquiry-table th {
                background: #f1f3f5;
                font-weight: 600;
                font-size: 13px;
                color: #555;
                border-bottom: 1px solid #eee;
                padding: 12px 10px;
                text-align: center;
            }

            .inquiry-table td {
                padding: 12px 10px;
                border-bottom: 1px solid #f1f1f1;
                font-size: 13px;
                color: #333;
                text-align: center;
            }

            .inquiry-table tr:hover {
                background: #f8f9fa;
            }

            .text-left {
                text-align: left !important;
                max-width: 260px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

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

            /* 공통 버튼 */
            button {
                border: 1px solid #ddd;
                background: #fff;
                padding: 5px 10px;
                font-size: 12px;
                border-radius: 6px;
                cursor: pointer;
            }

            button:hover {
                background: #f8f9fa;
            }

            /* 하단 페이징 */
            .BatchPaging {
                display: flex;
                justify-content: space-between;
                margin-top: 15px;
            }

            .pagination-wrap {
                display: flex;
                gap: 5px;
            }

            .pagination-wrap button {
                border: 1px solid #ddd;
                background: #fff;
                padding: 5px 10px;
                border-radius: 6px;
            }

            .pagination-wrap button.active {
                background: #007bff;
                color: #fff;
                border: 1px solid #007bff;
                font-weight: bold;
            }

            .pagination-wrap button:hover:not(:disabled) {
                background: #e6f0ff;
            }

            .pagination-wrap button:disabled {
                cursor: not-allowed;
                opacity: .5;
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

                .inquiry-header {
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
                    <div class="inquiry-container">
                        <h2>문의 관리</h2>
                        <div class="inquiry-header">
                            <div class="filter-group">
                                <div>
                                    <select v-model="status" @change="fnGetList">
                                        <option value="ALL">처리상태</option>
                                        <option value="WAIT">WAIT</option>
                                        <option value="DONE">DONE</option>
                                    </select>
                                </div>
                                <div>
                                    <span>정렬</span>
                                    <select v-model="sortType" @change="fnGetList">
                                        <option value="latest">최신순</option>
                                        <option value="old">오래된순</option>
                                    </select>
                                </div>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <!-- 리스트 -->
                        <table class="inquiry-table">
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
                                    <td>{{item.userId}}</td>

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

                                <tr v-if="inquirylist.length == 0">
                                    <td colspan="6">문의 내역 없음</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징  -->
                        <div class="pagination-wrap">
                            <button @click="fnPageMove(currentPage-1)" :disabled="currentPage==1">‹</button>

                            <button v-for="p in index" :key="p" @click="fnPageMove(p)"
                                :class="{active: currentPage==p}">
                                {{p}}
                            </button>

                            <button @click="fnPageMove(currentPage+1)" :disabled="currentPage==index">›</button>
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

                                <button class="btn btn-primary" @click="saveAnswer()">
                                    저장
                                </button>

                                <button class="btn btn-success" v-if="selected && selected.status == 'WAIT'"
                                    @click="fnchangeStatus('DONE')">
                                    DONE
                                </button>

                                <button class="btn btn-danger" v-if="selected && selected.status == 'DONE'"
                                    @click="fnchangeStatus('WAIT')">
                                    WAIT
                                </button>

                                <button class="btn btn-secondary" data-dismiss="modal">
                                    닫기
                                </button>

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
                            activeMenu: "",
                            inquirylist: [],
                            selected: null,
                            answerContent: "",
                            status: "ALL",
                            sortType: "latest",
                            pageSize: 5,
                            index: 1,
                            currentPage: 1
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

                            $.ajax({
                                url: "http://localhost:8080/inquiryAnswer.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    inquiryNo: self.selected.inquiryNo,
                                    answerContent: self.answerContent,
                                    status: status
                                },
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
                                            path.includes('adminReviewWait') ? 'reviewWait' :
                                                path.includes('adminPayment') ? 'payment' :
                                                    path.includes('adminReport') ? 'report' :
                                                        path.includes('adminInquiry') ? 'inquiry' :
                                                            path.includes('adminStatistics') ? 'stats' :
                                                                '';
                        this.fnGetList();
                    }
                });

                app.mount('#app');
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>