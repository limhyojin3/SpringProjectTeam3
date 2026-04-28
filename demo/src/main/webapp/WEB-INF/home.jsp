<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarryView</title>
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
    .tag-pink   { background-color: #f4a096; }
    .tag-purple { background-color: #9b8fd4; }
    .tag-yellow { background-color: #f0b429; }
    .tag-red    { background-color: #ff6b6b; }
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
                            <div class="review-tag tag-pink"><span>#감동</span></div>
                            <div class="review-tag tag-purple"><span>#행복</span></div>
                            <div class="review-tag tag-yellow"><span>#결혼준비</span></div>
                            <div class="review-tag tag-red"><span>#리얼후기</span></div>
                        </div>

                        <p class="section-desc">메리뷰를 선택한 소중한 신랑, 신부님들의 리얼한 후기를 확인하세요.</p>
                        <div class="review-grid">
                            <div class="review-card" v-for="review in reviewList" :key="review.reviewNo"
                                @click="fnGoReview(review.reviewNo)">
                                <div class="review-img-thumb">
                                    <img v-if="review.imgUrl && !review.imgUrl.endsWith('.zip')"
                                        :src="review.imgUrl.split(',')[0]"
                                        style="width:100%; height:100%; object-fit:cover;"
                                        @error="event => { event.target.style.display='none'; event.target.parentElement.style.backgroundColor='#ffc7c2'; }">
                                    <div v-else class="thumb-placeholder">
                                        <p>{{ review.title }}</p>
                                    </div>
                                </div>
                                <p class="review-title">{{ review.title }}</p>
                            </div>
                        </div>
                        <div class="review-more-wrap">
                            <a href="/api/review/list.do" class="more-link">더보기 ></a>
                        </div>
                    </section>

                    <section class="community-section">
                        <div class="section-header">
                            <h2>⭐커뮤니티 인기글⭐</h2>
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
                <span v-if="!isChatOpen">💬</span> 
                <span v-else>✖</span>
            </div>
            <div class="chatbot-container" v-show="isChatOpen">
                <div class="chat-header">
                    <h3>🌸 메리뷰 AI 가이드</h3>
                </div>
                <div class="chat-messages" id="chatMessages">
                    <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.type]">
                        <div class="message-content">
                            {{ msg.text }}
                        </div>
                    </div>
                    <div class="quick-questions">
                    <button v-for="q in quickQuestions" 
                            :key="q.label" 
                            @click="askQuickQuestion(q.text)" 
                            class="q-btn">
                        {{ q.label }}
                    </button>
                </div>
                </div>
                <div class="chat-input-area">
                    <input v-model="userInput" 
                           @keyup.enter="sendMessage" 
                           placeholder="궁금한 점을 입력하세요..." />
                    <button @click="sendMessage">전송</button>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        el: '#chatbot-app',
        data() {
            return {
                reviewList: [],
                postList: [],
                isChatOpen: false, 
                userInput: "",
                messages: [
                    { type: 'bot', text: '안녕하세요! 메리뷰 AI 가이드입니다. 무엇을 도와드릴까요?' }
                ],
                isLoading: false,
                // 화면에 보여줄 버튼 이름과 실제 서버로 보낼 질문 텍스트 분리
                quickQuestions: [
                    { label: '서비스 소개', text: '메리뷰는 어떤 서비스인가요?' },
                    { label: '웨딩홀 추천', text: '인기 있는 웨딩홀 추천해줘' },
                    { label: '리뷰 작성법', text: '리뷰 작성은 어떻게 하나요?' },
                    { label: '이벤트 혜택', text: '베스트 리뷰 혜택이 뭐야?' },
                    { label: '준비 순서', text: '결혼 준비 순서 알려줘' }
                ]
            };
        },
        methods: {
            // --- 기존 홈 기능 생략 ---
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
            // 1. 추천 질문 클릭 시 실행되는 함수 (오타 수정됨!)
            askQuickQuestion(questionText) {
                // 기존: this.userInput = text; -> 수정: questionText 사용
                this.userInput = questionText; 
                this.sendMessage();
            },
            // 2. 챗봇 기능 
            async sendMessage() {
                if (!this.userInput.trim() || this.isLoading) return;

                const userMsg = this.userInput;
                this.messages.push({ type: 'user', text: userMsg });
                this.userInput = '';
                this.isLoading = true; // 로딩 시작

                // 화면 하단으로 즉시 이동
                this.scrollToBottom();

                // 1. 고정 답변(Fixed Reply) 체크
                let reply = this.checkFixedReply(userMsg);

                if (reply) {
                    // 고정 답변 처리
                    setTimeout(() => {
                        this.messages.push({ type: 'bot', text: reply });
                        this.isLoading = false;
                        this.scrollToBottom();
                        this.saveToDB(userMsg, reply, 'FIXED');
                    }, 500); // 자연스러운 지연 시간
                } else {
                    // 2. AI 서버에 요청
                    try {
                        const response = await axios.post('/ask', {
                            // 복잡한 contents/parts 구조 대신, 
                            // 서버의 ChatRequest 생성자가 받기 쉬운 단순 구조로 보냅니다.
                            prompt: userMsg 
                        });
                        
                        // 서버가 응답하는 ChatResponse 구조에 맞춰 답변 추출
                        const aiAnswer = response.data.answer; 
                        this.messages.push({ type: 'bot', text: aiAnswer });
                    } catch (error) {
                        console.error("AI 요청 에러:", error);
                        this.messages.push({ type: 'bot', text: '죄송합니다. AI 연결에 실패했어요. 😢' });
                    }
                }
            },
            checkFixedReply(question) {
                // 정확한 문구 비교를 위해 trim() 사용
                const q = question.trim();
                if (q === '메리뷰는 어떤 서비스인가요?') {
                    return "🌸 메리뷰는 신랑, 신부님들의 리얼한 웨딩 후기를 공유하는 플랫폼입니다!";
                } else if (q === '인기 있는 웨딩홀 추천해줘') {
                    return "현재 가장 인기 있는 곳은 '강남 메리웨딩홀'과 '잠실 루프탑 가든'입니다! 더 자세한 리뷰를 확인해 보세요.";
                }
                else if (q === '리뷰 작성은 어떻게 하나요?') {
                    return "마이페이지 > 내가 다녀온 웨딩홀 선택 > '리뷰 쓰기' 버튼을 눌러주세요! 사진을 3장 이상 첨부하면 베스트 리뷰 확률이 높아져요. 📸";
                } 
                else if (q === '베스트 리뷰 혜택이 뭐야?') {
                    return "매달 5분을 선정하여 스타벅스 기프티콘과 메리뷰 공식 파트너사 할인권을 드리고 있습니다! 많은 참여 부탁드려요. 🎁";
                } 
                else if (q === '결혼 준비 순서 알려줘') {
                    return "일반적으로 [상견례 > 홀 투어/계약 > 스드메 예약 > 신혼여행지 선정] 순으로 진행됩니다. 메리뷰의 '준비 가이드' 게시판을 참고해 보세요! 👰🤵";
                }

                return null; // 고정 답변이 없으면 AI 서버로 전달됩니다.
            },
            async saveToDB(q, a, type) {
                try {
                    await axios.post('/saveLog', { question: q, answer: a, type: type });
                } catch(e) { console.log("DB 저장 실패"); }
            },
            // 하단 자동 스크롤
            scrollToBottom() {
                setTimeout(() => {
                    const container = document.getElementById("chatMessages");
                    container.scrollTop = container.scrollHeight;
                }, 100);
            },
            endChat() {
                // 1. 종료 메시지 표시
                this.messages.push({ text: "🌸 대화를 종료합니다. 이용해 주셔서 감사합니다!", type: 'bot' });
                this.scrollToBottom();

                // 1초 뒤에 창을 닫고, 대화 내역을 초기화해서 다음번엔 깨끗하게 보이게 함
                setTimeout(() => {
                    this.isChatOpen = false; 
                    this.messages = []; // 대화 내역 초기화 (다시 열 때 첫 인사만 나오게)
                }, 1000);
            }
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