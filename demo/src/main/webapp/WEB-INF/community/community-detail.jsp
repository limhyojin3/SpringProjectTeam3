<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 - MerryView</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }

        /* 1. 메인 컨텐츠 영역 */
        .main-content {
            padding: 50px 40px;
            max-width: 1000px;
            margin: 0 auto;
            min-height: 800px;
        }

        /* 2. 게시글 헤더 스타일 */
        .post-header { 
            border-bottom: 2px solid var(--dark-color); 
            padding-bottom: 30px; 
            margin-bottom: 30px; 
        }
        .category-tag { 
            display: inline-block; padding: 5px 12px; background: #fff0f3; 
            color: var(--primary-color); border-radius: 20px; font-weight: 800; font-size: 0.85rem; margin-bottom: 15px;
        }
        .post-title { font-size: 36px; color: var(--dark-color); font-weight: 800; margin-bottom: 20px; letter-spacing: -1px; }
        
        .post-info { display: flex; align-items: center; gap: 15px; color: #888; font-size: 15px; }
        .post-info strong { color: #333; }
        .divider { color: #eee; }

        /* 3. 게시글 본문 */
        .post-content { 
            padding: 50px 10px; line-height: 2; min-height: 450px; 
            font-size: 18px; color: #333; 
            white-space: pre-wrap;
        }

        /* 4. 하단 버튼 영역 */
        .bottom-area { 
            border-top: 1px solid #eee; padding-top: 40px; margin-top: 40px;
            display: flex; justify-content: space-between; align-items: center;
        }
        
        .login-msg { color: var(--primary-color); font-size: 14px; font-weight: 600; background: #fff0f3; padding: 10px 20px; border-radius: 10px; }
        
        button { padding: 13px 30px; cursor: pointer; border: none; border-radius: 12px; font-size: 15px; transition: 0.3s; font-weight: 700; }
        
        /* 좋아요 버튼 전용 스타일 */
        .btn-like { 
            background-color: #fff; color: var(--primary-color); border: 2px solid var(--primary-color); 
            display: flex; align-items: center; gap: 8px;
        }
        .btn-like:hover { background-color: #fff0f3; }
        
        .btn-list { background-color: #f5f5f5; color: #666; margin-right: 10px; }
        .btn-list:hover { background-color: #eee; }
        
        .btn-edit { background-color: var(--dark-color); color: white; margin-right: 10px; }
        .btn-edit:hover { background-color: #333; }
        
        .btn-delete { background-color: #ffb3c1; color: #fff; }
        .btn-delete:hover { background-color: #ff4d6d; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <template v-if="post">
                <div class="post-header">
                    <span class="category-tag"># {{ post.category || '전체' }}</span>
                    <h2 class="post-title">{{ post.title }}</h2>
                    <div class="post-info">
                        <span>작성자 <strong>@{{ post.userId }}</strong></span>
                        <span class="divider">|</span>
                        <span>{{ post.regDate }}</span>
                        <span class="divider">|</span>
                        <span>조회 {{ post.viewCnt }}</span>
                        <span class="divider">|</span>
                        <span>좋아요 {{ post.likeCnt }}</span>
                    </div>
                </div>

                <div class="post-content">{{ post.content }}</div>

                <div class="text-center mb-4" v-if="!sessionId">
                    <span class="login-msg">💡 로그인을 하시면 좋아요와 댓글 작성이 가능합니다!</span>
                </div>

                <div class="bottom-area">
                    <div class="left-btns">
                        <button class="btn-like" @click="fnLike">
                            <span v-if="post.isLiked">❤️</span>
                            <span v-else>🤍</span> 
                            좋아요 {{ post.likeCnt }}
                        </button>
                    </div>
                    
                    <div class="right-btns">
                        <button class="btn-list" @click="fnGoList">목록으로</button>
                        
                        <template v-if="post && post.userId === sessionId">
                            <button class="btn-edit" @click="fnEdit">수정하기</button>
                            <button class="btn-delete" @click="fnRemove">삭제</button>
                        </template>
                    </div>
                </div>
            </template>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    postNo: "${postNo}", 
                    post: null,
                    sessionId: "" 
                };
            },
            methods: {
                fnGetDetail() {
                    $.ajax({
                        url: "/api/community/getPost.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: (data) => {
                            this.post = data.post;
                            this.sessionId = data.sessionId; 
                            if(!this.post) {
                                alert("존재하지 않는 게시글입니다.");
                                this.fnGoList();
                            }
                        }
                    });
                },
                fnLike() {
                    if(!this.sessionId) {
                        if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "/login.do";
                        }
                        return;
                    }
                    $.ajax({
                        url: "/api/community/toggleLike.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo, userId : this.sessionId }),
                        success: (data) => {
                            // 단순 토스트나 알림 대신 데이터를 다시 불러와서 숫자를 갱신
                            this.fnGetDetail();
                        }
                    });
                },
                fnGoList() { location.href = "/api/community/list.do"; },
                fnRemove() {
                    if(!confirm("정말 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/community/remove.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: () => {
                            alert("삭제되었습니다.");
                            this.fnGoList();
                        }
                    });
                },
                fnEdit() {
                    location.href = "/api/community/edit.do?postNo=" + this.postNo; 
                }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>