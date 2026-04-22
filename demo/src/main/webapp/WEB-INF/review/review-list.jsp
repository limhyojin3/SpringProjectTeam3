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
        
        /* 댓글 개수 포인트 컬러 */
        .comment-count { color: var(--primary-color); font-weight: bold; font-size: 0.9rem; margin-left: 4px; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="font-weight-bold" @click="fnReset" style="cursor:pointer">📸 리뷰 커뮤니티</h2>
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
                        <th>리뷰 정보</th>
                        <th style="width: 90px;">추천</th>
                        <th style="width: 130px;">작성자</th>
                        <th style="width: 120px;">날짜</th>
                        <th style="width: 80px;">조회</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in list" :key="item.reviewNo" @click="fnDetail(item.reviewNo)">
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
                            
                            <span v-if="item.commentCnt > 0" class="comment-count">
                                [{{ item.commentCnt }}]
                            </span>
                            
                            <i v-if="item.hasImg === 'Y'" class="far fa-image ml-2 text-primary"></i>
                        </td>
                        <td>
                            <span :class="item.likeCnt > 0 ? 'text-danger' : 'text-muted'">
                                <i class="fas fa-heart mr-1"></i>{{ item.likeCnt || 0 }}
                            </span>
                        </td>
                        <td>
                            <i class="far fa-user-circle mr-1"></i>{{ item.userId }}
                        </td>
                        <td class="small text-muted">{{ item.regDate }}</td>
                        <td class="text-muted">{{ item.viewCnt }}</td>
                    </tr>
                    <tr v-if="list.length == 0">
                        <td colspan="7" class="py-5">
                            <i class="fas fa-exclamation-circle fa-3x text-light mb-3"></i>
                            <p class="text-muted">조건에 맞는 리뷰가 아직 없습니다.</p>
                        </td>
                    </tr>
                </tbody>
            </table>
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
                    category: 'all',
                };
            },
            methods: {
                fnList() {
                    const nParam = {
                        isPaid: this.isPaid,
                        category: this.category, //  서버로 카테고리 값 전송
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType
                    };
                    
                    $.ajax({
                        url: "/api/review/list.dox",
                        type: "POST",
                        data: JSON.stringify(nParam),
                        contentType: "application/json",
                        success: (data) => {
                            console.log(this.list);
                            let result = (typeof data === 'string') ? JSON.parse(data) : data;
                            if(result.result === "success") {
                                this.list = result.list;
                            }
                        },
                        error: () => { console.error("서버 통신 에러"); }
                    });
                },
                fnFilter(val) {
                    this.isPaid = val;
                    this.fnList();
                },
                fnReset() {
                    this.isPaid = null;
                    this.searchKeyword = '';
                    this.fnList();
                },
                fnDetail(no) {
                    location.href = "/api/review/detail.do?reviewNo=" + no;
                },
                fnWrite() {
                    location.href = "/api/review/add.do";
                },
                //  카테고리 필터 함수 추가
                fnCategoryFilter(val) {
                    this.category = val;
                    this.fnList();
                },
                fnFilter(val) {
                    this.isPaid = val;
                    this.fnList();
                },
                fnReset() {
                    this.isPaid = null;
                    this.category = 'all'; // 리셋 시 카테고리도 초기화
                    this.searchKeyword = '';
                    this.fnList();
                }
            },
            mounted() {
                this.fnList();
            }
        }).mount('#app');
    </script>
</body>
</html> 