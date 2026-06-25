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
    :root{
        --primary:#ff5c8a;
        --primary-light:#fff1f5;
        --primary-soft:#ffe4ec;
        --secondary:#ff85a1;
        --dark:#2d3436;
        --gray:#6b7280;
        --line:#f3f4f6;
        --white:#ffffff;
    }

    /* 전체 */
    body{
        background:
            radial-gradient(circle at top left,#ffe8ef 0%,transparent 30%),
            radial-gradient(circle at top right,#fff1f5 0%,transparent 25%),
            #fff;
        font-family:'Pretendard',sans-serif;
        margin:0;
        padding:0;
        color:var(--dark);
    }

    /* 메인 */
    .main-content{
        max-width:1200px;
        margin:auto;
        padding:80px 20px;
        min-height:100vh;
    }

    /* 헤더 */
    .header-area{
        text-align:center;
        margin-bottom:60px;
    }

    .header-area h2{
        font-size:48px;
        font-weight:900;
        color:#222;
        margin-bottom:15px;
        letter-spacing:-2px;
    }

    .header-area p{
        color:#777;
        font-size:18px;
    }

    /* 카테고리 */
    .category-tabs{
        display:flex;
        justify-content:center;
        flex-wrap:wrap;
        gap:14px;
        margin-bottom:45px;
    }

    .tab-item{
        padding:13px 26px;
        border-radius:999px;
        background:white;
        border:1px solid #f2f2f2;
        cursor:pointer;
        font-weight:700;
        color:#777;
        transition:.25s;
        box-shadow:0 4px 15px rgba(0,0,0,.03);
    }

    .tab-item:hover{
        transform:translateY(-3px);
        color:var(--primary);
    }

    .tab-item.active{
        background:linear-gradient(135deg,#ff5c8a,#ff8fa9);
        color:white;
        border:none;
        box-shadow:0 10px 25px rgba(255,92,138,.3);
    }

    /* 검색 */
    .search-box{
        width:320px;
        border:none !important;
        border-radius:50px !important;
        padding:14px 22px !important;
        background:white;
        box-shadow:0 6px 20px rgba(0,0,0,.05);
    }

    .search-box:focus{
        box-shadow:
        0 0 0 4px rgba(255,92,138,.15),
        0 8px 25px rgba(0,0,0,.08);
    }

    .btn-search{
        border:none !important;
        border-radius:50px !important;
        padding:0 28px !important;
        background:linear-gradient(135deg,#ff5c8a,#ff8fa9);
        color:white;
        font-weight:700;
        box-shadow:0 8px 20px rgba(255,92,138,.25);
    }

    /* 게시판 */
    .board-list-container{
        background:white;
        border-radius:30px;
        overflow:hidden;
        box-shadow:
        0 20px 60px rgba(255,92,138,.08),
        0 4px 15px rgba(0,0,0,.03);
    }

    /* 헤더 */
    .list-header{
        display:flex;
        align-items:center;
        background:linear-gradient(135deg,#fff7f9,#fff);
        padding:22px 25px;
        font-weight:800;
        color:#555;
        border-bottom:1px solid #f5f5f5;
    }

    /* 게시글 */
    .list-item{
        display:flex;
        align-items:center;
        padding:24px 25px;
        border-bottom:1px solid #fafafa;
        transition:.25s;
        cursor:pointer;
        position:relative;
    }

    .list-item:hover{
        background:#fff8fa;
        transform:translateY(-2px);
    }

    .list-item::after{
        content:'';
        position:absolute;
        left:0;
        top:0;
        width:4px;
        height:100%;
        background:transparent;
        transition:.25s;
    }

    .list-item:hover::after{
        background:var(--primary);
    }

    /* 컬럼 */
    .col-no{
        width:70px;
        text-align:center;
        color:#bbb;
        font-size:.9rem;
    }

    .col-cate{
        width:120px;
        text-align:center;
    }

    .col-title{
        flex:1;
        font-size:1.08rem;
        font-weight:700;
        color:#333;
        padding:0 20px;
    }

    .col-info{
        width:180px;
        display:flex;
        align-items:center;
        justify-content:flex-start;
        position:relative;
    }

    /* 댓글수 */
    .comment-count{
        color:var(--primary);
        font-weight:800;
        margin-left:6px;
    }

    /* 카테고리 */
    .badge-cate{
        border-radius:999px;
        padding:7px 15px;
        font-size:.8rem;
        font-weight:800;
    }

    .cate-자유{
        background:#e0f2fe;
        color:#0369a1;
    }

    .cate-결혼{
        background:#ffe4ec;
        color:#be185d;
    }

    .cate-가족행사{
        background:#dcfce7;
        color:#15803d;
    }

    .cate-육아출산{
        background:#fef3c7;
        color:#b45309;
    }

    .cate-고민{
        background:#ede9fe;
        color:#6d28d9;
    }

    .cate-직장{
        background:#e2e8f0;
        color:#334155;
    }

    .cate-default{
        background:#f3f4f6;
        color:#6b7280;
    }

    /* 닉네임 */
    .nickname{
        background:#fff5f8;
        color:#ff5c8a;
        padding:7px 13px;
        border-radius:12px;
        font-weight:800;
        transition:.25s;
        display: inline-block;
    }

    .nickname:hover{
        background:#ffe3ec;
        transform:translateY(-1px);
    }

    .nickname-link{
        text-decoration:none;
        color:inherit;
    }

    /* 통계 */
    .stat-group{
        display:flex;
        gap:18px;
        color:#999;
        font-weight:700;
    }

    .icon-heart{
        color:#ff5c8a;
    }

    /* 프로필 호버 */
    .nickname-container{
        position:relative;
         display:inline-block;
    }

    .profile-hover-modal{
        position:absolute;
        left:110%;
        top:50%;
        transform:translateY(-50%);
        width:210px;

        background:white;
        border-radius:20px;
        padding:18px;

        border:1px solid #ffe4ec;

        box-shadow:
        0 15px 40px rgba(255,92,138,.15);

        z-index:9999;

        animation:popup .2s ease;
    }

    .profile-hover-modal img{
        width:60px;
        height:60px;
        border-radius:50%;
        object-fit:cover;
        display:block;
        margin:0 auto;
        border:3px solid #ffe4ec;
    }

    .profile-hover-modal::before{
        content:"";
        position:absolute;
        left:-8px;
        top:50%;
        transform:translateY(-50%);
        border-top:8px solid transparent;
        border-bottom:8px solid transparent;
        border-right:8px solid white;
    }

    @keyframes popup{
        from{
            opacity:0;
            transform:translateY(-50%) scale(.9);
        }
        to{
            opacity:1;
            transform:translateY(-50%) scale(1);
        }
    }

    /* 페이지네이션 */
    .pagination .page-link{
        border:none;
        border-radius:14px;
        margin:0 4px;
        color:#777;
        font-weight:700;
    }

    .pagination .active .page-link{
        background:linear-gradient(135deg,#ff5c8a,#ff8fa9);
        color:white !important;
        box-shadow:0 8px 20px rgba(255,92,138,.25);
    }

    /* 글쓰기 버튼 */
    .write-btn-wrapper{
        position:fixed;
        right:40px;
        bottom:40px;
        z-index:999;
    }

    .btn-write{
        width:75px;
        height:75px;
        border:none;
        border-radius:26px;
        background:linear-gradient(135deg,#ff5c8a,#ff8fa9);
        color:white;
        font-size:30px;
        box-shadow:
        0 15px 35px rgba(255,92,138,.35);
        transition:.3s;
        animation:pulse 2.5s infinite;
    }
    @keyframes pulse{
        0%{
            box-shadow:
            0 0 0 0 rgba(255,92,138,.45),
            0 15px 35px rgba(255,92,138,.35);
        }
        70%{
            box-shadow:
            0 0 0 18px rgba(255,92,138,0),
            0 15px 35px rgba(255,92,138,.35);
        }
        100%{
            box-shadow:
            0 0 0 0 rgba(255,92,138,0),
            0 15px 35px rgba(255,92,138,.35);
        }
    }
    .btn-write i{
        animation:bouncePen 2.5s infinite;
    }

    @keyframes bouncePen{
        0%,100%{
            transform:translateY(0);
        }
        50%{
            transform:translateY(-4px);
        }
    }

    .btn-write:hover{
        transform:translateY(-5px) scale(1.08);
    }

    /* Total Posts */
    .text-primary{
        color:#ff5c8a !important;
    }

    /* 모바일 */
    @media(max-width:768px){

        .header-area h2{
            font-size:34px;
        }

        .list-header{
            display:none !important;
        }

        .list-item{
            flex-direction:column;
            align-items:flex-start;
            gap:10px;
        }

        .col-no,
        .col-cate,
        .col-info,
        .col-title{
            width:100%;
            padding:0;
        }

        .stat-group{
            margin-top:8px;
        }
    }
    /* 배경 꽃잎 */
    .petal{
        position:fixed;
        top:-80px;
        pointer-events:none;
        z-index:0;
        opacity:.22;

        animation:
            petalFall linear infinite,
            petalSway ease-in-out infinite;
    }

    @keyframes petalFall{
        from{
            transform:translateY(-100px) rotate(0deg);
        }
        to{
            transform:translateY(120vh) rotate(360deg);
        }
    }

    @keyframes petalSway{
        0%,100%{
            margin-left:0;
        }
        50%{
            margin-left:60px;
        }
    }
    /* 정렬 버튼 */
    .sort-tabs{
        display:flex;
        justify-content:center;
        gap:12px;
        margin-bottom:25px;
        flex-wrap:wrap;
    }

    .sort-item{
        padding:10px 22px;
        border-radius:999px;
        background:white;
        border:1px solid #f2f2f2;
        cursor:pointer;
        font-weight:700;
        color:#777;
        transition:.25s;
        box-shadow:0 4px 15px rgba(0,0,0,.03);
    }

    .sort-item:hover{
        transform:translateY(-2px);
        color:#ff5c8a;
    }

    .sort-item.active{
        background:linear-gradient(135deg,#ff5c8a,#ff8fa9);
        color:white;
        border:none;
        box-shadow:0 10px 25px rgba(255,92,138,.25);
    }
.popular-board{
    background:#fff;
    border-radius:24px;
    padding:25px;
    margin-bottom:40px;

    box-shadow:
    0 10px 30px rgba(255,92,138,.08);

    border:1px solid #ffe4ec;
}

.popular-title{
    font-size:20px;
    font-weight:900;
    color:#ff5c8a;
    margin-bottom:18px;
}

.popular-item{
    display:flex;
    align-items:center;
    justify-content:space-between;

    padding:14px 10px;

    border-bottom:1px solid #f7f7f7;

    cursor:pointer;

    transition:.2s;
}

.popular-item:last-child{
    border-bottom:none;
}

.popular-item:hover{
    background:#fff7fa;
    border-radius:12px;
}

.popular-rank{
    width:40px;
    font-weight:900;
    color:#ff5c8a;
}

.popular-subject{
    flex:1;
    font-weight:700;
    color:#333;
}

.popular-stat{
    color:#999;
    font-size:.9rem;
}
.badge-best{
    display:inline-block;

    padding:4px 10px;
    margin-right:8px;

    border-radius:8px;

    background:linear-gradient(
        135deg,
        #ffd700,
        #ffb300
    );

    color:white;
    font-size:11px;
    font-weight:900;

    box-shadow:
        0 4px 12px rgba(255,193,7,.4);

    animation:bestGlow 2s infinite;
}
@keyframes bestGlow{

    0%{
        transform:scale(1);
        box-shadow:
            0 0 5px rgba(255,215,0,.4),
            0 0 10px rgba(255,215,0,.2);
    }

    50%{
        transform:scale(1.08);
        box-shadow:
            0 0 15px rgba(255,215,0,.8),
            0 0 25px rgba(255,215,0,.5);
    }

    100%{
        transform:scale(1);
        box-shadow:
            0 0 5px rgba(255,215,0,.4),
            0 0 10px rgba(255,215,0,.2);
    }
}
.badge-hot{
    display:inline-block;

    padding:4px 10px;
    margin-right:8px;

    border-radius:8px;

    background:linear-gradient(
        135deg,
        #ff5c8a,
        #ff8fa9
    );

    color:white;
    font-size:11px;
    font-weight:900;

    box-shadow:
        0 4px 12px rgba(255,92,138,.3);

    animation:hotPulse 1.5s infinite;
}
@keyframes hotPulse{

    0%{
        transform:scale(1);
    }

    50%{
        transform:scale(1.08);
    }

    100%{
        transform:scale(1);
    }
}
.badge-king{
    display:inline-block;

    padding:4px 10px;
    margin-right:8px;

    border-radius:8px;

    background:linear-gradient(
        135deg,
        #7c3aed,
        #a855f7
    );

    color:white;
    font-size:11px;
    font-weight:900;

    animation:bestGlow 1.5s infinite;
}
.author-box{
    display:flex;
    flex-direction:column;
    gap:4px;
}

.post-date{
    font-size:11px;
    color:#b5b5b5;
    padding-left:4px;
}
.title-meta{
    margin-top:6px;
    font-size:12px;
    color:#aaa;
    font-weight:600;
    display:flex;
    align-items:center;
    gap:6px;
}
.title-meta span{
    color:#ddd;
}
.title-main{
    line-height:1.4;
}
.title-meta .writer{
    color:#ff5c8a;
    font-weight:700;
}
.meta-nickname{
    color:#ff5c8a !important;
    font-weight:800;
    text-decoration:none !important;
}
    /* 컨텐츠가 꽃잎 위로 올라오게 */
    #app,
    .main-content{
        position:relative;
        z-index:2;
    }
    .col-date{
        width:90px;
        text-align:right;
        color:#aaa;
        font-size:12px;
        font-weight:700;
        flex-shrink:0;
    }

</style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div class="petal">🌸</div>
    <div class="petal">💗</div>
    <div class="petal">🌸</div>
    <div class="petal">💗</div>
    <div class="petal">🌸</div>
    <div class="petal">💗</div>
    <div class="petal">🌸</div>
    <div class="petal">💗</div>
    <div class="petal">🌸</div>
    <div class="petal">💗</div>

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
            <!-- 인기글 -->
            <div class="popular-board mb-5" v-if="popularList.length > 0">

                <div class="popular-title">
                    🔥 실시간 인기글
                </div>

                <div class="popular-item"
                    v-for="(item,index) in popularList"
                    :key="item.postNo"
                    @click="fnDetail(item.postNo)">

                    <span class="popular-rank">
                    {{ getRank(index) }}
                    </span>

                    

                    <span class="popular-subject">
                        {{ item.title }}
                    </span>

                    <span class="popular-stat">
                        ❤️ {{ item.likeCnt }}
                        👁 {{ item.viewCnt }}
                    </span>

                </div>

            </div>

            <!-- 정렬 버튼 -->
            <div class="sort-tabs">
                <div
                    :class="['sort-item', { active: sortType === 'latest' }]"
                    @click="fnChangeSort('latest')">
                    🕒 최신순
                </div>

                <div
                    :class="['sort-item', { active: sortType === 'popular' }]"
                    @click="fnChangeSort('popular')">
                    🔥 인기순
                </div>

                <div
                    :class="['sort-item', { active: sortType === 'view' }]"
                    @click="fnChangeSort('view')">
                    👀 조회순
                </div>

                <div
                    :class="['sort-item', { active: sortType === 'like' }]"
                    @click="fnChangeSort('like')">
                    ❤️ 좋아요순
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
        <div class="col-date">Date</div>
    </div>

    <div v-for="item in list" :key="item.postNo" class="list-item" @click="fnDetail(item.postNo)">
        <div class="col-no">{{ item.postNo }}</div>

        <div class="col-cate">
            <span :class="['badge-cate', 'cate-' + (item.category || 'default')]">
                {{ getCategoryLabel(item.category) || '기타' }}
            </span>
        </div>

        <div class="col-title">
            <div class="title-main">
                <span v-if="popularList.length > 0 && item.postNo === popularList[0].postNo" class="badge-king">
                    👑 KING
                </span>

                <span v-else-if="bestPosts.includes(item.postNo)" class="badge-best">
                    🏆 BEST
                </span>

                <span v-else-if="item.viewCnt >= 100 || item.commentCnt >= 10" class="badge-hot">
                    🔥 HOT
                </span>

                {{ item.title }}

                <span v-if="item.imgYn === 'Y'" style="margin-left:8px;color:#ff4d6d;font-size:.9rem;">
                    <i class="fas fa-image"></i>
                </span>

                <span v-if="item.commentCnt > 0" class="comment-count">
                    ({{ item.commentCnt }})
                </span>
            </div>

            <div class="title-meta" @click.stop>
                <span class="nickname-container"
                    @mouseenter="fnShowHover(item.userId, item.postNo)"
                    @mouseleave="fnHideHover">

                    <a v-if="item.nickname !== '탈퇴회원'"
                        :href="'/userProfile.do?userId=' + item.userId"
                        class="nickname-link meta-nickname">
                        @{{ item.nickname }}
                    </a>

                    <b v-else class="text-danger meta-nickname">
                        @{{ item.nickname }}
                    </b>

                    <div v-if="hoverUserId === item.userId && hoverPostNo === item.postNo && hoverInfo"
                        class="profile-hover-modal">

                        <div style="text-align:center;">
                            <img
                                :src="'/img/profile/' + (hoverInfo.info.profileImg || 'heart.png')"
                                style="width:50px;height:50px;border-radius:50%;object-fit:cover;display:block;margin:0 auto;">

                            <div class="mt-2 font-weight-bold">
                                {{ hoverInfo.info.nickName }}
                            </div>

                            <div style="font-size:12px;color:#666;">
                                게시글 {{ hoverInfo.postTotal }} | 리뷰 {{ hoverInfo.reviewTotal }}
                            </div>
                        </div>
                    </div>
                </span>

                <span>·</span>
                조회 {{ item.viewCnt }}
                <span>·</span>
                좋아요 {{ item.likeCnt }}
            </div>
        </div>

        <div class="col-date">
            {{ formatTime(item.regDate) }}
        </div>
    </div>

    <div v-if="list.length == 0" class="text-center p-5">
        <div class="mb-3" style="font-size:50px;opacity:.3;">📂</div>
        <p style="color:#999;font-weight:500;">작성된 게시물이 없습니다.</p>
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
                    hoverPostNo : null,    
                    hoverInfo: null, // 호버한 유저의 정보가 담길 곳
                    hoverUserId: null, // 현재 호버 중인 유저의 ID
                    sortType: "latest", // latest, view, like, popular
                    popularList : [],
                    bestPosts : [],
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
                        sortType: this.sortType,
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
                fnPopularList() {
                    $.ajax({
                        url : "/api/community/popularList.dox",
                        type : "POST",
                        dataType : "json",
                        success : (data)=>{
                            this.popularList = data.list;
                            this.bestPosts = data.list.map(item => item.postNo);
                        }
                    })
                },
                getRank(index){
                    if(index==0) return "🥇";
                    if(index==1) return "🥈";
                    if(index==2) return "🥉";
                    return index+1;
                },
                fnSearch() {
                    this.currentPage = 1;
                    this.fnList();
                },
                fnChangeSort(type) {
                    this.sortType = type;
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
                },
                formatTime(date) {
                    const now = new Date();
                    const target = new Date(date);
                    const diff = Math.floor((now - target) / 1000);
                    if(diff < 60){
                        return "방금 전";
                    }
                    if(diff < 3600){
                        return Math.floor(diff / 60) + "분 전";
                    }
                    if(diff < 86400){
                        return Math.floor(diff / 3600) + "시간 전";
                    }
                    if(diff < 172800){
                        return "어제";
                    }
                    if(diff < 604800){
                        return Math.floor(diff / 86400) + "일 전";
                    }
                    return target.toLocaleDateString('ko-KR');
                },
            },
            mounted() {
                this.fnList();
                 this.fnPopularList();
                 document.querySelectorAll('.petal').forEach(el => {
                    el.style.left = Math.random() * 100 + 'vw';
                    el.style.fontSize =
                        (18 + Math.random() * 18) + 'px';
                    el.style.animationDuration =
                        (12 + Math.random() * 10) + 's';
                    el.style.animationDelay =
                        Math.random() * 5 + 's';
                });
            }
        }).mount('#app');
    </script>
</body>
</html>