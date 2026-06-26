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

    @Value("${cloudinary.cloud-name}")
    private String cloudName;

    @Value("${cloudinary.api-key}")
    private String apiKey;

    @Value("${cloudinary.api-secret}")
    private String apiSecret;

    private Cloudinary cloudinary;

    @PostConstruct
    public void init() {
        // secure 옵션을 true로 주고, 설정을 명확히 잡습니다.
        this.cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", cloudName,
            "api_key", apiKey,
            "api_secret", apiSecret,
            "secure", true 
        ));
    }

    public Map<String, String> uploadFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            // 에러 핵심 해결: 타임스탬프를 서버의 현재 시간으로 직접 생성해서 파라미터로 넘깁니다.
            // 이렇게 하면 Cloudinary 서버와의 시간 오차로 인한 Signature 에러를 줄일 수 있습니다.
            Map<String, Object> params = ObjectUtils.asMap(
                "timestamp", System.currentTimeMillis() / 1000L,
                "resource_type", "auto"
            );

            // 파일 업로드 실행
            Map uploadResult = cloudinary.uploader().upload(file.getBytes(), params);

            // 결과 데이터 추출
            String imgUrl = (String) uploadResult.get("secure_url"); 
            String publicId = (String) uploadResult.get("public_id"); 
            String originalName = file.getOriginalFilename();

            Map<String, String> fileMap = new HashMap<>();
            fileMap.put("originalName", originalName);
            fileMap.put("storedName", publicId); 
            fileMap.put("imgUrl", imgUrl); 
            
            return fileMap;

        } catch (Exception e) { // IOException 외의 에러도 잡기 위해 Exception으로 확대
            System.err.println("Cloudinary 업로드 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
            // 에러 발생 시 null을 리턴하거나 예외를 던져서 컨트롤러에서 알 수 있게 합니다.
            throw new RuntimeException("파일 업로드 실패: " + e.getMessage());
        } 
    }
}