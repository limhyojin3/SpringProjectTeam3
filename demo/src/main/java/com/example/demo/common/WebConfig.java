package com.example.demo.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir}")
    private String uploadDir;
    
    @Value("${file.resource-path}")
    private String resourcePath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /// /uploads/** 로 들어오는 요청을 C:/uploads/project/ 폴더로 연결
        registry.addResourceHandler(resourcePath)
        .addResourceLocations("file:///" + uploadDir);
    }
}
