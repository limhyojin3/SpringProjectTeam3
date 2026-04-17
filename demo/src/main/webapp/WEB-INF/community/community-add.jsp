<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 - 글쓰기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        .container { width: 800px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; }
        .row { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        textarea { height: 300px; resize: none; }
        .btn-group { text-align: center; margin-top: 20px; }
        button { padding: 10px 25px; margin: 0 5px; cursor: pointer; border: none; border-radius: 4px; }
        .btn-save { background-color: #28a745; color: white; }
        .btn-cancel { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
    <div id="app" class="container">
        <h2>새 글 작성</h2>
        <hr>
        <div class="row">
            <label>카테고리</label>
            <select v-model="category">
                <option value="자유">자유게시판</option>
                <option value="질문">질문게시판</option>
                <option value="정보">정보공유</option>
            </select>
        </div>
        <div class="row">
            <label>제목</label>
            <input type="text" v-model="title" placeholder="제목을 입력하세요">
        </div>

        <div class="row">
            <label>내용</label>
            <textarea v-model="content" placeholder="내용을 정성껏 작성해주세요"></textarea>
        </div>

        <div class="btn-group">
            <button class="btn-save" @click="fnSave">등록</button>
            <button class="btn-cancel" @click="fnBack">취소</button>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    title: "",
                    content: "",
                    category: "자유",
                    // 세션 연동 전까지는 실제 DB에 있는 아이디 하나를 써주세요.
                    userId: "seoyeonbride" 
                };
            },
            methods: {
                // 1. 저장 로직 (Logic Flow: 입력체크 -> AJAX 요청 -> 결과처리)
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
                        url: "/api/community/add.dox", // 컨트롤러 @PostMapping 주소
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function(data) {
                            // 만약 data가 문자열로 오면 객체로 변환해줍니다.
                            if (typeof data === "string") {
                                try {
                                    data = JSON.parse(data);
                                } catch (error) {
                                    console.error("JSON 파싱 에러 : ", error);
                                }
                                
                            }
                            // 서비스에서 반환한 Message.MSG_ADD 값과 비교
                            // (보통 "등록되었습니다" 같은 문자열이 올 거예요)
                            alert(data.result); 
                            
                            // 성공 시 목록으로 이동
                            if(data.result && (data.result.includes("저장") || data.result.includes("등록") || data.result.includes("성공"))) {
                                // 주소 앞에 슬래시(/)가 빠졌는지, 혹은 context path가 필요한지 확인하세요.
                                location.href = "/api/community/list.do";
                            } else {
                                console.log("조건 불일치로 이동 안 함. data.result 값:", data.result);
                            }
                        }
                    });
                },
                // 2. 뒤로 가기
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