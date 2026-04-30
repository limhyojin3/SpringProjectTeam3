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
                background: #f5f6f7;
                padding: 20px;
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }

            .user-container {
                padding: 20px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            }

            .user-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                gap: 10px;
            }

            .user-header input,
            .user-header select {
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
            .user-table {
                width: 1000px;
                border-collapse: collapse;
            }

            .user-table tr {
                cursor: pointer;
            }

            .user-table th {
                background: #f1f3f5;
                padding: 10px;
                font-size: 13px;
            }

            .user-table td {
                padding: 10px;
                font-size: 13px;
                border-bottom: 1px solid #eee;
            }

            .user-table tr:hover {
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
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="user-container">

                        <h2>회원 관리</h2>

                        <!-- 필터 영역 -->
                        <div class="user-header">
                            <div class="keyword-group">
                                <select v-model="searchType">
                                    <option value="all">전체</option>
                                    <option value="userId">아이디</option>
                                    <option value="name">이름</option>
                                    <option value="nickName">닉네임</option>
                                </select>

                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnGetUserList">
                                <button @click="fnGetUserList">검색</button>
                            </div>
                            <div class="filter-group">
                                <select v-model="statusFilter" @change="fnGetUserList">
                                    <option value="ALL">상태 전체</option>
                                    <option value="ACTIVE">활동</option>
                                    <option value="STOP">정지</option>
                                    <option value="DORMANT">휴면</option>
                                    <option value="WITHDRAWN">탈퇴</option>
                                </select>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <!-- 테이블 -->
                        <table class="user-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>이름</th>
                                    <th>닉네임</th>
                                    <th>상태</th>
                                    <th>신고</th>
                                    <th>마지막 로그인</th>
                                    <th>가입일</th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="user in userList"
                                    :class="{ 'active-row': selectedUser && selectedUser.userId === user.userId }"
                                    @click="selectUser(user)">

                                    <td>{{user.userId}}</td>
                                    <td>{{user.name}}</td>
                                    <td>{{user.nickName || '-'}}</td>

                                    <td>
                                        <span class="status-badge" :class="getStatusClass(user.status)">
                                            {{ getStatusInfo(user.status).text }}
                                        </span>
                                    </td>

                                    <td>
                                        <span v-if="user.reportCount > 0" class="count-badge">
                                            {{ user.reportCount }}
                                        </span>
                                        <span v-else>-</span>
                                    </td>

                                    <td>{{ formatDate(user.lastLogin) }}</td>
                                    <td>{{ formatDate(user.regDate) }}</td>
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
                        userList: [],
                        sessionId: "${sessionScope.sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                        searchType: "all",
                        keyword: "",
                        statusFilter: "ALL",
                        selectedUser: null,
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
                        this.fnGetUserList();
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnGetUserList: function () {
                        let self = this;
                        let param = {
                            searchType: self.searchType,
                            keyword: self.keyword,
                            status: self.statusFilter,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1),
                        };
                        $.ajax({
                            url: "http://localhost:8080/userList.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.userList = data.list || [];
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                            }
                        });
                    },

                    selectUser(user) {
                        location.href = "/adminUserDetail.do?userId=" + user.userId;
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
                        this.page = 1;
                        this.searchType = "all";
                        this.statusFilter = "ALL";
                        this.fnGetUserList();
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
                    self.fnGetUserList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>