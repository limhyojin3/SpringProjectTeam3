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
        <style>
            .middle {
                width: 100%;
                /* 화면 전체 높이를 사용하되, 헤더/푸터 제외한 나머지는 유연하게(1fr) */
                display: grid;
                grid-template-areas:
                    "nav main";
                /* 높이 고정 (쉼표 없음) */
                grid-template-columns: 220px 1fr;
                /* 너비 고정 */
                gap: 5px;
            }

            .navi {
                grid-area: nav;
                border: 1px solid blue;
                padding: 20px 10px;
                display: flex;
                flex-direction: column;
                gap: 8px;
                background-color: #ffc7c2;
            }

            .navi-btn {
                width: 100%;
                padding: 12px 10px;
                text-align: left;
                background-color: white;
                border: 1px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
            }

            .navi-btn:hover {
                background-color: #e3f2fd;
                border-color: #2196f3;
                color: #1976d2;
            }

            .activebtn {
                background-color: #ff6b6b;
                color: white;
                font-weight: bold;
                border: 1px solid #ff6b6b;
            }

            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
                background-color: #ffc7c2;
                padding: 20px;
                display: flex;
                gap: 20px;
                /* 카드 사이 간격 */
                align-items: flex-start;
                /* 카드들이 위쪽에 고정되도록 */
            }

            .report-container {
                padding: 20px;
                font-family: sans-serif;
                background: #f9f9f9;
            }

            .report-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .filter-group {
                display: flex;
                flex-direction: row;
            }

            .report-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .report-table th,
            .report-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
                text-align: center;
                font-size: 14px;
            }

            .report-table th {
                background: #f4f7f6;
                color: #666;
                font-weight: 600;
            }

            .report-table tr:hover {
                background: #fcfcfc;
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

            .type-tag {
                font-size: 11px;
                padding: 2px 5px;
                border-radius: 3px;
                margin-right: 5px;
                font-weight: bold;
            }

            .tag-user {
                background: #e3f2fd;
                color: #1976d2;
            }

            /* 파란색 계열 */
            .tag-review {
                background: #f3e5f5;
                color: #7b1fa2;
            }

            /* 보라색 계열 */

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
                font-size: 12px;
            }

            .waiting {
                background: #eee;
                color: #666;
            }

            .complete {
                background: #4caf50;
                color: #fff;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <div class="navi">
                    <button :class="['navi-btn', activeMenu === 'main' ? 'activebtn' : '']"
                        @click="fnPage('/adminMain.do')">관리자 메인 페이지</button>

                    <button :class="['navi-btn', activeMenu === 'user' ? 'activebtn' : '']"
                        @click="fnPage('/adminUser.do')">전체 회원 목록</button>

                    <button :class="['navi-btn', activeMenu === 'company' ? 'activebtn' : '']"
                        @click="fnPage('/adminCompany.do')">전체 업체 목록</button>

                    <button :class="['navi-btn', activeMenu === 'board' ? 'activebtn' : '']"
                        @click="fnPage('/adminBoard.do')">전체 게시판/리뷰 목록</button>

                    <button :class="['navi-btn', activeMenu === 'reviewWait' ? 'activebtn' : '']"
                        @click="fnPage('/adminReviewWait.do')">승인 대기중인 리뷰</button>

                    <button :class="['navi-btn', activeMenu === 'payment' ? 'activebtn' : '']"
                        @click="fnPage('/adminPayment.do')">결제 및 상품 관리</button>

                    <button :class="['navi-btn', activeMenu === 'report' ? 'activebtn' : '']"
                        @click="fnPage('/adminReport.do')">신고 관리</button>

                    <button :class="['navi-btn', activeMenu === 'stats' ? 'activebtn' : '']"
                        @click="fnPage('/adminStatistics.do')">통계</button>
                </div>
                <div class="main">
                    <div class="report-container">
                        <!-- 상단 필터 영역 -->
                        <div class="report-header">
                            <h2>신고 제보 관리</h2>
                            <div class="filter-group">
                                <div>
                                    신고대상
                                    <select v-model="targetType" @change="fnGetReportList">
                                        <option value="ALL">전체</option>
                                        <option value="MEMBER">회원</option>
                                        <option value="POST">게시글</option>
                                        <option value="REVIEW">리뷰</option>
                                        <option value="COMPANY">업체</option>
                                    </select>
                                </div>
                                <div>
                                    처리상태
                                    <select v-model="processStatus" @change="fnGetReportList">
                                        <option value="ALL">전체</option>
                                        <option value="WAIT_ACTION">조치대기</option> <!-- action_status = 0 -->
                                        <option value="WAIT_ANSWER">답변대기</option>
                                        <!-- action_status = 1 AND answer_status = 0 -->
                                        <option value="COMPLETED">처리완료</option>
                                        <!-- action_status = 1 AND answer_status = 1 -->
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- 리스트 바디 -->
                        <table class="report-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>신고자</th>
                                    <th>신고 대상 (유형/ID)</th>
                                    <th>신고 사유</th>
                                    <th>일시</th>
                                    <th>조치/통보</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="r in reportList" :key="r.reportNo">
                                    <td>{{ r.reportNo }}</td>
                                    <td>{{ r.reporterId }}</td>
                                    <td>
                                        <span class="type-tag" :class="'tag-' + r.targetType.toLowerCase()">
                                            {{ r.targetType }}
                                        </span>
                                        <span class="target-id">{{ r.uniTargetId }}</span>
                                    </td>
                                    <td class="text-left">{{ r.reportContent }}</td>
                                    <td>{{ r.regDate }}</td>
                                    <td>
                                        <span class="status-badge"
                                            :class="r.actionStatus == 0 ? 'waiting' : (r.answerStatus == 0 ? 'status-process' : 'complete')">
                                            {{ r.actionStatus == 0 ? '조치대기'
                                            : (r.answerStatus == 0 ? '답변대기' : '완료') }}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn-sm" @click="fnSelectReport(r)">보기</button>
                                    </td>
                                </tr>
                                <tr v-if="reportList.length === 0">
                                    <td colspan="7">신고 내역 없음</td>
                                </tr>
                            </tbody>
                        </table>
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
                        answerContent: "",
                        reportNo: 0,
                        reporterId: "",
                        targetType: "ALL",
                        processStatus: "ALL",
                        uniTargetId: "",
                        reportTitle: "",
                        reportContent: "",
                        actionStatus: "",
                        answerStatus: "",
                        regDate: ""

                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnSelectReport: function (r) {
                        this.selectedReport = r;
                        this.answerContent = r.answerContent || "";
                    },
                    fnGetReportList: function () {
                        let self = this;
                        let param = {
                            targetType: self.targetType,
                            processStatus: self.processStatus
                        };
                        $.ajax({
                            url: "http://localhost:8080/viewReport.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                console.log("전체:", data);
                                console.log("list:", data.list);
                                console.log("길이:", data.list ? data.list.length : "없음");
                                self.reportList = data.list;
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
                                        path.includes('adminReviewWait') ? 'reviewWait' :
                                            path.includes('adminPayment') ? 'payment' :
                                                path.includes('adminReport') ? 'report' :
                                                    path.includes('adminStatistics') ? 'stats' :
                                                        '';
                    self.fnGetReportList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>