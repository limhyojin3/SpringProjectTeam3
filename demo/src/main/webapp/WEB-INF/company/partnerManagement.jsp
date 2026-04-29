<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!-- <%-- 1. JSTL 코어 태그 라이브러리를 사용하겠다고 선언합니다 --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> -->
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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <style>
            /* 기본 레이아웃 */
            /*body {
                font-family: 'Malgun Gothic', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f9f9f9;
            }*/

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
            /* header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                border-bottom: 2px solid #333;
            }*/

            /*.nav-top button {
                padding: 8px 15px;
                margin-right: 5px;
                border: 1px solid #ff7f9f;
                background: white;
                color: #ff7f9f;
                cursor: pointer;
                border-radius: 5px;
            }*/

            /*.user-info {
                background: #ff7f9f;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
            }*/

            /* 메인 바디 레이아웃 */
            .container1 {
                display: flex;
                flex: 1;
                margin-top: 50px;
                background-color: #fff9f9;
            }

            /* 사이드바 */
            /*aside {
                width: 220px;
                background: #fff0f3;
                padding: 20px;
                border-right: 1px solid #ddd;
            }*/

            .left-banner {
                width: 320px;
                flex-shrink: 0;
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
                border: 2px solid #ffc7c2;
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
            /* footer {
                background: #ffc1cc;
                padding: 20px;
                text-align: center;
                font-size: 14px;
                border-top: 1px solid #ddd;
            }*/

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
                /*background: #ffcef0;*/
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
            .pagination1 {
                text-align: center;
                margin-top: 25px;
            }

            .pagination1 a {
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

            .pagination1 a:hover {
                background: #ff7f9f;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 124, 159, 0.3);
            }

            .pagination1 a:active {
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

            /* 테이블 전체 컨테이너 */
            table {
                width: 100%;
                border-collapse: separate;
                /* 테두리 둥글게 하기 위해 분리 */
                border-spacing: 0;
                margin-bottom: 40px;
                /* 테이블 간 간격 확보 */
                background-color: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                /* 은은한 그림자 */
                border: 1px solid #edf2f7;
            }

            /* 왼쪽 헤더 (th) */
            th {
                width: 180px;
                /* 일정한 너비 유지 */
                background-color: #f9fafb;
                /* 은은한 회색 배경 */
                color: #4a5568;
                font-weight: 600;
                text-align: left;
                padding: 14px 20px;
                border-bottom: 1px solid #edf2f7;
                border-right: 1px solid #edf2f7;
                font-size: 14px;
            }

            /* 오른쪽 내용 (td) */
            td {
                padding: 14px 20px;
                color: #2d3748;
                border-bottom: 1px solid #edf2f7;
                font-size: 15px;
            }

            /* 마지막 행은 테두리 제거 */
            tr:last-child th,
            tr:last-child td {
                border-bottom: none;
            }

            /* 테이블 제목 부분 강조 */
            h2 {
                font-size: 1.5rem;
                margin-bottom: 25px;
                padding-left: 10px;
                border-left: 5px solid #ff1493;
                /* 메인 컬러 포인트 */
            }

            /* 삼항 연산자로 들어간 텍스트 강조 (결제완료/미결제 등) */
            td {
                line-height: 1.6;
            }

            .nav-container {
                background-color: transparent;
                background-color: #ffc7c2;
                padding: 20px 10px;
                border-radius: 12px;
                display: flex;
                flex-direction: column;
                gap: 10px;
                border: 1px solid #eee;
                min-height: 100vh;
                /* 부모(.main-content) 높이만큼 꽉 채움 */


            }

            .nav-title {
                background-color: #f4a096;
                color: #fff;
                text-align: center;
                padding: 15px;
                border-radius: 8px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .nav-btn {
                width: 100%;
                padding: 12px 15px;
                background: #fff;
                border: 1px solid #eee;
                border-radius: 6px;
                text-align: left;
                cursor: pointer;
                font-size: 14px;
                transition: 0.3s;
            }

            /*.main-content{
                background-color: #fff9f9; 
            }*/
            /*.main-content {
                display: flex !important;
                align-items: stretch;
                /* 사이드바와 콘텐츠 영역 높이를 동일하게 맞춤 */
            /*min-height: 800px;
                /* 최소 높이 확보 */
            /*}*/

            /*#wrapper {
                max-width: 1300px;
                margin: 0 auto;
                /* 상단 마진을 없애거나 조절하여 헤더와 밀착 */
            /*padding: 50px 20px;
                /* 내부 여백으로 간격 조절 */
            /*min-height: 100vh;
                /* 브라우저 화면 높이만큼 최소 높이 확보 */
            /*display: flex;
                flex-direction: column;
            }*/
            /*#wrapper {
                max-width: 1300px;
                margin: 50px auto;
                padding: 0 20px;
                position: relative;
            }
                */
            #wrapper {
                background-color: #fff9f9;
            }


            /* 상태별 배지 스타일 (선택사항) */
            /* td 내부에 span 등으로 감싸져 있다면 더 좋지만, 
            현재 구조에서 글자색만으로도 충분히 세련되어 보일 거예요. */
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div id="wrapper">
                <div class="main-content">
                    <div class="container1">

                        <aside>

                            <div class="left-banner">
                                <div class="nav-container">
                                    <div class="nav-title">업체페이지</div>
                                    <button class="nav-btn" @click="handleMenuClick('main')">업체페이지</button>
                                    <button class="nav-btn" @click="handleMenuClick('product')">상품 관리</button>
                                    <button class="nav-btn" @click="handleMenuClick('reservation')">예약 관리</button>
                                    <button class="nav-btn" @click="handleMenuClick('inquiry')">문의 내역</button>
                                    <button class="nav-btn" @click="handleMenuClick('review')">리뷰 내역</button>
                                </div>
                            </div>
                        </aside>


                        <!-- menuList() {
                    return [
                        { id: 'main', name: '마이 페이지', count: 0 },
                        { id: 'product', name: '상품 관리', count: 0 },
                        { id: 'reservation', name: '예약 관리', count: this.resCount },
                        { id: 'inquiry', name: '문의 내역', count: 2 },
                        { id: 'review', name: '리뷰 내역', count: this.newReviewCnt + this.newUnpaidReviewCnt },
                        { id: 'customer', name: '고객센터', count: 0 }
                    ];
                },


                handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
                    this.currentMenu = menuId;
                    this.productPage = 'list';
                    this.page = 1;
                    this.page1 = 'main';
                    this.reviewTab = 'detail';
                    this.currentPage = 1;

                    if (menuId === 'main') {
                        this.fnCom();
                    }
                    else if (menuId === 'product') {
                        this.fnProductList();
                    } else if (menuId === 'reservation') {
                        this.fnReservationList();
                    } else if (menuId === 'review') {

                        this.fnSimple();
                        this.fnReview();
                    }
                }, -->





                        <!-- <aside>
                    <div class="menu-item" v-for="m in menuList" :key="m.id">
                        <button :class="{ active: currentMenu === m.id }" @click="handleMenuClick(m.id)">
                            {{ m.name }}
                        </button>
                        <span class="badge" v-if="m.count > 0">{{ m.count }}</span>
                    </div>
                </aside> -->

                        <main>
                            <div v-if="currentMenu === 'main'">
                                <h2>안녕하세요, '{{ user.name }}'님!</h2>
                                <div class="section-title" v-if="user.grade === '제휴업체'">제휴업체</div>
                                <div class="section-title" v-else-if="user.grade === '일반업체'">일반업체</div>
                                <div class="content-card">
                                    <h3><span v-if="user.grade === '제휴업체'">제휴업체</span> 이용 기간</h3>
                                    <p style="text-align: right; font-size: 20px;">{{ user.usePeriod }}</p>
                                </div>
                                <div class="content-card">
                                    <h3>마지막 결제 수단</h3>
                                    <p style="text-align: right; font-size: 20px;">{{ user.lastPayment }}</p>
                                </div>
                                <!-- <button style="float: right;" @click="withdraw">탈퇴하기</button> -->
                            </div>


                            <!-- 상품 관리 메뉴 -->
                            <div v-if="currentMenu === 'product'">

                                <div v-if="productPage === 'list'">
                                    <!-- db 랑 연결한 곳 -->
                                    <h2>등록한 상품({{ productList3.length }})</h2>
                                    <div v-for="i in productList3" class="content-card"
                                        style="display: flex; align-items: center; padding: 15px;">
                                        <div
                                            style="width: 100px; height: 100px;  display: flex; align-items: center; justify-content: center; margin-right: 20px;">
                                            <!--{{ i.thumbnail }}-->
                                            <img :src="i.imgUrl" :alt="i.productName"
                                                style="width: 100%; height: 100%; object-fit: cover;">
                                        </div>
                                        <div style="flex: 1; font-weight: bold;">{{ i.productDetails }}</div>
                                        <div>{{ Number(i.originalPrice).toLocaleString() }}원</div>
                                        <button @click="goEditPage(i)" style="margin-left: 10px;">수정하기</button>
                                        <button @click="fnRemove2(i)" style="margin-left: 10px;">삭제하기</button>
                                    </div>
                                    <div style="text-align: center;">
                                        <button @click="goRegPage2"
                                            style="background: #ffb400; padding: 15px 40px; border: none; font-weight: bold; cursor: pointer;">상품
                                            등록</button>
                                    </div>


                                    <!-- 여기는 프론트만으로 되는 곳-->
                                    <!-- <h2>등록한 상품({{ productList.length }})</h2>
                            <div v-for="i in productList" class="content-card"
                                style="display: flex; align-items: center; padding: 15px;">
                                <div
                                    style="width: 120px; height: 80px; background: #ffcef0; display: flex; align-items: center; justify-content: center; margin-right: 20px;">
                                    {{ i.thumbnail }} -->
                                    <!-- <img :src="i.thumbnail" :alt="i.name" style="max-width: 100%; max-height: 100%">
                                </div>
                                <div style="flex: 1;">{{ i.content }}</div>
                                <div>{{ i.price }}</div>
                                <button @click="goEditPage(i)" style="margin-left: 10px;">수정하기</button>
                                <button @click="fnRemove(i)" style="margin-left: 10px;">삭제하기</button>
                            </div>
                            <div style="text-align: center;">
                                <button @click="goRegPage"
                                    style="background: #ffb400; padding: 15px 40px; border: none; font-weight: bold; cursor: pointer;">상품
                                    등록</button>
                            </div> -->
                                </div>

                                <!-- 상품 등록 폼 -->
                                <div v-else-if="productPage === 'reg'">
                                    <div class="product-form-wrapper">
                                        <!-- {{serverTagList}}
                                        {{newTagsOnly}}
                                        {{uniqueNewTagsOnly()}} -->
                                        <h2 style="color: #333; margin-bottom: 30px;">상품 등록하기</h2>

                                        <div class="product-form-section">
                                            <div class="form-title-box">상품 기본 정보</div>
                                            <div class="form-content-box">


                                                <div class="form-group">
                                                    <label class="form-label">상품 이름</label>
                                                    <div class="form-info-box">
                                                        <input type="text" placeholder="여기에 상품 이름을 적어주세요."
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product2.productName">
                                                    </div>
                                                </div>




                                                <div class="form-group">
                                                    <label class="form-label">카테고리</label>
                                                    <div class="category-group">
                                                        <div class="category-item" v-for="item in category" :key="item">
                                                            <label>
                                                                <input type="checkbox" :value="item"
                                                                    v-model="product2.proType">{{item}}
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">상품 태그</label>                                        
                                                        <input type="text" placeholder="첫번째 태그"
                                                            v-model="tagMap.input1">
                                                        <input type="text" placeholder="두번째 태그"
                                                            v-model="tagMap.input2">
                                                        <input type="text" placeholder="세번째 태그"
                                                            v-model="tagMap.input3">
                                                        <input type="text" placeholder="네번째 태그"
                                                            v-model="tagMap.input4">
                                                        <input type="text" placeholder="다섯번째 태그"
                                                            v-model="tagMap.input5">
                                                </div>
                                                <!-- {{tagMap}}
                                                {{tagMapToList}} -->

                                                <div class="form-group">

                                                    <label class="form-label">상품 설명</label>
                                                    <div class="form-info-box">
                                                        <textarea placeholder="상품에 대한 자세한 설명을 입력하세요."
                                                            v-model="product2.productDetails"
                                                            style="width: 60%; height: 100px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"></textarea>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    
                                                    <label class="form-label"><span class="form-info-label">예상
                                                            견적</span></label>
                                                    <div class="form-info-box">
                                                        <input placeholder="여기에 견적을 적어주세요." type="text"
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product2.originalPrice">
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label"><span class="form-info-label">예약금</span></label>
                                                    <div class="form-info-box">
                                                        <input placeholder="여기에 예약금을 적어주세요." type="text"
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product2.deposit">
                                                    </div>
                                                </div>
                                                <!-- {{product2.deposit}} -->
                                            </div>
                                        </div>

                                        <div class="product-form-section">
                                            <div class="form-title-box">상품 이미지</div>
                                            <div class="form-content-box">
                                                <div class="form-group">


                                                    <div style="margin-bottom: 10px; font-weight: bold;">등록할 이미지 :
                                                    </div>

                                                    <label
                                                        style="background: #ff1493; color: white; padding: 5px 15px; cursor: pointer; border-radius: 5px;">
                                                        사진 선택하기
                                                        <input type="file" @change="fnFileChange" ref="fileInput"
                                                            style="display: none;">
                                                    </label>
                                                    <div class="image-editor-box">

                                                        <div v-if="previewUrl" style="margin-top: 10px;">
                                                            <p>선택된 이미지 미리보기:</p>
                                                            <img :src="previewUrl"
                                                                style="max-width: 80%; border: 1px solid #ccc;">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-button-group">
                                            <button class="btn-cancel" @click="fnBack3()">취소(돌아가기)</button>
                                            <button class="btn-submit" @click="fnInsertProduct()">상품 등록</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- 상품 수정 폼 -->
                                <div v-else-if="productPage === 'edit'">
                                    <div class="product-form-wrapper">
                                        <!-- {{serverTagList}}
                                        {{newTagsOnly}}
                                        {{uniqueNewTagsOnly()}} -->
                                        <h2 style="color: #333; margin-bottom: 30px;">상품 수정하기</h2>

                                        <div class="product-form-section">
                                            <div class="form-title-box">상품 기본 정보</div>
                                            <div class="form-content-box">

                                                <div class="form-group">
                                                    <label class="form-label">상품 이름</label>
                                                    <div class="form-info-box">
                                                        <input type="text"
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product1.productName">
                                                    </div>
                                                </div>




                                                <div class="form-group">
                                                    <label class="form-label">카테고리</label>
                                                    <div class="category-group">


                                                        <div class="category-item" v-for="item in category" :key="item">
                                                            <input type="checkbox" :value="item"
                                                                v-model="product1.proType">{{item}}
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label">상품 태그</label>                                        
                                                        <input type="text" placeholder="첫번째 태그"
                                                            v-model="tagMap.input1">
                                                        <input type="text" placeholder="두번째 태그"
                                                            v-model="tagMap.input2">
                                                        <input type="text" placeholder="세번째 태그"
                                                            v-model="tagMap.input3">
                                                        <input type="text" placeholder="네번째 태그"
                                                            v-model="tagMap.input4">
                                                        <input type="text" placeholder="다섯번째 태그"
                                                            v-model="tagMap.input5">
                                                </div>
                                                <!-- {{tagMap}}
                                                {{tagMapToList}}
                                                {{product1}} -->


                                                <div class="form-group">
                                                    <label class="form-label">상품 설명</label>
                                                    <div class="form-info-box">
                                                        <textarea
                                                            style="width: 60%; height: 100px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            placeholder="상품에 대한 자세한 설명을 입력하세요."
                                                            v-model="product1.productDetails"></textarea>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label"><span class="form-info-label">예상
                                                            견적</span></label>
                                                    <div class="form-info-box">

                                                        <input type="text"
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product1.originalPrice">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="form-label"><span class="form-info-label">예약금</span></label>
                                                    <div class="form-info-box">
                                                        <input placeholder="여기에 예약금을 적어주세요." type="text"
                                                            style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                            v-model="product1.deposit">
                                                    </div>
                                                </div>
                                                <!-- {{product1.deposit}} -->
                                            </div>
                                        </div>

                                        <div class="product-form-section">
                                            <div class="form-title-box">상품 이미지</div>
                                            <div class="form-content-box">
                                                <div class="form-group">
                                                    <div style="margin-bottom: 10px; font-weight: bold;">기존 이미지 : </div>
                                                    <div class="image-editor-box">
                                                        <img :src="product1.imgUrl"
                                                            style="max-width: 500px; max-height: 500px;">
                                                    </div>
                                                    <br>
                                                    <div style="margin-bottom: 10px; font-weight: bold;">수정할 이미지 :
                                                    </div>
                                                    <!-- 이미지 첨부 -->
                                                    <label
                                                        style="background: #ff1493; color: white; padding: 5px 15px; cursor: pointer; border-radius: 5px;">
                                                        사진 선택하기
                                                        <input type="file" @change="fnFileChange" ref="fileInput"
                                                            style="display: none;">

                                                    </label>
                                                    <div class="image-editor-box">

                                                        <div v-if="previewUrl" style="margin-top: 10px;">
                                                            <p>선택된 이미지 미리보기:</p>
                                                            <img :src="previewUrl"
                                                                style="max-width: 80%; border: 1px solid #ccc;">
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-button-group">
                                            <button class="btn-cancel" @click="productPage = 'list'">취소(돌아가기)</button>
                                            <button class="btn-submit" @click="fnUpdateProduct">상품 수정</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div v-if="currentMenu === 'reservation'">
                                <h2>예약 관리 : <span style="color: #ff1493;">새 예약 {{ resCount }}건</span></h2>
                                <template v-for="res in fnPaginatedReservation" :key="res.id">
                                    <table style="margin-bottom: 30px;">
                                        <tr>
                                            <th>예약 상품</th>
                                            <td>{{ res.productName }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약 내용/ 요청 사항</th>
                                            <td>{{ res.resContent === '' ? '요청사항 없음' : res.resContent }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약저장</th>
                                            <td>{{ res.resDate }} {{ res.resTime }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약결제</th>
                                            <td>{{ res.payDate === undefined ? '(미결제)' : '(결제완료)' + res.payDate }}</td>
                                        </tr>

                                        <tr>
                                            <th>예약 날짜/시간</th>
                                            <td>{{ res.useDate }} {{ res.useTime }}</td>
                                        </tr>

                                        <tr>
                                            <th>예약자명</th>
                                            <td>{{ res.resUserId }}</td>
                                        </tr>
                                        <tr>
                                            <th>연락처</th>
                                            <td>{{ res.tel }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약금</th>
                                            <td>{{ Number(res.deposit).toLocaleString() }}원</td>
                                        </tr>
                                        <tr>
                                            <th>예약 처리상태</th>
                                            <td v-if="res.resStatus === 'WAIT'" style="color: #3714ff;">
                                                {{ res.resStatus }}
                                            </td>
                                            <td v-else-if="res.resStatus === 'CANCEL'" style="color: red;">
                                                {{ res.resStatus }}
                                            </td>
                                            <td v-else>{{ res.resStatus }}</td>
                                        </tr>
                                    </table>
                                </template>
                                <div class="pagination1">
                                    <span v-for="num in totalPageReservation" :key="num">
                                        <a @click="fnPageChange(num)" href="javascript:;"
                                            :style="currentPage === num ? 'color: #ff1493; border: 1px solid #ff1493;' : ''">
                                            {{num}}
                                        </a> <!-- 1,2,3,4-->
                                    </span>
                                </div>
                            </div>

                            <div v-if="currentMenu === 'inquiry'">
                                <h2>문의 관리 : <span style="color: #ff1493;">새 문의 {{inquiryList.length}}건</span></h2>
                                <div class="content-card" v-for="i in fnPaginatedInquiry" :key="i">

                                    <div style="display: flex;">
                                        <div
                                            style="width: 100px; height: 100px;  margin-right: 20px; text-align: center;">
                                            <img :src="fnThumbnail(i)" :alt="i.product"
                                                style="width: 100%; height: 100%; object-fit: cover;">

                                        </div>
                                        <h3>상품명 : <span style="color: #d6336c;">{{i.product}}</span> </h3>

                                    </div>

                                    <table>
                                        <tr>
                                            <th>제목</th>
                                            <td>{{i.title}}</td>
                                        </tr>
                                        <tr>
                                            <th>작성자</th>
                                            <td>{{i.userid}}</td>
                                        </tr>
                                        <tr>
                                            <th>내용</th>
                                            <td>{{i.content}}</td>
                                        </tr>
                                    </table>

                                    <button style="background: #ffb400; margin-top: 10px; 
                                padding: 10px 20px; border: none; display: block; 
                                margin-left: auto; cursor: pointer;">답변하기</button>

                                </div>
                                <div class="pagination1">
                                    <span v-for="num in inquiryList.length" :key="num">
                                        <a @click="currentPage = num" href="javascript:;"
                                            :style="currentPage === num ? 'color: #ff1493; border: 1px solid #ff1493;' : ''">
                                            {{num}}
                                        </a> <!-- 1,2-->
                                    </span>
                                </div>
                            </div>

                            <div v-if="currentMenu === 'review'">


                                <!--page1 이 main인경우-->
                                <template v-if="page1 === 'main'">


                                    <div class="tab-menu">
                                        <button :class="{ active: reviewTab === 'detail' }" @click="fnReview()">상세
                                            리뷰({{totalReviewCnt}})
                                        </button>

                                        <button :class="{ active: reviewTab === 'simple' }" @click="fnSimple()">한줄
                                            리뷰({{totalSimpleReviewCnt}})
                                        </button>
                                    </div>

                                    <div v-if="reviewTab === 'detail'" class="content-card">

                                        <h3>리뷰 내역 : <span style="color: #ff1493;">새 리뷰 {{newReviewCnt}}건</span></h3>
                                        <template v-for="w in productList3" :key="w.productName">
                                            <div class="review-header-info" style="margin-bottom: 10px;">
                                                <div class="review-thumb-box">
                                                    <img :src="w.imgUrl"
                                                        style="width: 100%; height: 100%; object-fit: cover;">
                                                </div>
                                                <div class="review-product-name">
                                                    <a href="javascript:;" style="text-decoration: none; color:#0b3f8e;"
                                                        @click="fnReviewDetails3(w)"><strong>{{w.productName}}</strong></a>
                                                </div>
                                                <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                                            </div>
                                        </template>
                                    </div>

                                    <div v-if="reviewTab === 'simple'" class="content-card">

                                        <h3>리뷰 내역 : <span style="color: #ff1493;">새 리뷰 {{newUnpaidReviewCnt}}건</span>
                                        </h3>

                                        <template v-for="w in productList4" :key="w.productName">

                                            <div class="review-header-info" style="margin-bottom: 10px;">
                                                <div class="review-thumb-box">
                                                    <img :src="w.imgUrl"
                                                        style="width: 100%; height: 100%; object-fit: cover;">
                                                </div>
                                                <div class="review-product-name">
                                                    <!--totalSimpleReviewCnt-->
                                                    <a href="javascript:;" style="text-decoration: none; color:#0b3f8e;"
                                                        @click="fnSimpleReviewDetails3(w)"><strong>{{w.productName}}</strong></a>

                                                </div>
                                                <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                                            </div>
                                        </template>
                                    </div>
                                </template>




                                <!--page1이 main이 아닌 경우-->
                                <template v-else> <!--page1 != 'main'-->

                                    <!-- 1
                            {{reviewTab}}
                            {{reviews}} -->
                                    <!-- reviewTab === 'detail' 인 경우-->
                                    <template v-if="reviewTab === 'detail'">

                                        <template v-if="reviews && reviews.length > 0">

                                            <template v-for="rev in paginatedReviews" :key="rev"
                                                class="detail-review-item">
                                                <!-- {{rev}} -->
                                                <div class="star-rating">평점 : {{rating2(rev)}}</div>
                                                <!-- {{rev.rating}}/5 -->

                                                <div style="display: flex; gap: 20px;">
                                                    <div style="position: relative;">
                                                        <span class="new-label" v-if="rev.updated === '1'"
                                                            style="position: absolute; top: -5px; left: -5px;">NEW
                                                        </span>
                                                        <div class="review-photo">
                                                            <img :src="rev.imgUrl" :alt="rev.imgDescription"
                                                                style="width: 100%; height: 100%; object-fit: cover;">
                                                        </div>
                                                    </div>
                                                    <div style="flex: 1; line-height: 1.6; color: #444;">
                                                        {{rev.content}}
                                                    </div>
                                                </div>
                                                <div
                                                    style="text-align: right; font-size: 13px; color: #888; margin-top: 15px; border-top: 1px dashed #eee; padding-top: 10px;">
                                                    작성자: <strong>{{rev.userId}}</strong> | 작성일자: {{rev.regDate}}
                                                </div>
                                                <hr>
                                            </template>
                                            <div class="pagination1">
                                                <span v-for="num in totalPages" :key="num">
                                                    <a @click="fnPageChange2(num)" href="javascript:;"
                                                        :style="page === num ? 'color: #ff1493; border: 1px solid #ff1493;' : ''">
                                                        {{num}}
                                                    </a>
                                                </span>
                                            </div>
                                        </template>
                                        <template v-else>
                                            <div style="text-align: center; padding: 50px;">
                                                <h2 style="color: #ccc;">아직 작성된 리뷰가 없습니다!</h2>
                                            </div>
                                        </template>
                                    </template>




                                    <!--reviewTab === 'simple' 인 경우-->
                                    <template v-else-if="reviewTab === 'simple'">
                                        <template v-if="simpleReviews && simpleReviews.length > 0">


                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>번호</th>
                                                        <th>내용</th>
                                                        <th>작성자</th>
                                                        <th>평점</th>
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                    <!--self.simpleReviews = data.list; =[]-->
                                                    <template v-for="(rev, idx) in paginatedSimpleReviews"
                                                        :key="rev.reviewNo">
                                                        <!--페이지에 맞는 리뷰 표시-->
                                                        <tr>
                                                            <td>{{ (page - 1) * 5 + idx + 1 }} <span class="new-label"
                                                                    v-if="rev.updated === '1'">NEW</span></td>
                                                            <td>{{rev.content}}</td>
                                                            <td>{{rev.userId}}</td>
                                                            <td><span
                                                                    style="color: #ff6a00;">{{rev.rating}}</span><span>/5</span>
                                                            </td>
                                                        </tr>
                                                    </template>

                                                </tbody>
                                            </table>
                                            <div class="pagination1">
                                                <span v-for="num in totalSimplePages" :key="num">
                                                    <a @click="page = num" href="javascript:;"
                                                        :style="page === num ? 'color: #ff1493; border: 1px solid #ff1493;' : ''">
                                                        {{num}}
                                                    </a>
                                                </span> <!-- num 에 해당하는 페이지가 뜨고 그 페이지에 자료가 5개씩 표시되도록( )-->
                                            </div>
                                        </template>
                                        <template v-else>
                                            <div style="text-align: center; padding: 50px;">
                                                <h2 style="color: #ccc;">아직 작성된 리뷰가 없습니다!</h2>
                                            </div>
                                        </template>
                                    </template>


                                </template>
                            </div>
                        </main>
                    </div>


                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/common/footer.jsp" />



        <!-- <div class="ai-chatbot">ai 챗봇</div> -->
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    resCount: '',
                    newReviewCnt: 0,
                    newUnpaidReviewCnt: 0,
                    productNo: '',
                    totalSimpleReviewCnt: 0,
                    // 변수 - (key : value)
                    totalReviewCnt: 0,
                    productList3: [],
                    productList4: [],
                    inquiryList: [
                        { id: 1, product: '야외 스냅 기본', title: '투어 일정 변경하고 싶습니다.', userid: '김결혼', content: '04.01일 예약했는데 04.08일로 변경하고 싶어요.', imgUrl: "https://i.imgur.com/P4PQtwM.jpeg" },
                        { id: 2, product: '해변스냅', title: '메이크업 추가되나요?', userid: '아리랑', content: '메이크업 여기서 받고싶어요.', imgUrl: "https://i.imgur.com/rFfGfor.jpeg" },
                    ],
                    user: {
                        id: 1, name: 'ABC 드레스 샵', usePeriod: '25.01.01 ~ 26.01.01', lastPayment: '신협 ***', grade: '제휴업체' /* 일반업체, 제휴업체 구분 변수 */
                    },
                    currentMenu: 'main', // 초기 화면
                    reviewTab: 'detail',

                    page1: 'main', // 상품별 리뷰 페이지 구분 변수
                    productPage: 'list', //(list: 목록, reg: 등록, edit: 수정)

                    page: 1,
                    product: '',
                    product1: {},
                    proType: [],

                    //product === productList.        v-for = "pro in productList" :key="pro.id"   v-if="product === pro.name" 
                    productList: [  //상품 리스트
                        { id: 1, thumbnail: 'https://i.imgur.com/RwwCSsD.jpeg', name: '스몰 웨딩', content: '스몰 웨딩 상품 설명입니다.', price: '1,700,000원', category: ['스튜디오', '드레스'] },
                        { id: 2, thumbnail: 'https://i.imgur.com/zKxXEJ1.jpeg', name: '화려하게', content: '화려하게 상품 설명입니다.', price: '2,500,000원', category: ['스튜디오', '메이크업'] },
                        { id: 3, thumbnail: 'https://i.imgur.com/JyVciZk.jpeg', name: '동화같은 분위기', content: '동화같은 분위기 상품 설명입니다.', price: '1,200,000원', category: ['메이크업'] }
                    ],


                    simpleReviews: [
                        // 1~7: 스몰 웨딩 (7개)
                        { id: 1, product: '스몰 웨딩', content: '드레스 피팅 때 전문가 포스가 느껴져서 안심됐어요.', userid: '예신이1004', rating: 5, updated: 'new' },
                        { id: 2, product: '스몰 웨딩', content: '지정했던 드레스가 대여 중이라 다른 걸 입어 아쉬워요.', userid: '드레스투어중', rating: 3, updated: 'new' },
                        { id: 3, product: '스몰 웨딩', content: '메이크업 지속력이 좀 떨어져서 촬영 중간에 수정했어요.', userid: '수정화장필수', rating: 3, updated: 'new' },
                        { id: 4, product: '스몰 웨딩', content: '대기 공간이 좁아서 부모님 모시고 가기엔 좀 불편해요.', userid: '효도신부', rating: 2, updated: 'old' },
                        { id: 5, product: '스몰 웨딩', content: '드레스 상태가 조금 사용감이 느껴져서 아쉬웠습니다.', userid: '꼼꼼한체크', rating: 2, updated: 'old' },
                        { id: 6, product: '스몰 웨딩', content: '가까운 지인들만 모시는 자리에 딱 맞는 심플한 드레스가 많아요.', userid: '심플리즘', rating: 5, updated: 'old' },
                        { id: 7, product: '스몰 웨딩', content: '소규모 예식이라 걱정했는데 상담 실장님이 동선까지 잘 짜주셨어요.', userid: '미니멀라이프', rating: 4, updated: 'old' },

                        // 8~12: 화려하게 (5개)
                        { id: 8, product: '화려하게', content: '헬퍼 이모님이 세심하게 챙겨주셔서 공주 된 기분이었어요.', userid: '행복한웨딩', rating: 5, updated: 'new' },
                        { id: 9, product: '화려하게', content: '수입 드레스 라인이 정말 독보적이네요. 화려함 끝판왕!', userid: '비즈가좋아', rating: 5, updated: 'new' },
                        { id: 10, product: '화려하게', content: '실장님이 제 체형에 딱 맞는 드레스를 잘 골라주셨어요.', userid: '체형교정마법', rating: 5, updated: 'old' },
                        { id: 11, product: '화려하게', content: '야간 촬영 추가했는데 분위기가 정말 환상적이에요.', userid: '밤하늘의별', rating: 5, updated: 'old' },
                        { id: 12, product: '화려하게', content: '조명 아래서 비즈가 반짝이는 게 너무 예뻐서 눈을 뗄 수가 없었네요.', userid: '반짝이덕후', rating: 5, updated: 'old' },

                        // 13~15: 동화같은 분위기 (3개)
                        { id: 13, product: '동화같은 분위기', content: '스튜디오 채광이 너무 예뻐서 원본도 만족스러워요.', userid: '촬영끝행복시작', rating: 5, updated: 'old' },
                        { id: 14, product: '동화같은 분위기', content: '작가님이 긴장을 잘 풀어주셔서 자연스럽게 찍었습니다.', userid: '웃는게어색해', rating: 5, updated: 'old' },
                        { id: 15, product: '동화같은 분위기', content: '스튜디오 배경이 유행을 좀 탈 것 같지만 사진은 예쁩니다.', userid: '감성신부v', rating: 4, updated: 'old' }
                    ],
                    reviews: [
                        { id: 1, product: '스몰 웨딩', rating: 5, author: '김결혼', content: '웨딩 플래너님이 정말 세심하게 도와주셔서 만족스러웠어요.', date: '26.04.08', updated: 'new' },
                        { id: 2, product: '스몰 웨딩', rating: 4, author: '김tntn', content: '드레스 퀄리티가 기대 이상이었습니다!', date: '26.04.08', updated: 'new' },
                        { id: 3, product: '스몰 웨딩', rating: 5, author: '김발랄', content: '스튜디오 촬영 분위기가 너무 좋아서 즐겁게 찍었어요.', date: '26.04.08', updated: 'new' },
                        { id: 4, product: '스몰 웨딩', rating: 5, author: '김망고', content: '스냅 사진 퀄리티가 정말 좋아요.', date: '26.04.08', updated: 'new' },
                        { id: 5, product: '스몰 웨딩', rating: 3, author: '김딸기', content: '예식 진행 스태프들이 매우 프로페셔널했습니다.', date: '26.04.07', updated: 'old' },
                        { id: 6, product: '스몰 웨딩', rating: 4, author: '김포도', content: '예약 과정이 간편해서 좋았어요.', date: '26.04.07', updated: 'old' },
                        { id: 7, product: '스몰 웨딩', rating: 3, author: '김사과', content: '디테일까지 신경 써주셔서 감동이었습니다.', date: '26.04.07', updated: 'old' },
                        { id: 8, product: '스몰 웨딩', rating: 3, author: '김오렌지', content: '예산에 맞춰 잘 추천해주셔서 도움이 많이 됐어요.', date: '26.04.06', updated: 'old' },
                        { id: 9, product: '스몰 웨딩', rating: 5, author: '김자몽', content: '웨딩 촬영 결과물이 정말 만족스러웠습니다.', date: '26.04.05', updated: 'old' },
                        { id: 10, product: '스몰 웨딩', rating: 3, author: '김레몬', content: '당일 진행이 체계적이라 믿고 맡길 수 있었어요.', date: '26.04.05', updated: 'old' },
                        { id: 11, product: '스몰 웨딩', rating: 3, author: '김복숭아', content: '친구들에게도 추천하고 싶은 업체입니다.', date: '26.04.02', updated: 'old' },
                        { id: 12, product: '스몰 웨딩', rating: 5, author: '김수박', content: '상담부터 계약까지 과정이 투명했어요.', date: '26.04.02', updated: 'old' },
                        { id: 13, product: '스몰 웨딩', rating: 5, author: '김참외', content: '웨딩홀 연출이 너무 아름다웠습니다.', date: '26.04.01', updated: 'old' },
                        { id: 14, product: '스몰 웨딩', rating: 5, author: '김멜론', content: '가성비 좋은 패키지라 만족해요.', date: '26.04.01', updated: 'old' },
                        { id: 15, product: '스몰 웨딩', rating: 3, author: '김키위', content: '플래너님 응대가 빠르고 정확했습니다.', date: '26.04.01', updated: 'old' },

                        // 화려하게 (10개)
                        { id: 16, product: '화려하게', rating: 3, author: '김미미', content: '메이크업이 자연스럽고 예쁘게 잘 되었어요.', date: '26.04.08', updated: 'new' },
                        { id: 17, product: '화려하게', rating: 5, author: '김sksk', content: '상담부터 진행까지 전반적으로 만족합니다.', date: '26.04.08', updated: 'new' },
                        { id: 18, product: '화려하게', rating: 5, author: '김하늘', content: '예식 당일 진행이 매끄러워서 걱정 없이 진행했어요.', date: '26.04.08', updated: 'new' },
                        { id: 19, product: '화려하게', rating: 3, author: '김바다', content: '플래너님 덕분에 준비 과정이 훨씬 수월했습니다.', date: '26.04.05', updated: 'old' },
                        { id: 20, product: '화려하게', rating: 3, author: '김초코', content: '드레스 종류가 다양해서 선택하기 좋았어요.', date: '26.04.05', updated: 'old' },
                        { id: 21, product: '화려하게', rating: 5, author: '김쿠키', content: '촬영 작가님이 포즈도 잘 잡아주셔서 만족!', date: '26.04.04', updated: 'old' },
                        { id: 22, product: '화려하게', rating: 4, author: '김라떼', content: '웨딩홀 분위기가 정말 고급스러웠습니다.', date: '26.04.04', updated: 'old' },
                        { id: 23, product: '화려하게', rating: 5, author: '김모카', content: '상담이 친절하고 꼼꼼해서 신뢰가 갔어요.', date: '26.04.03', updated: 'old' },
                        { id: 24, product: '화려하게', rating: 5, author: '김코코', content: '헤어 스타일링이 마음에 쏙 들었습니다.', date: '26.04.02', updated: 'old' },
                        { id: 25, product: '화려하게', rating: 5, author: '김치즈', content: '전체 패키지 구성이 합리적이었어요.', date: '26.04.02', updated: 'old' },

                        // 동화같은 분위기 (5개)
                        { id: 26, product: '동화같은 분위기', rating: 5, author: '김파인', content: '드레스 피팅 경험이 정말 좋았어요.', date: '26.04.08', updated: 'new' },
                        { id: 27, product: '동화같은 분위기', rating: 5, author: '김체리', content: '소소한 요청도 잘 반영해주셔서 감사했습니다.', date: '26.04.08', updated: 'new' },
                        { id: 28, product: '동화같은 분위기', rating: 5, author: '김블루베리', content: '전체 일정 관리가 체계적이었어요.', date: '26.04.08', updated: 'new' },
                        { id: 29, product: '동화같은 분위기', rating: 5, author: '김라임', content: '결혼 준비 스트레스가 많이 줄었습니다.', date: '26.04.05', updated: 'old' },
                        { id: 30, product: '동화같은 분위기', rating: 5, author: '김코코넛', content: '인생에 한 번뿐인 날을 잘 만들어주셔서 감사합니다.', date: '26.04.01', updated: 'old' }
                    ],
                    reservationList: [
                        { id: 1, product: '동화같은 분위기', content: '몽환적인 야외 촬영 희망합니다.', resDate: '26.03.01', useDate: '26.04.01 14:00PM', name: '김결혼', contact: '010-1234-5678', price: '50,000원' },
                        { id: 2, product: '화려하게', content: '럭셔리한 호텔 연회장 예약 건입니다.', resDate: '26.03.05', useDate: '26.04.05 10:00AM', name: '5월신부', contact: '010-9876-5432', price: '100,000원' },
                        { id: 3, product: '스몰 웨딩', content: '직계 가족만 모시는 조용한 예식입니다.', resDate: '26.03.10', useDate: '26.04.10 16:00PM', name: '김tntn', contact: '010-5555-6666', price: '30,000원' },
                        { id: 4, product: '동화같은 분위기', content: '디즈니 컨셉 웨딩 상담 부탁드려요.', resDate: '26.03.12', useDate: '26.04.15 11:00AM', name: '이봄날', contact: '010-2222-3333', price: '50,000원' },
                        { id: 5, product: '화려하게', content: '조명이 화려한 웨딩홀을 원합니다.', resDate: '26.03.15', useDate: '26.04.18 13:00PM', name: '박정성', contact: '010-4444-5555', price: '100,000원' },
                        { id: 6, product: '스몰 웨딩', content: '펜션 전체 대관 스몰웨딩 상담입니다.', resDate: '26.03.18', useDate: '26.04.20 09:00AM', name: '최기록', contact: '010-7777-8888', price: '30,000원' },
                        { id: 7, product: '동화같은 분위기', content: '숲속 컨셉 촬영 예약입니다.', resDate: '26.03.20', useDate: '26.04.22 15:30PM', name: '정반짝', contact: '010-9999-0000', price: '50,000원' },
                        { id: 8, product: '화려하게', content: '풍성한 비즈 드레스 투어 희망합니다.', resDate: '26.03.22', useDate: '26.04.25 10:30AM', name: '강꽃님', contact: '010-1111-2222', price: '100,000원' },
                        { id: 9, product: '스몰 웨딩', content: '레스토랑 웨딩 식순 문의입니다.', resDate: '26.03.25', useDate: '26.04.28 17:00PM', name: '윤소식', contact: '010-3333-4444', price: '30,000원' },
                        { id: 10, product: '동화같은 분위기', content: '파스텔 톤 생화 장식 상담입니다.', resDate: '26.03.28', useDate: '26.05.02 12:00PM', name: '조전통', contact: '010-6666-7777', price: '50,000원' },
                        { id: 11, product: '화려하게', content: '대형 웨딩홀 촬영 스케줄 문의입니다.', resDate: '26.04.01', useDate: '26.05.05 14:00PM', name: '한찬란', contact: '010-8888-9999', price: '100,000원' }
                    ],
                    inquiry: [
                        { id: 1, }
                    ],
                    category: ["스튜디오", "드레스", "메이크업"],
                    selectedItems: [],
                    productForm: {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    },
                    pageSize: 0,
                    currentPage: 1,
                    previewUrl: null, // 미리보기용 URL
                    uploadFile: null,  // 서버로 보낼 실제 파일 객체
                    product2: {
                        companyNo: '',
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: '',
                        deposit: 0,
                        tag: []
                    },
                    tagMap: {
                        input1:'',
                        input2:'',
                        input3:'',
                        input4:'',
                        input5:''
                    },
                    serverTagList: [],
                }

            }, // data
            computed: {
                // resCount() {
                //     return this.reservationList.length;
                // }
                //,
                tagMapToList(){
                    const filteredtagArray = Object.values(this.tagMap).filter(tag => tag.trim() !== "");

                    //console.log(filteredtagArray);
                    return filteredtagArray;
                },
                newTagsOnly(){
                    if(!this.serverTagList) {
                        return tagMapToList();
                    }
                    
                    return this.tagMapToList.filter(t => !this.serverTagList.includes(t));

                },
                

                revCnt() {
                    return this.reviews.filter(r => r.updated === 'new').length
                        + this.simpleReviews.filter(r => r.updated === 'new').length;
                }
                ,
                editingProduct() {
                    // productList에서 이름이 일치하는 녀석을 찾고, 없으면 빈 객체{}를 반환
                    return this.productList.find(p => p.name === this.product) || {};
                },


                menuList() {
                    return [
                        { id: 'main', name: '마이 페이지', count: 0 },
                        { id: 'product', name: '상품 관리', count: 0 },
                        { id: 'reservation', name: '예약 관리', count: this.resCount },
                        { id: 'inquiry', name: '문의 내역', count: 2 },
                        { id: 'review', name: '리뷰 내역', count: this.newReviewCnt + this.newUnpaidReviewCnt },
                        { id: 'customer', name: '고객센터', count: 0 }
                    ];
                },
                weddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.reviews.filter(r => r.product === product.name).length,
                            thumbnail: product.thumbnail
                        }
                    })
                },
                simpleweddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.simpleReviews.filter(r => r.product === product.name).length,
                            thumbnail: product.thumbnail
                        }
                    })
                },


                filteredReviews() {
                    return this.reviews;
                    //return this.reviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },
                filteredSimpleReviews() {
                    return this.simpleReviews;
                    //return this.simpleReviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },



                paginatedReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },
                paginatedSimpleReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },

                fnPaginatedReservation() {
                    let start = (this.currentPage - 1) * 3;
                    let end = start + 3;
                    return this.reservationList.slice(start, end);
                },

                fnPaginatedInquiry() {
                    let start = this.currentPage - 1;
                    let end = start + 1;
                    return this.inquiryList.slice(start, end);
                    //(0, 1), (1, 2)
                },



                totalPages() {
                    return Math.ceil(this.filteredReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
                },
                totalSimplePages() {
                    return Math.ceil(this.filteredSimpleReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
                }
                ,
                totalPageReservation() {
                    return Math.ceil(this.reservationList.length / 3);
                },

                

            },
            methods: {
                // 함수(메소드) - (key : function())
                fnPageChange(num) {
                    this.currentPage = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                },
                fnCom: function () {
                    let self = this;
                    let param = {
                        userid: "${sessionScope.sessionId}" //이거 맞다
                    };
                    $.ajax({
                        url: "http://localhost:8080/company.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data); //info,result,message

                            self.user.name = data.info.comName;
                            self.user.usePeriod = data.info.usePeriod;
                            self.user.grade = data.info.grade;
                            self.user.lastPayment = data.info.lastPayment;

                            //console.log(self.user);
                        }
                    });
                },
                fnProductList: function () {
                    let self = this;
                    let param = {
                        userid: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "http://localhost:8080/productList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data);

                            self.productList3 = data.list; //덮어씌우기


                        }
                    });
                },

                withdraw: function () {
                    if (confirm("정말 탈퇴하시겠습니까?")) {
                        alert("탈퇴되었습니다.");
                    } else {
                        alert("탈퇴가 취소되었습니다.");
                    }
                },
                updateProduct: function () {
                    alert("상품이 수정되었습니다.");

                    this.productPage = 'list'; // 수정 후 상품 목록으로 돌아가기
                    // 여기야!!(+)
                },

                goEditPage(item) {
                    let self = this;
                    self.productPage = 'edit';

                    let param = {
                        userid: "${sessionScope.sessionId}",
                        productNo: item.productNo //파라미터로 보내주면되는구나~
                    };
                    $.ajax({
                        url: "http://localhost:8080/productDetail.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            // 1. 일단 전체 데이터를 담습니다.
                            self.product1 = data.info;//덮어씌우기
                            self.serverTagList = data.tagList;

                            

                            //
                            // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                            // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                            if (typeof self.product1.proType === 'string') {
                                try {
                                    let rawArray = JSON.parse(self.product1.proType);//["MAKEUP" , "STUDIO"]

                                    self.product1.proType = rawArray.map(val => {
                                        if (val === 'MAKEUP') {
                                            return '메이크업';
                                        } else if (val === 'DRESS') {
                                            return '드레스';
                                        } else if (val === 'STUDIO') {
                                            return '스튜디오';
                                        } else {
                                            return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                        } //self.product1.proType = ["메이크업", "스튜디오"]
                                    })
                                } catch (e) {
                                    // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                                    self.product1.proType = [];
                                }
                            }
                            if(typeof self.product1.tag === 'string'){
                                try {
                                    let rawArry = JSON.parse(self.product1.tag);

                                    self.product1.tag = rawArry;

                                    self.tagMap.input1 = self.product1.tag[0] || "";
                                    self.tagMap.input2 = self.product1.tag[1] || "";
                                    self.tagMap.input3 = self.product1.tag[2] || "";
                                    self.tagMap.input4 = self.product1.tag[3] || "";
                                    self.tagMap.input5 = self.product1.tag[4] || "";
                                } catch(e){
                                    self.product1.tag = [];
                                }
                            }

                        }
                    });
                },

                //프론트 만으로 되는거
                //goEditPage(item) {
                //    this.productPage = 'edit';
                //    this.product = item.name;
                // 중요: [... ]를 써서 원본이 아닌 '복사본'을 바구니에 담습니다.
                //    this.selectedItems = [...item.category];
                //},

                // [2] 등록 버튼 누를 때: 바구니 깨끗이 비우기
                goRegPage() {
                    this.productPage = 'reg';
                    this.product = ''; // 수정 대상이 없으므로 비워줍니다.
                    this.selectedItems = []; // 바구니를 비워야 등록창이 깨끗합니다.
                },

                // [3] 수정 완료 버튼 (Save)
                fnSave() {
                    // 1. 현재 어떤 상품을 찾으려 하는지 확인
                    console.log("현재 찾으려는 상품명:", this.product);
                    console.log("현재 바구니(체크된 것):", this.selectedItems);

                    // 2. productList에서 해당 상품 찾기
                    const item = this.productList.find(p => p.name === this.product);

                    if (item) {
                        // 3. 찾았다면 데이터 덮어씌우기
                        item.category = [...this.selectedItems];
                        console.log("수정 완료된 원본 데이터:", item);

                        alert("수정되었습니다!");
                        this.productPage = 'list';
                    } else {
                        // 4. 만약 못 찾았다면 왜 못 찾았는지 경고!
                        alert("수정 대상을 찾지 못했습니다. (콘솔창을 확인하세요)");
                        console.error("productList 안에 '" + this.product + "'와 일치하는 이름이 없습니다.");
                        console.log("현재 목록들:", this.productList.map(p => p.name));
                    }
                },
                fnAdd() {
                    const newProduct = {
                        id: this.productList.length > 0 ?
                            Math.max(...this.productList.map(p => p.id)) + 1 : 1,
                        thumbnail: this.productForm.thumbnail || "images/default-thumbnail.png",
                        name: this.productForm.name,
                        content: this.productForm.content,
                        price: this.productForm.price,
                        category: [...this.selectedItems]
                    }

                    this.productList.push({ ...newProduct });  //{...newProduct} <- 이게 복사본이야? (+)

                    alert("등록되었습니다!");
                    this.resetForm();

                    this.productPage = "list";


                },
                goRegPage2() {
                    this.product1 = {
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: '',
                        deposit: 0,
                        tag: []
                    }
                    this.productPage = 'reg';

                    let self = this;
                    let param = {

                    };
                    $.ajax({
                        url: "/getTagList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.serverTagList = data.tagList;
                        }
                    });
                    


                },
                resetForm() {
                    this.productForm = {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    }

                    this.selectedItems = [];

                },
                fnRemove(item) {
                    //fnRemove(프로덕트 리스트에 있는요소)

                    if (confirm("정말 삭제하시겠습니까?")) {

                        const removed = this.productList.find(p => p.id === item.id);
                        const index = this.productList.indexOf(removed);
                        //removed 객체의 인덱스를 구해라. 담아라.

                        if (index !== -1) {
                            this.productList.splice(index, 1);
                            //index 위치에서부터1개 데이터 삭제하고 인덱스들을 앞으로 당김.

                            this.reviews = this.reviews.filter(r => r.product !== item.name);
                            this.simpleReviews = this.simpleReviews.filter(r => r.product !== item.name);

                        }

                        alert("삭제되었습니다.");
                    } else {
                        alert("삭제가 취소되었습니다.");
                    }

                },
                fnThumbnail(i) {    //fnThumbnail(개별문의) 해변스냅
                    return this.inquiryList.find(p => p.product === i.product).imgUrl;
                    //return this.productList3.find(p => p.productName === inquiry.product).imgUrl;
                }
                ,
                handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
                    this.currentMenu = menuId;
                    this.productPage = 'list';
                    this.page = 1;
                    this.page1 = 'main';
                    this.reviewTab = 'detail';
                    this.currentPage = 1;

                    if (menuId === 'main') {
                        this.fnCom();
                    }
                    else if (menuId === 'product') {
                        this.fnProductList();
                    } else if (menuId === 'reservation') {
                        this.fnReservationList();
                    } else if (menuId === 'review') {

                        this.fnSimple();
                        this.fnReview();
                    }
                },




                fnFileChange(event) {
                    // 1. 이벤트가 일어난 대상(input)에서 선택된 파일들 중 첫 번째[0]를 가져와요.
                    const file = event.target.files[0];

                    if (file) {
                        // 2. 진짜 파일 덩어리를 우리 변수에 쏙 넣어둡니다.
                        this.uploadFile = file;

                        // 3. 브라우저가 "이 파일 내가 잠깐 보여줄 수 있게 가짜 주소 만들어줄게!" 하는 기능이에요.
                        this.previewUrl = URL.createObjectURL(file);

                    }
                },
                fnUpdateProduct() {
                    // 1. 택배 박스(FormData)를 하나 만듭니다.
                    // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
                    let self = this;
                    let formData = new FormData();

                    // 1. 사진 파일 담기(선택했을 때만)
                    if (this.uploadFile) {
                        formData.append("file", this.uploadFile);
                    }

                    // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
                    formData.append("productNo", this.product1.productNo);
                    formData.append("productName", this.product1.productName);
                    formData.append("productDetails", this.product1.productDetails);
                    formData.append("originalPrice", this.product1.originalPrice);

                    formData.append("deposit", this.product1.deposit);
                    formData.append("tag",JSON.stringify([...new Set(this.tagMapToList)]));

                    formData.append("proType", JSON.stringify(this.product1.proType));

                    formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

                    $.ajax({
                        url: "/upload.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                            // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)


                            if (res.result === "success") {
                                alert("상품 정보가 모두 수정되었습니다!");
                                console.log(res.message1);
                                window.location.href = "/partnerManagement.do";  //
                            } else {
                                alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                            }

                        }
                    })
                },
                fnInsertProduct() {
                    // 1. 택배 박스(FormData)를 하나 만듭니다.
                    // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
                    let self = this;
                    let formData = new FormData();

                    // 1. 사진 파일 담기(선택했을 때만)
                    if (this.uploadFile) {
                        formData.append("file", this.uploadFile);
                    }

                    // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
                    //formData.append("companyNo", this.product2.companyNo);
                    formData.append("productNo", this.product2.productNo);
                    formData.append("productName", this.product2.productName);
                    formData.append("productDetails", this.product2.productDetails);
                    formData.append("originalPrice", this.product2.originalPrice);

                    //
                    formData.append("deposit", this.product2.deposit);
                    formData.append("proType", JSON.stringify(this.product2.proType));
                    formData.append("userId", "${sessionScope.sessionId}");
                    
                    formData.append("tag",JSON.stringify([...new Set(this.tagMapToList)]));
                    formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

                    $.ajax({
                        url: "/upload2.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                            // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)


                            if (res.result === "success") {
                                alert("상품 정보가 모두 등록되었습니다!");
                                console.log(res.message1);
                                window.location.href = "/partnerManagement.do"; //
                            } else {
                                alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                            }

                        }
                    })
                },
                fnRemove2(item) {  //item in productList
                    if (confirm("정말 삭제하시겠습니까?")) {

                        let self = this;
                        let param = {
                            productNo: item.productNo
                        };
                        console.log(item);
                        $.ajax({
                            url: "/productRemove.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                                alert(data.message);
                                location.href = "/partnerManagement.do"
                            }
                        });



                    } else {
                        alert("삭제가 취소되었습니다.");
                    }
                },
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
                },
                fnReservationList: function () {
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "/ReservationList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.reservationList = data.list;
                            self.resCount = data.newResCnt;
                        }
                    });
                },
                fnReview() {
                    this.reviewTab = 'detail'

                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "/getReviewCnt.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.productList3 = data.list;
                            self.newReviewCnt = data.info.reviewCount;

                            let reviewCntList = self.productList3.map(p => p.reviewCount); //[3,0,1..];

                            let sum = 0;
                            for (let i = 0; i < reviewCntList.length; i++) {
                                sum += reviewCntList[i];
                            }

                            self.totalReviewCnt = sum;
                        }
                    });
                },
                fnSimple() {
                    this.reviewTab = 'simple'

                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "/getSimpleReviewCnt.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data);
                            self.productList4 = data.list;
                            self.newUnpaidReviewCnt = data.info.reviewCount;

                            let reviewCntList = self.productList4.map(p => p.reviewCount); //[3,0,1..];

                            let sum = 0;
                            for (let i = 0; i < reviewCntList.length; i++) {
                                sum += reviewCntList[i];
                            }

                            self.totalSimpleReviewCnt = sum;

                        }
                    });
                },
                fnReviewDetails3(w) {
                    this.page1 = 1;
                    this.page = 1;

                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}", //${sessionScope.sessionId}
                        productNo: w.productNo
                    };
                    console.log(param.productNo);
                    $.ajax({
                        url: "/ReviewDetails3.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            //console.log(data);
                            self.reviews = data.list;
                            //console.log(self.reviews);


                        }
                    });

                },
                fnSimpleReviewDetails3(w) {
                    this.page1 = 1;
                    this.page = 1;


                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}",
                        productNo: w.productNo
                    };

                    $.ajax({
                        url: "/SimpleReviewDetails3.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            self.simpleReviews = data.list;
                            //reviews, simpleReviews
                        }
                    });
                },
                fnPageChange2(num) {
                    this.page = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                },
                rating2(rev) {

                    rev.rating = rev.rating + "";

                    if (rev.rating.slice(0, 1) == 5) {
                        return '★★★★★';
                    } else if (rev.rating.slice(0, 1) == 4) {
                        return '★★★★☆';
                    } else if (rev.rating.slice(0, 1) == 3) {
                        return '★★★☆☆';
                    } else if (rev.rating.slice(0, 1) == 2) {
                        return '★★☆☆☆';
                    } else {
                        return '★☆☆☆☆';
                    }
                },

                uniqueNewTagsOnly(){
                    return [...new Set(this.newTagsOnly)];
                },
                fnBack3(){
                    this.tagMap = {};
                    //this.tagMapToList = [];
                    this.productPage = 'list'
                    this.product2.deposit = 0;
                }
                


            }, // methods


            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnCom();
                self.fnReservationList();
                self.fnSimple();
                self.fnReview();

            }


        });

        app.mount('#app');
    </script>