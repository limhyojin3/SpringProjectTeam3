<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }
        .main-content { padding: 50px 40px; max-width: 900px; margin: 0 auto; min-height: 800px; }
        h2 { font-size: 32px; color: var(--dark-color); margin-bottom: 10px; font-weight: 800; }
        .sub-title { color: #888; margin-bottom: 40px; }

        .form-group { margin-bottom: 25px; }
        label { display: block; font-weight: 700; margin-bottom: 10px; color: #333; font-size: 16px; }
        
        input[type="text"] { 
            width: 100%; padding: 15px; border: 1px solid #eee; 
            border-radius: 12px; box-sizing: border-box; font-size: 15px;
            background-color: #f9f9f9; transition: all 0.3s ease;
        }
        
        input[type="text"]:focus {
            outline: none; background-color: #fff; border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 77, 109, 0.1);
        }
        
        /* 에디터 스타일 커스텀 */
        #editor { height: 450px; background-color: #fff; border-radius: 0 0 12px 12px; }
        .ql-toolbar { border-radius: 12px 12px 0 0; background-color: #f9f9f9; border-color: #eee !important; }
        .ql-container { border-color: #eee !important; }

        .btn-area { text-align: center; margin-top: 50px; padding-bottom: 60px; display: flex; justify-content: center; gap: 15px; }
        .btn-common { padding: 15px 50px; cursor: pointer; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; transition: 0.3s; }
        .btn-update { background-color: var(--primary-color); color: white; }
        .btn-update:hover { background-color: #ff1a4a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 77, 109, 0.3); }
        .btn-cancel { background-color: #eee; color: #666; }
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
                <div id="editor"></div>
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
                    post: {},
                    quill: null
                };
            },
            methods: {
                // 1. 에디터 초기화
                initEditor() {
                    this.quill = new Quill('#editor', {
                        theme: 'snow',
                        modules: {
                            toolbar: [
                                [{ 'header': [1, 2, 3, false] }],
                                ['bold', 'italic', 'underline', 'strike'],
                                [{ 'color': [] }, { 'background': [] }],
                                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                                ['link', 'image'],
                                ['clean']
                            ]
                        },
                        placeholder: '수정할 내용을 입력해주세요'
                    });
                },
                // 2. 기존 데이터 불러오기
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
                            // 에디터에 기존 HTML 내용 주입
                            if(self.post.content) {
                                self.quill.root.innerHTML = self.post.content;
                            }
                        }
                    });
                },
                // 3. 수정 처리
                fnUpdate() {
                    const content = this.quill.root.innerHTML; // 에디터 내용 가져오기

                    if(!this.post.title || this.post.title.trim() === "") {
                        alert("제목을 입력해주세요."); return;
                    }
                    // 텍스트가 없고 이미지도 없는 경우 체크
                    if(this.quill.getText().trim().length <= 0 && content.indexOf('<img') === -1) { 
                        alert("내용을 입력해주세요."); return; 
                    }
                    
                    if(!confirm("이대로 수정하시겠습니까?")) return;

                    // 업데이트할 데이터 세팅
                    let param = {
                        ...this.post,
                        content: content
                    };

                    $.ajax({
                        url: "/api/community/edit.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function(data) {
                            if(data.result === "success") {
                                alert("수정이 완료되었습니다. ✨");
                                location.href = "/api/community/detail.do?postNo=" + param.postNo;
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
                this.initEditor(); // 에디터 먼저 만들고
                this.fnGetDetail(); // 데이터 불러와서 채우기
            }
        });
        app.mount('#app');
    </script>
</body>
</html>