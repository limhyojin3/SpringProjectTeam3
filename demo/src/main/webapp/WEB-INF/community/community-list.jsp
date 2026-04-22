<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }

        /* 1. 메인 컨텐츠 영역 */
        .main-content { padding: 50px 40px; min-height: 800px; max-width: 1200px; margin: 0 auto; }
        .header-area { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; }
        h2 { font-size: 32px; color: var(--dark-color); font-weight: 800; letter-spacing: -1px; }

        /* 2. 카테고리 탭 (리얼리뷰 스타일) */
        .category-tabs { display: flex; gap: 10px; margin-bottom: 25px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .tab-item { 
            padding: 10px 20px; cursor: pointer; border-radius: 30px; font-weight: 700; color: #888;
            transition: 0.3s; background: #f8f9fa; border: 1px solid #eee;
        }
        .tab-item:hover { color: var(--primary-color); }
        .tab-item.active { background: var(--primary-color); color: white; border-color: var(--primary-color); }

        /* 3. 테이블 디자인 */
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { 
            background-color: #fff; padding: 20px 15px; border-bottom: 2px solid var(--dark-color); 
            font-weight: 700; color: #333; text-align: center;
        }
        .custom-table td { padding: 20px 15px; border-bottom: 1px solid #eee; text-align: center; color: #555; transition: 0.2s; }
        .custom-table tbody tr:hover td { background-color: #fff0f3; cursor: pointer; }
        
        .title-link { text-align: left !important; font-weight: 600; color: #333; position: relative; }
        .comment-count { color: var(--primary-color); font-weight: 800; margin-left: 5px; font-size: 0.9rem; }

        /* 4. 버튼 및 검색창 */
        .btn-pink { 
            padding: 12px 25px; border: none; border-radius: 10px; 
            background-color: var(--primary-color); color: white; font-weight: bold; transition: 0.3s; 
        }
        .btn-pink:hover { background-color: #ff1a4a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 77, 109, 0.3); }
        .search-area select, .search-area input { padding: 10px 15px; border: 1px solid #ddd; border-radius: 8px; outline: none; }
        .badge-heart { color: var(--primary-color); font-weight: bold; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <div class="header-area">
                <div>
                    <h2>💬 커뮤니티 게시판</h2>
                    <p class="text-muted mb-0">예비 부부들과 다양한 정보를 공유해보세요.</p>
                </div>
                <button class="btn-pink" @click="fnAddPage">글쓰기</button>
            </div>  

            <div class="category-tabs">
                <div v-for="cate in categories" :key="cate" 
                     :class="['tab-item', { active: searchCategory === cate }]"
                     @click="fnChangeCategory(cate)">
                    {{ cate }}
                </div>
            </div>

            <div class="search-area" style="margin-bottom: 30px; display: flex; justify-content: flex-end; gap: 10px;">
                <select v-model="searchType">
                    <option value="all">전체</option>
                    <option value="title">제목</option>
                    <option value="userId">작성자</option>
                </select>
                <input type="text" v-model="searchKeyword" @keyup.enter="fnList" placeholder="궁금한 것을 검색해보세요">
                <button @click="fnList" class="btn-pink" style="padding: 10px 20px;">검색</button>
            </div>

            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 120px;">분류</th>
                        <th>제목</th>
                        <th style="width: 150px;">작성자</th>
                        <th style="width: 150px;">작성일</th>
                        <th style="width: 100px;">조회수</th>
                        <th style="width: 100px;">좋아요</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in list" :key="item.postNo" @click="fnDetail(item.postNo)">
                        <td>{{ item.postNo }}</td>
                        <td>
                            <span class="badge badge-info p-2" v-if="item.category">{{ item.category }}</span>
                            <span class="badge badge-secondary p-2" v-else>기타</span>
                        </td>
                        <td class="title-link">
                            {{ item.title }}
                            <span v-if="item.commentCnt > 0" class="comment-count">[{{ item.commentCnt }}]</span>
                        </td>
                        <td><span class="badge badge-light p-2">@{{ item.userId }}</span></td>
                        <td class="small text-muted">{{ item.regDate }}</td>
                        <td>{{ item.viewCnt }}</td>
                        <td class="badge-heart">❤️ {{ item.likeCnt }}</td>
                    </tr>
                    <tr v-if="list.length == 0">
                        <td colspan="7" style="padding: 100px 0; color: #999;">작성된 게시글이 아직 없습니다.</td>
                    </tr>
                </tbody>
            </table>
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
                    //  3. 카테고리 관련 데이터 추가
                    searchCategory: "전체",
                    categories: ["전체", "자유", "질문", "정보공유", ]
                };
            },
            methods: {
                fnList() {
                    const nParam = {
                        searchKeyword: this.searchKeyword,
                        searchType: this.searchType,
                        //  4. 파라미터에 카테고리 추가
                        category: this.searchCategory 
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
                        },
                        error: (xhr) => console.error("데이터 로드 실패!")
                    });
                },
                //  5. 카테고리 변경 시 리스트 다시 호출
                fnChangeCategory(cate) {
                    this.searchCategory = cate;
                    this.fnList();
                },
                fnDetail(postNo) {
                    location.href = "/api/community/detail.do?postNo=" + postNo;
                },
                fnAddPage() {
                    if (!this.sessionId || this.sessionId === "") {
                        if (confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
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