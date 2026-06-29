package com.example.marryview.common;

import java.io.PrintWriter;

import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        if (session.getAttribute("sessionId") == null) {
            // 1. 응답 형식을 HTML로 설정 (한글 깨짐 방지)
            response.setContentType("text/html; charset=UTF-8");
            
            // 2. 출력을 위한 객체 생성
            PrintWriter out = response.getWriter();
            
            // 3. 자바스크립트 실행 (알림창 띄우고 지정된 경로로 이동)
            out.println("<script>");
            out.println("alert('로그인 후 이용 가능합니다.');");
            out.println("location.href='" + request.getContextPath() + "/merryViewHome.do';"); // 확인 후 보낼 주소
            out.println("</script>");
            
            out.flush();
            out.close(); // 자원 반환
            
            return false; // 더 이상 진행하지 않고 중단
        }
        
        return true; // 로그인 되어 있으면 정상 진행
    }
}