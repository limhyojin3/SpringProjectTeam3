package com.example.demo.common;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.RequiredArgsConstructor;

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
        
        //컴퍼니 담당자가 붙임
        // /img2/** 요청이 오면 사용자의 문서 폴더로 연결한다.
        String projectPath = System.getProperty("user.dir");
        
        registry.addResourceHandler("/img2/**")
        .addResourceLocations("file:///" + projectPath + "/src/main/resources/static/uploads/");
        
    }
   
    // 로그인 세션 체크용 HandlerInterceptor
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1) // 인터셉터 실행 순서
                // [로그인 검사할 대상] 로그인이 꼭 필요한 주소들 (ex)마이페이지, 관리자, 업체 페이지 등
                .addPathPatterns(
                		"/userMyPage*.do", // 유저 마이페이지 주소 전부
                		"/company10.do",
                		"/admin*.do", // 관리자 마이페이지 주소 전부
                		"/add.do" // 리뷰 작성
                ) 
                // [제외할 대상] 로그인 안 해도 보여줘야 하는 주소들
                .excludePathPatterns(
                		"/merryViewHome.do",
                        "/login.do",
                        "/join*.do",    // join.do, join-user.do 등 제외
                        "/find-*.do",   // find-id.do, find-pwd.do 제외
                        
                        "/css/**", "/js/**", "/img/**", "/images/**"
                ); // 제외할 경로
    }
    
    // ai 챗봇
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
