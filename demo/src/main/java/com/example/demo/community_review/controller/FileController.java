package com.example.demo.community_review.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

@RestController
public class FileController {

    @RequestMapping("/api/display.dox")
    public void displayFile(@RequestParam("fileName") String fileName, HttpServletResponse response) {
        // 실제 파일이 저장된 경로 (환경에 맞게 수정)
        String savePath = "C:/upload/"; 
        File file = new File(savePath + fileName);

        if (!file.exists()) {
            return; // 파일이 없으면 중단
        }

        // 브라우저에게 전송할 파일의 타입을 설정 (이미지라고 알려줌)
        // 파일 확장자에 따라 MIME 타입을 동적으로 설정하면 더 좋습니다.
        response.setContentType("image/jpeg"); 

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
            // 파일을 바이트 단위로 복사해서 전송
            byte[] buffer = new byte[1024];
            int readCount;
            while ((readCount = fis.read(buffer)) != -1) {
                os.write(buffer, 0, readCount);
            }
            os.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
