package com.example.demo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication 
@MapperScan("com.example.demo") 
public class DemoApplication extends SpringBootServletInitializer { // 💡 상속 추가

	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) { // 💡 오버라이드 추가
        return builder.sources(DemoApplication.class);
    }
	
	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}