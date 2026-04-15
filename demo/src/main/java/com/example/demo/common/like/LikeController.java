package com.example.demo.common.like;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/like")
public class LikeController {

    @Autowired
    private LikeService likeService;

    @PostMapping("/toggle")
    // 이제 JSON 데이터를 통째로 객체에 매핑합니다.
    public boolean toggleLike(@RequestBody LikeDTO likeDto) {
        return likeService.toggleLike(likeDto);
    }
}