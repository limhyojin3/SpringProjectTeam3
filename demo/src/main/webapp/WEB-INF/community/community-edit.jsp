<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }

        /* 1. 메인 컨텐츠 영역 */
        .main-content {
            padding: 50px 40px;
            max-width: 900px;
            margin: 0 auto;
            min-height: 800px;
        }

        h2 { font-size: 32px; color: var(--dark-color); margin-bottom: 10px; font-weight: 800; letter-spacing: -1px; }
        .sub-title { color: #888; margin-bottom: 40px; }

        /* 2. 입력 폼 디자인 */
        .form-group { margin-bottom: 25px; }
        label { display: block; font-weight: 700; margin-bottom: 10px; color: #333; font-size: 16px; }
        
        input[type="text"], textarea { 
            width: 100%; padding: 15px; border: 1px solid #eee; 
            border-radius: 12px; box-sizing: border-box; font-size: 15px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        input[type="text"]:focus, textarea:focus {
            outline: none;
            background-color: #fff;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 77, 109, 0.1);
        }
        
        textarea { height: 450px; resize: none; line-height: 1.8; }

        /* 3. 버튼 그룹 */
        .btn-area { text-align: center; margin-top: 50px; padding-bottom: 60px; display: flex; justify-content: center; gap: 15px; }
        
        .btn-common { padding: 15px 50px; cursor: pointer; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; transition: 0.3s; }
        
        .btn-update { background-color: var(--primary-color); color: white; }
        .btn-update:hover { background-color: #ff1a4a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 77, 109, 0.3); }
        
        .btn-cancel { background-color: #eee; color: #666; }
        .btn-cancel:hover { background-color: #ddd; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <div class="edit-header">
                <h2>📝 게시글 수정</h2>
                <p class="sub-title">내용을 수정하고 '수정완료' 버튼을 눌러주세요.</p>
            </div>
            
            <div class="form-group">
                <label>제목</label>
                <input type="text" v-model="post.title" placeholder="제목을 입력하세요">
            </div>

            <div class="form-group">
                <label>내용</label>
                <textarea v-model="post.content" placeholder="수정할 내용을 입력해주세요"></textarea>
            </div>

            <div class="btn-area">
                <button class="btn-common btn-cancel" @click="fnBack">취소</button>
                <button class="btn-common btn-update" @click="fnUpdate">수정완료</button>
            </div>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    postNo: "${postNo}",
                    post: {}
                };
            },
            methods: {
                fnGetDetail() {
                    let self = this;
                    $.ajax({
                        url: "/api/community/getPost.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({ postNo: self.postNo }),
                        success: function(data) {
                            self.post = data.post;
                        }
                    });
                },
                fnUpdate() {
                    let self = this;
                    if(!self.post.title || self.post.title.trim() === "") {
                        alert("제목을 입력해주세요."); return;
                    }
                    if(!self.post.content || self.post.content.trim() === "") {
                        alert("내용을 입력해주세요."); return;
                    }
                    if(!confirm("이대로 수정하시겠습니까?")) return;

                    $.ajax({
                        url: "/api/community/edit.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(self.post),
                        success: function(data) {
                            if(data.result === "success") {
                                alert("수정이 완료되었습니다. ✨");
                                location.href = "/api/community/detail.do?postNo=" + self.postNo;
                            } else {
                                alert(data.message || "수정에 실패했습니다.");
                            }
                        }
                    });
                },
                fnBack() {
                    if(confirm("수정 중인 내용은 저장되지 않습니다. 돌아가시겠습니까?")) {
                        history.back();
                    }
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