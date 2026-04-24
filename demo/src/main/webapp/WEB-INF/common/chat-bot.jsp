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
        /* 선생님께서 주신 스타일 유지 */
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .chat-container { width: 350px; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); display: flex; flex-direction: column; }
        .chat-header { background: #007bff; color: white; padding: 15px; text-align: center; font-weight: bold; }
        .chat-box { height: 400px; overflow-y: auto; padding: 15px; display: flex; flex-direction: column; }
        .message { max-width: 70%; padding: 10px; border-radius: 10px; margin-bottom: 10px; font-size: 14px; line-height: 1.4; word-break: break-all; }
        .user { align-self: flex-end; background: #007bff; color: white; }
        .bot { align-self: flex-start; background: #e9ecef; color: #333; }
        .chat-input { display: flex; padding: 10px; border-top: 1px solid #ccc; background: white; }
        .chat-input textarea { flex: 1; height: 40px; border: none; resize: none; padding: 10px; border-radius: 5px; outline: none; }
        .chat-input button { margin-left: 10px; padding: 10px 15px; background: #007bff; color: white; border: none; cursor: pointer; border-radius: 5px; }
        /* 로딩 중 버튼 스타일 추가 */
        .chat-input button:disabled { background: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>
    <div id="app" class="chat-container">
        <div class="chat-header">Gemini AI 챗봇</div>
        <div class="chat-box" ref="chatBox">
            <div class="message bot" v-if="messages.length === 0">안녕하세요! 무엇을 도와드릴까요?</div>
            
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
                userInput: "",
                messages: [],
                isLoading: false // 로딩 상태 추가
            };
        },
        methods: {
            sendMessage() {
                // 입력값이 없거나 이미 로딩 중이면 중단
                if (this.userInput.trim() === "" || this.isLoading) return;
                
                // 1. 유저 메시지 화면에 추가
                this.messages.push({ text: this.userInput, type: 'user' });
                
                let inputText = this.userInput;
                this.userInput = ""; // 입력창 비우기
                this.isLoading = true; // 로딩 시작
                this.scrollToBottom();
                
                // 2. 선생님 스타일의 jQuery AJAX 호출
                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: { input: inputText },
                    success: (response) => {
                        // 봇 메시지 추가
                        this.messages.push({ text: response, type: 'bot' });
                    },
                    error: (xhr) => {
                        this.messages.push({ 
                            text: "오류가 발생했습니다. (사유: " + (xhr.responseText || "서버 연결 실패") + ")", 
                            type: 'bot' 
                        });
                    },
                    complete: () => {
                        this.isLoading = false; // 성공하든 실패하든 로딩 종료
                        this.scrollToBottom();
                    }
                });
            },
            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    if (chatBox) {
                        chatBox.scrollTop = chatBox.scrollHeight;
                    }
                });
            }
        }
    });
    app.mount('#app');
</script>
</html>