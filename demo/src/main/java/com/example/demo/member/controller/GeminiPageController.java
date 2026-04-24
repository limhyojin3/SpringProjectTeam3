package com.example.demo.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller // RestController가 아닙니다!
public class GeminiPageController {

    @GetMapping("/chat-view") // 브라우저에 칠 주소
    public String goGeminiChat() {
        return "/common/chat-bot"; // 실제 JSP 파일 이름 (확장자 제외)
    }
}