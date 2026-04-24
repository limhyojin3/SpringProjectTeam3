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

            .active {
                background-color: #ffe5e5;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <jsp:include page="/WEB-INF/common/header.jsp" />
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class=inquiry-wrap>
                        <!-- 왼쪽: 회원 리스트 -->
                        <div class="left">
                            <table class="table table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>이름</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="user in userList"
                                        :class="{active: selectedUser && selectedUser.userId && selectedUser.userId === user.userId}"
                                        @click="selectUser(user)">
                                        {{ console.log("row user:", user) }}
                                        <td>{{user.userId}}</td>
                                        <td>{{user.name}}</td>
                                        <td>
                                            <span :class="['badge', getStatusClass(user.status)]">
                                                {{ getStatusInfo(user.status).text }}
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 오른쪽: 상세 + 정지 -->
                        <div class="right" v-if="selectedUser">
                            <h3>업체 상세</h3>
                            <p>ID: {{ selectedUser.userId }}</p>
                            <p>업체명: {{ selectedUser.name }}</p>
                            <p>대표자: {{ selectedUser.ceoName }}</p>
                            <p>사업자번호: {{ selectedUser.bizNo }}</p>
                            <p>제휴 등급: {{ selectedUser.grade }}</p>
                            <p>회원 상태:
                                <span :style="{color: selectedUser.status === 'STOP' ? 'red' : 'green'}">
                                    {{ selectedUser.status === 'STOP' ? '정지됨' : '정상' }}
                                </span>
                            </p>
                            <p>휴무 상태:
                                <span :style="{color: selectedUser.status === 'STOP' ? 'red' : 'green'}">
                                    {{ selectedUser.companyStatus === 'STOP' ? '휴무' : '영업' }}
                                </span>
                            </p>
                            <h4>정지 이력</h4>
                            <table class="table table-sm table-bordered">
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>사유</th>
                                        <th>관리자</th>
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, index) in banHistoryList" :key="item.banRegDate + index">
                                        <td>
                                            {{ item.actionType === 'BAN' ? '정지' : '해제' }}
                                        </td>
                                        <td>{{ item.reason || '-' }}</td>
                                        <td>{{ item.adminId }}</td>
                                        <td>{{ item.banRegDate }}</td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- 정지 영역 -->
                            <div v-if="selectedUser && selectedUser.status !== 'STOP'">
                                <h4>정지 처리</h4>

                                <input v-model="banReason" placeholder="정지 사유" />

                                <button @click="fnBanUser"
                                    :disabled="selectedUser.userId === sessionId || sessionRole !== 'ADMIN'">
                                    정지
                                </button>

                                <p v-if="selectedUser.userId === sessionId" style="color:red;">
                                    본인 계정은 정지할 수 없습니다
                                </p>
                            </div>

                            <!-- 해제 영역 -->
                            <div v-if="selectedUser && selectedUser.status === 'STOP'">
                                <h4>정지 해제</h4>

                                <input v-model="unbanReason" placeholder="해제 사유" />

                                <button @click="fnUnbanUser"
                                    :disabled="selectedUser.userId === sessionId || sessionRole !== 'ADMIN'">
                                    해제
                                </button>
                            </div>
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
                        selectedUser: null,
                        suspendReason: "",
                        banReason: "",
                        unbanReason: "",
                        banHistoryList: [],
                        sessionId: "${sessionScope.sessionId}",
                        sessionRole: "${sessionScope.sessionRole}",
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnGetUserList: function () {
                        let self = this;
                        let param = {};
                        $.ajax({
                            url: "http://localhost:8080/companyList.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                console.log(data);
                                self.userList = data.list;
                                console.log(self.userList);
                                console.log(self.userList[0]);
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

                    selectUser(user) {
                        this.selectedUser = user;
                        this.fnGetBanHistory(user.userId, user.targetType);
                    },

                    resetForm() {
                        this.selectedUser = null;
                        this.banReason = "";
                        this.unbanReason = "";
                    },

                    fnBanUser() {
                        let self = this;

                        if (!self.banReason) {
                            alert("정지 사유 입력해라");
                            return;
                        }

                        if (!confirm("정지하시겠습니까?")) return;

                        $.ajax({
                            url: "http://localhost:8080/editMemberBan.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                target_id: self.selectedUser.userId,
                                target_type: self.selectedUser.targetType,
                                action_type: "BAN",
                                reason: self.banReason,
                                admin_id: self.sessionId,
                            },
                            success: function (res) {
                                alert("정지 완료");

                                let userId = self.selectedUser.userId;
                                let targetType = self.selectedUser.targetType;

                                self.resetForm();
                                self.fnGetUserList();
                                self.fnGetBanHistory(userId, targetType);
                            }
                        });
                    },

                    fnUnbanUser() {
                        let self = this;

                        if (!confirm("해제하시겠습니까?")) return;

                        $.ajax({
                            url: "http://localhost:8080/editMemberBan.dox",
                            type: "POST",
                            dataType: "json",
                            data: {
                                target_id: self.selectedUser.userId,
                                target_type: self.selectedUser.targetType,
                                action_type: "UNBAN",
                                reason: self.unbanReason,
                                admin_id: self.sessionId,
                            },
                            success: function (res) {
                                alert("해제 완료");

                                let userId = self.selectedUser.userId;
                                let targetType = self.selectedUser.targetType;

                                self.resetForm();
                                self.fnGetUserList();
                                self.fnGetBanHistory(userId, targetType);
                            }
                        });
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
                            ACTIVE: "badge-success",
                            STOP: "badge-danger",
                            DORMANT: "badge-secondary",
                            WITHDRAWN: "badge-dark"
                        };
                        return map[status] || "badge-light";
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
                    self.fnGetUserList();
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>