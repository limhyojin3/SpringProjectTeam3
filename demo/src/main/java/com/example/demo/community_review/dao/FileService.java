package com.example.demo.community_review.dao;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;

@Service
public class FileService {

    @Value("${file.upload-dir}")
    private String uploadPath;

    /**
     * 파일 업로드 프로세스
     * 1. 폴더 생성 -> 2. 파일명 변환(UUID) -> 3. 로컬 저장
     */
    public String uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // 1. 저장할 폴더가 없으면 생성
        File folder = new File(uploadPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        // 2. 파일명 중복 방지 (UUID + 원본파일명)
        String originalName = file.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String saveName = uuid + "_" + originalName;

        try {
            // 3. 물리적 저장
            File target = new File(uploadPath + saveName);
            file.transferTo(target);
            
            return saveName; // 저장된 파일명 반환 (DB 저장용)

        } catch (IOException e) {
            e.printStackTrace();
            // 팀 공통 에러 메시지 활용
            throw new RuntimeException(Message.MSG_SERVER_ERR);
        }
    }
}