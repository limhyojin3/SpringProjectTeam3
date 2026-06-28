package com.example.marryview;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
@MapperScan("com.example.marryview") 
public class MarryViewApplication extends SpringBootServletInitializer { // 💡 상속 추가

	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) { // 💡 오버라이드 추가
        return builder.sources(MarryViewApplication.class);
    }
	
	public static void main(String[] args) {
		SpringApplication.run(MarryViewApplication.class, args);
	}

} 