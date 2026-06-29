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
            .table tr:hover {
                cursor: pointer;
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
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="container admin-fade-up delay-1">

                        <h2>회원 관리</h2>

                        <!-- 필터 영역 -->
                        <div class="header">
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
                                <button @click="fnReport">신고수</button>
                                <select v-model="statusFilter" @change="fnGetUserList">
                                    <option value="ALL">상태</option>
                                    <option value="ACTIVE">활동</option>
                                    <option value="STOP">정지</option>
                                    <option value="DORMANT">휴면</option>
                                    <option value="WITHDRAWN">탈퇴</option>
                                </select>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <!-- 테이블 -->
                        <table class="table">
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

                                    <td class="admin-id-cell">
                                        <span class="admin-id-text" :title="user.userId">
                                            {{ user.userId }}
                                        </span>
                                    </td>
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
                                <tr v-for="n in emptyRows" class="empty-row">
                                    <td colspan="7">&nbsp;</td>
                                </tr>
                            </tbody>
                        </table>
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
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        userList: [],
                        sessionId: "${sessionScope.sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                        searchType: "all",
                        keyword: "",
                        sort: "",
                        statusFilter: "ALL",
                        selectedUser: null,
                        pageSize: 10,
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
                    fnReport: function () {
                        this.sort = "report";
                        this.fnGetUserList();
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
                            sort: self.sort,
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
                                self.emptyRows = 10 - data.list.length;
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
                        this.sort = "";
                        this.fnGetUserList();

                    },

                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    const path = location.pathname;
                    self.fnGetUserList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>