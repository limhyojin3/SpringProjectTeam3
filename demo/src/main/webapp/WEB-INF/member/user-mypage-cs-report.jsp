<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 신고 내역</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <style>
        .cs-write-title { font-size: 30px; font-weight: bold; text-align: center; margin-bottom: 25px; color: #333; }
        .report-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px; background: white; table-layout: fixed; }
        .report-table th { background-color: #f8f9fa; padding: 12px; text-align: center; border-bottom: 2px solid #dee2e6; color: #333; }
        .report-table td { padding: 12px; text-align: center; border-bottom: 1px solid #eee; color: #555; vertical-align: middle; }
        .report-table tr:hover { background-color: #fdfdfd; }
        
        .ellipsis { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .col-title { text-align: left !important; cursor: pointer; font-weight: 500; }
        .col-title:hover { color: #f4a096; text-decoration: underline; }
        .target-text { text-align: left !important; color: #888; font-size: 13px; }

        .badge-wait { background-color: #ffeeba; color: #856404; padding: 5px 10px; border-radius: 4px; font-size: 12px; }
        .badge-done { background-color: #d4edda; color: #155724; padding: 5px 10px; border-radius: 4px; font-size: 12px; }

        .report-bottom { display: flex; justify-content: center; margin-top: 20px; }
        .btn-back { padding: 10px 30px; background-color: #9b8fd4; color: white; border: none; border-radius: 6px; cursor: pointer; }

        .modal-label { font-weight: bold; color: #666; font-size: 13px; margin-bottom: 5px; display: block; }
        .target-box { background: #f1f3f5; padding: 10px 15px; border-radius: 6px; border-left: 4px solid #9b8fd4; margin-bottom: 15px; font-weight: 600; }
        .content-box { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; min-height: 100px; white-space: pre-wrap; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <h3 class="cs-write-title">내 신고 내역</h3>
                    
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">번호</th>
                                <th style="width: 110px;">신고유형</th>
                                <th>나의 신고 제목</th>
                                <th style="width: 200px;">신고 대상(글 제목)</th>
                                <th style="width: 100px;">처리상태</th>
                                <th style="width: 110px;">신고일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in reportList" :key="item.reportNo">
                                <td>{{ reportList.length - index }}</td>
                                <td><span class="text-muted">[{{ fnTranslateType(item.targetType) }}]</span></td>
                                <td class="col-title ellipsis" @click="fnDetailReport(item.reportNo)" :title="item.reportTitle">
                                    {{ item.reportTitle }}
                                </td>
                                <td class="target-text ellipsis" :title="item.targetTitle">
                                    {{ item.targetTitle || '정보 없음' }}
                                </td>
                                <td>
                                    <span v-if="item.answerStatus == 0" class="badge-wait">검토중</span>
                                    <span v-else class="badge-done">처리완료</span>
                                </td>
                                <td>{{ fnFormatDate(item.regDate) }}</td>
                            </tr>
                            <tr v-if="reportList.length === 0">
                                <td colspan="6" style="padding: 50px 0; color: #999;">신고하신 내역이 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="report-bottom">
                        <button class="btn-back" onclick="location.href='/userMyPage.do'">마이페이지로 돌아가기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="reportDetailModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title font-weight-bold">신고 상세 확인</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body" v-if="detailItem">
                        <label class="modal-label">신고 대상물(제목/내용)</label>
                        <div class="target-box">{{ detailItem.targetTitle }}</div>

                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="modal-label">신고 유형</label>
                                <div><strong>{{ fnTranslateType(detailItem.targetType) }}</strong></div>
                            </div>
                            <div class="col-6">
                                <label class="modal-label">피신고자 ID</label>
                                <div>{{ detailItem.targetUserId || '-' }}</div>
                            </div>
                        </div>

                        <label class="modal-label">나의 신고 제목</label>
                        <div class="mb-3 font-weight-bold">{{ detailItem.reportTitle }}</div>

                        <label class="modal-label">상세 신고 내용</label>
                        <div class="content-box">{{ detailItem.reportContent }}</div>

                        <div class="mt-4 text-center border-top pt-3">
                            <span v-if="detailItem.answerStatus == 0" class="text-warning font-weight-bold">관리자가 해당 내용을 확인하고 있습니다.</span>
                            <span v-else class="text-success font-weight-bold">조치가 완료된 신고건입니다.</span>
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
                sessionId: "${sessionId}",
                reportList: [],
                detailItem: null
            };
        },
        methods: {
            fnGetReportList() {
                const self = this;
                $.ajax({
                    url: "/api/report/my-list.dox",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ reporterId: self.sessionId }),
                    success: (res) => {
                        console.log("전체 응답 데이터:", res);
                        // res.list.list 구조 대응
                        if (res.list && res.list.list) {
                            self.reportList = res.list.list;
                        } else if (res.list) {
                            self.reportList = res.list;
                        } else {
                            self.reportList = res;
                        }
                    },
                    error: (err) => { console.error("AJAX 에러:", err); }
                });
            },
            fnDetailReport(no) {
                this.detailItem = this.reportList.find(item => item.reportNo === no);
                $('#reportDetailModal').modal('show');
            },
            fnTranslateType(type) {
                const types = {
                    'COMPANY': '업체 신고', 'POST': '커뮤니티 신고',
                    'MEMBER': '회원 신고', 'REVIEW': '리뷰 신고', 'COMMENT' : '댓글 신고'
                };
                return types[type] || type;
            },
            fnFormatDate(date) {
                if (!date) return "-";
                let d = String(date);
                return d.length >= 10 ? d.substring(0, 10) : d;
            }
        },
        mounted() {
            if(this.sessionId) {
                this.fnGetReportList();
            } else {
                alert("로그인이 필요합니다.");
                location.href = "/login.do";
            }
        }
    });
    app.mount('#app');
</script>
</body>
</html>