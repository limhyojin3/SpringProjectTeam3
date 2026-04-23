<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            /* 기본 레이아웃 */
            body {
                font-family: 'Malgun Gothic', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }

            #app {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border: 1px solid #ddd;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* 헤더 영역 */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                border-bottom: 2px solid #333;
            }

            .nav-top button {
                padding: 8px 15px;
                margin-right: 5px;
                border: 1px solid #ff7f9f;
                background: white;
                color: #ff7f9f;
                cursor: pointer;
                border-radius: 5px;
            }

            .user-info {
                background: #ff7f9f;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
            }

            /* 메인 바디 레이아웃 */
            .container {
                display: flex;
                flex: 1;
            }

            /* 사이드바 */
            aside {
                width: 220px;
                background: #fff0f3;
                padding: 20px;
                border-right: 1px solid #ddd;
            }

            .menu-item {
                position: relative;
                margin-bottom: 10px;
            }

            .menu-item button {
                width: 100%;
                padding: 12px;
                text-align: center;
                border: 1px solid #ddd;
                background: white;
                cursor: pointer;
                font-weight: bold;
            }

            .menu-item button.active {
                background: #ff1493;
                color: white;
                border-color: #ff1493;
            }

            /* 숫자 배지 */
            .badge {
                position: absolute;
                right: -10px;
                top: 50%;
                transform: translateY(-50%);
                background: #ff1493;
                color: white;
                border-radius: 12px;
                padding: 2px 10px;
                font-size: 12px;
                border: 2px solid white;
                z-index: 10;
            }

            /* 메인 컨텐츠 */
            main {
                flex: 1;
                padding: 30px;
            }

            .content-card {
                border: 2px solid #ff7f9f;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 20px;
                position: relative;
            }

            .section-title {
                background: #ffb400;
                display: inline-block;
                padding: 5px 15px;
                color: white;
                font-weight: bold;
                margin-bottom: 15px;
            }

            /* 테이블 및 리스트 스타일 */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                background: #fef0f3;
                width: 120px;
            }

            .new-label {
                background: #ff7f9f;
                color: white;
                font-size: 10px;
                padding: 2px 4px;
                border-radius: 3px;
                vertical-align: middle;
                margin-right: 5px;
            }

            /* 탭 버튼 */
            .tab-menu {
                margin-bottom: 20px;
            }

            .tab-menu button {
                padding: 10px 20px;
                border: 1px solid #ddd;
                background: #eee;
                cursor: pointer;
            }

            .tab-menu button.active {
                background: #ff7f9f;
                color: white;
                border-color: #ff7f9f;
            }

            /* 푸터 */
            footer {
                background: #ffc1cc;
                padding: 20px;
                text-align: center;
                font-size: 14px;
                border-top: 1px solid #ddd;
            }

            /* 플로팅 버튼 */
            .ai-chatbot {
                position: fixed;
                right: 30px;
                bottom: 100px;
                background: #0099ff;
                color: white;
                width: 70px;
                height: 70px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            /* 리뷰 섹션 공통 */
            .review-header-info {
                display: flex;
                align-items: center;
                gap: 20px;
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border: 1px solid #eee;
            }

            .review-thumb-box {
                width: 80px;
                height: 80px;
                background: #ffcef0;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 6px;
                font-size: 12px;
                color: #d6336c;
            }

            .review-product-name {
                flex: 1;
                font-size: 18px;
                color: #333;
            }

            .review-count-badge {
                font-size: 14px;
                color: #666;
                background: #fff;
                padding: 5px 12px;
                border-radius: 20px;
                border: 1px solid #ddd;
            }

            /* 상세 리뷰 카드 내부 */
            .detail-review-item {
                padding: 20px 0;
                border-bottom: 1px solid #f0f0f0;
            }

            .star-rating {
                color: #ffb400;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .review-photo {
                width: 100px;
                height: 100px;
                background: #fff0f3;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 11px;
                color: #ff7f9f;
                border: 1px solid #ffe0e6;
            }

            /* 페이징 */
            .pagination {
                text-align: center;
                margin-top: 25px;
            }

            .pagination a {
                display: inline-block;
                padding: 8px 12px;
                margin: 0 4px;
                text-decoration: none;
                color: #666;
                border-radius: 4px;
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                cursor: pointer;
                border: 1px solid transparent;
                font-weight: 500;
            }

            .pagination a:hover {
                background: #ff7f9f;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 124, 159, 0.3);
            }

            .pagination a:active {
                transform: translateY(0px);
            }

            /* 상품 등록/수정 폼 */
            .product-form-wrapper {
                background: white;
            }

            .product-form-section {
                margin-bottom: 25px;
            }

            .form-title-box {
                background: linear-gradient(135deg, #ff7f9f 0%, #ff9fb8 100%);
                padding: 12px 20px;
                color: white;
                font-weight: bold;
                font-size: 15px;
                border-radius: 6px 6px 0 0;
                margin-bottom: 0;
            }

            .form-content-box {
                border: 2px solid #ff7f9f;
                border-top: none;
                padding: 25px;
                border-radius: 0 0 6px 6px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group:last-child {
                margin-bottom: 0;
            }

            .form-label {
                display: block;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                font-size: 14px;
            }

            .category-group {
                display: flex;
                gap: 25px;
                padding: 10px 0;
            }

            .category-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .category-item input[type="checkbox"] {
                cursor: pointer;
                width: 18px;
                height: 18px;
            }

            .category-item label {
                cursor: pointer;
                margin: 0;
                font-size: 14px;
                color: #555;
            }

            .form-info-box {
                background: #fff9f0;
                border-left: 4px solid #ffb400;
                padding: 12px 15px;
                border-radius: 4px;
                color: #333;
                font-size: 14px;
                line-height: 1.6;
            }

            .form-info-label {
                font-weight: 600;
                color: #ff1493;
            }

            .image-editor-box {
                background: linear-gradient(135deg, #ffe0e6 0%, #fff0f3 100%);
                border: 2px dashed #ff7f9f;
                border-radius: 8px;
                padding: 40px;
                text-align: center;
                color: #ff7f9f;
                font-weight: 600;
                min-height: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .image-editor-box:hover {
                background: linear-gradient(135deg, #ffd4e5 0%, #ffe8ef 100%);
                border-color: #ff1493;
            }

            .form-button-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                justify-content: flex-end;
            }

            .form-button-group button {
                padding: 12px 30px;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .btn-submit {
                background: #ff7f9f;
                color: white;
            }

            .btn-submit:hover {
                background: #ff1493;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 124, 159, 0.3);
            }

            .btn-cancel {
                background: #f0f0f0;
                color: #666;
                border: 1px solid #ddd;
            }

            .btn-cancel:hover {
                background: #e8e8e8;
                border-color: #999;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <header>
                <div class="logo"><img src="/img/merryViewLogo.png" alt="메리뷰" height="60"></div>
                <div class="nav-top">
                    <button>회사소개</button>
                    <button>제휴업체</button>
                    <button>커뮤니티</button>
                    <button>패스구매</button>
                    <button>고객센터</button>
                </div>
                <div class="user-info">{{ user.name }}님</div>
            </header>

            <div class="container">

                
            </div>


        </div>

        <footer>
            푸터 → 업체 정보 | 사업자번호: 000-00-00000 | 고객센터: 1588-0000
        </footer>

        <div class="ai-chatbot">ai 챗봇</div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {

                }

            }, // data
            computed: {

            },
            methods: {

                fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "http://localhost:8080/",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                        }
                    });
                }
            }, // methods


            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }


        });

        app.mount('#app');
    </script>