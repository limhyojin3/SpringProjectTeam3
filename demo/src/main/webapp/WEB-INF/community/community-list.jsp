<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록 - MarryView</title>
    <!-- 라이브러리 로드 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    
    <style>
        :root { 
            --primary-color: #ff4d6d; 
            --secondary-color: #ff85a1;
            --primary-light: rgba(255, 77, 109, 0.05);
            --dark-color: #2d3436; 
            --gray-color: #636e72;
        }

        body { 
            /* 화사한 그라데이션 배경 적용 */
            background: linear-gradient(180deg, #fff0f3 0%, #ffffff 400px, #ffffff 100%);
            font-family: 'Pretendard', -apple-system, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* 1. 메인 컨텐츠 영역 */
        .main-content { padding: 80px 20px; max-width: 1140px; margin: 0 auto; min-height: 100vh; }
        
        /* 헤더 영역 */
        .header-area { margin-bottom: 50px; text-align: center; }
        .header-area h2 { font-size: 40px; font-weight: 900; color: var(--dark-color); margin-bottom: 15px; letter-spacing: -1.5px; }
        .header-area p { color: var(--gray-color); font-size: 1.15rem; font-weight: 500; }

        /* 2. 카테고리 탭 (유리 스타일링 적용) */
        .category-tabs { display: flex; justify-content: center; gap: 15px; margin-bottom: 45px; }
        .tab-item { 
            padding: 12px 28px; cursor: pointer; border-radius: 50px; font-weight: 700; 
            color: #888; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            background: rgba(255, 255, 255, 0.8); border: 1px solid #eee;
            backdrop-filter: blur(5px);
        }
        .tab-item:hover { color: var(--primary-color); transform: translateY(-3px); }
        .tab-item.active { 
            background: var(--primary-color); color: white; border-color: var(--primary-color); 
            box-shadow: 0 8px 20px rgba(255, 77, 109, 0.3); 
        }

        /* 3. 게시판 리스트 디자인 */
        .board-list-container { 
            background: rgba(255, 255, 255, 0.9); border-radius: 24px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.05); overflow: hidden; 
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .list-header { 
            display: flex; background: #fafafa; padding: 20px 25px; 
            font-weight: 700; color: #444; border-bottom: 1px solid #f1f1f1; font-size: 0.95rem;
            text-align: center;
        }
        
        .list-item { 
            display: flex; align-items: center; padding: 24px 25px; border-bottom: 1px solid #f9f9f9;
            transition: all 0.25s ease; cursor: pointer; background: transparent;
        }
        .list-item:hover { background-color: var(--primary-light); transform: scale(1.005); }

        /* 컬럼 너비 설정 */
        .col-no { width: 70px; text-align: center; font-size: 0.85rem; color: #bbb; }
        .col-cate { width: 110px; text-align: center; }
        .col-title { flex: 1; padding: 0 25px; font-weight: 600; color: #333; font-size: 1.1rem; }
        .col-info { width: 320px; display: flex; align-items: center; justify-content: space-between; font-size: 0.95rem; }
        
        /* 제목 및 댓글수 */
        .comment-count { color: var(--primary-color); font-weight: 800; margin-left: 8px; }

        /* 카테고리 뱃지 */
        .badge-cate { padding: 6px 14px; border-radius: 10px; font-size: 0.78rem; font-weight: 800; display: inline-block; }
        .cate-자유 { background: #eef2ff; color: #4f46e5; }
        .cate-질문 { background: #fff7ed; color: #ea580c; }
        .cate-정보 { background: #fdf2f8; color: #db2777; }
        .cate-default { background: #f3f4f6; color: #6b7280; }
        
        /* 작성자 및 통계 */
        .nickname { font-weight: 700; color: #555; background: #f8f9fa; padding: 4px 10px; border-radius: 6px; }
        .stat-group { display: flex; gap: 18px; color: #a0a0a0; font-weight: 600; min-width: 130px; justify-content: flex-end; }
        .icon-heart { color: var(--primary-color); }
        .icon-view { margin-right: 4px; }

        /* 4. 검색창 개선 */
        .search-box { 
            width: 280px; border-radius: 30px !important; border: 2px solid #f1f1f1; 
            padding: 10px 20px; transition: 0.3s;
        }
        .search-box:focus { border-color: var(--primary-color); box-shadow: none; }
        .btn-search { 
            border-radius: 30px !important; padding: 8px 25px !important; 
            background: var(--dark-color); border: none; color: white; font-weight: 700;
        }

        /* 페이지네이션 */
        .pagination .page-link { border: none; color: #888; margin: 0 5px; border-radius: 12px; font-weight: 700; padding: 10px 18px; }
        .pagination .active .page-link { background-color: var(--primary-color) !important; color: white !important; box-shadow: 0 5px 15px rgba(255, 77, 109, 0.2); }

        /* 플로팅 글쓰기 버튼 */
        .write-btn-wrapper { position: fixed; bottom: 50px; right: 50px; z-index: 1000; }
        .btn-write { 
            width: 70px; height: 70px; border-radius: 24px; background: var(--primary-color);
            color: white; border: none; font-size: 30px; box-shadow: 0 12px 30px rgba(255, 77, 109, 0.4);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); display: flex; align-items: center; justify-content: center;
        }
        .btn-write:hover { transform: scale(1.1) rotate(5deg); background: #ff1a4a; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <div id="app">
        <main class="main-content">
            <!-- 상단 헤더 -->
            <header class="header-area">
                <h2>💬 Marry Community</h2>
                <p>예비 부부들의 생생한 이야기와 꿀팁을 확인하세요.</p>
            </header>

            <!-- 카테고리 탭 -->
            <div class="category-tabs">
                <div v-for="cate in categories" :key="cate" 
                     :class="['tab-item', { active: searchCategory === cate }]"
                     @click="fnChangeCategory(cate)">
                    {{ cate }}
                </div>
            </div>

            <!-- 상단 검색바 -->
            <div class="d-flex justify-content-between align-items-center mb-4 px-3">
                <div class="text-muted small">Total <span class="text-primary font-weight-bold">{{ totalCount }}</span> Posts</div>
                <div class="d-flex">
                    <input type="text" class="form-control search-box" 
                           v-model="searchKeyword" @keyup.enter="fnSearch" placeholder="무엇이든 검색해보세요">
                    <button @click="fnSearch" class="btn btn-search ml-3">검색</button>
                </div>
            </div>

            <!-- 게시판 리스트 -->
            <div class="board-list-container">
                <div class="list-header d-none d-md-flex">
                    <div class="col-no">No.</div>
                    <div class="col-cate">Category</div>
                    <div class="col-title">Subject</div>
                    <div class="col-info">Author / Status</div>
                </div>
                
                <div v-for="item in list" :key="item.postNo" class="list-item" @click="fnDetail(item.postNo)">
                    <div class="col-no">{{ item.postNo }}</div>
                    <div class="col-cate">
                        <span :class="['badge-cate', 'cate-' + (item.category || 'default')]">
                            {{ item.category || '기타' }}
                        </span>
                    </div>
                    <div class="col-title">
                        {{ item.title }}
                        <span v-if="item.commentCnt > 0" class="comment-count">({{ item.commentCnt }})</span>
                    </div>
                    <div class="col-info">
                        <span class="nickname">@{{ item.nickname }}</span>
                        <div class="stat-group">
                            <span><i class="far fa-eye icon-view"></i>{{ item.viewCnt }}</span>
                            <span class="icon-heart"><i class="fas fa-heart"></i> {{ item.likeCnt }}</span>
                        </div>
                    </div>
                </div>

                <!-- 데이터 없을 때 -->
                <div v-if="list.length == 0" class="text-center p-5">
                    <div class="mb-3" style="font-size: 50px; opacity: 0.3;">📂</div>
                    <p style="color: #999; font-weight: 500;">작성된 게시물이 없습니다.</p>
                </div>
            </div>

            <!-- 페이지네이션 -->
            <nav class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item" :class="{disabled: currentPage === 1}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(currentPage - 1)">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item" v-for="page in pageNumbers" :key="page" :class="{active: currentPage === page}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(page)">{{ page }}</a>
                    </li>
                    <li class="page-item" :class="{disabled: currentPage === totalPageCount}">
                        <a class="page-link" href="javascript:;" @click="fnPageChange(currentPage + 1)">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- 플로팅 글쓰기 버튼 -->
            <div class="write-btn-wrapper">
                <button class="btn-write" @click="fnAddPage">
                    <i class="fas fa-pen"></i>
                </button>
            </div>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    sessionId: "",
                    searchKeyword: "",
                    searchType: "all",
                    searchCategory: "전체",
                    categories: ["전체", "자유", "질문", "정보"],
                    currentPage: 1,
                    pageSize: 10,
                    totalCount: 0,
                    pageBlockSize: 5
                };
            },
            computed: {
                pageNumbers() {
                    const totalPages = this.totalPageCount;
                    const startPage = Math.floor((this.currentPage - 1) / this.pageBlockSize) * this.pageBlockSize + 1;
                    let endPage = startPage + this.pageBlockSize - 1;
                    if (endPage > totalPages) endPage = totalPages;
                    
                    const pages = [];
                    for (let i = startPage; i <= endPage; i++) {
                        pages.push(i);
                    }
                    return pages;
                },
                totalPageCount() {
                    return Math.ceil(this.totalCount / this.pageSize) || 1;
                }
            },
            methods: {
                fnList() {
                    const nParam = {
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType,
                        category: this.searchCategory === "전체" ? "" : this.searchCategory,
                        startIndex: (this.currentPage - 1) * this.pageSize,
                        pageSize: this.pageSize
                    };
                    $.ajax({
                        url: "/api/community/list.dox",
                        dataType: "json",
                        type: "POST", 
                        contentType: "application/json",
                        data: JSON.stringify(nParam),
                        success: (data) => {
                            this.list = data.list; 
                            this.sessionId = data.sessionId;
                            this.totalCount = data.count; 
                        },
                        error: (xhr) => console.error("데이터 로드 실패")
                    });
                },
                fnSearch() {
                    this.currentPage = 1;
                    this.fnList();
                },
                fnChangeCategory(cate) {
                    this.searchCategory = cate;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnPageChange(page) {
                    if (page < 1 || page > this.totalPageCount) return;
                    this.currentPage = page;
                    this.fnList();
                    window.scrollTo({top: 0, behavior: 'smooth'});
                },
                fnDetail(postNo) {
                    location.href = "/api/community/detail.do?postNo=" + postNo;
                },
                fnAddPage() {
                    if (!this.sessionId) {
                        if (confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "/login.do"; 
                        }
                    } else {
                        location.href = "/api/community/add.do";
                    }
                }
            },
            mounted() {
                this.fnList();
            }
        }).mount('#app');
    </script>
</body>
</html>