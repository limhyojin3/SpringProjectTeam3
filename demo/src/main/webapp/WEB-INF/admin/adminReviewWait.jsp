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
                /* 높이 고정 (쉼표 없음) */
                grid-template-columns: 300px 1fr;
                /* 너비 고정 */
                gap: 5px;
            }

            .main {
                grid-area: main;
                padding: 20px;
                display: flex;
                gap: 20px;
                /* 카드 사이 간격 */
                align-items: flex-start;
                /* 카드들이 위쪽에 고정되도록 */
            }

            .main {
                display: flex;
                height: 500px;
                border: 1px solid #ddd;
            }

            /* 왼쪽 리스트 */
            .left {
                width: 40%;
                border-right: 1px solid #ddd;
                overflow-y: auto;
            }

            /* 오른쪽 상세 */
            .right {
                width: 60%;
                padding: 20px;
            }

            /* 테이블 */
            table {
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                border-bottom: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            /* 클릭된 행 */
            tr.active {
                background-color: #e6f2ff;
            }

            /* 상세 */
            .detail {
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            /* 버튼 영역 (아래 고정 느낌) */
            .actionBox {
                margin-top: auto;
                display: flex;
                gap: 10px;
            }

            button {
                padding: 10px 20px;
                cursor: pointer;
            }

            .tableTitle {
                display: flex;
                align-items: center;
                flex-direction: row;
                gap: 20px;
            }

            .newBox {
                text-align: center;
                border: 2px solid #bd2915;
                background-color: #f24822;
                color: white;
                border-radius: 5px;
                font-size: 1em;
                width: 80px;
                height: 30px;
                font-weight: bold;
            }

            .reviewTable table,
            th,
            td {
                border-collapse: collapse;
                border: 1px solid black;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <!-- 왼쪽: 리뷰 리스트 -->
                    <div class="left">
                        <div class="tableTitle">
                            <h2>승인 대기중인 리뷰</h2>
                            <div class="newBox">new {{reviewWait}}개</div>
                        </div>
                        <table>
                            <tr>
                                <th>번호</th>
                                <th>리뷰번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>완료여부</th>
                            </tr>
                            <tr v-for="item in reviewList" :key="reviewNo"
                                :class="{ active: selectedReview === item.reviewNo}"
                                @click="selectReview(item.reviewNo)">
                                <td>{{item.reviewNo}}</td>
                                <td>{{}}</td>
                                <td>{{item.title}}</td>
                                <td>{{item.userId}}</td>
                                <td>{{item.postDay}}</td>
                                <td>{{item.approvalStatus}}</td>
                            </tr>
                        </table>
                    </div>

                    <!-- 오른쪽: 상세 -->
                    <div class="right">
                        <div v-if="selectedReview" class="detail">
                            <h3>{{ selectedReview.title }}</h3>
                            <p>{{ selectedReview.content }}</p>
                            <p><b>작성자:</b> {{ selectedReview.writer }}</p>

                            <!-- 하단 버튼 -->
                            <div class="actionBox">
                                <button @click="approveReview">승인</button>
                                <button @click="rejectReview">거절</button>
                            </div>
                        </div>

                        <div v-else class="empty">
                            리뷰를 선택하세요
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
                        reviewWait: 0,
                        reviewNo: 0,
                        userId: "",
                        approvalStatus: "",
                        title: "",
                        postDay: "",
                        selectedReview: null
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },
                    fnGetReviewList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/viewReview.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data)
                                self.reviewList = data.list;
                                self.reviewWait = self.reviewList[0].reviewWait;
                            }
                        });
                    },
                    selectReview(reviewNo) {
                        this.selectedReview = reviewNo;
                    },
                    approveReview() {
                        confirm("승인하시겠습니까?");
                        this.removeReview();
                    },
                    rejectReview() {
                        confirm("거절하시겠습니까?");
                        this.removeReview();
                    },
                    removeReview() {

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
                    self.fnGetReviewList();

                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>