<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 커뮤니티 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css"> 
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
        body { background-color: #f8f9fa; }
        .main-content { padding: 50px 40px; max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-top: 30px; margin-bottom: 50px; }
        
        .review-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #eee; }
        .tab-item { cursor: pointer; padding: 12px 25px; font-weight: bold; color: #999; transition: 0.3s; position: relative; }
        .tab-item.active { color: var(--primary-color); }
        .tab-item.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 3px; background-color: var(--primary-color); }
        
        .badge-paid { background: #fff0f3; color: #ff4d6d; border: 1px solid #ffccd5; padding: 5px 10px; }
        .badge-free { background: #e7f5ff; color: #228be6; border: 1px solid #a5d8ff; padding: 5px 10px; }
        
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { padding: 15px; border-bottom: 2px solid var(--dark-color); text-align: center; background: #fafafa; }
        .custom-table td { padding: 18px 15px; border-bottom: 1px solid #eee; text-align: center; vertical-align: middle; }
        .custom-table tbody tr:hover td { background-color: #fff9fa; cursor: pointer; }
        
        .search-area { background: #f1f3f5; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .review-title-text { font-weight: 700; color: #333; font-size: 1.05rem; }
        .comment-count { color: var(--primary-color); font-weight: bold; font-size: 0.9rem; margin-left: 4px; }
        .page-item.disabled .page-link { pointer-events: auto !important; cursor: not-allowed !important; }
        .page-link { cursor: pointer !important; }
        .page-item.active .page-link { background-color: #007bff !important; border-color: #007bff !important; color: white !important; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />


        <main class="main-content">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="font-weight-bold" @click="fnReset" style="cursor:pointer">📸 리뷰 커뮤니티</h2>
                    <span v-if="sessionId" class="badge badge-info ml-2" style="background-color: #4dabf7;">
                        내 열람권: {{ userRemainingCount }}개
                    </span>
                    <p class="text-muted mb-0">생생한 이용 후기를 확인하고 스마트하게 선택하세요.</p>
                </div>
                <button class="btn btn-danger btn-lg" style="background-color: var(--primary-color); border:none;" @click="fnWrite">
                    <i class="fas fa-pen mr-2"></i>리뷰 작성하기
                </button>
            </div>

            <div class="search-area d-flex justify-content-center">
                <div class="input-group" style="max-width: 600px;">
                    <select class="form-control col-3" v-model="searchType">
                        <option value="all">전체</option>
                        <option value="company">업체명</option>
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                    </select>
                    <input type="text" class="form-control col-7" placeholder="검색어를 입력하세요..." v-model="searchKeyword" @keyup.enter="fnList">
                    <div class="input-group-append col-2 p-0">
                        <button class="btn btn-dark btn-block" @click="fnList">검색</button>
                    </div>
                </div>
            </div>

            <div class="review-tabs">
                <div class="tab-item" :class="{active: isPaid === null}" @click="fnFilter(null)">전체보기</div>
                <div class="tab-item" :class="{active: isPaid === 1}" @click="fnFilter(1)">💎 유료 리뷰</div>
                <div class="tab-item" :class="{active: isPaid === 0}" @click="fnFilter(0)">🎁 무료 리뷰</div>
            </div>

            <div class="category-filter-bar mb-4">
                <button class="btn btn-sm mr-2" :class="category === 'all' ? 'btn-dark' : 'btn-outline-dark'" @click="fnCategoryFilter('all')">전체</button>
                <button class="btn btn-sm mr-2" :class="category === 'STUDIO' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('STUDIO')">📸 스튜디오</button>
                <button class="btn btn-sm mr-2" :class="category === 'DRESS' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('DRESS')">👗 드레스</button>
                <button class="btn btn-sm" :class="category === 'MAKEUP' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('MAKEUP')">💄 메이크업</button>
            </div>

            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">구분</th>
                        <th style="width: 100px;">별점</th>
                        <th>리뷰 제목</th>
                        <th style="width: 90px;">추천</th>
                        <th style="width: 130px;">작성자</th>
                        <th style="width: 120px;">날짜</th>
                        <th style="width: 80px;">조회</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in list" :key="item.reviewNo" @click="fnDetail(item)">
                        <td>
                            <span v-if="item.isPaid == 1" class="badge badge-paid">유료</span>
                            <span v-else class="badge badge-free">무료</span>
                        </td>
                        <td class="text-warning font-weight-bold">
                            <i class="fas fa-star mr-1"></i>{{ parseFloat(item.rating || 0).toFixed(1) }}
                        </td>
                        <td class="text-left">
                            <span class="badge badge-light border text-dark mr-2" style="font-size: 0.75rem;">{{ item.comName }}</span>
                            <span class="review-title-text">{{ item.title }}</span>
                            <span v-if="item.commentCnt > 0" class="comment-count">[{{ item.commentCnt }}]</span>
                            <i v-if="item.hasImg === 'Y'" class="far fa-image ml-2 text-primary"></i>
                        </td>
                        <td>
                            <span :class="item.likeCnt > 0 ? 'text-danger' : 'text-muted'">
                                <i class="fas fa-heart mr-1"></i>{{ item.likeCnt || 0 }}
                            </span>
                        </td>
                        <td><i class="far fa-user-circle mr-1"></i>{{ item.nickname }}</td>
                        <td class="small text-muted">{{ item.regDate }}</td>
                        <td class="text-muted">{{ item.viewCnt }}</td>
                    </tr>
                    <tr v-if="list.length == 0">
                        <td colspan="7" class="py-5 text-center">
                            <p class="text-muted">조건에 맞는 리뷰가 아직 없습니다.</p>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="d-flex justify-content-center mt-4">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(1)">&laquo;</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === 1}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage > 1 && fnPageChange(currentPage - 1)">이전</a>
                        </li>
                        <li class="page-item" v-for="page in pageNumbers" :key="page" :class="{active: currentPage === page}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(page)">{{ page }}</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="currentPage < totalPageCount && fnPageChange(currentPage + 1)">다음</a>
                        </li>
                        <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                            <a class="page-link" href="javascript:;" @click.prevent="fnPageChange(totalPageCount)">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </div>

            
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    list: [],
                    isPaid: null,
                    searchKeyword: '',
                    searchType: 'all',
                    sessionId: "${sessionId}",
                    userRole: "${sessionRole}",
                    category: 'all',
                    currentPage: 1,
                    pageSize: 10,
                    totalCount: 0,
                    pageBlockSize: 5,
                    userRemainingCount: 0, // 사용자의 보유 열람권 개수
                };
            },
            computed: {
                pageNumbers() {
                    const totalPages = Math.ceil(this.totalCount / this.pageSize);
                    const startPage = Math.floor((this.currentPage - 1) / this.pageBlockSize) * this.pageBlockSize + 1;
                    let endPage = startPage + this.pageBlockSize - 1;
                    if (endPage > totalPages) endPage = totalPages;
                    const pages = [];
                    for (let i = startPage; i <= endPage; i++) { pages.push(i); }
                    return pages;
                },
                totalPageCount() { return Math.ceil(this.totalCount / this.pageSize); }
            },
            methods: {
                fnGetUserTicket() {
                    if(!this.sessionId) return; // 로그인 안 되어 있으면 중단

                    $.ajax({
                        url: "/api/review/getUserAccessCount.dox", // 아래에서 컨트롤러에 추가할 주소
                        type: "POST",
                        data: JSON.stringify({ userId: this.sessionId }),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            this.userRemainingCount = result.count;
                        }
                    });
                },
                fnList() {
                    const nParam = {
                        isPaid: this.isPaid,
                        category: this.category,
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType,
                        startIndex: (this.currentPage - 1) * this.pageSize,
                        pageSize: this.pageSize
                    };
                    $.ajax({
                        url: "/api/review/list.dox",
                        type: "POST",
                        data: JSON.stringify(nParam),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            if(result.result === "success") {
                                this.list = result.list;
                                this.totalCount = result.count;
                            }
                        }
                    });
                },
                fnDetail(item) {
                    // 0. 관리자(ADMIN)이거나 본인 글인 경우 -> 프리패스
                    if (this.userRole === 'ADMIN' || (this.sessionId && this.sessionId === item.userId)) {
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                        return;
                    }

                    // 1. 유료 리뷰인데 로그인을 안 했다면? -> 로그인 페이지로 이동
                    if (item.isPaid == 1 && !this.sessionId) {
                        alert("유료 리뷰는 로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    }

                    // 2. 유료 리뷰 로직 (일반 사용자 전용)
                    if (item.isPaid == 1) {
                        $.ajax({
                            url: "/api/review/useTicket.dox",
                            type: "POST",
                            data: JSON.stringify({ reviewNo: item.reviewNo, checkOnly: "Y" }),
                            contentType: "application/json",
                            success: (data) => {
                                let result = (typeof data === 'string') ? JSON.parse(data) : data;

                                if (result.result === "ALREADY_VIEWED") {
                                    location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                                } else {
                                    const confirmMsg = "유료 리뷰입니다. 열람권을 사용하여 확인하시겠습니까?\n" +
                                                    "------------------------------------------\n" +
                                                    "현재 보유 열람권: " + this.userRemainingCount + "개\n" +
                                                    "------------------------------------------";

                                    if (confirm(confirmMsg)) {
                                        this.fnExecuteUsage(item);
                                    }
                                }
                            }
                        });
                    } else {
                        // 무료 리뷰는 바로 이동
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                    }
                },
                // 실제 차감을 수행하는 메서드
                fnExecuteUsage(item) {
                    $.ajax({
                        url: "/api/review/useTicket.dox",
                        type: "POST",
                        data: JSON.stringify({ reviewNo: item.reviewNo }),
                        contentType: "application/json",
                        success: (data) => {
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            if(result.result === "SUCCESS") {
                                this.userRemainingCount--; 
                                alert("열람권 1개가 차감되었습니다.\n남은 열람권: " + this.userRemainingCount + "개");
                                location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                            } else if(result.result === "NO_TICKET") {
                                alert("열람권이 부족합니다. (현재: " + this.userRemainingCount + "개)");
                            } else {
                                alert("처리 중 오류가 발생했습니다.");
                            }
                        }
                    });
                },
                fnCategoryFilter(val) {
                    this.category = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnFilter(val) {
                    this.isPaid = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnReset() {
                    this.isPaid = null;
                    this.category = 'all';
                    this.searchKeyword = '';
                    this.fnList();
                },
                fnPageChange(page) {
                    this.currentPage = page;
                    this.fnList();
                },
                fnWrite() {
                    if(!this.sessionId) {
                        alert("로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    }else{
                        location.href = "/api/review/add.do";
                    }
                    
                }
            },
            mounted() {
                this.fnList();
                this.fnGetUserTicket(); // 페이지 로드 시 잔액 조회
            }
        }).mount('#app');
    </script>
</body>
</html>