<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home-style2.css">

    <div id="chatbotApp">
        <div id="wrapper">
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
    <script>
        const chatbotApp = Vue.createApp({
            data() {
                return {
                    sessionId: '${sessionId}',
                    userRole: '${sessionRole}',
                    isChatOpen: false, // 처음엔 닫혀있음
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
                // 추천 질문 클릭 시 실행되는 함수
                askQuickQuestion(questionText) {
                    this.userInput = questionText; // 클릭한 텍스트를 입력창에 넣기
                    this.sendMessage();           // 바로 전송 함수 호출!
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
                    this.$nextTick(() => {
                        const container = document.getElementById("chatMessages");
                        if (chatBox) chatBox.scrollTop = chatBox.scrollHeight;
                    });
                },

            }
        });
        chatbotApp.mount('#chatbotApp');
    </script>