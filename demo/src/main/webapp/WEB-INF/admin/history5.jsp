<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>메리뷰 소개</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <style>
            /* --- 1. 기본 레이아웃 및 히어로 (유지) --- */
            .about-hero {
                width: 100%;
                height: 420px;
                background-image: url('/img/home_about3.jpg');
                background-size: cover;
                background-position: center;
                position: relative;
                display: flex;
                align-items: flex-end;
            }

            .about-hero-overlay {
                width: 100%;
                padding: 40px 60px;
                background: linear-gradient(to top, rgba(0, 0, 0, 0.5), transparent);
            }

            .about-hero-overlay h1 {
                font-family: Georgia, serif;
                font-style: italic;
                font-size: 48px;
                color: white;
                margin: 0;
            }

            .about-hero-overlay p {
                color: rgba(255, 255, 255, 0.85);
                font-size: 16px;
                margin: 8px 0 0;
            }

        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <!-- 히어로 -->
            <div class="about-hero">
                <div class="about-hero-overlay">
                    <h1>MerryView</h1>
                    <p>결혼을 준비하는 모든 순간을 함께하는 웨딩 리뷰 전문 플랫폼</p>
                </div>
            </div>

            <div class="about-body">
                
            </div>

            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>

        <script>
            
        </script>
    </body>

    </html>