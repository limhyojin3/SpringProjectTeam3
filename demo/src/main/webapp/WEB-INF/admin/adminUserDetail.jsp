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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">

        <style>
            .status-badge {
                padding: 8px 14px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
            }

            .report-badge {
                background: #fff3cd;
                color: #9a6700;
                padding: 8px 14px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
            }

            /* 기존 상태 클래스랑 같이 사용 */
            .badge-success {
                background: #e8f8ee;
                color: #1c8c4c;
            }

            .badge-danger {
                background: #ffe9e9;
                color: #d93025;
            }

            .badge-secondary {
                background: #eef1f5;
                color: #666;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">

            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />

                <div class="main">
                    <div class="detail-container" v-if="selectedUser">
                        <!-- 상단 -->
                        <div class="detail-header">
                            <div class="detail-top">
                                <button class="btn-back" @click="fnPage('/adminUser.do')">
                                    <i class="fas fa-bars"></i>
                                    <span>목록으로</span>
                                </button>
                            </div>

                            <div class="detail-title-row">
                                <h2>회원 상세</h2>
                                <div class="detail-badges">
                                    <span :class="['badge status-badge', getStatusClass(selectedUser.status)]">
                                        {{ getStatusInfo(selectedUser.status).text }}
                                    </span>

                                    <span class="badge report-badge">
                                        신고 {{ reportCount || 0 }}회
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- ===== 1. 회원 기본 정보 ===== -->
                        <div class="card p-3 mb-3">
                            <h5>👤 회원 정보</h5>
                            <div class="row">
                                <div class="col-4"><b>ID</b><br>{{ selectedUser.userId }}</div>
                                <div class="col-4"><b>이름</b><br>{{ selectedUser.name }}</div>
                                <div class="col-4"><b>닉네임</b><br>{{ selectedUser.nickName || '-' }}</div>

                                <div class="col-4 mt-3"><b>이메일</b><br>{{ selectedUser.userEmail }}</div>
                                <div class="col-4 mt-3"><b>전화번호</b><br>{{ selectedUser.tel || '-' }}</div>
                                <div class="col-4 mt-3"><b>유형</b><br>{{ selectedUser.role }}</div>

                                <div class="col-4 mt-3"><b>성별</b><br>{{ getStatusInfo(selectedUser.gender).text }}</div>
                                <div class="col-4 mt-3"><b>혼인</b><br>{{ getStatusInfo(selectedUser.maritalStatus).text
                                    || '-' }}</div>
                                <div class="col-4 mt-3"><b>결혼기념일/예정일</b><br>{{ selectedUser.anniversaryDate ||
                                    selectedUser.weddingDate }}</div>
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
                                        <div>{{ getStatusInfo(selectedUser.status)?.text }}</div>
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
                            <input class="form-control mb-2" v-model="banReason" placeholder="정지 사유 입력"
                                @keyup.enter="fnBanUser" />
                            <button class="btn btn-danger btn-block" @click="fnBanUser">정지</button>
                        </div>

                        <div class="card p-3" v-if="selectedUser.status === 'STOP'">
                            <h5 class="text-success">✅ 정지 해제</h5>
                            <input class="form-control mb-2" v-model="unbanReason" placeholder="해제 사유 입력"
                                @keyup.enter="fnUnbanUser" />
                            <button class="btn btn-success btn-block" @click="fnUnbanUser">해제</button>
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
                            STOP: { text: "정지" },
                            DORMANT: { text: "휴면" },
                            WITHDRAWN: { text: "탈퇴" },
                            M: { text: "남성" },
                            F: { text: "여성" },
                            SINGLE: { text: "미혼" },
                            MARRIED: { text: "기혼" }
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
                        if (!confirm("정지하시겠습니까?")) { return }
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
                        if (!confirm("정지해제하시겠습니까?")) { return }
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