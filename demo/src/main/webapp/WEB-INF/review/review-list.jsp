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
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
        body { background-color: #f8f9fa; }
        .main-content { padding: 50px 40px; max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-top: 30px; margin-bottom: 50px; }
        
        /* 유료/무료 탭 스타일 */
        .review-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 2px solid #eee; }
        .tab-item { cursor: pointer; padding: 12px 25px; font-weight: bold; color: #999; transition: 0.3s; position: relative; }
        .tab-item.active { color: var(--primary-color); }
        .tab-item.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 3px; background-color: var(--primary-color); }
        
        /* 뱃지 및 테이블 커스텀 */
        .badge-paid { background: #fff0f3; color: #ff4d6d; border: 1px solid #ffccd5; padding: 5px 10px; }
        .badge-free { background: #e7f5ff; color: #228be6; border: 1px solid #a5d8ff; padding: 5px 10px; }
        
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { padding: 15px; border-bottom: 2px solid var(--dark-color); text-align: center; background: #fafafa; }
        .custom-table td { padding: 18px 15px; border-bottom: 1px solid #eee; text-align: center; vertical-align: middle; }
        .custom-table tbody tr:hover td { background-color: #fff9fa; cursor: pointer; }
        
        /* 검색창 스타일 */
        .search-area { background: #f1f3f5; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
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
                <div class="input-group style" style="max-width: 600px;">
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

            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="width: 100px;">구분</th>
                        <th style="width: 120px;">별점</th>
                        <th>리뷰 정보</th>
                        <th style="width: 150px;">작성자</th>
                        <th style="width: 130px;">날짜</th>
                        <th style="width: 90px;">조회</th>
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
                            <span class="badge badge-light border text-dark mr-2">{{ item.comName }}</span>
                            <span class="text-dark">{{ item.content && item.content.length > 50 ? item.content.substring(0, 50) + '...' : item.content }}</span>
                            <i v-if="item.hasImg === 'Y'" class="far fa-image ml-2 text-primary"></i>
                        </td>
                        <td>
                            <i class="far fa-user-circle mr-1"></i>{{ item.userId }}
                        </td>
                        <td class="small text-muted">{{ item.regDate }}</td>
                        <td class="text-muted">{{ item.viewCnt }}</td>
                    </tr>
                    <tr v-if="list.length == 0">
                        <td colspan="6" class="py-5">
                            <i class="fas fa-exclamation-circle fa-3x text-light mb-3"></i>
                            <p class="text-muted">조건에 맞는 리뷰가 아직 없습니다.</p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </main>
    </div>

    <script>
        const { createApp } = Vue;
        createApp({
            data() {
                return {
                    list: [],
                    isPaid: null,       // 필터링 (null: 전체, 1: 유료, 0: 무료)
                    searchKeyword: '',
                    searchType: 'all',
                    sessionId: "${sessionId}" // 서버에서 넘겨준 세션 아이디
                };
            },
            methods: {
                // 리스트 가져오기
                fnList() {
                    const nParam = {
                        isPaid: this.isPaid,
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType
                    };
                    
                    $.ajax({
                        url: "/api/review/list.dox",
                        type: "POST",
                        data: JSON.stringify(nParam),
                        contentType: "application/json",
                        success: (data) => {
                           // 만약 컨트롤러에서 String이 아니라 Map/List를 바로 리턴한다면 parse가 필요 없음
                        let result = (typeof data === 'string') ? JSON.parse(data) : data;
                        
                        if(result.result === "success") {
                            this.list = result.list;
                            console.log("리스트 개수: ", this.list.length); // 콘솔에서 개수 확인!
                        }
                        },
                        error: () => {
                            console.error("서버 통신 에러");
                        }
                    });
                },
                // 필터 변경
                fnFilter(val) {
                    this.isPaid = val;
                    this.fnList();
                },
                // 초기화
                fnReset() {
                    this.isPaid = null;
                    this.searchKeyword = '';
                    this.fnList();
                },
                // 상세 보기 이동
                fnDetail(no) {
                    location.href = "/review/detail.do?reviewNo=" + no;
                },
                // 글쓰기 이동
                fnWrite() {
                    if(!this.sessionId || this.sessionId === "null" || this.sessionId === "") {
                        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "/login.do";
                        }
                        return;
                    }
                    location.href = "/api/review/add.do";
                }
            },
            mounted() {
                this.fnList(); // 페이지 로드 시 즉시 실행
            }
        }).mount('#app');
    </script>
</body>
</html>