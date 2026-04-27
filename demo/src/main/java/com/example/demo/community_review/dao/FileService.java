package com.example.demo.community_review.dao;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.demo.common.Message;

import jakarta.annotation.PostConstruct;

@Service
public class FileService {

    // 1. properties 파일에서 설정값 읽어오기
    @Value("${cloudinary.cloud-name}")
    private String cloudName;

    @Value("${cloudinary.api-key}")
    private String apiKey;

    @Value("${cloudinary.api-secret}")
    private String apiSecret;

    private Cloudinary cloudinary;

    // 2. 빈(Bean)이 생성된 후 설정값들을 가지고 Cloudinary 객체 초기화
    @PostConstruct
    public void init() {
        this.cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", cloudName,
            "api_key", apiKey,
            "api_secret", apiSecret
        ));
    }

    /**
     * Cloudinary 클라우드 서버에 파일을 업로드하고 접속 가능한 URL을 반환합니다.
     */
    public Map<String, String> uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            // Cloudinary에 파일 업로드 실행
            Map uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());

            // 업로드 완료 후 정보 가져오기
            String imgUrl = (String) uploadResult.get("secure_url"); // 클라우드 보안 주소
            String publicId = (String) uploadResult.get("public_id"); // 클라우드 내 고유 ID
            String originalName = file.getOriginalFilename();

            // 컨트롤러 및 DB 저장용 정보 구성
            Map<String, String> fileMap = new HashMap<>();
            fileMap.put("originalName", originalName);
            fileMap.put("storedName", publicId); 
            fileMap.put("imgUrl", imgUrl); 
            
            return fileMap;

        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(Message.MSG_SERVER_ERR);
        }
    }
}