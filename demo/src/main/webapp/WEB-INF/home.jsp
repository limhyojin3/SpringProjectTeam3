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
    <link rel="shortcut icon" href="/images/marryviewlogo_v2.png">
    <link rel="apple-touch-icon" href="/images/marryviewlogo_v2.png">
    <link rel="manifest" href="/manifest.json">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<style>
    /* 홈 css에 있어요. */
</style>
<body>
    <jsp:include page="/WEB-INF/common/header.jsp" />
    <div id="app" v-cloak>
        <div class="prep-modal-bg" v-if="showPrep" @click.self="showPrep = false">
            <div class="prep-modal">
                <div class="prep-icon">🛠️</div>
                <h3>이벤트 준비 중입니다!</h3>
                <p>더 좋은 혜택으로 곧 찾아올게요.<br>조금만 기다려주세요 💕</p>
                <button class="prep-modal-btn" @click="showPrep = false">확인</button>
            </div>
        </div>
        <div class="event-banner" :class="{ open: isEventOpen }">
            <div class="event-banner-body">
                <a class="event-item" href="/mypage/info" @click.prevent="showPrep = true">
                    <div class="event-img-bridal">
                        <i class="fa-solid fa-champagne-glasses"></i>
                        <span class="event-img-label">BRIDAL</span>
                    </div>
                    <span class="item-icon"><i class="fa-solid fa-ring"></i></span>결혼예정일 입력하고<br>브라이덜샤워 혜택 받기
                </a>
                <a class="event-item" href="/review/list" @click.prevent="showPrep = true">
                    <div class="event-img-baby">
                        <i class="fa-solid fa-cake-candles"></i>
                        <span class="event-img-label">EVENT</span>
                    </div>
                    <span class="item-icon"><i class="fa-solid fa-baby"></i></span>우리 아이 첫돌 사진<br>리뷰 이벤트
                </a>
                <a class="event-more" href="/event.do">이벤트 더보기 ›</a>
            </div>
            <!-- 탭 헤더를 오른쪽에 세로로 -->
            <div class="event-banner-header" @click="isEventOpen = !isEventOpen">
                <i class="fa-solid fa-gift"></i>
                <span class="tab-text">이벤트 보기</span>
            </div>
        </div>
        <div id="wrapper">
            <div class="catchphrase-section">
                <p class="catchphrase-text">
                    <i class="fa-solid fa-heart wave-icon"></i>
                    <span class="typing-text"></span>
                    <i class="fa-solid fa-heart wave-icon" id="wave-right" style="display:none;"></i>
                </p>
            </div>
            <div class="main-content">
                <div class="left-banner">
                    <div class="main-banner-img">
                        <transition name="fade">
                            <div class="slide"
                                :key="currentSlide"
                                :style="{ backgroundImage: 'url(' + slides[currentSlide].img + ')' }">
                            </div>
                        </transition>
                        <div class="banner-overlay">
                            <h2>
                                {{ slides[currentSlide].title1 }}
                                <br>
                                {{ slides[currentSlide].title2 }}
                            </h2>
                            <p>{{ slides[currentSlide].desc }}</p>
                        </div>
                        <!-- 하단 점 인디케이터 -->
                        <div class="slide-dots">
                            <span v-for="(s, i) in slides" :key="i"
                                :class="['dot', { active: i === currentSlide }]"
                                @click="currentSlide = i">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="right-sections">
                    <section class="review-section">
                        <div class="section-title-wrap">
                            <h2>
                                <i class="fa-solid fa-gem section-icon"></i>
                                이유있는 선택!
                                <i class="fa-solid fa-gem section-icon"></i>
                            </h2>
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
                               <!-- 2. 이미지 영역 (썸네일 추출 및 블러 처리 로직 통합) -->
                                <div class="card-img-box">
                                    <!-- 
                                    1) thumbnailUrl이 있으면 우선 사용
                                    2) 없으면 기존 imgUrl의 첫 번째 이미지 사용
                                    3) 둘 다 없으면 기본 로고 출력
                                    -->
                                    <img :src="review.thumbnailUrl || (review.imgUrl && !review.imgUrl.endsWith('.zip') ? review.imgUrl.split(',')[0] : '/images/marryviewlogo_v3.png')" 
                                        :class="{
                                            'default-logo': !review.thumbnailUrl && !review.imgUrl,
                                            'blur-img': review.isPaid == 1 && review.isPurchased == 0 && userRole !== 'ADMIN' && review.userId !== sessionId
                                        }"
                                        @error="(e) => e.target.src = '/images/marryviewlogo_v3.png'"
                                        alt="리뷰 썸네일">
                                </div>
                                <p class="review-title" style="margin-top: 10px; font-weight: bold;">{{ review.title }}</p>
                                <div class="review-meta">
                                    <span class="meta-nick">{{ review.userNick }}</span>
                                    <div class="meta-stats">
                                        <span><i class="fa-solid fa-heart like-icon"></i> {{ review.likeCnt }}</span>
                                        <span><i class="fa-regular fa-eye"></i> {{ review.viewCnt }}</span>
                                    </div>
                                </div>    
                            </div>
                        </div>
                        <div class="review-more-wrap">
                            <a href="/api/review/list.do" class="more-link">더보기 ></a>
                        </div>
                    </section>
                    <section class="community-section">
                        <div class="section-header">
                            <h2>
                                <i class="fa-solid fa-crown section-icon"></i>
                                커뮤니티 인기글
                                <i class="fa-solid fa-crown section-icon"></i>
                            </h2>
                        </div>
                        <div class="post-grid">
                            <div class="post-card" v-for="post in postList" :key="post.postNo"
                                @click="fnGoPost(post.postNo)">
                                <p class="post-text">{{ post.title }}</p>
                                <div class="post-info">
                                    <span><i class="fa-solid fa-heart like-icon"></i> {{ post.likeCnt }}</span>
                                    <span><i class="fa-regular fa-eye"></i> {{ post.viewCnt }}</span>
                                </div>
                            </div>
                        </div>
                        <div class="community-more-wrap">
                            <a href="/api/community/list.do" class="more-link">더보기 ></a>
                        </div>
                    </section>
                </div>
            </div>
            <div class="chat-btn" @click="isChatOpen = !isChatOpen">
                <i v-if="!isChatOpen" class="fa-solid fa-comment-dots"></i>
                <i v-else class="fa-solid fa-xmark"></i>
            </div>
            <div class="chatbot-container" v-show="isChatOpen">
                <div class="chat-header">
                    <h3>
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        메리뷰 AI 가이드
                    </h3>
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
                    userRole: '${sessionRole}',
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
                    ],
                    isEventOpen: false,
                    showPrep : false,
                    slides: [
                        {
                            img: '/img/left-banner2.jpg',
                            title1: '당신의 특별한 날,',
                            title2: '메리하게',
                            desc: '소중한 웨딩, 진짜 후기로 현명하게 선택하세요'
                        },
                        {
                            img: '/img/left-banner3.jpg',
                            title1: '설레는 브라이덜 샤워,',
                            title2 : '메리하게',
                            desc: '특별한 순간을 더 특별하게'
                        },
                        {
                            img: '/img/left-banner.jpg',
                            title1: '그날의 감동을 다시,',
                            title2: '리마인드 웨딩',
                            desc: '소중한 추억을 다시 한번 메리하게'
                        },
                    ],
                    currentSlide: 0,
                    slideInterval: null
                };
            },
            methods: {
                fnGoReview: function(review) { 
                    // 1. 로그인 체크 - 유료 리뷰일 때만 로그인 필요
                    if (review.isPaid == 1 && (!this.sessionId || this.sessionId === '' || this.sessionId === 'null')) {
                        alert("로그인이 필요한 서비스입니다.");
                        location.href = "/login.do";
                        return;
                    }

                    // 2. 무료 리뷰이거나 내가 쓴 글이거나 이미 구매했거나 관리자인 경우: 즉시 이동
                    if (review.isPaid != 1  || review.userId === this.sessionId || review.isPurchased == 1 || this.userRole === 'ADMIN') {
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
                },
                startSlide() {
                    this.slideInterval = setInterval(() => {
                        this.currentSlide = (this.currentSlide + 1) % this.slides.length;
                    }, 4000);
                },
            },
            mounted() {
                // 초기 데이터 로딩
                axios.get("/mainReviewList.dox").then(res => { this.reviewList = res.data; });
                axios.get("/mainPostList.dox").then(res => { this.postList = res.data; });

                this.startSlide();
            }
        });
        app.mount('#app');
        document.addEventListener('DOMContentLoaded', function() {
            const text = 'Marry해서 Merry하게 · 메리뷰와 함께하세요';
            const target = document.querySelector('.typing-text');
            const waveRight = document.getElementById('wave-right');
            let i = 0;

            function type() {
                if (i < text.length) {
                    target.innerHTML = text.slice(0, i + 1)
                        .replace('Marry', '<span class="brand-point">Marry</span>')
                        .replace('Merry', '<span class="brand-point">Merry</span>');
                    i++;
                    setTimeout(type, 80);
                } else {
                    target.style.borderRight = 'none';
                    if (waveRight) waveRight.style.display = 'inline-block';
                    document.querySelector('.catchphrase-section').classList.add('done');
                    setTimeout(() => {
                        i = 0;
                        target.style.borderRight = '2px solid #ff4a6b';
                        if (waveRight) waveRight.style.display = 'none';
                        document.querySelector('.catchphrase-section').classList.remove('done');
                        type();
                    }, 3000);
                }
            }
            type();  // ← 이 줄 추가!
        });
    </script>
</body>
</html>