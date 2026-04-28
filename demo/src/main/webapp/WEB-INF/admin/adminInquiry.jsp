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
            .middle {
                width: 100%;
                display: grid;
                grid-template-areas: "nav main";
                grid-template-columns: 300px 1fr;
                min-height: calc(100vh - 160px);
                background: #f8f9fc;
            }

            .main {
                grid-area: main;
                padding: 35px;
            }

            /* 좌우 감싸는 영역 */
            .inquiry-wrap {
                display: flex;
                width: 100%;
                gap: 20px;
            }

            /* ================= 왼쪽 리스트 ================= */
            .left {
                flex: 1.2;
                /* 기존 비율 유지 */
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, .06);
                overflow: hidden;
                height: 75vh;
            }

            /* 테이블 */
            .left table {
                margin: 0;
            }

            .left thead {
                background: #f4f6fa;
            }

            .left th {
                padding: 16px;
                font-size: 14px;
                font-weight: 700;
                color: #444;
                text-align: center;
                border-bottom: 1px solid #e6eaf0;
            }

            .left td {
                padding: 15px;
                font-size: 14px;
                color: #555;
                text-align: center;
                border-bottom: 1px solid #f0f2f5;
            }

            .left tbody tr {
                cursor: pointer;
                transition: .2s;
            }

            .left tbody tr:hover {
                background: #f8fbff;
            }

            /* ================= 오른쪽 상세 ================= */
            .right {
                flex: 1;
                /* 기존 비율 유지 */
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, .06);
                padding: 28px;
                min-height: 75vh;
            }

            /* 제목 */
            .right h5 {
                font-size: 24px;
                font-weight: 700;
                color: #222;
                margin-bottom: 10px;
            }

            /* 날짜 */
            .right p {
                font-size: 13px;
                color: #888;
                margin-bottom: 18px;
            }

            /* 문의 내용 */
            .right .content-area {
                min-height: 180px;
                background: #f8f9fc;
                padding: 18px;
                border-radius: 14px;
                line-height: 1.7;
                color: #444;
                margin-bottom: 25px;
            }

            /* 답변 제목 */
            .right h6 {
                font-size: 16px;
                font-weight: 700;
                color: #333;
                margin-bottom: 10px;
            }

            /* textarea */
            .right textarea.form-control {
                border-radius: 14px;
                border: 1px solid #dfe4ea;
                resize: none;
                padding: 14px;
            }

            /* select */
            .right select.form-control {
                border-radius: 12px;
                height: 46px;
            }

            /* 버튼 */
            .right .btn {
                min-width: 110px;
                height: 44px;
                border: none;
                border-radius: 12px;
                font-weight: 600;
                transition: .2s;
            }

            .right .btn-primary {
                background: linear-gradient(135deg, #4a7dff, #275df7);
            }

            .right .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 14px rgba(39, 93, 247, .25);
            }

            /* 상태 색상 */
            .text-danger {
                color: #e04a4a !important;
                font-weight: 700;
            }

            .text-success {
                color: #1c9b52 !important;
                font-weight: 700;
            }

            /* 선택 안 했을 때 */
            .right:has(p:only-child) {
                display: flex;
                justify-content: center;
                align-items: center;
                color: #999;
                font-size: 18px;
                font-weight: 600;
            }

            /* 반응형 */
            @media (max-width:1100px) {
                .inquiry-wrap {
                    flex-direction: column;
                }

                .left,
                .right {
                    flex: none;
                    width: 100%;
                    height: auto;
                    min-height: auto;
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="inquiry-wrap">

                        <!-- 왼쪽 리스트 -->
                        <div class="left">
                            <select class="form-control" style="width:150px; margin-bottom:10px;" v-model="status"
                                @change="fnGetList">
                                <option value="">전체</option>
                                <option value="WAIT">WAIT</option>
                                <option value="DONE">DONE</option>
                            </select>
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>ID</th>
                                        <th>제목</th>
                                        <th>등록일</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in inquirylist" :key="item.inquiryNo" @click="selectInquiry(item)">
                                        <td>{{item.inquiryNo}}</td>
                                        <td>{{item.userId}}</td>
                                        <td>{{item.title}}</td>
                                        <td>{{item.regDate}}</td>
                                        <td :class="item.status === 'WAIT' ? 'text-danger' : 'text-success'">
                                            {{item.status}}
                                        </td>

                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 오른쪽 상세 -->
                        <div class="right" v-if="selected">

                            <!-- 제목 -->
                            <h5>{{ selected.title }}</h5>

                            <!-- 작성일 (있으면) -->
                            <p>
                                {{ selected.regDate || selected.reg_date }}
                            </p>

                            <hr>

                            <!-- 문의 내용 -->
                            <div class="content-area">
                                {{ selected.content }}
                            </div>

                            <hr>

                            <!-- 답변 영역 -->
                            <h6>답변</h6>

                            <textarea class="form-control" rows="7" v-model="answerContent"
                                placeholder="답변을 입력하세요"></textarea>

                            <br>

                            <!-- 저장 및 상태변경 버튼 -->
                            <div style="display:flex; gap:10px;">
                                <button class="btn btn-primary" @click="saveAnswer()">
                                    저장
                                </button>

                                <button class="btn btn-success" v-if="selected.status == 'WAIT'"
                                    @click="fnchangeStatus('DONE')">
                                    DONE
                                </button>

                                <button class="btn btn-danger" v-else @click="fnchangeStatus('WAIT')">
                                    WAIT
                                </button>
                            </div>

                        </div>

                        <!-- 선택 안했을 때 -->
                        <div class="right" v-else>
                            <p>문의를 선택하세요</p>
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
                        inquirylist: [],
                        selected: null,
                        answerContent: "",
                        status: ""
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },


                    fnGetList() {
                        let self = this;
                        $.ajax({
                            url: "http://localhost:8080/inquiry.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                status: self.status
                            },
                            success: function (data) {
                                self.inquirylist = data.list;
                            }
                        });
                    },

                    selectInquiry(item) {
                        this.selected = item;
                        this.answerContent = item.answerContent || "";
                        console.log(this.selected);
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
    </body>

    </html>