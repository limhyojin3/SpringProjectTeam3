package com.example.demo.community;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/community")
public class CommunityController {

    @Autowired
    private CommunityService communityService;

    // 게시글 쓰기
    @PostMapping("/write")
    public String write(@RequestBody Community post) {
        // JSON 형태로 데이터를 받을 때는 @RequestBody를 사용합니다.
        return communityService.writePost(post);
    }
}