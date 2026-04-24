<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터 문의 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <style>
        .cs-list-title { font-size: 30px; font-weight: bold; text-align: center; margin-bottom: 20px; color: #333; }
        .write-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px; }
        .write-table th { background-color: #ffc7c2; padding: 10px; text-align: center; border: 1px solid #f4a096; font-weight: bold; }
        .write-table td { padding: 10px; text-align: center; border: 1px solid #eee; color: #555; }
        .write-table tr:hover { background-color: #fff0ef; }
        .write-table td.col-title { text-align: left; cursor: pointer; }
        .write-table td.col-title:hover { color: #f4a096; text-decoration: underline; }
        .col-no { width: 100px; } .col-writer { width: 100px; } .col-status { width: 80px; }
        .status-wait { color: #f4a096; font-weight: bold; }
        .status-done { color: #9b8fd4; font-weight: bold; }
        .cs-list-bottom { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .btn-cs-write { padding: 10px 25px; background-color: #f0b429; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; transition: 0.2s; }
        .btn-cs-write:hover { opacity: 0.85; }
        
        /* 모달 내부 스타일 */
        .modal-label { font-weight: bold; color: #333; margin-top: 10px; }
        .answer-box { background-color: #f9f9f9; border-left: 4px solid #9b8fd4; padding: 15px; margin-top: 20px; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <h3 class="cs-list-title">어떤 도움이 필요하세요?</h3>

                    <table class="write-table">
                        <thead>
                            <tr>
                                <th class="col-no">번호</th>
                                <th class="col-no">유형</th>
                                <th class="col-title">제목</th>
                                <th class="col-status">처리상태</th>
                                <th class="col-writer">문의일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in inquiryList" :key="item.inquiryNo">
                                <td>{{ inquiryList.length - index }}</td>
                                <td>{{ item.inquiryType }}</td>
                                <td class="col-title" @click="fnDetailInquiry(item.inquiryNo)">
                                    {{ item.title }}
                                </td>
                                <td>
                                    <span :class="item.status === 'WAIT' ? 'status-wait' : 'status-done'">
                                        {{ item.status === 'WAIT' ? '대기' : '완료' }}
                                    </span>
                                </td>
                                <td>{{ item.regDate }}</td>
                            </tr>
                            <tr v-if="inquiryList.length === 0">
                                <td colspan="5">등록된 문의 내역이 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="cs-list-bottom">
                        <button class="btn-review-index" onclick="location.href='/userMyPage.do'">마이페이지 메인</button>
                        <button class="btn-cs-write" @click="fnOpenWriteModal()">새 문의 작성</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="writeModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">1:1 문의하기</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="modal-label">문의 유형</label>
                            <select class="form-control" v-model="newInquiry.inquiryType">
                                <option value="">유형 선택</option>
                                <option value="이용불편">이용불편</option>
                                <option value="결제문의">결제문의</option>
                                <option value="계정관련">계정관련</option>
                                <option value="기타">기타</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="modal-label">제목</label>
                            <input type="text" class="form-control" v-model="newInquiry.title" placeholder="제목을 입력하세요">
                        </div>
                        <div class="form-group">
                            <label class="modal-label">내용</label>
                            <textarea class="form-control" rows="5" v-model="newInquiry.content" placeholder="내용을 입력하세요"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                        <button type="button" class="btn btn-primary" @click="fnSubmitInquiry">제출하기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="detailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">문의 상세 내용</h5>
                        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <span class="badge badge-info">{{ detailItem.inquiryType }}</span>
                            <h4 class="mt-2">{{ detailItem.title }}</h4>
                            <p class="text-muted small">작성일: {{ detailItem.regDate }}</p>
                            <div class="p-3 border rounded bg-light">{{ detailItem.content }}</div>
                        </div>

                        <div v-if="detailItem.status === 'DONE'" class="answer-box">
                            <h6 class="font-weight-bold"><i class="fas fa-reply fa-rotate-180"></i> 관리자 답변 <small class="text-muted ml-2">({{ detailItem.answerDate }})</small></h6>
                            <div class="mt-2" style="white-space: pre-wrap;">{{ detailItem.answerContent }}</div>
                        </div>
                        <div v-else class="text-center p-4 border rounded mt-3 text-muted">
                            운영자가 문의 내용을 검토 중입니다. 답변이 등록될 때까지 조금만 기다려주세요!
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
                inquiryList: [],
                newInquiry: { inquiryType: '', title: '', content: '' },
                detailItem: {}
            };
        },
        methods: {
            // 목록 가져오기
            fnGetList() {
                $.ajax({
                    url: "/api/inquiry/list.dox",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ userId: this.sessionId }),
                    success: (res) => {
                        if(res.result === "success") this.inquiryList = res.list;
                    }
                });
            },
            // 작성 모달 열기
            fnOpenWriteModal() {
                this.newInquiry = { inquiryType: '', title: '', content: '' };
                $('#writeModal').modal('show');
            },
            // 문의 제출
            fnSubmitInquiry() {
                if(!this.newInquiry.inquiryType || !this.newInquiry.title || !this.newInquiry.content) {
                    return alert("모든 항목을 입력해주세요.");
                }
                $.ajax({
                    url: "/api/inquiry/add.dox",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ ...this.newInquiry, userId: this.sessionId }),
                    success: (res) => {
                        if(res.result === "success") {
                            alert("문의가 성공적으로 접수되었습니다.");
                            $('#writeModal').modal('hide');
                            this.fnGetList();
                        }
                    }
                });
            },
            // 상세 보기
            fnDetailInquiry(no) {
                $.ajax({
                    url: "/api/inquiry/detail.dox",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ inquiryNo: no }),
                    success: (res) => {
                        if(res.result === "success") {
                            this.detailItem = res.info;
                            $('#detailModal').modal('show');
                        }
                    }
                });
            }
        },
        mounted() {
            this.fnGetList();
        }
    });
    app.mount('#app');
</script>
</body>
</html>