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