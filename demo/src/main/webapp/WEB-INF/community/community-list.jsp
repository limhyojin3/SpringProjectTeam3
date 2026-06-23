<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록 - MarryView</title>
    <!-- 라이브러리 로드 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
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

       /* 카테고리 뱃지 스타일 - 다채롭고 감각적인 컬러 팔레트 */
    .badge-cate { 
        padding: 6px 14px; 
        border-radius: 12px; 
        font-size: 0.78rem; 
        font-weight: 800; 
        display: inline-block; 
        transition: transform 0.2s;
    }

    /* 1. 자유: 청량한 파란색 */
    .cate-자유 { background: #dbeafe; color: #1e40af; }

    /* 2. 결혼: 사랑스러운 피치 핑크 */
    .cate-결혼 { background: #ffe4e6; color: #be123c; }

    /* 3. 가족행사: 싱그러운 그린 계열 */
    .cate-가족행사 { background: #dcfce7; color: #15803d; }

    /* 4. 육아출산: 따스한 옐로우 계열 */
    .cate-육아출산 { background: #fef9c3; color: #a16207; }

    /* 5. 고민: 차분하면서도 깊이 있는 퍼플 */
    .cate-고민 { background: #ede9fe; color: #6d28d9; }

    /* 6. 직장: 도시적인 느낌의 그레이 블루 */
    .cate-직장 { background: #e2e8f0; color: #334155; }

    /* 기본값: 깔끔한 중립 그레이 */
    .cate-default { background: #f1f5f9; color: #64748b; }
        
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

        .nickname-link {
            text-decoration: none; /* 밑줄 제거 */
            color: inherit;       /* 기존 글자색 유지 */
            cursor: pointer;
        }

        .nickname-link:hover {
            text-decoration: underline; /* 호버 시 밑줄 효과 */
            color: #555;                /* 살짝 다른 색상으로 강조 */
        }
        .col-info {
            position: relative;
            z-index: 1; /* 기본값 */
        }

        .nickname-container {
            position: relative; /* 기준점 */
            display: inline-block;
        }

        /* 모달 스타일 */
        .profile-hover-modal {
            position: absolute;
            top: 100%; /* 닉네임 바로 아래 */
            left: 0;
            width: 170px;
            background: #fff;
            border: 1px solid #eee;
            padding: 12px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            z-index: 9999; /* 핵심: 다른 요소보다 무조건 위 */
            
            /* 부드러운 등장 애니메이션 */
            animation: fadeIn 0.3s ease-out forwards;
        }

        /* 애니메이션 효과 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 아래 행의 닉네임과 겹칠 때 모달이 무조건 위로 오게 함 */
        .list-item:hover {
            z-index: 100;
        }
        /* 데이터가 로드되고 모달이 보일 때 */
        .profile-hover-modal.active {
            opacity: 1;
            visibility: visible;
        }
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
                <div v-for="cate in categoryList" :key="cate.value" 
                     :class="['tab-item', { active: searchCategory === cate.value }]"
                     @click="fnChangeCategory(cate.value)">
                    {{ cate.label }}
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
                            {{ getCategoryLabel(item.category) || '기타' }}
                        </span>
                    </div>
                    <div class="col-title">
                        {{ item.title }}
                        <span v-if="item.imgYn === 'Y'" style="margin-left: 8px; color: #ff4d6d; font-size: 0.9rem;">
                            <i class="fas fa-image"></i>
                        </span>
                        <span v-if="item.commentCnt > 0" class="comment-count">({{ item.commentCnt }})</span>
                    </div>
                    <div class="col-info" style="position: relative;">
                        <div class="nickname-container" 
                            @mouseenter="fnShowHover(item.userId, item.postNo)" 
                            @mouseleave="fnHideHover">
                            
                            <a v-if="item.nickname !== '탈퇴회원'" 
                            :href="'/userProfile.do?userId=' + item.userId" 
                            class="nickname-link">
                                <span class="nickname">@{{ item.nickname }}</span>
                            </a>
                            <b v-else class="text-danger">@{{ item.nickname }}</b>

                            <div v-if="hoverUserId === item.userId && hoverPostNo === item.postNo && hoverInfo" 
                                class="profile-hover-modal">
                                <div class="modal-content" style="text-align: center;">
                                    <img :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')" 
                                        style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-bottom: 8px;">
                                    <p style="margin: 0; font-weight: bold; white-space: nowrap;">{{ hoverInfo.info.nickName }}</p>
                                    <div style="font-size: 0.8em; color: #666; margin-top: 5px; white-space: nowrap;">
                                        게시글: {{ hoverInfo.postTotal }} | 리뷰: {{ hoverInfo.reviewTotal }}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="stat-group">
                            <span><i class="far fa-eye icon-view"></i>{{ item.viewCnt }}</span>
                            <span class="icon-heart"><i class="fas fa-heart"></i> {{ item.likeCnt }}</span>
                        </div>
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
                    categoryList: [
                        { label: "전체", value: "전체" },
                        { label: "🎈 자유", value: "자유" },
                        { label: "💍 결혼", value: "결혼" },
                        { label: "👨‍👩‍👧‍👦 가족행사", value: "가족행사" },
                        { label: "👶 육아출산", value: "육아출산" },
                        { label: "💬 고민", value: "고민" },
                        { label: "💼 직장", value: "직장" }
                    ],
                    currentPage: 1,
                    pageSize: 10,
                    totalCount: 0,
                    pageBlockSize: 5,
                    popularList: [], // 인기글 데이터를 담을 배열 추가
                    hoverInfo: null, // 호버한 유저의 정보가 담길 곳
                    hoverUserId: null // 현재 호버 중인 유저의 ID
                    
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
                fnShowHover(userId, postNo) {
                    this.hoverUserId = userId;
                    this.hoverPostNo = postNo;
                    // 서버에서 데이터 가져오기
                    axios.get('/userProfileSimple.dox', { params: { userId: userId  } })
                        .then(res => {
                            this.hoverInfo = res.data; // 서버에서 보낸 info, reviewTotal, postTotal 저장
                        });
                },
                fnHideHover() {
                    this.hoverUserId = null;
                    this.hoverPostNo = null; // 초기화
                    this.hoverInfo = null;
                },
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
                fnGetPopularList() {
                    $.ajax({
                        url: "/api/community/popular.dox", // 해당 API 주소
                        type: "POST",
                        dataType: "json",
                        success: (data) => {
                            console.log(data); // ✅ 콘솔에 데이터가 찍히는지 확인하세요!
                            this.popularList = data.list;
                        }
                    });
                },
                fnSearch() {
                    this.currentPage = 1;
                    this.fnList();
                },
                fnChangeCategory(value) {
                    this.searchCategory = value;
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
                },
                getCategoryLabel(val) {
                    // categoryList에서 value가 일치하는 항목을 찾아 label을 반환
                    const found = this.categoryList.find(c => c.value === val);
                    return found ? found.label : val;
                }
            },
            mounted() {
                this.fnList();
                this.fnGetPopularList();  // 사이드바 인기글 로드
            }
        }).mount('#app');
    </script>
</body>
</html>