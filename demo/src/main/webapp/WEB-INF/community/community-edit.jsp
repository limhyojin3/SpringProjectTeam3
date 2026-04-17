<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        #app {
            width: 800px;
            margin: 50px auto;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 12px;
            background-color: #fff;
            font-family: 'Malgun Gothic', sans-serif;
        }
        h2 {
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            color: #333;
            margin-bottom: 30px;
        }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; margin-bottom: 8px; color: #555; }
        
        input[type="text"], textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
            font-size: 16px;
        }
        input[type="text"]:focus, textarea:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.2);
        }
        textarea { resize: vertical; min-height: 300px; }

        .btn-area {
            text-align: center;
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        button {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-update { background-color: #007bff; color: white; }
        .btn-update:hover { background-color: #0056b3; }
        .btn-cancel { background-color: #6c757d; color: white; }
        .btn-cancel:hover { background-color: #5a6268; }
    </style>
</head>
<body>
    <div id="app">
        <h2>게시글 수정</h2>
        
        <div class="form-group">
            <label>제목</label>
            <input type="text" v-model="post.title" placeholder="제목을 입력하세요">
        </div>

        <div class="form-group">
            <label>내용</label>
            <textarea v-model="post.content" placeholder="내용을 입력하세요"></textarea>
        </div>

        <div class="btn-area">
            <button class="btn-update" @click="fnUpdate">수정완료</button>
            <button class="btn-cancel" @click="fnBack">취소</button>
        </div>
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
                    console.log("수정 요청 데이터:", this.post); // 여기에 userId가 있는지 확인!
                    let self = this;
                    if(!confirm("이대로 수정하시겠습니까?")) return;

                    $.ajax({
                        url: "/api/community/edit.dox",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify(self.post),
                        success: function(data) {
                            if(data.result === "success") {
                                alert("수정이 완료되었습니다.");
                                location.href = "/api/community/detail.do?postNo=" + self.postNo;
                            } else {
                                alert(data.message || "수정에 실패했습니다.");
                            }
                        }
                    });
                },
                fnBack() {
                    history.back(); // 이전 페이지(상세보기)로 돌아가기
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