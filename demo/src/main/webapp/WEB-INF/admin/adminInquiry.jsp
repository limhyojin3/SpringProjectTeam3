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
                /* 화면 전체 높이를 사용하되, 헤더/푸터 제외한 나머지는 유연하게(1fr) */
                display: grid;
                grid-template-areas:
                    "nav main";
                grid-template-columns: 300px 1fr;
                /* 너비 고정 */
            }

            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
                padding: 20px;
                display: flex;
                gap: 20px;
                /* 카드 사이 간격 */
                align-items: flex-start;
                /* 카드들이 위쪽에 고정되도록 */
            }

            .inquiry-wrap {
                display: flex;
                width: 100%;
                gap: 20px;
            }

            .left {
                width: 40%;
                border: 1px solid #ddd;
                height: 70vh;
                overflow-y: auto;
            }

            .right {
                flex: 1;
                border: 1px solid #ddd;
                padding: 15px;
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
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>ID</th>
                                        <th>제목</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in inquirylist" @click="selectInquiry(item)">
                                        <td>{{item.inquiryNo}}</td>
                                        <td>{{item.userId}}</td>
                                        <td>{{item.title}}</td>
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
                            <p style="color: gray; font-size: 12px;">
                                {{ selected.regDate || selected.reg_date }}
                            </p>

                            <hr>

                            <!-- 문의 내용 -->
                            <div style="min-height:150px;">
                                {{ selected.content }}
                            </div>

                            <hr>

                            <!-- 답변 영역 -->
                            <h6>답변</h6>

                            <textarea class="form-control" v-model="answer" placeholder="답변을 입력하세요" rows="6"></textarea>

                            <br>

                            <!-- 상태 -->
                            <select class="form-control" v-model="selected.status">
                                <option value="WAIT">WAIT</option>
                                <option value="DONE">DONE</option>
                            </select>

                            <br>

                            <!-- 저장 버튼 -->
                            <button class="btn btn-primary" @click="saveAnswer">
                                저장
                            </button>

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
                        answer: "",
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
                        this.answer = item.answer || "";
                        console.log(this.selected);
                    },

                    saveAnswer() {
                        let self = this;

                        if (!self.answer) {
                            alert("답변 입력하세요");
                            return;
                        }

                        $.ajax({
                            url: "http://localhost:8080/inquiryAnswer.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                inquiryNo: self.selected.inquiryNo,
                                answer: self.answer,
                                status: self.selected.status
                            },
                            success: function () {
                                alert("저장 완료");

                                // 목록 새로고침
                                self.fnGetList();

                                // 선택 유지하고 싶으면 아래 유지
                                // self.selected.answer = self.answer;
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