package com.example.demo.community_review.dao;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
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
     * 고도화된 파일 업로드 프로세스
     * 반환값: originalName, storedName, imgUrl 정보를 담은 Map
     */
    public Map<String, String> uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // 1. 폴더 생성 (C:/uploads/project/)
        File folder = new File(uploadPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        // 2. 파일명 생성 (원본명, 저장용명)
        String originalName = file.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String extension = originalName.substring(originalName.lastIndexOf("."));
        String storedName = uuid + extension; // 저장용 이름

        try {
        	// [수정 포인트] transferTo 대신 InputStream을 직접 복사합니다.
            Path destination = new File(uploadPath + storedName).toPath();
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);

            // 4. DB에 저장할 3종 세트 구성 (중요!)
            Map<String, String> fileMap = new HashMap<>();
            fileMap.put("originalName", originalName);
            fileMap.put("storedName", storedName);
            // application.properties의 가상경로와 맞춰서 생성
            fileMap.put("imgUrl", "/uploads/" + storedName); 
            
            return fileMap;

        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(Message.MSG_SERVER_ERR);
        }
    }
}