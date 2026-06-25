<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터 문의 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

    <style>
        /* 제목 */
        .cs-list-title {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e07a8a;
            text-align: left;
        }

        /* 필터 */
        .filter-area {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-bottom: 15px;
        }

        .filter-select {
            width: 150px;
            height: 38px;
            font-size: 14px;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            color: #555;
            padding: 0 8px;
        }

        .filter-select:focus {
            outline: none;
            border-color: #e07a8a;
        }

        /* 테이블 */
        .write-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .write-table th {
            background-color: #fff0f3;
            padding: 12px 10px;
            text-align: center;
            border-bottom: 2px solid #e07a8a;
            border-top: 1px solid #ffc7c2;
            font-weight: 700;
            color: #555;
        }

        .write-table td {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid #f5f5f5;
            color: #555;
        }

        .write-table tr:hover td {
            background-color: #fff9f9;
        }

        .write-table td.col-title {
            text-align: left;
            cursor: pointer;
        }

        .write-table td.col-title:hover {
            color: #e07a8a;
            text-decoration: underline;
        }

        .col-no { width: 60px; }
        .col-writer { width: 120px; }
        .col-status { width: 100px; }

        /* 상태 배지 */
        .status-wait {
            color: #e07a8a;
            font-weight: 700;
        }

        .status-done {
            color: #9b8fd4;
            font-weight: 700;
        }

        /* 페이지네이션 */
        .pagination-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 6px;
        }

        .btn-page-arrow,
        .btn-page-num {
            height: 34px;
            min-width: 34px;
            padding: 0 10px;
            background-color: #fff;
            color: #e07a8a;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
        }

        .btn-page-arrow:hover,
        .btn-page-num:hover {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        .btn-page-num.active-page {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
            font-weight: bold;
        }

        .btn-page-arrow:disabled {
            opacity: 0.3;
            cursor: not-allowed;
        }

        /* 하단 버튼 영역 */
        .cs-list-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

        .btn-back {
            padding: 8px 20px;
            background-color: white;
            color: #e07a8a;
            border: 1px solid #ffc7c2;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s;
        }

        .btn-back:hover {
            background-color: #e07a8a;
            color: white;
            border-color: #e07a8a;
        }

        .btn-cs-write {
            padding: 8px 20px;
            background-color: #e07a8a;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s;
        }

        .btn-cs-write:hover {
            background-color: #c9606f;
        }

        /* 모달 */
        .modal-label {
            font-weight: 700;
            color: #333;
            margin-top: 10px;
        }

        .answer-box {
            background-color: #f8f6ff;
            border-left: 4px solid #9b8fd4;
            padding: 15px;
            margin-top: 20px;
            border-radius: 0 8px 8px 0;
        }

        /* 부트스트랩 모달 버튼 오버라이드 */
        .btn-primary {
            background-color: #e07a8a !important;
            border-color: #e07a8a !important;
        }

        .btn-primary:hover {
            background-color: #c9606f !important;
            border-color: #c9606f !important;
        }

        .pagination .page-item.active .page-link {
            background-color: #e07a8a;
            border-color: #e07a8a;
        }

        .pagination .page-link {
            color: #e07a8a;
        }
        i {
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <div id="wrapper">
            <div class="main-content">
                <jsp:include page="/WEB-INF/common/mypage-nav.jsp" />

                <div class="right-sections">
                    <h3 class="cs-list-title"><i class="fas fa-headset"></i>어떤 도움이 필요하세요?</h3>

                    <div class="filter-area">
                        <select class="filter-select" v-model="searchType" @change="fnGetList(1)">
                            <option value="">전체 유형</option>
                            <option value="이용불편">이용불편</option>
                            <option value="결제문의">결제문의</option>
                            <option value="계정관련">계정관련</option>
                            <option value="기타">기타</option>
                        </select>
                        <select class="filter-select" v-model="searchStatus" @change="fnGetList(1)">
                            <option value="">전체 상태</option>
                            <option value="WAIT">대기</option>
                            <option value="DONE">완료</option>
                        </select>
                    </div>

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
                                <td>{{ totalCount - (currentPage - 1) * pageSize - index }}</td>
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

                    <div class="pagination-wrap">
                        <button class="btn-page-arrow"
                                @click="fnGetList(currentPage - 1)"
                                :disabled="currentPage === 1">이전</button>
                        <button class="btn-page-num"
                                v-for="p in totalPages" :key="p"
                                :class="p === currentPage ? 'active-page' : ''"
                                @click="fnGetList(p)">
                            {{ p }}
                        </button>
                        <button class="btn-page-arrow"
                                @click="fnGetList(currentPage + 1)"
                                :disabled="currentPage === totalPages">다음</button>
                    </div>

                    <div class="cs-list-bottom">
                        <button class="btn-back" onclick="location.href='/userMyPage.do'">마이페이지 메인</button>
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
                            <div class="p-3 border rounded bg-light" style="white-space: pre-wrap;">{{ detailItem.content }}</div>
                        </div>

                        <div v-if="detailItem.status === 'DONE'" class="answer-box">
                            <h6 class="font-weight-bold"><i class="fas fa-reply fa-rotate-180"></i> 관리자 답변 </h6>
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
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-btn').forEach(btn => {
            const onclick = btn.getAttribute('onclick');
            if (!onclick) return;
            const match = onclick.match(/'([^']+)'/);
            if (!match) return;
            if (currentPath.endsWith(match[1])) {
                btn.classList.add('active');
            }
        });
    </script>
<script>
    const app = Vue.createApp({
        data() {
            return {
                sessionId: "${sessionId}",
                inquiryList: [],
                newInquiry: { inquiryType: '', title: '', content: '' },
                detailItem: {},
                
                // 페이징 및 검색 필터 변수
                searchType: '',
                searchStatus: '',
                currentPage: 1,
                pageSize: 10,
                totalCount: 0
            };
        },
        computed: {
            // 전체 페이지 수 계산
            totalPages() {
                return Math.ceil(this.totalCount / this.pageSize);
            }
        },
        methods: {
            // 목록 가져오기 (필터 및 페이징 적용)
            fnGetList(page) {
                if(page < 1 || (this.totalPages > 0 && page > this.totalPages)) return;
                this.currentPage = page;

                const params = {
                    userId: this.sessionId,
                    searchType: this.searchType,
                    searchStatus: this.searchStatus,
                    startIndex: (this.currentPage - 1) * this.pageSize,
                    pageSize: this.pageSize
                };

                $.ajax({
                    url: "/api/inquiry/list.dox",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(params),
                    success: (res) => {
                        if(res.result === "success") {
                            this.inquiryList = res.list;
                            this.totalCount = res.totalCount; // 서버에서 전체 개수를 같이 보내줘야 합니다.
                            console.log("전체 개수: ", this.totalCount);
                        }
                    }
                });
            },
            fnOpenWriteModal() {
                this.newInquiry = { inquiryType: '', title: '', content: '' };
                $('#writeModal').modal('show');
            },
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
                            this.fnGetList(1); // 첫 페이지로 이동하여 새로고침
                        }
                    }
                });
            },
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
            this.fnGetList(1);
        }
    });
    app.mount('#app');
</script>
</body>
</html>