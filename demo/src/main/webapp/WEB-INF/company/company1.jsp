<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>업체 마이페이지</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* 기본 초기화 및 폰트 */
        body, html { margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; background-color: #f9f9f9; }
        
        #app { width: 1000px; margin: 20px auto; background: #fff; border: 1px solid #ccc; display: flex; flex-direction: column; }

        /* 상단 헤더 섹션 */
        .header-container { display: flex; align-items: center; padding: 10px 20px; border-bottom: 2px solid #333; justify-content: space-between; }
        .logo { width: 120px; }
        .nav-buttons button { padding: 8px 15px; margin-right: 5px; border: 1px solid #ff7b9c; background: white; color: #333; cursor: pointer; border-radius: 4px; }
        .user-info { font-weight: bold; padding: 8px 15px; background: #ff7b9c; color: white; border-radius: 4px; }

        /* 메인 컨텐츠 영역 (사이드바 + 본문) */
        .main-wrapper { display: flex; min-height: 500px; }

        /* 왼쪽 사이드바 (LNB) */
        .sidebar { width: 200px; border-right: 1px solid #ddd; background-color: #fff; padding: 0; }
        .sidebar button { width: 100%; padding: 15px; border: none; border-bottom: 1px solid #eee; background: white; text-align: left; cursor: pointer; font-size: 14px; position: relative; }
        .sidebar button.active { background-color: #ff2d78; color: white; font-weight: bold; }
        .sidebar .badge { position: absolute; right: 10px; top: 12px; background: #ff2d78; color: white; border-radius: 12px; padding: 2px 8px; font-size: 11px; }

        /* 본문 내용 */
        .content { flex: 1; padding: 30px; }
        .content h1 { font-size: 24px; margin-bottom: 10px; }
        .tag-partner { display: inline-block; background: #ffb800; color: white; padding: 5px 15px; border-radius: 5px; font-weight: bold; margin-bottom: 20px; }

        /* 정보 박스 */
        .info-box { border: 2px solid #ff7b9c; border-radius: 10px; padding: 20px; margin-bottom: 15px; position: relative; }
        .info-box .title { font-weight: bold; color: #333; margin-bottom: 10px; }
        .info-box .value { text-align: right; font-size: 18px; font-weight: bold; }

        .btn-withdraw { float: right; padding: 10px 20px; border: 1px solid #333; background: #fff; cursor: pointer; margin-top: 10px; }

        /* 푸터 */
        .footer { background: #ffccbc; padding: 20px; text-align: center; border-top: 1px solid #ddd; }

        /* AI 챗봇 버튼 */
        .ai-chatbot { position: fixed; bottom: 80px; right: 40px; width: 70px; height: 70px; background: #0099ff; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
    </style>
</head>
<body>
    <div id="app">
        <header class="header-container">
            <img src="/images/logo.png" class="logo" alt="메리 뷰 로고">
            <div class="nav-buttons">
                <button>회사소개</button>
                <button>제휴업체</button>
                <button>커뮤니티</button>
                <button>패스구매</button>
                <button>고객센터</button>
            </div>
            <span class="user-info">{{ userName }}님</span>
        </header>

        <div class="main-wrapper">
            <nav class="sidebar">
                <button class="active">마이 페이지</button>
                <button>상품 관리</button>
                <button>예약 관리 <span class="badge">3</span></button>
                <button>문의 내역 <span class="badge">2</span></button>
                <button>리뷰 내역 <span class="badge">10</span></button>
                <button style="height: 150px; background-color: #ffccbc;"></button> </nav>

            <main class="content">
                <h1>안녕하세요, '{{ companyName }}'님!</h1>
                <div class="tag-partner">제휴업체</div>

                <div class="info-box">
                    <div class="title">제휴업체 이용 기간</div>
                    <div class="value">25.01.01 ~ 26.01.01</div>
                </div>

                <div class="info-box">
                    <div class="title">마지막 결제 수단</div>
                    <div class="value">신협 ***</div>
                </div>

                <button class="btn-withdraw">탈퇴하기</button>
            </main>
        </div>

        <footer class="footer">
            푸터 → 업체 정보
        </footer>

        <div class="ai-chatbot">ai 챗봇</div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userName: 'ooo',
                    companyName: 'ABC 드레스 샵'
                };
            },
            methods: {
                fnList: function () {
                    let self = this;
                    $.ajax({
                        url: "http://localhost:8080/",
                        type: "POST",
                        dataType: "json",
                        success: function (data) {
                            // 데이터 처리
                        }
                    });
                }
            }
        });
        app.mount('#app');
    </script>
</body>
</html>