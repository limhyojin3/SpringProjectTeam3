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

            button:hover {
                background: #f8f9fa;
            }

            .role-badge {
                padding: 4px 8px;
                border-radius: 10px;
                font-size: 12px;
            }

            .partner {
                background: #e3f2fd;
                color: #1976d2;
            }

            .normal {
                background: #f1f3f5;
                color: #555;
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

                        <h2>업체 관리</h2>
                        <!-- 필터 영역 -->
                        <div class="header">
                            <div class="keyword-group">
                                <select v-model="searchType">
                                    <option value="all">전체</option>
                                    <option value="userId">아이디</option>
                                    <option value="companyName">업체명</option>
                                    <option value="ceoName">대표자명</option>
                                </select>
                                <input v-model="keyword" placeholder="검색어 입력" @keyup.enter="fnGetCompanyList">
                                <button @click="fnGetCompanyList">검색</button>
                            </div>
                            <div class="filter-group">
                                <button @click="fnReport">신고수</button>
                                <div>
                                    <select v-model="role" @change="fnGetCompanyList">
                                        <option value="ALL">유형</option>
                                        <option value="PARTNER">제휴</option>
                                        <option value="NPARTNER">일반</option>
                                    </select>
                                </div>
                                <select v-model="statusFilter" @change="fnGetCompanyList">
                                    <option value="ALL">상태</option>
                                    <option value="ACTIVE">활동</option>
                                    <option value="STOP">정지</option>
                                    <option value="DORMANT">휴면</option>
                                    <option value="WITHDRAWN">탈퇴</option>
                                </select>
                                <button @click="fnResetSearch">초기화</button>
                            </div>
                        </div>

                        <table class="table">
                            <thead>
                                <tr>
                                    <th>유형</th>
                                    <th>ID</th>
                                    <th>업체명</th>
                                    <th>대표자</th>
                                    <th>상태</th>
                                    <th>신고</th>
                                    <th>가입일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="company in companyList" @click="selectCompany(company)">
                                    <td>
                                        <span class="role-badge"
                                            :class="company.role === 'PARTNER' ? 'partner' : 'normal'">
                                            {{ getRoleText(company.role) }}
                                        </span>
                                    </td>
                                    <td class="admin-id-cell">
                                        <span class="admin-id-text" :title="company.userId">
                                            {{ company.userId }}
                                        </span>
                                    </td>
                                    <td>{{company.companyName}}</td>
                                    <td>{{company.ceoName}}</td>
                                    <td>
                                        <span class="status-badge" :class="getStatusClass(company.status)">
                                            {{ getStatusInfo(company.status).text }}
                                        </span>
                                    </td>
                                    <td>
                                        <span v-if="company.reportCount > 0" class="count-badge">
                                            {{ company.reportCount }}
                                        </span>
                                        <span v-else>-</span>
                                    </td>
                                    <td>{{ formatDate(company.regDate) }}</td>
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
                        companyList: [],
                        sessionId: "${sessionScope.sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                        searchType: "all",
                        keyword: "",
                        sort: "",
                        role: "ALL",
                        statusFilter: "ALL",
                        selectedCompany: null,
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
                        this.fnGetCompanyList();
                    },
                    getRoleText(role) {
                        const map = {
                            PARTNER: "제휴",
                            NPARTNER: "일반"
                        };
                        return map[role] || role;
                    },

                    fnPageMove(p) {
                        if (p < 1 || p > this.index) return;
                        this.currentPage = p;
                        this.fnGetCompanyList();
                    },

                    selectCompany(company) {
                        location.href = "/adminCompanyDetail.do?userId=" + company.userId;
                    },

                    formatDate(date) {
                        return date ? date.substring(0, 10) : '-';
                    },

                    fnGetCompanyList: function () {
                        let self = this;
                        let param = {
                            searchType: self.searchType,
                            keyword: self.keyword,
                            role: self.role,
                            status: self.statusFilter,
                            pageSize: self.pageSize,
                            offSet: self.pageSize * (self.currentPage - 1),
                            sort: self.sort,
                        };
                        $.ajax({
                            url: "http://localhost:8080/companyList.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.companyList = data.list;
                                self.index = Math.ceil(data.totalCount / self.pageSize);
                                self.emptyRows = 10 - data.list.length;
                            }
                        });
                    },

                    fnResetSearch() {
                        this.keyword = "";
                        this.currentPage = 1;
                        this.searchType = "all";
                        this.role = "ALL"
                        this.statusFilter = "ALL";
                        this.sort = "";
                        this.fnGetCompanyList();
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
                }, // methods
                mounted() {
                    // 처음 시작할 때 실행되는 부분
                    let self = this;
                    const path = location.pathname;
                    self.fnGetCompanyList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>