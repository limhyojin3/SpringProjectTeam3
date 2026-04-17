<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        .container { width: 800px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
        .post-header { border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 20px; }
        .content { min-height: 300px; padding: 20px; background: #f9f9f9; border-radius: 5px; line-height: 1.6; }
        .btn-area { margin-top: 30px; text-align: center; }
        button { padding: 10px 20px; cursor: pointer; margin: 0 5px; border-radius: 5px; border: 1px solid #ddd; background-color: #fff; transition: 0.2s; }
        button:hover { background-color: #f0f0f0; }
        .btn-edit { background-color: #ffc107; border-color: #ffb100; }
        .btn-delete { background-color: #dc3545; color: white; border-color: #c82333; }
        .login-msg { color: #d9534f; font-size: 0.85em; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div id="app" class="container">
        <template v-if="post">
            <div class="post-header">
                <h2>{{ post.title }}</h2>
                <div style="color: #666; font-size: 0.9em;">
                    작성자: <strong>{{ post.userId }}</strong> | 작성일: {{ post.regDate }} |
                    좋아요: {{ post.likeCnt }} | 조회수: {{ post.viewCnt }} 
                </div>
            </div>

            <div class="content">
                {{ post.content }}
            </div>

            <div class="btn-area">
                <p v-if="!sessionId" class="login-msg">※ 좋아요 및 수정/삭제는 로그인 후 이용 가능합니다.</p>
                
                <button @click="fnLike">❤️ 좋아요</button>
                <button @click="fnGoList">목록으로</button>
                
                <template v-if="post && post.userId === sessionId">
                    <button class="btn-edit" @click="fnEdit">수정</button>
                    <button class="btn-delete" @click="fnRemove">삭제</button>
                </template>
            </div>
        </template>
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
                fnGetDetail: function() {
                    let self = this;
                    $.ajax({
                        url: "/api/community/getPost.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : self.postNo }),
                        success: function(data) {
                            self.post = data.post;
                            self.sessionId = data.sessionId; 

                            // 두 값을 콘솔에서 직접 대조해보세요.
                            console.log("작성자:", self.post.userId);
                            console.log("세션ID:", self.sessionId);
                            console.log("일치여부:", self.post.userId === self.sessionId);
                            
                            // [추가] 만약 게시글이 없거나 잘못된 접근일 때 처리
                            if(!self.post) {
                                alert("존재하지 않는 게시글입니다.");
                                self.fnGoList();
                            }
                        }
                    });
                },
                fnLike: function() {
                    let self = this;
                    // [방어 코드] 로그인 체크
                    if(!self.sessionId) {
                        if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "/login.do"; // 실제 로그인 페이지 경로로 수정하세요
                        }
                        return;
                    }
                    
                    $.ajax({
                        url: "/api/community/toggleLike.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : self.postNo, userId : self.sessionId }),
                        success: function(data) {
                            if(data.status == 1) alert("좋아요 완료!");
                            else alert("좋아요 취소!");
                            self.fnGetDetail();
                        }
                    });
                },
                fnGoList: function() {
                    location.href = "/api/community/list.do";
                },
                fnRemove: function() {
                    // [방어 코드] 혹시나 버튼이 보였더라도 한 번 더 체크
                    if(!this.sessionId || this.post.userId !== this.sessionId) {
                        alert("본인 글만 삭제할 수 있습니다.");
                        return;
                    }

                    if(!confirm("정말 삭제하시겠습니까?")) return;
                    
                    let self = this;
                    $.ajax({
                        url: "/api/community/remove.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo : self.postNo }),
                        success: function(data) {
                            alert("삭제되었습니다.");
                            self.fnGoList();
                        }
                    });
                },
                fnEdit: function() {
                    if(!this.sessionId || this.post.userId !== this.sessionId) {
                        alert("본인 글만 수정할 수 있습니다.");
                        return;
                    }
                    location.href = "/api/community/edit.do?postNo=" + this.postNo; 
                }
            },
            mounted() {
                this.fnGetDetail();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>