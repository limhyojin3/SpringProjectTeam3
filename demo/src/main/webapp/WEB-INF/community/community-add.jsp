<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 글 작성 - MerryView</title>
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

        .write-row { margin-bottom: 25px; }
        label { display: block; font-weight: 700; margin-bottom: 10px; color: #333; font-size: 16px; }
        
        select, input[type="text"] { 
            width: 100%; padding: 15px; border: 1px solid #eee; 
            border-radius: 12px; box-sizing: border-box; font-size: 15px;
            background-color: #f9f9f9; transition: all 0.3s ease;
        }
        
        /* 에디터 높이 조절 */
        #editor { height: 450px; background-color: #fff; border-radius: 0 0 12px 12px; }
        .ql-toolbar { border-radius: 12px 12px 0 0; background-color: #f9f9f9; }

        .btn-group { text-align: center; margin-top: 50px; padding-bottom: 60px; display: flex; justify-content: center; gap: 15px; }
        .btn-common { padding: 15px 50px; cursor: pointer; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; transition: 0.3s; }
        .btn-save { background-color: var(--primary-color); color: white; }
        .btn-save:hover { background-color: #ff1a4a; transform: translateY(-2px); }
        .btn-cancel { background-color: #eee; color: #666; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <div class="write-header">
                <h2>✍️ 새 글 작성</h2>
                <p class="sub-title">메리뷰 가족들에게 에디터로 멋진 글을 남겨보세요.</p>
            </div>
            
            <div class="write-row">
                <label>카테고리</label>
                <select v-model="category">
                    <option value="자유">🎈 자유게시판</option>
                    <option value="질문">❓ 질문게시판</option>
                    <option value="정보">💡 정보공유</option>
                </select>
            </div>

            <div class="write-row">
                <label>제목</label>
                <input type="text" v-model="title" placeholder="제목을 입력하세요">
            </div>

            <div class="write-row">
                <label>내용</label>
                <div id="editor"></div>
            </div>

            <div class="btn-group">
                <button class="btn-common btn-cancel" @click="fnBack">취소</button>
                <button class="btn-common btn-save" @click="fnSave">등록하기</button>
            </div>
        </main>

        <jsp:include page="/WEB-INF/common/footer.jsp" />
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    title: "",
                    category: "자유",
                    userId: "${sessionId}", // 세션 아이디 자동 할당
                    quill: null
                };
            },
            methods: {
                // 에디터 초기화
                initEditor() {
                    this.quill = new Quill('#editor', {
                        theme: 'snow',
                        modules: {
                            toolbar: [
                                [{ 'header': [1, 2, 3, false] }],
                                ['bold', 'italic', 'underline', 'strike'],
                                [{ 'color': [] }, { 'background': [] }],
                                ['blockquote', 'code-block'],
                                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                                ['link', 'image'], // 이미지 버튼 포함
                                ['clean']
                            ]
                        },
                        placeholder: '내용을 입력해주세요 (이미지 삽입 가능)'
                    });
                },
                fnSave() {
                    // 에디터의 HTML 내용 가져오기
                    const content = this.quill.root.innerHTML;

                    if(!this.title.trim()) { alert("제목을 입력해주세요."); return; }
                    // 아무것도 안써도 <p><br></p> 가 생기므로 텍스트만 체크
                    if(this.quill.getText().trim().length <= 0 && content.indexOf('<img') === -1) { 
                        alert("내용을 입력해주세요."); return; 
                    }

                    let param = {
                        title: this.title,
                        content: content, // HTML 태그가 포함된 내용
                        category: this.category,
                        userId: this.userId
                    };

                    $.ajax({
                        url: "/api/community/add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function(data) {
                            if (typeof data === "string") data = JSON.parse(data);
                            alert("글이 성공적으로 등록되었습니다."); 
                            location.href = "/api/community/list.do";
                        },
                        error: function() {
                            alert("저장 중 오류가 발생했습니다. DB 타입을 확인하세요.");
                        }
                    });
                },
                fnBack() {
                    if(confirm("작성 중인 내용은 저장되지 않습니다. 돌아가시겠습니까?")) {
                        history.back();
                    }
                }
            },
            mounted() {
                this.initEditor(); // 화면이 열리면 에디터 실행
            }
        });
        app.mount('#app');
    </script>
</body>
</html>