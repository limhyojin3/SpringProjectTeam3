<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 커뮤니티 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css"> 
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
    body { background-color: #f8f9fa; }
    .main-content { padding: 50px 40px; max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-top: 30px; margin-bottom: 50px; }
    
    /* 탭 및 필터 스타일 */
    .review-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #eee; }
    .tab-item { cursor: pointer; padding: 12px 25px; font-weight: bold; color: #999; transition: 0.3s; position: relative; }
    .tab-item.active { color: var(--primary-color); }
    .tab-item.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 3px; background-color: var(--primary-color); }
    
    /* 뱃지 스타일 */
    .badge-paid { background: #fff0f3; color: #ff4d6d; border: 1px solid #ffccd5; padding: 5px 10px; }
    .badge-free { background: #e7f5ff; color: #228be6; border: 1px solid #a5d8ff; padding: 5px 10px; }
    .badge-best { background: #ffb703; color: white; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 0.75rem; }
    
    .search-area { background: #f1f3f5; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
    
    /* 카드 그리드 레이아웃 */
    .review-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; padding: 20px 0; }
    .review-card { background: #fff; border-radius: 15px; overflow: hidden; border: 1px solid #eee; transition: all 0.3s ease; cursor: pointer; display: flex; flex-direction: column; position: relative; height: 100%; }
    .review-card:hover { transform: translateY(-8px); box-shadow: 0 12px 24px rgba(0,0,0,0.1); border-color: var(--primary-color); }
    
    /* [수정] 카드 이미지 박스 - 높이를 180px에서 220px로 확대 */
    .card-img-box { width: 100%; height: 220px; background: #f8f9fa; overflow: hidden; position: relative; display: flex; align-items: center; justify-content: center; }
    .card-img-box img { width: 100%; height: 100%; object-fit: cover; }
    .no-img { color: #ccc; font-size: 2.5rem; }
    .card-badges { position: absolute; top: 12px; left: 12px; z-index: 2; display: flex; gap: 6px; }
    
    /* [수정] 카드 바디 패딩 조정 */
    .card-body-custom { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; }
    .card-com-name { font-size: 0.85rem; color: var(--primary-color); font-weight: bold; margin-bottom: 4px; }
    
    /* [수정] 제목 영역 - margin-bottom을 12px에서 4px로 줄여 공백 제거 */
    .card-review-title { 
        font-size: 1.05rem; 
        font-weight: 700; 
        color: #333; 
        margin-bottom: 4px; 
        line-height: 1.4; 
        height: 2.8em; 
        overflow: hidden; 
        display: -webkit-box; 
        -webkit-line-clamp: 2; 
        -webkit-box-orient: vertical; 
    }
    
    .comment-count { color: var(--primary-color); font-weight: bold; font-size: 0.9rem; }
    
    /* [수정] 통계 영역 - 별점/하트가 제목에 더 가깝게 붙도록 조정 */
    .card-stats { font-size: 0.85rem; margin-bottom: 10px; display: flex; gap: 12px; }
    .card-info-row { display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 10px; border-top: 1px solid #f1f1f1; font-size: 0.8rem; color: #888; }

    /* 페이징 스타일 */
    .page-item.disabled .page-link { pointer-events: auto !important; cursor: not-allowed !important; }
    .page-link { cursor: pointer !important; color: #333; }
    .page-item.active .page-link { background-color: var(--primary-color) !important; border-color: var(--primary-color) !important; color: white !important; }
    
    /* 베스트 섹션 전체 레이아웃 */
    .best-review-wrapper { margin-bottom: 50px; padding: 20px; background-color: #fffaf0; border-radius: 20px; }
    .best-main-title { text-align: center; font-size: 24px; font-weight: 800; margin-bottom: 5px; color: #333; }
    .best-sub-title { text-align: center; color: #888; margin-bottom: 30px; font-size: 14px; }
    .best-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }

    /* 베스트 카드 디자인 */
    .best-card { position: relative; background: #fff; border-radius: 15px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); cursor: pointer; transition: all 0.3s ease; border: 1px solid #eee; }
    .best-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); border-color: #FFD700; }

    /* 순위 뱃지 스타일 */
    .rank-label { position: absolute; top: -10px; left: -10px; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #fff; z-index: 5; box-shadow: 2px 2px 5px rgba(0,0,0,0.2); }
    .rank-1 { background: #FFD700; } 
    .rank-2 { background: #C0C0C0; } 
    .rank-3 { background: #CD7F32; } 

    /* [수정] 베스트 이미지 박스도 동일하게 확대 (선택사항) */
    .best-img-box { width: 100%; height: 200px; overflow: hidden; border-radius: 15px 15px 0 0; }
    .best-img-box img { width: 100%; height: 100%; object-fit: cover; }
    .no-img-default { padding: 30px; object-fit: contain !important; }

    /* 베스트 텍스트 영역 */
    .best-info { padding: 15px; }
    .company-tag { font-size: 12px; color: #ff6b6b; font-weight: bold; }
    .title-text { margin: 8px 0; font-size: 16px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .best-meta { font-size: 13px; color: #999; display: flex; gap: 10px; }
    .section-divider { border: 0; height: 1px; background: #eee; margin: 40px 0; }

    /* 이미지가 없을 때 로고 설정 */
    .default-logo, .no-img-default { object-fit: contain !important; padding: 20px; background-color: #f8f9fa; }
        
        
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        

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

            <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="review-tabs mb-0" style="border-bottom: none;">
                    <div class="tab-item" :class="{active: isPaid === null}" @click="fnFilter(null)">전체보기</div>
                    <div class="tab-item" :class="{active: isPaid === 1}" @click="fnFilter(1)">💎 유료 리뷰</div>
                    <div class="tab-item" :class="{active: isPaid === 0}" @click="fnFilter(0)">🎁 무료 리뷰</div>
                </div>
                <div class="btn-group btn-group-sm">
                    <button class="btn" :class="orderType === 'date' ? 'btn-dark' : 'btn-outline-dark'" @click="fnChangeOrder('date')">최신순</button>
                    <button class="btn" :class="orderType === 'views' ? 'btn-dark' : 'btn-outline-dark'" @click="fnChangeOrder('views')">조회순</button>
                    <button class="btn" :class="orderType === 'likes' ? 'btn-dark' : 'btn-outline-dark'" @click="fnChangeOrder('likes')">좋아요순</button>
                </div>
            </div>

            <div class="category-filter-bar mb-4">
                <button class="btn btn-sm mr-2" :class="category === 'all' ? 'btn-dark' : 'btn-outline-dark'" @click="fnCategoryFilter('all')">전체</button>
                <button class="btn btn-sm mr-2" :class="category === 'STUDIO' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('STUDIO')">📸 스튜디오</button>
                <button class="btn btn-sm mr-2" :class="category === 'DRESS' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('DRESS')">👗 드레스</button>
                <button class="btn btn-sm" :class="category === 'MAKEUP' ? 'btn-danger' : 'btn-outline-danger'" @click="fnCategoryFilter('MAKEUP')">💄 메이크업</button>
            </div>

            <div class="best-review-wrapper" v-if="bestList && bestList.length > 0">
                <div class="section-header">
                    <h2 class="best-main-title">
                        <i class="fas fa-crown" style="color: #FFD700;"></i> WEEKLY BEST REVIEWS
                    </h2>
                    <p class="best-sub-title">가장 많은 사랑을 받은 베스트 후기입니다.</p>
                </div>

                <div class="best-grid">
                    <div v-for="(best, index) in bestList" :key="best.reviewNo" class="best-card" @click="fnDetail(best)">
                        <div class="rank-label" :class="'rank-' + (index + 1)">{{index + 1}}</div>
                        
                        <div class="best-img-box">
                            <!-- 1순위: 썸네일(본문이미지), 2순위: 기본 로고 -->
                            <img :src="best.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                                :class="{'no-img-default': !best.thumbnailUrl}"
                                @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'">
                        </div>

                        <div class="best-info">
                            <span class="company-tag">{{best.comName}}</span>
                            <h3 class="title-text">{{best.title}}</h3>
                            <div class="best-meta">
                                <span><i class="fas fa-heart"></i> {{best.likeCnt}}</span>
                                <span><i class="fas fa-eye"></i> {{best.viewCnt}}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="section-divider">

            <div class="review-grid">
                <div v-for="item in list" :key="item.reviewNo" class="review-card" @click="fnDetail(item)">
                    <div class="card-badges">
                        <span v-if="item.viewCnt >= 100 || item.likeCnt >= 10" class="badge-best">BEST</span>
                        <span v-if="item.isPaid == 1" class="badge badge-paid">유료</span>
                        <span v-else class="badge badge-free">무료</span>
                    </div>

                    <div class="card-img-box">
                        <!-- 본문에서 추출한 썸네일이 있으면 보여주고, 없으면 로고 출력 -->
                        <img :src="item.thumbnailUrl || '/images/marryviewlogo_v3.png'" 
                            :class="{'default-logo': !item.thumbnailUrl}"
                            @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'"
                            alt="리뷰 썸네일">
                    </div>

                    <div class="card-body-custom">
                        <div class="card-com-name">{{ item.comName }}</div>
                        <h5 class="card-review-title">
                            {{ item.title }}
                            <span v-if="item.commentCnt > 0" class="comment-count">[{{ item.commentCnt }}]</span>
                        </h5>
                        
                        <div class="card-stats">
                            <span class="text-warning"><i class="fas fa-star mr-1"></i>{{ parseFloat(item.rating || 0).toFixed(1) }}</span>
                            <span class="text-danger"><i class="fas fa-heart mr-1"></i>{{ item.likeCnt || 0 }}</span>
                            <span><i class="far fa-eye mr-1"></i>{{ item.viewCnt }}</span>
                        </div>

                        <div class="card-info-row">
                            <span><i class="far fa-user-circle mr-1"></i>{{ item.nickname }}</span>
                            <span>{{ item.regDate }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="list.length == 0" class="py-5 text-center bg-light rounded border">
                <p class="text-muted mb-0">조건에 맞는 리뷰가 아직 없습니다.</p>
            </div>

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
                    bestList : [],
                    isPaid: null,
                    searchKeyword: '',
                    searchType: 'all',
                    orderType : 'date',
                    sessionId: "${sessionId}",
                    userRole: "${sessionRole}",
                    category: 'all',
                    currentPage: 1,
                    pageSize: 9, // 카드 형태이므로 12개가 적당함 (3개씩 4줄 혹은 4개씩 3줄)
                    totalCount: 0,
                    pageBlockSize: 5,
                    userRemainingCount: 0, 
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
                    if(!this.sessionId) return;
                    $.ajax({
                        url: "/api/review/getUserAccessCount.dox",
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
                        pageSize: this.pageSize,
                        orderType: this.orderType 
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
                                this.bestList = result.bestList;
                            }
                        }
                    });
                },
                fnDetail(item) {
                    if (this.userRole === 'ADMIN' || (this.sessionId && this.sessionId === item.userId)) {
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                        return;
                    }
                    if (item.isPaid == 1 && !this.sessionId) {
                        alert("유료 리뷰는 로그인 후 이용 가능합니다.");
                        location.href = "/login.do";
                        return;
                    }
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
                        location.href = "/api/review/detail.do?reviewNo=" + item.reviewNo;
                    }
                },
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
                    this.orderType = 'date';
                    this.currentPage = 1;
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
                    } else {
                        location.href = "/api/review/add.do";
                    }
                },
                fnChangeOrder(type) {
                    this.orderType = type;
                    this.currentPage = 1;
                    this.fnList();
                }
            },
            mounted() {
                this.fnList();
                this.fnGetUserTicket();
            }
        }).mount('#app');
    </script>
</body>
</html>