<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home-style.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<style>
    .review-card, .post-card {
    cursor: pointer;
}
</style>
<body>
    <div id="app">
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="wrapper">
            <div class="main-content">
                <div class="left-banner">
                    <div class="main-banner-img">
                        <span class="img-placeholder"></span>
                        <div class="banner-overlay">
                            <h2>당신의 특별한 날,<br>메리뷰와 함께</h2>
                            <p>솔직한 웨딩 리뷰로<br>현명한 선택을 하세요</p>
                        </div>
                    </div>
                </div>
                <div class="right-sections">
                    <section class="review-section">
                        <div class="section-title-wrap">
                                <h2>이유있는 선택!</h2>
                        </div>

                        <div class="hash-tag-wrap">
                            <span>#감동</span> <span>#행복</span> <span>#결혼준비</span>
                            <div class="review-tag">
                                <span>리얼후기</span>
                            </div>
                        </div>

                        <p class="section-desc">메리뷰를 선택한 소중한 신랑, 신부님들의 리얼한 후기를 확인하세요.</p>
                        <div class="review-grid">
                            <div class="review-card" v-for="review in reviewList" :key="review.reviewNo"
                                @click="fnGoReview(review.reviewNo)">
                                <div class="review-img-thumb">
                                    <img v-if="review.imgUrl" 
                                        :src="review.imgUrl" 
                                        @error="handleImgError">
                                    <div v-else class="thumb-placeholder">
                                        <span>🌸</span>
                                        <p>{{ review.title }}</p>
                                    </div>
                                </div>
                                <p class="review-title">{{ review.title }}</p>
                            </div>
                        </div>
                    </section>

                    <section class="community-section">
                        <div class="section-header">
                            <h2>커뮤니티 인기글</h2>
                            <a href="/api/community/list.do" class="more-link">더보기 ></a>
                        </div>

                        <div class="post-grid">
                            <div class="post-card" v-for="post in postList" :key="post.postNo"
                                @click="fnGoPost(post.postNo)">
                                <p class="post-text">{{ post.title }}</p>
                                <div class="post-info">
                                    <span><i class="icon-thumb">👍</i> {{ post.likeCnt }}</span>
                                    <span class="post-views">조회 {{ post.viewCnt }}</span>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
            <div class="chat-btn" @click="isChatOpen = !isChatOpen">
                <span v-if="!isChatOpen">💬</span> <span v-else>✖</span>
            </div>
            <div class="chat-container" v-show="isChatOpen" style="display: none;">
                <div class="chat-header">메리뷰 AI 가이드</div>
                <div class="chat-box" ref="chatBox">
                    <div class="message bot">
                        안녕하세요! 메리뷰 AI 가이드입니다. <br>
                        아래 버튼을 눌러보시거나 궁금한 점을 입력해주세요!
                        
                        <div class="quick-questions">
                            <div @click="askQuickQuestion('메리뷰는 어떤 서비스인가요?')" class="q-btn">서비스 소개</div>
                            <div @click="askQuickQuestion('인기 있는 웨딩홀 추천해줘')" class="q-btn">웨딩홀 추천</div>
                            <div @click="askQuickQuestion('리뷰 작성은 어떻게 하나요?')" class="q-btn">리뷰 작성법</div>
                        </div>
                    </div>
                </div>
                <div class="chat-input">
                    <textarea v-model="userInput" @keydown.enter.prevent="sendMessage" placeholder="질문을 입력하세요..."></textarea>
                    <button @click="sendMessage" :disabled="isLoading">전송</button>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                reviewList: [],
                postList: [],
                isChatOpen: false, 
                userInput: "",
                messages: [],
                isLoading: false
            };
        },
        methods: {
            // --- 기존 홈 기능 ---
            fnGoPost: function(postNo) {
                location.href = '/api/community/detail.do?postNo=' + postNo;
            },
            fnGoReview: function(reviewNo) {
                location.href = '/api/review/detail.do?reviewNo=' + reviewNo;
            },
            handleImgError: function(event) {
                // 이미지가 없으면 해당 이미지만 숨깁니다.
                if (event.target) {
                    event.target.style.display = 'none';
                    
                    // 부모 요소가 있을 때만 배경색을 바꿉니다.
                    const parent = event.target.parentElement;
                    if (parent) {
                        parent.style.backgroundColor = '#ffc7c2';
                    }
                }
            },
            // 1. 추천 질문 클릭 시 실행되는 함수
            askQuickQuestion(questionText) {
                /// 1. 사용자 질문을 화면에 표시
                this.messages.push({ text: questionText, type: 'user' });
                this.scrollToBottom();

                // 2. 질문 내용에 따라 고정 답변 매칭
                let fixedReply = "";

                if (questionText === '메리뷰는 어떤 서비스인가요?') {
                    fixedReply = "🌸 메리뷰는 신랑, 신부님들의 리얼한 웨딩 후기를 공유하고, 투명한 웨딩 문화를 만들어가는 커뮤니티 플랫폼입니다!";
                } 
                else if (questionText === '인기 있는 웨딩홀 추천해줘') {
                    fixedReply = "🏰 현재 우리 사이트에서 가장 조회수가 높은 곳은 '루클라비'와 '빌라드지디'입니다. 리뷰 게시판에서 더 자세한 후기를 확인해보세요!";
                } 
                else if (questionText === '리뷰 작성은 어떻게 하나요?') {
                    fixedReply = "✍️ 로그인 후 '리얼후기' 게시판 하단의 글쓰기 버튼을 눌러 작성하실 수 있습니다. 사진을 첨부하면 베스트 리뷰 확률이 높아져요!";
                }

                // 3. 고정 답변이 있다면 서버에 묻지 않고 바로 출력
                if (fixedReply !== "") {
                    this.isLoading = true;
                    setTimeout(() => { // 실제 대화하는 느낌을 주기 위해 0.5초 뒤에 출력
                        this.messages.push({ text: fixedReply, type: 'bot' });
                        this.isLoading = false;
                        this.scrollToBottom();
                    }, 500);
                } 
                else {
                    // 4. 고정 답변이 없는 일반 질문만 서버(AI)로 전송
                    this.userInput = questionText;
                    this.sendMessage();
                }
            },
            // 2. 챗봇 기능 
            sendMessage() {
                if (this.userInput.trim() === "" || this.isLoading) return;
                
                // 사용자 메시지 화면에 추가
                this.messages.push({ text: this.userInput, type: 'user' });
                let inputText = this.userInput;
                this.userInput = ""; // 입력창 비우기
                this.isLoading = true;
                this.scrollToBottom();
                
                // Spring 컨트롤러와 통신
                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: { input: inputText },
                    success: (response) => {
                        // 서버에서 온 답변을 채팅창에 추가
                        this.messages.push({ text: response, type: 'bot' });
                    },
                    error: (xhr) => {
                        this.messages.push({ text: "잠시 후 다시 시도해주세요", type: 'bot' });
                    },
                    complete: () => {
                        this.isLoading = false;
                        this.scrollToBottom();
                    }
                });
            },
            // 하단 자동 스크롤
            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    if (chatBox) {
                        chatBox.scrollTop = chatBox.scrollHeight;
                    }
                });
            },
            

        },
        mounted() {
            let self = this;
            axios.get("/mainReviewList.dox")
                .then(res => { self.reviewList = res.data; });
            axios.get("/mainPostList.dox")
                .then(res => { self.postList = res.data; });
        }
    });

    app.mount('#app');
</script>