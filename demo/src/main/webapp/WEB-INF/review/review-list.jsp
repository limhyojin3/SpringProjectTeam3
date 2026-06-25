<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 커뮤니티 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css"> 
    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/review/review-list.css">
    <style>
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app">
        <jsp:include page="/WEB-INF/review/view/review-list-view.jsp" />
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />

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
                    mainCategory: 'all', // mainCategory 대신 largeCategory 사용
                    subCategory: 'all', // subCategory 대신 mediumCategory 사용
                    // 대분류별 중분류 매핑 데이터
                    categoryMap: {
                        '결혼': ['스튜디오', '드레스', '메이크업'],
                        '가족행사': ['가족사진', '돌잔치', '아이생일파티', '기념일', '부모님생신'],
                        '친구와함께': ['우정사진', '브라이덜샤워', '파티룸']
                    },
                    hoverUserId : null,
                    hoverInfo : null,
                    hoverReviewNo : null,
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
                fnShowHover(userId, reviewNo) {
                    this.hoverUserId = userId;
                    this.hoverReviewNo = reviewNo;
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
                // 1차 분류 선택 시
                fnChangeLargeCategory(val) {
                    this.mainCategory = val;
                    this.subCategory = 'all'; // 대분류 변경 시 중분류 초기화
                    this.currentPage = 1;
                    this.fnList();
                },
                // 2차 분류 선택 시
                fnChangeMediumCategory(val) {
                    this.subCategory = val;
                    this.currentPage = 1;
                    this.fnList();
                },
                fnList() {
                    const nParam = {
                        isPaid: this.isPaid,
                        largeCategory: this.mainCategory,  
                        mediumCategory: this.subCategory,
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
                },
                // 블러 처리 여부를 결정하는 핵심 로직
                shouldBlur(item) {
                    // 1. 관리자(ADMIN)는 절대 블러 안 함
                    if (this.userRole === 'ADMIN') return false;
                    
                    // 2. 유료 리뷰(isPaid == 1)가 아니면 블러 안 함
                    if (item.isPaid != 1) return false;
                    
                    // 3. 내가 쓴 리뷰(userId가 일치)면 블러 안 함
                    if (this.sessionId === item.userId) return false;
                    
                    // 4. 이미 열람권을 사용해 구매한 이력이 있다면 블러 안 함
                    // (이 데이터는 DB에서 'isViewed' 같은 컬럼으로 가져온다고 가정)
                    if (item.viewStatus === 'ALREADY_VIEWED') return false;

                    // 위 조건에 모두 해당하지 않는 유료 리뷰만 블러 처리
                    return true;
                },
            },
            mounted() {
                this.fnList();
                this.fnGetUserTicket();
            }
        }).mount('#app');
    </script>
</body>
</html>