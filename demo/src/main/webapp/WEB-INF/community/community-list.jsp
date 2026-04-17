<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* (기존 스타일 유지) */
        #app { width: 1000px; margin: 50px auto; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: white; }
        .title-link { text-align: left; cursor: pointer; color: #007bff; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .title-link:hover { text-decoration: underline; color: #0056b3; }
        th, td { border: 1px solid #eee; padding: 12px; text-align: center; }
        th { background-color: #f8f9fa; font-weight: bold; }
        .header-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div id="app">
        <div class="header-area">
            <h2>커뮤니티 게시판</h2>
            <button @click="fnAddPage" style="padding: 10px 20px; cursor: pointer;">글쓰기</button>
        </div>  

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th> <th>좋아요</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="item in list" :key="item.postNo">
                    <td>{{ item.postNo }}</td>
                    <td class="title-link" @click="fnDetail(item.postNo)">
                        {{ item.title }}
                    </td>
                    <td>{{ item.userId }}</td>
                    <td>{{ item.regDate }}</td>
                    <td>{{ item.viewCnt }}</td> <td>❤️ {{ item.likeCnt }}</td>
                </tr>
                <tr v-if="list.length == 0">
                    <td colspan="6">게시글이 없습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    list: [],
                    sessionId: "" // 현재 로그인된 사용자 아이디 저장용
                };
            },
            methods: {
                fnList: function () {
                    let self = this;
                    $.ajax({
                        url: "/api/community/list.dox",
                        dataType: "json",
                        type: "POST", 
                        data: {},
                        success: function (data) {
                            self.list = data.list; 
                            // 🚩 [체크] 컨트롤러가 보내준 sessionId를 받아야 방어가 작동함!
                            self.sessionId = data.sessionId; 
                        },
                        error: function(xhr) {
                            console.error("데이터 로드 실패!");
                        }
                    });
                },
                fnDetail: function(postNo) {
                    location.href = "/api/community/detail.do?postNo=" + postNo;
                },
                // 🚩 [수정] 글쓰기 버튼 방어 로직 추가
                fnAddPage: function() {
                    let self = this;
                    
                    // sessionId가 없으면 비회원 취급
                    if (!self.sessionId || self.sessionId === "") {
                        if (confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "/login.do"; // 본인의 로그인 페이지 경로로 수정
                        }
                    } else {
                        // 로그인 상태일 때만 글쓰기 이동
                        location.href = "/api/community/add.do";
                    }
                }
            },
            mounted() {
                this.fnList();
            }
        });
        app.mount('#app');
    </script>
</body>
</html>