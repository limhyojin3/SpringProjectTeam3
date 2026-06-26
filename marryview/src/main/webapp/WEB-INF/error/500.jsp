<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>500 - 서버 오류</title>
    <style>
        body { background: #f9f9f9; font-family: 'Noto Sans KR', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .error-box { text-align: center; }
        .error-code { font-size: 100px; font-weight: bold; color: #f4a096; margin: 0; }
        .error-msg { font-size: 20px; color: #555; margin: 10px 0 30px; }
        .btn-home { padding: 12px 30px; background-color: #f4a096; color: white; border: none; border-radius: 8px; font-size: 15px; cursor: pointer; text-decoration: none; }
        .btn-home:hover { opacity: 0.85; }
    </style>
</head>
<body>
    <div class="error-box">
        <p class="error-code">500</p>
        <p class="error-msg">서버 오류가 발생했습니다.</p>
        <a href="/merryViewHome.do" class="btn-home">메인으로 돌아가기</a>
    </div>
</body>
</html>