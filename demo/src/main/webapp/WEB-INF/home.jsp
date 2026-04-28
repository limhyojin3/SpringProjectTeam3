<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메리뷰 - 리얼 웨딩 후기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home-style.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="/js/page-change.js"></script>
</head>
<style>
    .review-card, .post-card { cursor: pointer; position: relative; }
    .tag-pink   { background-color: #f4a096; }
    .tag-purple { background-color: #9b8fd4; }
    .tag-yellow { background-color: #f0b429; }
    .tag-red    { background-color: #ff6b6b; }

    /* 프리미엄 배지 스타일 */
    .premium-badge {
        position: absolute;
        top: 0;
        left: 0;
        background: linear-gradient(45deg, #f0b429, #f7d07a);
        color: #fff;
        padding: 4px 10px;
        font-size: 0.7rem;
        font-weight: bold;
        border-bottom-right-radius: 10px;
        z-index: 10;
        display: flex;
        align-items: center;
    }
    .premium-badge i { margin-right: 4px; }

    /* 유료 리뷰 이미지 블러 처리 (미구매 시) */
    .blur-img {
        filter: blur(8px) brightness(0.8);
        transition: 0.3s;
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
                            <div class="review-tag tag-pink"><span>#감동</span></div>
                            <div class="review-tag tag-purple"><span>#행복</span></div>
                            <div class="review-tag tag-yellow"><span>#결혼준비</span></div>
                            <div class="review-tag tag-red"><span>#리얼후기</span></div>
                        </div>

                        <p class="section-desc">메리뷰를 선택한 소중한 신랑, 신부님들의 리얼한 후기를 확인하세요.</p>

                        
                        
                        <div class="review-grid">
                            <div class="review-card" v-for="review in reviewList" :key="review.reviewNo"
                                @click="fnGoReview(review)">
                                
                                
                                <div v-if="review.isPaid == 1" class="premium-badge">
                                    <i class="fas fa-crown"></i> Premium
                                </div>

                                <div class="review-img-thumb" style="overflow:hidden; height: 200px; background: #eee;">
                                    <img v-if="review.imgUrl && !review.imgUrl.endsWith('.zip')"
                                        :src="review.imgUrl.split(',')[0]"
                                        :class="{'blur-img': review.isPaid == 1 && review.userId !== sessionId}"
                                        style="width:100%; height:100%; object-fit:cover;"
                                        @error="handleImgError">
                                    <div v-else class="thumb-placeholder" style="height:100%; display:flex; flex-direction:column; justify-content:center; align-items:center;">
                                        <span style="font-size: 2rem;">🌸</span>
                                        <p style="font-size: 0.8rem; color: #888; margin-top: 5px;">{{ review.title }}</p>
                                    </div>
                                </div>
                                <p class="review-title" style="margin-top: 10px; font-weight: bold;">{{ review.title }}</p>
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
                        <div class="message-content">{{ msg.text }}</div>
                    </div>
                    <div class="quick-questions">
                        <button v-for="q in quickQuestions" :key="q.label" @click="askQuickQuestion(q.text)" class="q-btn">
                            {{ q.label }}
                        </button>
                    </div>
                </div>
                <div class="chat-input-area">
                    <input v-model="userInput" @keyup.enter="sendMessage" placeholder="궁금한 점을 입력하세요..." />
                    <button @click="sendMessage">전송</button>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/common/footer.jsp" />

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    sessionId: '${sessionId}', 
                    reviewList: [],
                    postList: [],
                    isChatOpen: false, 
                    userInput: "",
                    messages: [{ type: 'bot', text: '안녕하세요! 메리뷰 AI 가이드입니다. 무엇을 도와드릴까요?' }],
                    isLoading: false,
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
                fnGoReview: function(review) { 
                    // 1. 로그인 체크 (세션값이 비어있는지 확인)
                    if (!this.sessionId || this.sessionId === '' || this.sessionId === 'null') {
                        alert("로그인이 필요한 서비스입니다.");
                        location.href = "/login.do";
                        return;
                    }

                    // 2. 무료 리뷰이거나 내가 쓴 글인 경우: 즉시 이동
                    if (review.isPaid != 1  || review.userId === this.sessionId) {
                        location.href = '/api/review/detail.do?reviewNo=' + review.reviewNo; 
                        return;
                    }

                    // 3. 유료 리뷰인 경우: 티켓 사용 로직 실행
                    if (confirm("이 리뷰는 유료 콘텐츠입니다. \n열람권을 1회 차감하여 확인하시겠습니까?")) {
                        axios.post('/api/review/useTicket.dox', {
                            reviewNo: review.reviewNo
                        })
                        .then(res => {
                            // ReviewService의 리턴값과 대소문자까지 정확히 매칭함
                            const result = res.data.result;
                            
                            if (result === "SUCCESS" || result === "ALREADY_VIEWED") {
                                location.href = '/api/review/detail.do?reviewNo=' + review.reviewNo;
                            } else if (result === "NO_TICKET") {
                                alert("남은 열람권이 없습니다. 이용권을 구매해주세요! 🌸");
                                // location.href = "/api/pass/buy.do"; 
                            } else {
                                alert("서버 처리 중 알 수 없는 응답이 왔습니다: " + result);
                            }
                        })
                        .catch(err => {
                            console.error("통신 에러:", err);
                            alert("서버와 통신 중 오류가 발생했습니다.");
                        });
                    }
                },
                fnGoPost: function(postNo) { 
                    location.href = '/api/community/detail.do?postNo=' + postNo; 
                },
                handleImgError: function(event) {
                    event.target.style.display = 'none';
                    const parent = event.target.parentElement;
                    if (parent) parent.style.backgroundColor = '#fce4ec';
                },
                askQuickQuestion(questionText) {
                    this.userInput = questionText; 
                    this.sendMessage();
                },
                async sendMessage() {
                    if (!this.userInput.trim() || this.isLoading) return;
                    const userMsg = this.userInput;
                    this.messages.push({ type: 'user', text: userMsg });
                    this.userInput = '';
                    this.isLoading = true;
                    this.scrollToBottom();

                    let reply = this.checkFixedReply(userMsg);
                    if (reply) {
                        setTimeout(() => {
                            this.messages.push({ type: 'bot', text: reply });
                            this.isLoading = false;
                            this.scrollToBottom();
                        }, 500);
                    } else {
                        try {
                            const response = await axios.post('/ask', { prompt: userMsg });
                            this.messages.push({ type: 'bot', text: response.data.answer });
                        } catch (error) {
                            this.messages.push({ type: 'bot', text: '죄송합니다. AI 연결에 실패했어요. 😢' });
                        } finally {
                            this.isLoading = false;
                            this.scrollToBottom();
                        }
                    }
                },
                checkFixedReply(question) {
                    const q = question.trim();
                    const replies = {
                        '메리뷰는 어떤 서비스인가요?': "🌸 메리뷰는 신랑, 신부님들의 리얼한 웨딩 후기를 공유하는 플랫폼입니다!",
                        '인기 있는 웨딩홀 추천해줘': "현재 가장 인기 있는 곳은 '강남 메리웨딩홀'과 '잠실 루프탑 가든'입니다!",
                        '리뷰 작성은 어떻게 하나요?': "마이페이지 > '리뷰 쓰기' 버튼을 눌러주세요! 사진 3장 이상 첨부 시 혜택이 커집니다.",
                        '베스트 리뷰 혜택이 뭐야?': "매달 5분을 선정하여 스타벅스 기프티콘과 파트너사 할인권을 드립니다!",
                        '결혼 준비 순서 알려줘': "상견례 > 홀 투어 > 스드메 예약 > 신혼여행 순을 추천드려요! 👰🤵"
                    };
                    return replies[q] || null;
                },
                scrollToBottom() {
                    setTimeout(() => {
                        const container = document.getElementById("chatMessages");
                        if(container) container.scrollTop = container.scrollHeight;
                    }, 100);
                }
            },
            mounted() {
                // 초기 데이터 로딩
                axios.get("/mainReviewList.dox").then(res => { this.reviewList = res.data; });
                axios.get("/mainPostList.dox").then(res => { this.postList = res.data; });
            }
        });
        app.mount('#app');
    </script>
</body>
</html>