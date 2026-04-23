<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 신고 내역</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <style>
        .cs-write-title { font-size: 30px; font-weight: bold; text-align: center; margin-bottom: 25px; color: #333; }
        
        /* 테이블 스타일 (문의 목록과 통일감 유지) */
        .report-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px; background: white; }
        .report-table th { background-color: #f8f9fa; padding: 12px; text-align: center; border-bottom: 2px solid #dee2e6; color: #333; }
        .report-table td { padding: 12px; text-align: center; border-bottom: 1px solid #eee; color: #555; }
        .report-table tr:hover { background-color: #fdfdfd; }
        
        .col-title { text-align: left !important; cursor: pointer; font-weight: 500; }
        .col-title:hover { color: #f4a096; text-decoration: underline; }

        /* 상태 배지 */
        .badge-wait { background-color: #ffeeba; color: #856404; padding: 5px 10px; border-radius: 4px; font-size: 12px; }
        .badge-done { background-color: #d4edda; color: #155724; padding: 5px 10px; border-radius: 4px; font-size: 12px; }

        .report-bottom { display: flex; justify-content: center; margin-top: 20px; }
        .btn-back { padding: 10px 30px; background-color: #9b8fd4; color: white; border: none; border-radius: 6px; cursor: pointer; }

        /* 상세 모달 스타일 */
        .modal-label { font-weight: bold; color: #666; font-size: 13px; margin-bottom: 5px; display: block; }
        .content-box { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; min-height: 100px; }
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
                                <th style="width: 80px;">번호</th>
                                <th style="width: 120px;">신고유형</th>
                                <th>신고 제목</th>
                                <th style="width: 120px;">처리상태</th>
                                <th style="width: 120px;">신고일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in reportList" :key="item.reportNo">
                                <td>{{ reportList.length - index }}</td>
                                <td>
                                    <span class="text-muted">[{{ fnTranslateType(item.targetType) }}]</span>
                                </td>
                                <td class="col-title" @click="fnDetailReport(item.reportNo)">
                                    {{ item.reportTitle }}
                                </td>
                                <td>
                                    <span v-if="item.answerStatus == 0" class="badge-wait">검토중</span>
                                    <span v-else class="badge-done">처리완료</span>
                                </td>
                                <td>{{ item.regDate.substring(0, 10) }}</td>
                            </tr>
                            <tr v-if="reportList.length === 0">
                                <td colspan="5" style="padding: 50px 0; color: #999;">신고하신 내역이 없습니다.</td>
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
                        <h5 class="modal-title">신고 상세 확인</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body" v-if="detailItem">
                        <div class="mb-3">
                            <label class="modal-label">신고 유형</label>
                            <div><strong>{{ fnTranslateType(detailItem.targetType) }}</strong></div>
                        </div>
                        <div class="mb-3">
                            <label class="modal-label">신고 제목</label>
                            <div>{{ detailItem.reportTitle }}</div>
                        </div>
                        <div class="mb-3">
                            <label class="modal-label">상세 내용</label>
                            <div class="content-box">{{ detailItem.reportContent }}</div>
                        </div>
                        <div class="mb-0">
                            <label class="modal-label">처리 상태</label>
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
            // 신고 내역 불러오기 (본인이 신고한 것만)
            fnGetReportList() {
                $.ajax({
                    url: "/api/report/my-list.dox", // 이전에 만든 API 주소
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ reporterId: this.sessionId }),
                    success: (res) => {
                        if(res.result === "success") {
                            this.reportList = res.list;
                        }
                    }
                });
            },
            // 상세 보기
            fnDetailReport(no) {
                // 리스트에서 이미 가져온 데이터를 활용하거나, 상세 API를 따로 호출
                this.detailItem = this.reportList.find(item => item.reportNo === no);
                $('#reportDetailModal').modal('show');
            },
            // 유형 한글 변환
            fnTranslateType(type) {
                const types = {
                    'COMPANY': '업체 신고',
                    'POST': '커뮤니티 신고',
                    'MEMBER': '회원 신고',
                    'REVIEW': '리뷰 신고',
                    'COMMENT' : '댓글 신고',
                };
                return types[type] || type;
            }
        },
        mounted() {
            this.fnGetReportList();
        }
    });
    app.mount('#app');
</script>
</body>
</html>