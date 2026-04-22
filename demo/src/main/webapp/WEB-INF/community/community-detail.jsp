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
        .main-content { padding: 50px 40px; max-width: 1000px; margin: 0 auto; min-height: 800px; }
        .post-header { border-bottom: 2px solid var(--dark-color); padding-bottom: 30px; margin-bottom: 30px; }
        .category-tag { display: inline-block; padding: 5px 15px; background: #fff0f3; color: var(--primary-color); border-radius: 20px; font-weight: 800; font-size: 0.9rem; margin-bottom: 15px; }
        .post-title { font-size: 36px; color: var(--dark-color); font-weight: 800; margin-bottom: 20px; letter-spacing: -1px; }
        .post-info { display: flex; align-items: center; gap: 15px; color: #888; font-size: 15px; }
        .post-content { padding: 50px 10px; line-height: 2; min-height: 300px; font-size: 18px; color: #333; white-space: pre-wrap; }
        .bottom-area { border-top: 1px solid #eee; padding-top: 40px; margin-top: 40px; display: flex; justify-content: space-between; align-items: center; }
        button { padding: 10px 25px; cursor: pointer; border: none; border-radius: 12px; font-size: 15px; transition: 0.3s; font-weight: 700; }
        .btn-like { background-color: #fff; color: var(--primary-color); border: 2px solid var(--primary-color); display: flex; align-items: center; gap: 8px; }
        .btn-list { background-color: #f5f5f5; color: #666; }
        .btn-edit { background-color: var(--dark-color); color: white; margin-right: 5px; }
        .btn-delete { background-color: #ffb3c1; color: #fff; }
        .comment-section { border-top: 1px solid #eee; padding-top: 50px; margin-top: 50px; }
        .comment-item { padding: 20px 0; border-bottom: 1px solid #f1f1f1; }
        .is-reply { margin-left: 50px; background-color: #fcfcfc; padding: 20px; border-radius: 15px; border-bottom: none; margin-top: 5px; }
        .comment-header { font-size: 14px; margin-bottom: 10px; }
        .comment-body { font-size: 16px; color: #444; }
        .comment-like-btn { cursor: pointer; display: inline-flex; align-items: center; gap: 8px; color: #888; font-size: 14px; }
        .text-danger { color: var(--primary-color) !important; }
        .action-link { font-size: 13px; cursor: pointer; color: #aaa; margin-left: 15px; }
        .comment-write-box textarea { border-radius: 15px; padding: 15px; border: 1px solid #ddd; resize: none; }
        .btn-primary-sm { background: var(--primary-color); color: white; padding: 8px 20px; border-radius: 10px; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <template v-if="post && post.postNo">
                <div class="post-header">
                    <span class="category-tag"># {{ post.category || '일반' }}</span>
                    <h2 class="post-title">{{ post.title }}</h2>
                    <div class="post-info">
                        <span>작성자 <strong>@{{ post.userId }}</strong></span>
                        <span>|</span>
                        <span>{{ post.regDate }}</span>
                        <span>|</span>
                        <span>조회 {{ post.viewCnt }}</span>
                    </div>
                </div>

                <div class="post-content">{{ post.content }}</div>

                <div class="bottom-area">
                    <button class="btn-like" @click="fnPostLike">
                        <template v-if="post && post.isLiked > 0">
                            <span style="color: #ff4d6d;">❤️</span>
                        </template>
                        <template v-else>
                            <span>🤍</span>
                        </template>
                        좋아요 {{ post.likeCnt || 0 }}
                    </button>
                    <div class="right-btns">
                        <button class="btn-list" @click="fnGoList">목록으로</button>
                        <template v-if="post.userId === sessionId">
                            <button class="btn-edit" @click="fnEdit">수정</button>
                            <button class="btn-delete" @click="fnRemove">삭제</button>
                        </template>
                    </div>
                </div>

                <div class="comment-section">
                    <h5 class="mb-4">댓글 <b>{{ commentList.length }}</b></h5>
                    
                    <div class="comment-write-box mb-4" v-if="sessionId">
                        <textarea v-model="newComment" class="form-control" placeholder="댓글을 입력해주세요." rows="3"></textarea>
                        <div class="text-right mt-2">
                            <button class="btn-primary-sm" @click="fnAddComment(null)">등록</button>
                        </div>
                    </div>

                    <div class="comment-list">
                        <div v-for="item in commentList" :key="item.commentNo" :class="['comment-item', { 'is-reply': item.parentNo }]">
                            <div class="comment-header d-flex justify-content-between">
                                <b>@{{ item.userId }}</b>
                                <span class="text-muted small">{{ item.regDate }}</span>
                            </div>
                            <div class="comment-body">{{ item.content }}</div>
                            <div class="comment-footer mt-2">
                                <span class="comment-like-btn" @click="fnCommentLike(item)">
                                    <i :class="item.isLiked > 0 ? 'fas fa-heart text-danger' : 'far fa-heart'"></i>
                                    <small>{{ item.likeCnt }}</small>
                                </span>
                                <span class="action-link" v-if="!item.parentNo && sessionId" @click="item.showReply = !item.showReply">답글</span>
                                <span class="action-link" v-if="item.userId === sessionId" @click="fnRemoveComment(item.commentNo)">삭제</span>
                            </div>

                            <div class="mt-3" v-if="item.showReply">
                                <textarea v-model="item.replyContent" class="form-control" rows="2" placeholder="답글 작성..."></textarea>
                                <div class="text-right mt-2">
                                    <button class="btn btn-sm btn-dark" @click="fnAddComment(item)">답글 등록</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
            <div v-else class="text-center py-5">
                <p class="text-muted">게시글을 불러오고 있습니다...</p>
            </div>
        </main>
        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    postNo: "${postNo}", 
                    post: {}, // 빈 객체로 초기화
                    sessionId: "" ,
                    commentList: [],
                    newComment: ""
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
                        success: (res) => {
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            if(data.post) {
                                //  중요: Vue 3의 반응성을 위해 객체 자체를 새로 할당합니다.
                                this.post = data.post;
                                this.sessionId = data.sessionId;
                                
                                // 디버깅용: 콘솔에 이게 1로 나오는지 꼭 보세요!
                                console.log("서버에서 온 좋아요 여부(isLiked):", this.post.isLiked);
                                
                                this.fnGetComments();
                            }
                        }
                    });
                },
                fnGetComments() {
                    $.ajax({
                        url: "/api/comment/Comm-list.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ 
                            postNo: this.postNo, 
                            userId: this.sessionId 
                        }),
                        success: (res) => {
                            const data = JSON.parse(res);
                            this.commentList = data.list.map(c => ({...c, showReply: false, replyContent: ""}));
                        }
                    });
                },
                fnAddComment(parentItem) {
                    const content = parentItem ? parentItem.replyContent : this.newComment;
                    if(!content) return alert("내용을 입력하세요.");
                    $.ajax({
                        url: "/api/comment/Comm-add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({
                            postNo: this.postNo,
                            userId: this.sessionId,
                            content: content,
                            parentNo: parentItem ? parentItem.commentNo : null
                        }),
                        success: (res) => {
                            this.newComment = "";
                            this.fnGetComments();
                        }
                    });
                },
                fnCommentLike(item) {
                    $.ajax({
                        url: "/api/comment/like.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ commentNo: item.commentNo, userId: this.sessionId }),
                        success: (res) => { if(res.result === "success") this.fnGetComments(); }
                    });
                },
                fnRemoveComment(commentNo) {
                    if(!confirm("삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/api/comment/remove.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ commentNo: commentNo }),
                        success: () => { this.fnGetComments(); }
                    });
                },
                fnPostLike() {
                    if(!this.sessionId) {
                        alert("로그인이 필요합니다.");
                        return;
                    }
                    $.ajax({
                        url: "/api/community/toggleLike.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : this.postNo }),
                        success: (res) => {
                            const data = (typeof res === "string") ? JSON.parse(res) : res;
                            if(data.result === "success") {
                                //  좋아요 누른 후 다시 상세 정보를 불러와서 화면을 갱신합니다.
                                this.fnGetDetail();
                            }
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