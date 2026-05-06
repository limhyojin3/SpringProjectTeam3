<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <title>Gemini AI 챗봇</title>
    <style>
    </style>
</head>
<body>
    <div id="app" class="chat-container">
        <div class="chat-header">Gemini AI 챗봇</div>
        <div class="chat-box" ref="chatBox"> 
            <div class="message bot" v-if="messages.length === 0">
            안녕하세요! 메리뷰 AI 가이드입니다. <br>
            아래 버튼을 눌러보시거나 궁금한 점을 입력해주세요!
                <div class="quick-questions">
                    <div @click="askQuickQuestion('메리뷰는 어떤 서비스인가요?')" class="q-btn">서비스 소개</div>
                    <div @click="askQuickQuestion('인기 있는 웨딩홀 추천해줘')" class="q-btn">웨딩홀 추천</div>
                    <div @click="askQuickQuestion('리뷰 작성은 어떻게 하나요?')" class="q-btn">리뷰 작성법</div>
                </div>
            </div>
            </div>
            <div v-for="msg in messages" :class="['message', msg.type]">
                {{ msg.text }}
            </div>
        </div>
        <div class="chat-input">
            <textarea 
                v-model="userInput" 
                @keydown.enter.prevent="sendMessage"
                placeholder="메시지를 입력하세요..."
                :disabled="isLoading"
            ></textarea>
            <button @click="sendMessage" :disabled="isLoading || !userInput.trim()">
                {{ isLoading ? '...' : '전송' }}
            </button>
        </div>
    </div>
</body>
<script>
    const app = Vue.createApp({
        data() {
            return {
                isChatOpen: false, // 처음엔 닫혀있음
                userInput: "",
                messages: [],
                isLoading: false
            };
        },
        methods: {
            sendMessage() {
            if (this.userInput.trim() === "" || this.isLoading) return;
            
            this.messages.push({ text: this.userInput, type: 'user' });
            let inputText = this.userInput;
            this.userInput = "";
            this.isLoading = true;
            this.scrollToBottom();
            
            $.ajax({
                url: "/gemini/chat",
                type: "GET",
                data: { input: inputText },
                success: (response) => {
                    this.messages.push({ text: response, type: 'bot' });
                },
                error: (xhr) => {
                    this.messages.push({ text: "잠시 후 다시 시도해주세요.", type: 'bot' });
                },
                complete: () => {
                    this.isLoading = false;
                    this.scrollToBottom();
                }
            });
            },
            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    if(chatBox) chatBox.scrollTop = chatBox.scrollHeight;
                });
            },
            // 추천 질문 클릭 시 실행되는 함수
            askQuickQuestion(questionText) {
                this.userInput = questionText; // 클릭한 텍스트를 입력창에 넣기
                this.sendMessage();           // 바로 전송 함수 호출!
            },
        }
    });
    app.mount('#app');
</script>
</html>