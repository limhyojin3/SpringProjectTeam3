package com.example.demo.member.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.RequiredArgsConstructor;
// import com.company.member.service.GeminiService; // 서비스 만든 후 주석 해제

@RestController
@RequestMapping("/chat") // 기존 MemberController와 겹치지 않게!
@RequiredArgsConstructor
public class ChatController {
    // private final GeminiService geminiService; 
}