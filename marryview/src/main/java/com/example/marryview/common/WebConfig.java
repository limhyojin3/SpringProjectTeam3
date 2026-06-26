package com.example.marryview.common;

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
    	 // 2. 프로젝트 내부 저장소 설정 (필요 없다면 삭제해도 무방하지만 일단 유지했습니다)
        String projectPath = System.getProperty("user.dir");
        registry.addResourceHandler("/img2/**")
        .addResourceLocations("file:///" + projectPath + "/src/main/resources/static/uploads/");
    }
	
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1)
                .addPathPatterns(
                        "/userMyPage*.do",
                        "/company10.do",
                        "/admin*.do",
                        "/add.do",
                        "/api/review/**",
                        "/api/community/**"
                ) 
                .excludePathPatterns(
                        "/merryViewHome.do",
                        "/login.do",
                        "/join*.do",
                        "/find-*.do",
                        "/css/**", "/js/**", "/img/**", "/images/**",
                        "/uploads/**", // [중요] 사진 폴더는 로그인 체크에서 제외해야 사진이 뜹니다!,
                        "/api/review/list.do",
                        "/api/review/list.dox",   // [추가] 리뷰 목록 데이터를 가져오는 API
                        "/api/review/detail.do",  // [선택] 상세 페이지를 비회원도 보게 하려면 추가
                        "/api/review/detail.dox", // [선택] 상세 데이터를 가져오는 API
                        "/api/review/company-list.dox", // [추가] 업체 목록 API (목록 검색용)
                        "/api/community/list.do",
                        "/api/community/list.dox",
                        "/api/community/detail.do",
                        "/api/community/getPost.dox"
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