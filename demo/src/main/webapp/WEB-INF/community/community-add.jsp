<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 글 작성 - MerryView</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <style>
        :root { --primary-color: #ff4d6d; --dark-color: #1a1a1a; }

        /* 1. 메인 컨텐츠 영역 */
        .main-content {
            padding: 50px 40px;
            max-width: 900px; /* 글쓰기는 너무 넓으면 보기 힘드니 폭 조절 */
            margin: 0 auto;
            min-height: 800px;
        }

        h2 { font-size: 32px; color: var(--dark-color); margin-bottom: 10px; font-weight: 800; letter-spacing: -1px; }
        .sub-title { color: #888; margin-bottom: 40px; }

        /* 2. 입력 폼 디자인 */
        .write-row { margin-bottom: 25px; }
        label { display: block; font-weight: 700; margin-bottom: 10px; color: #333; font-size: 16px; }
        
        select, input[type="text"], textarea { 
            width: 100%; padding: 15px; border: 1px solid #eee; 
            border-radius: 12px; box-sizing: border-box; font-size: 15px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }
        
        /* 마우스 올리거나 클릭했을 때 핑크색 포인트 */
        select:focus, input[type="text"]:focus, textarea:focus {
            outline: none;
            background-color: #fff;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 77, 109, 0.1);
        }
        
        select { width: 220px; cursor: pointer; }
        textarea { height: 400px; resize: none; line-height: 1.8; }

        /* 3. 버튼 그룹 */
        .btn-group { text-align: center; margin-top: 50px; padding-bottom: 60px; display: flex; justify-content: center; gap: 15px; }
        
        .btn-common { padding: 15px 50px; cursor: pointer; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; transition: 0.3s; }
        
        .btn-save { background-color: var(--primary-color); color: white; }
        .btn-save:hover { background-color: #ff1a4a; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 77, 109, 0.3); }
        
        .btn-cancel { background-color: #eee; color: #666; }
        .btn-cancel:hover { background-color: #ddd; }
    </style>
</head>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <main class="main-content">
            <div class="write-header">
                <h2>✍️ 새 글 작성</h2>
                <p class="sub-title">메리뷰 가족들에게 전하고 싶은 이야기를 적어주세요.</p>
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
                <textarea v-model="content" placeholder="따뜻한 소통을 위해 비방이나 욕설은 자제해주세요."></textarea>
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
                    content: "",
                    category: "자유",
                    userId: "seoyeonbride" // 나중에 세션에서 가져오도록 수정 필요
                };
            },
            methods: {
                fnSave: function() {
                    if(!this.title.trim()) { alert("제목을 입력해주세요."); return; }
                    if(!this.content.trim()) { alert("내용을 입력해주세요."); return; }

                    let self = this;
                    let param = {
                        title: self.title,
                        content: self.content,
                        category: self.category,
                        userId: self.userId
                    };

                    $.ajax({
                        url: "/api/community/add.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function(data) {
                            if (typeof data === "string") data = JSON.parse(data);
                            // 결과 메시지 출력 후 이동
                            alert(data.result || "등록되었습니다."); 
                            location.href = "/api/community/list.do";
                        },
                        error: function() {
                            alert("저장 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnBack: function() {
                    if(confirm("작성 중인 내용은 저장되지 않습니다. 돌아가시겠습니까?")) {
                        history.back();
                    }
                }
            }
        });
        app.mount('#app');
    </script>
</body>
</html>