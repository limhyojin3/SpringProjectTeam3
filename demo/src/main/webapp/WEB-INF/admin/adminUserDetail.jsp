<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>회원 상세</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
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
                padding: 30px;
                background-color: #f8f9fa;
                width: 100%;
            }

            .card {
                border-radius: 12px;
                border: none;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
            }

            .card-header {
                font-weight: bold;
                background-color: #f1f3f5;
                border-bottom: none;
            }

            .btn-danger,
            .btn-success {
                font-weight: bold;
            }

            input.form-control {
                border-radius: 8px;
            }

            .summary-box {
                background: #f1f3f5;
                padding: 10px;
                border-radius: 10px;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .summary-box.danger {
                background: #ffe5e5;
                color: red;
            }

            .summary-title {
                font-size: 12px;
                color: #666;
                margin-bottom: 5px;

            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />

            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />

                <div class="main">

                    <!-- ===== 뒤로가기 ===== -->
                    <button class="btn btn-secondary mb-3" @click="fnPage('/adminUser.do')">← 목록으로</button>

                    <div v-if="selectedUser">

                        <!-- 상단 -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="mb-0">회원 상세</h3>
                            <div>
                                <span :class="['badge mr-2', getStatusClass(selectedUser.status)]">
                                    {{ getStatusInfo(selectedUser.status).text }}
                                </span>
                                <span class="badge badge-warning">
                                    신고 {{ reportCount || 0 }}회
                                </span>
                            </div>
                        </div>

                        <!-- ===== 1. 회원 기본 정보 ===== -->
                        <div class="card p-3 mb-3">
                            <h5>👤 회원 정보</h5>
                            <div class="row">
                                <div class="col-4"><b>ID</b><br>{{ selectedUser.userId }}</div>
                                <div class="col-4"><b>이름</b><br>{{ selectedUser.name }}</div>
                                <div class="col-4"><b>닉네임</b><br>{{ selectedUser.nickname || '-' }}</div>

                                <div class="col-4 mt-3"><b>이메일</b><br>{{ selectedUser.userEmail }}</div>
                                <div class="col-4 mt-3"><b>전화번호</b><br>{{ selectedUser.tel || '-' }}</div>
                                <div class="col-4 mt-3"><b>유형</b><br>{{ selectedUser.role }}</div>
                            </div>
                        </div>

                        <!-- ===== 2. 활동 요약 ===== -->
                        <div class="card p-3 mb-3">
                            <h5>📊 활동 요약</h5>
                            <div class="row text-center align-items-stretch">
                                <div class="col-3">
                                    <div class="summary-box">
                                        <div class="summary-title">가입일</div>
                                        <div style="font-size: 14px;">{{ formatDate(selectedUser.regDate) }}</div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="summary-box">
                                        <div class="summary-title">마지막 로그인</div>
                                        <div>{{ formatDate(selectedUser.lastLogin) }}</div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="summary-box danger">
                                        <div class="summary-title">신고 누적</div>
                                        <div>{{ reportCount || 0 }}</div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="summary-box">
                                        <div class="summary-title">계정 상태</div>
                                        <div>{{ selectedUser.status }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ===== 3. 신고 이력 ===== -->
                        <div class="card p-3 mb-3">
                            <h5>🚨 신고 이력</h5>
                            <table class="table table-sm table-bordered mt-2">
                                <thead>
                                    <tr>
                                        <th>사유</th>
                                        <th>신고자</th>
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, index) in reportList" :key="index">
                                        <td>{{ item.reportContent }}</td>
                                        <td>{{ item.reporterId }}</td>
                                        <td>{{ item.regDate }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- ===== 4. 정지 이력 ===== -->
                        <div class="card p-3 mb-3">
                            <h5>🔨 정지 이력</h5>
                            <table class="table table-sm table-bordered mt-2">
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>사유</th>
                                        <th>관리자</th>
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, index) in banHistoryList" :key="index">
                                        <td>{{ item.actionType === 'BAN' ? '정지' : '해제' }}</td>
                                        <td>{{ item.reason || '-' }}</td>
                                        <td>{{ item.adminId }}</td>
                                        <td>{{ item.banRegDate }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- ===== 5. 제재 처리 ===== -->
                        <div class="card p-3 mb-3" v-if="selectedUser.status !== 'STOP'">
                            <h5 class="text-danger">🚫 정지 처리</h5>
                            <input class="form-control mb-2" v-model="banReason" placeholder="정지 사유 입력" />
                            <button class="btn btn-danger btn-block" @click="fnBanUser">정지</button>
                        </div>

                        <div class="card p-3" v-if="selectedUser.status === 'STOP'">
                            <h5 class="text-success">✅ 정지 해제</h5>
                            <input class="form-control mb-2" v-model="unbanReason" placeholder="해제 사유 입력" />
                            <button class="btn btn-success btn-block" @click="fnUnbanUser">해제</button>
                        </div>

                    </div>
                </div>


            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            activeMenu: "",
                            selectedUser: null,
                            banHistoryList: [],
                            reportList: [],
                            reportCount: 0,
                            banReason: "",
                            unbanReason: "",
                            sessionId: "${sessionScope.sessionId}",
                            sessionRole: "${sessionScope.sessionRole}",
                        };
                    },

                    methods: {

                        fnPage(url) {
                            location.href = url;
                        },

                        formatDate(date) {
                            return date ? date.substring(0, 10) : '-';
                        },

                        getStatusInfo(status) {
                            const map = {
                                ACTIVE: { text: "활동" },
                                STOP: { text: "정지" }
                            };
                            return map[status] || { text: "기타" };
                        },

                        getStatusClass(status) {
                            return status === "STOP" ? "badge-danger" : "badge-success";
                        },

                        fnGetUserDetail(userId) {
                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/userDetail.dox",
                                type: "POST",
                                dataType: "json",
                                data: { userId: userId },
                                success: function (res) {
                                    self.selectedUser = res.user;
                                    self.fnGetBanHistory(userId, res.user.targetType);
                                }
                            });
                        },

                        fnGetReport(userId) {
                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/reportInfoList.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    target_id: userId,
                                },
                                success: function (res) {
                                    console.log(res);
                                    self.reportList = res.list || [];
                                    self.reportCount = res.count || 0;
                                }
                            });
                        },

                        fnGetBanHistory(userId, targetType) {
                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/banHistory.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    target_id: userId,
                                    target_type: targetType
                                },
                                success: function (res) {
                                    self.banHistoryList = res.list || [];
                                }
                            });
                        },

                        fnBanUser() {
                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/editMemberBan.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    target_id: self.selectedUser.userId,
                                    target_type: self.selectedUser.targetType,
                                    action_type: "BAN",
                                    reason: self.banReason,
                                    admin_id: self.sessionId
                                },
                                success: function () {
                                    alert("정지 완료");
                                    self.fnGetUserDetail(self.selectedUser.userId);
                                }
                            });
                        },

                        fnUnbanUser() {
                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/editMemberBan.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    target_id: self.selectedUser.userId,
                                    target_type: self.selectedUser.targetType,
                                    action_type: "UNBAN",
                                    reason: self.unbanReason,
                                    admin_id: self.sessionId
                                },
                                success: function () {
                                    alert("해제 완료");
                                    self.fnGetUserDetail(self.selectedUser.userId);
                                }
                            });
                        }

                    },

                    mounted() {
                        const urlParams = new URLSearchParams(location.search);
                        const userId = urlParams.get("userId");

                        if (userId) {
                            this.fnGetUserDetail(userId);
                            this.fnGetReport(userId);
                        }
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
                    }
                });

                app.mount('#app');
            </script>

    </body>

    </html>