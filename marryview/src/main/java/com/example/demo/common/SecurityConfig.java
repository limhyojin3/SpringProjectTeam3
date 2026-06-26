package com.example.demo.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration 
public class SecurityConfig {

    // ⭕ 1. PasswordEncoder 빈 등록 (MemberService에서 @Autowired 가능해짐)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); 
    }

    // ✅ 2. 더블 슬래시(//) 및 세미콜론 허용 방화벽 설정
    @Bean
    public HttpFirewall allowDoubleSlashFirewall() { 
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedDoubleSlash(true);
        firewall.setAllowSemicolon(true); 
        return firewall; 
    }

    // ✅ 3. 구버전 문법(람다식 생략) 대신 스프링 부트 3.x 표준 문법으로 방화벽 적용
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() { 
        return (web) -> web.httpFirewall(allowDoubleSlashFirewall()); 
    }

    // ✅ 4. 스프링 부트 3.x 최신 문법으로 시큐리티 필터 체인 설정 (접근 통제 해제)
    @Bean 
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception { 
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // 🔒 시큐리티 로그인창 안 뜨게 모든 주소 허용
            ) 
            .csrf(csrf -> csrf.disable()) // CSRF 비활성화
            .formLogin(form -> form.disable()) // 기본 로그인 페이지 비활성화
            .httpBasic(basic -> basic.disable()); // HTTP Basic 인증 비활성화

        return http.build(); 
    } 
}