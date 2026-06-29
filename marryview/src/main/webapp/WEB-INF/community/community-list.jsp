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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/community/community-list.css">
    
<style>
    
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>
    <div class="petal petal-heart"><i class="fas fa-heart"></i></div>

    <div id="app">
        <jsp:include page="/WEB-INF/community/view/community-list-view.jsp" />
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />

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
                        { label: "전체", value: "전체", icon: null },
                        { label: "자유", value: "자유", icon: "fa-smile" },
                        { label: "결혼", value: "결혼", icon: "fa-gem " },
                        { label: "가족행사", value: "가족행사", icon: "fa-users" },
                        { label: "육아출산", value: "육아출산", icon: "fa-baby" },
                        { label: "고민", value: "고민", icon: "fa-comment-dots" },
                        { label: "직장", value: "직장", icon: "fa-briefcase" }
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
                    // 페이드 아웃
                    document.querySelector('.board-list-container').classList.add('board-list-fade');
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
                            // 페이드 인
                            this.$nextTick(() => {
                                document.querySelector('.board-list-container').classList.remove('board-list-fade');
                            });
                        },
                        error: (xhr) => console.error("데이터 로드 실패")
                    });
                },
                fnPopularList() {
                    $.ajax({
                        url: "/api/community/popularList.dox",
                        type: "POST",
                        dataType: "json",

                        success: (data) => {
                            console.log("인기글 API 전체 응답:", data);
                            console.log("인기글 목록:", data.list);

                            this.popularList = data.list || [];
                            this.bestPosts = this.popularList.map(item => item.postNo);

                            console.log("Vue popularList:", this.popularList);
                        },

                        error: (xhr, status, error) => {
                            console.error("인기글 불러오기 실패");
                            console.error("상태:", xhr.status);
                            console.error("응답:", xhr.responseText);
                            console.error("오류:", error);

                            this.popularList = [];
                            this.bestPosts = [];
                        }
                    });
                },
                getRank(index) {
                    if(index === 0) return '<i class="fas fa-medal" style="color:#FFD700;"></i>';
                    if(index === 1) return '<i class="fas fa-medal" style="color:#C0C0C0;"></i>';
                    if(index === 2) return '<i class="fas fa-medal" style="color:#CD7F32;"></i>';
                    return index + 1;
                },
                fnSearch() {
                    this.currentPage = 1;
                    this.fnList();
                },
                fnChangeCategory(value) {
                    const scrollY = window.scrollY;
                    this.searchCategory = value;
                    this.currentPage = 1;
                    this.fnList();
                    this.$nextTick(() => {
                        window.scrollTo(0, scrollY);
                    });
                },

                fnChangeSort(type) {
                    const scrollY = window.scrollY;
                    this.sortType = type;
                    this.currentPage = 1;
                    this.fnList();
                    this.$nextTick(() => {
                        window.scrollTo(0, scrollY);
                    });
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
                    el.style.fontSize = (24 + Math.random() * 24) + 'px';  /* 18~36 → 24~48 */
                    el.style.animationDuration = (12 + Math.random() * 10) + 's';
                    el.style.animationDelay = -(Math.random() * 10) + 's';  /* 음수로 처음부터 보이게 */
                });
            }
        }).mount('#app');
    </script>
</body>
</html>