<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - MarryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    
    <!-- Quill Editor -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

    <style>
        :root { 
            --primary-color: #ff4d6d; 
            --secondary-color: #ff85a1;
            --bg-soft: #fffafa;
            --dark-text: #2d2d2d;
        }

        body { 
            background-color: var(--bg-soft);
            font-family: 'Pretendard', -apple-system, sans-serif;
        }

        .main-content { padding: 60px 20px; max-width: 940px; margin: 0 auto; min-height: 100vh; }
        
        /* 헤더 섹션 */
        .edit-header { text-align: center; margin-bottom: 40px; }
        .edit-header h2 { font-size: 34px; font-weight: 800; color: var(--dark-text); margin-bottom: 12px; }
        .edit-header .sub-title { color: #999; font-size: 16px; }

        /* 수정 카드 레이아웃 */
        .edit-card { 
            background: #fff; padding: 45px; border-radius: 24px; 
            box-shadow: 0 10px 40px rgba(255, 77, 109, 0.08);
            border: 1px solid rgba(255, 77, 109, 0.1);
        }

        .edit-row { margin-bottom: 30px; }
        label { display: block; font-weight: 700; margin-bottom: 12px; color: #444; font-size: 16px; }
        
        /* 카테고리 칩 UI (수정 가능하게 구성) */
        .category-group { display: flex; gap: 12px; }
        .cate-item {
            padding: 10px 24px; border-radius: 50px; border: 2px solid #f0f0f0;
            background: #fff; cursor: pointer; font-weight: 600; color: #aaa; transition: 0.3s;
        }
        .cate-item.active { 
            background: var(--primary-color); border-color: var(--primary-color); color: #fff;
            box-shadow: 0 4px 12px rgba(255, 77, 109, 0.2);
        }

        /* 입력창 디자인 */
        .input-title { 
            width: 100%; padding: 18px 20px; border: 2px solid #f4f4f4; 
            border-radius: 16px; font-size: 17px; transition: all 0.3s;
            background-color: #fafafa; outline: none;
        }
        .input-title:focus {
            border-color: var(--primary-color); background-color: #fff;
        }

        /* 에디터 스타일 */
        #editor { height: 480px; border: 2px solid #f4f4f4 !important; border-top: none !important; border-radius: 0 0 16px 16px; }
        .ql-toolbar { border: 2px solid #f4f4f4 !important; border-radius: 16px 16px 0 0; background-color: #fafafa; }

        /* 하단 버튼 */
        .btn-group { margin-top: 40px; display: flex; justify-content: center; gap: 15px; padding-bottom: 60px; }
        .btn-common { padding: 18px 65px; cursor: pointer; border: none; border-radius: 16px; font-size: 17px; font-weight: 700; transition: 0.3s; }
        .btn-update { background-color: var(--primary-color); color: white; }
        .btn-update:hover { background-color: #ff1a4a; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(255, 77, 109, 0.25); }
        .btn-cancel { background-color: #eee; color: #777; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    
    <div id="app">
        <main class="main-content">
            <div class="edit-header">
                <h2>📝 게시글 수정</h2>
                <p class="sub-title">내용을 다듬어서 더 멋진 글로 완성해보세요.</p>
            </div>
            
            <div class="edit-card">
                <!-- 카테고리 선택 -->
                <div class="edit-row">
                    <label>카테고리</label>
                    <div class="category-group">
                        <div v-for="item in categoryList" 
                             :key="item.value"
                             class="cate-item" 
                             :class="{ active: post.category === item.value }"
                             @click="post.category = item.value">
                            {{ item.label }}
                        </div>
                    </div>
                </div>

                <!-- 제목 입력 -->
                <div class="edit-row">
                    <label>제목</label>
                    <input type="text" class="input-title" v-model="post.title" placeholder="제목을 입력해 주세요">
                </div>

                <!-- 내용 입력 (에디터) -->
                <div class="edit-row">
                    <label>내용</label>
                    <div id="editor"></div>
                </div>
            </div>

            <!-- 하단 버튼 영역 -->
            <div class="btn-group">
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
                    post: {
                        title: "",
                        category: "",
                        content: ""
                    },
                    categoryList: [
                        { label: "🎈 자유게시판", value: "자유" },
                        { label: "❓ 질문게시판", value: "질문" },
                        { label: "💡 정보공유", value: "정보" }
                    ],
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
                    const content = this.quill.root.innerHTML;

                    if(!this.post.title.trim()) { alert("제목을 입력해 주세요! ✨"); return; }
                    if(this.quill.getText().trim().length <= 0 && content.indexOf('<img') === -1) { 
                        alert("내용을 입력해 주세요! ✨"); return; 
                    }
                    
                    if(!confirm("이대로 수정하시겠습니까?")) return;

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
                                alert("수정이 완료되었습니다! ✨");
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
                this.initEditor();
                this.fnGetDetail();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>