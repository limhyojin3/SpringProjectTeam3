package com.example.demo.community_review.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.community_review.dao.LikeService;
import com.example.demo.community_review.model.Like;

@RestController
@RequestMapping("/api/like")
public class LikeController {

    @Autowired
    private LikeService likeService;

    @PostMapping("/toggle") 
    // 이제 JSON 데이터를 통째로 객체에 매핑합니다.
    public boolean toggleLike(@RequestBody Like likeDto) {
    	// 1. 서비스가 요구하는 HashMap 주머니를 만듭니다.
        HashMap<String, Object> map = new HashMap<>();

        // 2. DTO의 알맹이를 맵에 옮겨 담습니다. 
        // MyBatis XML에서 사용하는 변수명(#{userId}, #{postNo} 등)과 똑같이 맞춰야 합니다.
        map.put("userId", likeDto.getUserId());
        map.put("type", likeDto.getType());
        
        // 3. 타입에 따라 targetId를 적절한 키값으로 매핑합니다.
        if ("COMMUNITY".equals(likeDto.getType())) {
            map.put("postNo", likeDto.getTargetId());
        } else if ("REVIEW".equals(likeDto.getType())) {
            map.put("targetId", likeDto.getTargetId());
        }

        // 4. 이제 null 대신 정성껏 준비한 map을 전달합니다.
        return likeService.toggleLike(map, likeDto);
    }
}