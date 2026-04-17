<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리얼 웨딩 리뷰 - MerryView</title>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <style>
        /* 메인 레이아웃 */
        main { grid-area: main; padding: 50px 40px; min-height: 800px; }
        .review-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px; }
        
        /* 카드 디자인 */
        .review-card { 
            transition: all 0.3s ease; border-radius: 15px; border: 1px solid #eee;
            background: #fff; overflow: hidden; cursor: pointer;
        }
        .review-card:hover { transform: translateY(-7px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
        .img-box { height: 200px; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; }
        .img-box img { width: 100%; height: 100%; object-fit: cover; }
        
        .company-name { font-size: 1.1rem; font-weight: 800; color: var(--dark-color); margin-bottom: 5px; }
        .review-title { font-size: 0.9rem; color: #777; margin-bottom: 15px; }
        
        /* 가격 텍스트 강조 */
        .price-box { background-color: #fff0f3; border-radius: 10px; padding: 12px; }
        .price-text { font-size: 1.1rem; color: var(--primary-color) !important; font-weight: 800; }
        
        .search-bar { max-width: 700px; margin: 0 auto 50px; }
        .btn-dark { background-color: var(--dark-color) !important; border: none; border-radius: 10px; }

        
    </style>
</head>
<body>

<div id="app" class="container-layout">
    <jsp:include page="/WEB-INF/common/header.jsp" />

    <main>
        <div class="review-header">
            <div>
                <h1 class="font-weight-bold" style="letter-spacing: -1px;">💍 리얼 웨딩 리뷰</h1>
                <p class="text-muted mb-0">인증된 신랑 신부님의 솔직한 후기</p>
            </div>
            <button class="btn btn-dark px-4 py-2" @click="fnWritePage">리뷰 작성</button>
        </div>

        <div class="search-bar">
            <div class="input-group shadow-sm" style="border-radius:12px; overflow:hidden;">
                <input type="text" v-model="searchMap.userId" class="form-control form-control-lg border-0" 
                       placeholder="작성자 ID를 입력하세요" @keyup.enter="fnGetList">
                <div class="input-group-append">
                    <button class="btn btn-secondary px-4 border-0" @click="fnGetList">검색</button>
                </div>
            </div>
        </div>

        <div class="row">
            <div v-if="list.length == 0" class="col-12 text-center py-5">
                <p class="text-muted">검색 결과가 없습니다.</p>
            </div>

            <div class="col-md-4 mb-4" v-for="item in list" :key="item.reviewNo">
                <div class="card review-card h-100" @click="fnDetailPage(item.reviewNo)">
                    <div class="img-box">
                        <img v-if="item.storedName" :src="'/uploads/' + item.storedName" alt="인증샷">
                        <div v-else class="text-muted small">MERRY VIEW</div>
                    </div>

                    <div class="card-body p-4">
                        <div class="company-name mb-1">{{ item.companyName || '기타 업체' }}</div>
                        <div class="review-title text-truncate">{{ item.title || '리뷰 제목이 없습니다.' }}</div>
                        
                        <div class="d-flex align-items-center mb-3">
                            <span class="text-warning mr-1">★</span>
                            <span class="font-weight-bold">{{ item.rating }}</span>
                            <span class="mx-2 text-light">|</span>
                            <small class="text-muted">조회 {{ item.viewCnt }}</small>
                        </div>
                        
                        <div class="price-box">
                            <small class="text-danger font-weight-bold d-block mb-1" style="font-size:0.7rem;">인증된 결제 금액</small>
                            <div class="price-text">{{ fnFormatPrice(item.totalCost) }}</div>
                        </div>
                    </div>
                    
                    <div class="card-footer bg-white border-top-0 px-4 pb-4 d-flex justify-content-between align-items-center">
                        <span class="badge badge-light p-2 text-secondary">@{{ item.userId }}</span>
                        <small class="text-muted">{{ item.regDate.substring(0, 10) }}</small>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/common/footer.jsp" />
</div>

<script>
    const app = Vue.createApp({
        data() {
            return {
                list: [],
                searchMap: { userId: "" }
            };
        },
        methods: {
            fnGetList() {
                $.ajax({
                    url: "/api/review/list.dox",
                    type: "GET",
                    data: this.searchMap,
                    success: (res) => {
                        this.list = typeof res === 'string' ? JSON.parse(res) : res;
                    },
                    error: () => alert("목록을 불러오지 못했습니다.")
                });
            },
            fnWritePage() { location.href = "/api/review/add.do"; },
            fnDetailPage(no) { console.log("상세보기 번호: " + no); },
            fnFormatPrice(val) {
                return val ? Number(val).toLocaleString() + '원' : '0원';
            }
        },
        mounted() { this.fnGetList(); }
    }).mount('#app');
</script>
</body>
</html>