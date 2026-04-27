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
            }

            .main {
                grid-area: main;
                border: 1px solid #ffc7c2;
                background: #f5f6f7;
                padding: 20px;
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }

            .board-container {
                padding: 20px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }

            .board-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                gap: 10px;
            }

            .board-header input,
            .board-header select {
                border: 1px solid #ddd;
                padding: 6px 10px;
                border-radius: 6px;
            }

            .keyword-group input {
                border: 1px solid #ddd;
                padding: 6px 10px;
                border-radius: 6px;
                outline: none;
            }

            .keyword-group select {
                border: 1px solid #ddd;
                padding: 6px;
                border-radius: 6px;
            }

            .filter-group {
                display: flex;
                flex-direction: row;
            }

            .filter-group select {
                border: 1px solid #ddd;
                padding: 6px;
                border-radius: 6px;
            }

            /* 테이블 */
            .board-table {
                width: 1000px;
                border-collapse: collapse;
            }

            .board-table tr {
                cursor: pointer;
            }

            .board-table th {
                background: #f1f3f5;
                padding: 10px;
                font-size: 13px;
            }

            .board-table td {
                padding: 10px;
                font-size: 13px;
                border-bottom: 1px solid #eee;
            }

            .board-table tr:hover {
                background: #f8f9fa;
            }

            /* 선택 강조 */
            .active-row {
                background: #e7f1ff !important;
            }

            /* 상태 배지 */
            .status-badge {
                padding: 4px 8px;
                border-radius: 10px;
                font-size: 12px;
            }

            .status-active {
                background: #e6f4ea;
                color: #2f9e44;
            }

            .status-stop {
                background: #fff1f0;
                color: #d9480f;
            }

            .status-dormant {
                background: #f1f3f5;
                color: #868e96;
            }

            .status-withdraw {
                background: #000;
                color: #fff;
            }

            /* 신고 수 */
            .count-badge {
                background: red;
                color: white;
                border-radius: 50%;
                padding: 3px 8px;
                font-size: 12px;
            }

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

            .pagination-wrap {
                display: flex;
                gap: 5px;
            }

            .pagination-wrap button.active {
                background: #007bff;
                color: #fff;
                transform: scale(1.1);
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="board-container">

                        <h2>게시판 관리</h2>

                        <!-- 필터 영역 -->
                        <div class="board-header">
                            <div class="keyword-group">
                                <select v-model="searchType">
                                    <option value="all">전체</option>
                                    <option value="userId">ID</option>
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                </select>

                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnGetBoardList">
                                <button @click="fnGetBoardList">검색</button>
                            </div>
                            <div class="filter-group">
                                <select v-model="category" @change="fnGetBoardList">
                                    <option value="ALL">분류 전체</option>
                                    <option value="자유">자유</option>
                                    <option value="질문">질문</option>
                                    <option value="정보">정보</option>
                                </select>
                                <div>
                                    정렬
                                    <select v-model="sortType" @change="fnGetBoardList">
                                        <option value="latest">최신순</option>
                                        <option value="old">오래된순</option>
                                    </select>
                                </div>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <!-- 테이블 -->
                        <table class="board-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>분류</th>
                                    <th>제목</th>
                                    <th>ID</th>
                                    <th>작성일</th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="board in boardList"
                                    :class="{ 'active-row': selectedBoard && selectedBoard.userId === board.userId }"
                                    @click="fnSelectBoard(board)">

                                    <td>{{board.postNo}}</td>
                                    <td>{{board.category}}</td>
                                    <td>{{board.title}}</td>
                                    <td>{{board.userId}}</td>
                                    <td>{{ formatDate(board.regDate) }}</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination-wrap">
                            <button @click="fnPageMove(currentPage-1)" :disabled="currentPage===1">‹</button>

                            <button v-for="p in index" :key="p" @click="fnPageMove(p)"
                                :class="{active: currentPage === p}">
                                {{ p }}
                            </button>

                            <button @click="fnPageMove(currentPage+1)" :disabled="currentPage===index">›</button>
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
                        boardList: [],
                        sessionId: "${sessionScope.sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                        searchType: "all",
                        category: "ALL",
                        keyword: "",
                        sortType:"latest",
                        selectedBoard: null,
                        pageSize: 10,
                        index: 1,
                        currentPage: 1,
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
                        this.fnGetBoardList();
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnGetBoardList: function () {
                        let self = this;
                        let param = {
                            searchType: self.searchType,
                            sortType: self.sortType,
                            keyword: self.keyword,
                            category: self.category,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1),
                        };
                        console.log(param);
                        console.log("category:", "[" + self.category + "]");
                        $.ajax({
                            url: "http://localhost:8080/boardList.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                console.log(data.list);
                                self.boardList = data.list || [];
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                            }
                        });
                    },

                    selectBoard(board) {
                        location.href = "/adminBoardDetail.do?postNo=" + board.postNo;
                    },

                    fnSelectBoard(board) {
                        window.open('http://localhost:8080/api/community/detail.do?postNo=' + board.postNo, '_blank', 'width=1000, height=1000');
                    },

                    getStatusInfo(status) {
                        const map = {
                            ACTIVE: { text: "활동", color: "green" },
                            STOP: { text: "정지", color: "red" },
                            DORMANT: { text: "휴면", color: "gray" },
                            WITHDRAWN: { text: "탈퇴", color: "black" }
                        };

                        return map[status] || { text: "알수없음", color: "black" };
                    },

                    getStatusClass(status) {
                        const map = {
                            ACTIVE: "status-active",
                            STOP: "status-stop",
                            DORMANT: "status-dormant",
                            WITHDRAWN: "status-withdraw"
                        };
                        return map[status] || "";
                    },

                    fnResetSearch() {
                        this.keyword = "";
                        this.currentPage = 1;
                        this.sortType = "latest";
                        this.searchType = "all";
                        this.category = "ALL"
                        this.fnGetBoardList();
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
                    self.fnGetBoardList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>