package com.example.demo.member.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;      // 이거 고르세요!
import org.springframework.web.bind.annotation.RequestParam;    // 이거 고르세요!
import org.springframework.http.ResponseEntity;                // 이거 고르세요!
import org.springframework.web.client.HttpClientErrorException; // 예외 처리용
import lombok.RequiredArgsConstructor;
import com.example.demo.member.dao.GeminiService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/gemini")
public class GeminiController {

    private final GeminiService geminiService;

    @GetMapping("/chat")
    public ResponseEntity<?> gemini(@RequestParam String input) {  // userInput 값 받기
        try {
            // 받은 입력값을 geminiService로 전달하여 처리
            return ResponseEntity.ok().body(geminiService.getContents(input));
        } catch (HttpClientErrorException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}