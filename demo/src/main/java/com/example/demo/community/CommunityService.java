package com.example.demo.community;

import com.example.demo.common.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommunityService {

    @Autowired
    private CommunityMapper communityMapper;

    // 게시글 등록
    public String writePost(Community post) {
        try {
            int result = communityMapper.insertPost(post);
            return (result > 0) ? Message.MSG_ADD : Message.MSG_ERR;
        } catch (Exception e) {
            e.printStackTrace();
            return Message.MSG_SERVER_ERR;
        }
    }
}