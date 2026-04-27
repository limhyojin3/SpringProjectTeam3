package com.example.demo.common;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.RequiredArgsConstructor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override 
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 외부 저장소 설정: /uploads/** 로 들어오는 요청을 실제 C:/uploads/project/ 폴더로 매핑
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:///C:/uploads/project/");
        
//        // 2. 프로젝트 내부 저장소 설정 (필요 없다면 삭제해도 무방하지만 일단 유지했습니다)
//        String projectPath = System.getProperty("user.dir");
//        registry.addResourceHandler("/img2/**")
//                .addResourceLocations("file:///" + projectPath + "/src/main/resources/static/uploads/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1)
                .addPathPatterns(
                        "/userMyPage*.do",
                        "/company10.do",
                        "/admin*.do",
                        "/add.do"
                ) 
                .excludePathPatterns(
                        "/merryViewHome.do",
                        "/login.do",
                        "/join*.do",
                        "/find-*.do",
                        "/css/**", "/js/**", "/img/**", "/images/**",
                        "/uploads/**" // [중요] 사진 폴더는 로그인 체크에서 제외해야 사진이 뜹니다!
                );
    }

    @RequiredArgsConstructor
    public class GeminiRestTemplateConfig {
        @Bean
        @Qualifier("geminiRestTemplate")
        public RestTemplate geminiRestTemplate() {
            RestTemplate restTemplate = new RestTemplate();
            restTemplate.getInterceptors().add((request, body, execution) -> execution.execute(request, body));
            return restTemplate;
        }
    }
}