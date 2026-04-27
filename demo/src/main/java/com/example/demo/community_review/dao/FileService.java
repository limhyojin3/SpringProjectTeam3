package com.example.demo.community_review.dao;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.common.Message;

@Service
public class FileService {

    public Map<String, String> uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        String projectPath = System.getProperty("user.dir");
        String uploadPath = projectPath + "/src/main/resources/static/uploads/";

        File folder = new File(uploadPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        // 1. 원본 파일명 가져오기
        String originalName = file.getOriginalFilename();
        
        // 2. 저장용 파일명 생성 (UUID 대신 원본명 활용)
        // System.currentTimeMillis()를 붙이면 이름 식별도 쉽고 중복 저장도 방지됩니다.
        // 만약 이것조차 싫고 "순수 원본명"만 쓰고 싶다면 storedName = originalName; 으로 바꾸세요.
        String storedName = System.currentTimeMillis() + "_" + originalName;

        try {
            // 3. 파일 물리적 복사
            Path destination = new File(uploadPath + storedName).toPath();
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);

            // 4. 정보 구성
            Map<String, String> fileMap = new HashMap<>();
            fileMap.put("originalName", originalName);
            fileMap.put("storedName", storedName); // 이제 DB와 폴더에 "시간_원본명.jpg"로 들어갑니다.
            fileMap.put("imgUrl", "/uploads/" + storedName); 
            
            return fileMap;

        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(Message.MSG_SERVER_ERR);
        }
    }
}