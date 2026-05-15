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
            #app {
                max-width: 1200px;
                margin: 0 auto;
                background: transparent;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            .container1 {
                display: flex;
                flex: 1;
                margin-top: 50px;
                background-color: #f5f2fc;
                
            }

            .left-banner {
                width: 320px;
                flex-shrink: 0;
            }

            main {
                flex: 1;
                padding: 30px;
            }

            .main-welcome-card {
                background: white;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 24px 28px;
                margin-bottom: 16px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                border-left: 4px solid #9b8fd4;
            }

            .main-welcome-card p {
                font-size: 15px;
                color: #333;
                line-height: 1.8;
            }

            .main-welcome-card strong {
                color: #9b8fd4;
                font-weight: 700;
            }

            .content-card {
                background-color: white;
                border: 1px solid #eee;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 20px;
                position: relative;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            }

            .section-title {
                background: #ffb400;
                display: inline-block;
                padding: 5px 15px;
                color: white;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .section-header {
                border-left: 4px solid #9b8fd4;
                padding-left: 12px;
                margin-bottom: 20px;
            }

            .section-header h2 {
                border: none;
                padding: 0;
                margin: 0;
                font-size: 1.3rem;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
                border-collapse: separate;
                border-spacing: 0;
                margin-bottom: 40px;
                background-color: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid #edf2f7;
            }
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background: #fef0f3;
                width: 120px;
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
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

            .tab-menu button {
                padding: 10px 20px;
                border: 1px solid #d4cdf0;
                border-bottom: none;
                background: #eee;
                cursor: pointer;
            }

            .tab-menu button.active {
                background: #9b8fd4;
                color: white;
                border-color: #9b8fd4;
            }

            .tab-menu button:first-child {
                border-radius: 8px 0 0 0px;
            }

            .tab-menu button:last-child {
                border-radius: 0 8px 0px 0;
            }
            
            .review-header-info {
                display: flex;
                align-items: center;
                gap: 16px;
                background: white;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 16px;
                margin-bottom: 12px;
                cursor: pointer;
                transition: 0.2s;
                position: relative;
            }

            .review-header-info:hover {
                border-color: #9b8fd4;
                box-shadow: 0 4px 12px rgba(155, 143, 212, 0.15);
                transform: translateY(-2px);
            }

            .review-thumb-box {
                width: 80px;
                height: 80px;
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
                background: #ccc2ff;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px #9285d1;
            }

            .pagination1 a:active {
                transform: translateY(0px);
            }

            .product-form-wrapper {
                background: white;
            }

            .product-form-section {
                margin-bottom: 25px;
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
            th {
                width: 180px;
                background-color: #f9fafb;
                color: #4a5568;
                font-weight: 600;
                text-align: left;
                padding: 14px 20px;
                border-bottom: 1px solid #edf2f7;
                border-right: 1px solid #edf2f7;
                font-size: 14px;
            }

            td {
                padding: 14px 20px;
                color: #2d3748;
                border-bottom: 1px solid #edf2f7;
                font-size: 15px;
                line-height: 1.6;
            }

            tr:last-child th,
            tr:last-child td {
                border-bottom: none;
            }

            h2 {
                font-size: 1.5rem;
                margin-bottom: 25px;
                padding-left: 10px;
            }

            .nav-container {
                background-color: transparent;
                background-color: #ede9f8;
                padding: 20px 10px;
                border-radius: 12px;
                display: flex;
                flex-direction: column;
                gap: 10px;
                border: 1px solid #9b8fd4;
                min-height: 100vh;
            }
            
            .nav-title {
                background-color: #9b8fd4;
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
            .nav-btn:hover {
                background: #9b8fd4;
                color: white;
                border-color: #9b8fd4;
            }

            .btn-edit {
                padding: 6px 14px;
                background: #9b8fd4;
                color: white;
                border: 1px solid #9b8fd4;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: 0.2s;
                margin-left: 10px;
            }

            .btn-edit:hover {
                background: white;
                color: #9b8fd4;
            }

            .btn-delete {
                padding: 6px 14px;
                background: #f4a096;
                color: white;
                border: 1px solid #f4a096;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: 0.2s;
                margin-left: 10px;
            }

            .btn-delete:hover {
                background: white;
                color: #f4a096;
            }

            .btn-product-reg {
                background: #ffb400;
                padding: 10px 24px;
                border: none;
                border-radius: 10px;
                font-weight: bold;
                cursor: pointer;
                color: white;
                font-size: 14px;
                transition: 0.2s;
            }

            .btn-product-reg:hover {
                background: #e0a500;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(240, 180, 41, 0.3);
            }

            .ticket-card {
                display: flex;
                align-items: center;
                gap: 16px;
                background: white;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 16px;
                margin-bottom: 12px;
                cursor: pointer;
                transition: 0.2s;
                position: relative;
            }

            .ticket-card:hover {
                border-color: #9b8fd4;
                box-shadow: 0 4px 12px rgba(155, 143, 212, 0.15);
                transform: translateY(-2px);
            }

            .ticket-img {
                width: 80px;
                height: 80px;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .ticket-info {
                flex: 1;
            }

            .ticket-no {
                font-size: 11px;
                color: #aaa;
                margin-bottom: 4px;
            }

            .ticket-name {
                font-size: 15px;
                font-weight: 700;
                color: #333;
                margin-bottom: 6px;
            }

            .ticket-date {
                font-size: 13px;
                color: #888;
            }

            .ticket-status {
                font-size: 12px;
                font-weight: 700;
                padding: 4px 10px;
                border-radius: 20px;
            }

            .ticket-status.wait {
                background: #eef0ff;
                color: #3714ff;
            }

            .ticket-status.cancel {
                background: #fff0f0;
                color: red;
            }

            .ticket-status.done {
                background: #f0fff4;
                color: green;
            }

            .ticket-detail-label {
                writing-mode: vertical-rl;
                font-size: 11px;
                color: #bbb;
                letter-spacing: 2px;
                padding: 0 8px;
                border-left: 1px solid #eee;
            }

            .btn-back {
                padding: 8px 18px;
                background: white;
                border: 1px solid #9b8fd4;
                color: #9b8fd4;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                margin-bottom: 20px;
                transition: 0.2s;
            }

            .btn-back:hover {
                background: #9b8fd4;
                color: white;
            }

            .btn-reply {
                background: #ffb400;
                color: white;
                margin-top: 10px;
                padding: 10px 20px;
                border: none;
                display: block;
                margin-left: auto;
                cursor: pointer;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 500;
                transition: 0.2s;
            }

            .btn-reply:hover {
                background: #e0a500;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(240, 180, 41, 0.3);
            }

            .review-text-limit {
                display: -webkit-box;
                -webkit-line-clamp: 5;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                line-height: 1.6;
                max-height: 8em;
            }

            .user-grade{
                text-align: right;
                font-size: 20px;
            }
            .user-nopartner{
                text-align: right;
            }
            .productlist-productReg{
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-left: 10px;
            }
            .PaginatedProductList{
                display: flex;
                align-items: center;
                padding: 15px;
            }
            .imgUrl{
                width: 100px; 
                height: 100px; 
                display: flex; 
                align-items: center;
                justify-content: center; 
                margin-right: 20px;
            }
            .productImg{
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 10px;
            }
            .registeredProductList{
                flex: 1;
                display: flex;
                flex-direction: column; 
                justify-content: center;
            }
            .originalPrice{
                display: flex;
                align-items: center;
                gap: 2px;
            }
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
                        <main>
                            <div v-if="currentMenu === 'main'">
                                <h2>안녕하세요, '{{ user.name }}'님!</h2>
                                <div class="section-title" v-if="user.grade === 'PARTNER'">제휴업체</div>
                                <div class="section-title" v-else-if="user.grade === 'NPARTNER'">일반업체</div>
                                <div class="content-card">
                                    <h3><span v-if="user.grade === 'PARTNER'">제휴업체 등록(결제) 일자</span></h3>
                                    <h3><span v-if="user.grade === 'NPARTNER'">일반업체 등록 일자</span></h3>
                                    <p v-if="user.grade === 'PARTNER'" class="user-grade">{{
                                        user.payDate }}</p>
                                    <p v-if="user.grade === 'NPARTNER'" class="user-grade">{{
                                        user.regDate }}</p>

                                </div>
                                <div v-if="user.grade === 'NPARTNER'" class="user-nopartner">
                                    <button class="btn-product-reg" @click="fnRegPTN">제휴 업체로 등록하기</button>
                                </div>
                                <div><span v-if="user.grade === 'NPARTNER'">*관리자가 승인후 제휴업체 등급이 됩니다!</span></div>
                            </div>

                            <div v-if="currentMenu === 'product'">

                                <div v-if="productPage === 'list'">
                                    <div
                                        class="productlist-productReg">
                                        <div class="section-header">
                                            <h2>등록한 상품({{ registeredProductList.length }})</h2>
                                        </div>
                                        <button @click="fnRegPage" class="btn-product-reg">상품등록</button>
                                    </div>
                                    <div v-for="(i, idx) in fnPaginatedProductList" :key="idx" class="content-card PaginatedProductList">
                                        <div
                                            class="imgUrl">
                                            <!--{{ i.thumbnail }}-->
                                            <img :src="i.imgUrl" :alt="i.productName"
                                                class="productImg">
                                        </div>
                                        <div class="registeredProductList">
                                            <div class="ticket-no">No. {{ registeredProductList.length - ((productCurrentPage - 1)
                                                * 5 + idx ) }}</div>
                                            <div style="flex: 1; font-weight: bold;">{{ i.productName }}</div>
                                            <!-- {{i}} -->
                                        </div>
                                        
                                        <div class="originalPrice">
                                            <div>{{ Number(i.originalPrice).toLocaleString() }}원</div>
                                            <button @click="fnEditPage(i)" class="btn-edit">수정하기</button>
                                            <button @click="fnRemoveProduct(i)" class="btn-delete">삭제하기</button>
                                        </div>
                                    </div>
                                    <!-- 여기에 페이징이 있어야 해요 -->
                                    <div class="pagination1">
                                        <span v-for="num in totalProductPages" :key="num">
                                            <a @click="productCurrentPage = num" href="javascript:;"
                                                :style="productCurrentPage === num ? 'color: #9b8fd4; border: 1px solid #9b8fd4;' : ''">
                                                {{ num }}
                                            </a>
                                        </span>
                                    </div>

                                </div>

                                <!-- 상품 등록 폼 -->
                                <div v-else-if="productPage === 'reg'">
                                    <div class="product-form-wrapper"
                                        style="max-width: 900px; margin: 20px auto; padding: 40px; background-color: #ffffff; border-radius: 15px; box-shadow: 0 10px 30px rgba(106, 90, 205, 0.1); font-family: 'Pretendard', sans-serif;">
                                        <!-- {{serverTagList}}
                                        {{newTagsOnly}}
                                        {{uniqueNewTagsOnly()}} -->
                                        <h2
                                            style="color: #6a5acd; margin-bottom: 30px; font-weight: 800; border-left: 5px solid #9a8cff; padding-left: 15px;">
                                            상품 등록하기</h2>

                                        <div class="product-form-section"
                                            style="margin-bottom: 35px; border: 1px solid #e0d7ff; border-radius: 10px; overflow: hidden;">
                                            <div class="form-title-box"
                                                style="background-color: #9a8cff; color: white; padding: 12px 20px; font-weight: bold; font-size: 16px;">
                                                상품 기본 정보</div>
                                            <div class="form-content-box"
                                                style="padding: 30px; background-color: #faf9ff;">


                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">상품
                                                        이름</label>
                                                    <div class="form-info-box">
                                                        <input type="text" placeholder="여기에 상품 이름을 적어주세요."
                                                            style="width: 100%; max-width: 400px; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none; font-size: 14px;"
                                                            v-model="initializedOneProductDetails.productName">
                                                    </div>
                                                </div>




                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">카테고리</label>
                                                    <div class="category-group"
                                                        style="display: flex; gap: 20px; flex-wrap: wrap; background: white; padding: 15px; border-radius: 8px; border: 1px solid #d1ccff;">
                                                        <div class="category-item" v-for="item in category" :key="item">
                                                            <label
                                                                style="cursor: pointer; font-size: 14px; color: #666; display: flex; align-items: center; gap: 5px;">
                                                                <input type="checkbox" :value="item"
                                                                    style="accent-color: #6a5acd;"
                                                                    v-model="initializedOneProductDetails.proType">{{item}}
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">상품
                                                        태그</label>
                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px;">
                                                        <input type="text" placeholder="첫번째 태그" v-model="tagMap.input1"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="두번째 태그" v-model="tagMap.input2"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="세번째 태그" v-model="tagMap.input3"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="네번째 태그" v-model="tagMap.input4"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="다섯번째 태그" v-model="tagMap.input5"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                    </div>


                                                </div>
                                                <!-- {{tagMap}}
                                                {{tagMapToList}} -->

                                                <div class="form-group" style="margin-bottom: 25px;">

                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">상품
                                                        설명</label>
                                                    <div class="form-info-box">
                                                        <textarea placeholder="상품에 대한 자세한 설명을 입력하세요."
                                                            v-model="initializedOneProductDetails.productDetails"
                                                            style="width: 100%; height: 120px; padding: 15px; border: 1px solid #d1ccff; border-radius: 8px; outline: none; resize: none; font-size: 14px;"></textarea>
                                                    </div>
                                                </div>
                                                <div style="display: flex; gap: 20px;">
                                                    <div class="form-group" style="flex: 1;">

                                                        <label class="form-label"
                                                            style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;"><span
                                                                class="form-info-label">예상
                                                                견적</span></label>
                                                        <div class="form-info-box">
                                                            <input placeholder="여기에 견적을 적어주세요." type="text"
                                                                style="width: 100%; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none;"
                                                                v-model="initializedOneProductDetails.originalPrice">
                                                        </div>
                                                    </div>
                                                    <div class="form-group" style="flex: 1;">
                                                        <label class="form-label"
                                                            style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;"><span
                                                                class="form-info-label">예약금</span></label>
                                                        <div class="form-info-box">
                                                            <input placeholder="여기에 예약금을 적어주세요." type="text"
                                                                style="width: 100%; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none;"
                                                                v-model="initializedOneProductDetails.deposit">
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- {{initializedOneProductDetails.deposit}} -->
                                            </div>
                                        </div>

                                        <div class="product-form-section"
                                            style="margin-bottom: 35px; border: 1px solid #e0d7ff; border-radius: 10px; overflow: hidden;">
                                            <div class="form-title-box"
                                                style="background-color: #9a8cff; color: white; padding: 12px 20px; font-weight: bold; font-size: 16px;">
                                                상품 이미지</div>
                                            <div class="form-content-box"
                                                style="padding: 30px; background-color: #faf9ff;">
                                                <div class="form-group">
                                                    <div style="margin-bottom: 15px; font-weight: bold; color: #444;">
                                                        등록할 이미지 :
                                                    </div>

                                                    <label
                                                        style="background: #6a5acd; color: white; padding: 10px 25px; cursor: pointer; border-radius: 8px; font-weight: 600; display: inline-block; transition: 0.3s; box-shadow: 0 4px 10px rgba(106, 90, 205, 0.2);">
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
                                            <button class="btn-cancel" @click="fnBackToList">취소(돌아가기)</button>
                                            <button class="btn-submit" @click="fnInsertProduct">상품 등록</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- 상품 수정 폼 -->
                                <div v-else-if="productPage === 'edit'">
                                    <div class="product-form-wrapper"
                                        style="max-width: 900px; margin: 20px auto; padding: 40px; background-color: #ffffff; border-radius: 15px; box-shadow: 0 10px 30px rgba(106, 90, 205, 0.1); font-family: 'Pretendard', sans-serif;">
                                        <!-- {{serverTagList}}
                                        {{newTagsOnly}}
                                        {{uniqueNewTagsOnly()}} -->
                                        <h2
                                            style="color: #6a5acd; margin-bottom: 30px; font-weight: 800; border-left: 5px solid #9a8cff; padding-left: 15px;">
                                            상품 수정하기</h2>

                                        <div class="product-form-section"
                                            style="margin-bottom: 35px; border: 1px solid #e0d7ff; border-radius: 10px; overflow: hidden;">
                                            <div class="form-title-box"
                                                style="background-color: #9a8cff; color: white; padding: 12px 20px; font-weight: bold; font-size: 16px;">
                                                상품 기본 정보</div>
                                            <div class="form-content-box"
                                                style="padding: 30px; background-color: #faf9ff;">

                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">상품
                                                        이름</label>
                                                    <div class="form-info-box">
                                                        <input type="text" placeholder="여기에 상품 이름을 적어주세요."
                                                            style="width: 100%; max-width: 400px; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none; font-size: 14px;"
                                                            v-model="oneProductDetails.productName">
                                                    </div>
                                                </div>
                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">카테고리</label>
                                                    <div class="category-group"
                                                        style="display: flex; gap: 20px; flex-wrap: wrap; background: white; padding: 15px; border-radius: 8px; border: 1px solid #d1ccff;">

                                                        <div class="category-item" v-for="item in category" :key="item">
                                                            <label
                                                                style="cursor: pointer; font-size: 14px; color: #666; display: flex; align-items: center; gap: 5px;">
                                                                <input type="checkbox" :value="item"
                                                                    style="accent-color: #6a5acd;"
                                                                    v-model="oneProductDetails.proType">{{item}}
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label"
                                                        style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;">상품
                                                        태그</label>

                                                    <div
                                                        style="display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px;">
                                                        <input type="text" placeholder="첫번째 태그" v-model="tagMap.input1"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="두번째 태그" v-model="tagMap.input2"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="세번째 태그" v-model="tagMap.input3"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="네번째 태그" v-model="tagMap.input4"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                        <input type="text" placeholder="다섯번째 태그" v-model="tagMap.input5"
                                                            style="padding: 10px; border: 1px solid #d1ccff; border-radius: 6px; outline: none;">
                                                    </div>

                                                </div>
                                                <!-- {{tagMap}}
                                                {{tagMapToList}}
                                                {{oneProductDetails}} -->
                                                <div class="form-group" style="margin-bottom: 25px;">
                                                    <label class="form-label">상품 설명</label>
                                                    <div class="form-info-box">
                                                        <textarea
                                                            style="width: 100%; height: 120px; padding: 15px; border: 1px solid #d1ccff; border-radius: 8px; outline: none; resize: none; font-size: 14px;"
                                                            placeholder="상품에 대한 자세한 설명을 입력하세요."
                                                            v-model="oneProductDetails.productDetails"></textarea>
                                                    </div>
                                                </div>
                                                <div style="display: flex; gap: 20px;">
                                                    <div class="form-group" style="flex: 1;">
                                                        <label class="form-label"
                                                            style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;"><span
                                                                class="form-info-label">예상
                                                                견적</span></label>
                                                        <div class="form-info-box">

                                                            <input type="text" placeholder="여기에 견적을 적어주세요."
                                                                style="width: 100%; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none;"
                                                                v-model="oneProductDetails.originalPrice">
                                                        </div>
                                                    </div>

                                                    <div class="form-group" style="flex: 1;">
                                                        <label class="form-label"
                                                            style="display: block; font-weight: 600; color: #444; margin-bottom: 10px; font-size: 15px;"><span
                                                                class="form-info-label">예약금</span></label>
                                                        <div class="form-info-box">
                                                            <input placeholder="여기에 예약금을 적어주세요." type="text"
                                                                style="width: 100%; padding: 12px; border: 1px solid #d1ccff; border-radius: 8px; outline: none;"
                                                                v-model="oneProductDetails.deposit">
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- {{oneProductDetails.deposit}} -->
                                            </div>
                                        </div>

                                        <div class="product-form-section"
                                            style="margin-bottom: 35px; border: 1px solid #e0d7ff; border-radius: 10px; overflow: hidden;">
                                            <div class="form-title-box"
                                                style="background-color: #9a8cff; color: white; padding: 12px 20px; font-weight: bold; font-size: 16px;">
                                                상품 이미지</div>
                                            <div class="form-content-box"
                                                style="padding: 30px; background-color: #faf9ff;">
                                                <div class="form-group">
                                                    <div style="margin-bottom: 15px; font-weight: bold; color: #444;">기존
                                                        이미지 : </div>
                                                    <div class="image-editor-box">
                                                        <img :src="oneProductDetails.imgUrl"
                                                            style="max-width: 500px; max-height: 500px;">
                                                    </div>
                                                    <br>
                                                    <div style="margin-bottom: 15px; font-weight: bold; color: #444;">
                                                        수정할 이미지 :
                                                    </div>
                                                    <!-- 이미지 첨부 -->
                                                    <label
                                                        style="background: #6a5acd; color: white; padding: 10px 25px; cursor: pointer; border-radius: 8px; font-weight: 600; display: inline-block; transition: 0.3s; box-shadow: 0 4px 10px rgba(106, 90, 205, 0.2);">
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
                                            <button class="btn-cancel" @click="fnBackToList">취소(돌아가기)</button>
                                            <button class="btn-submit" @click="fnUpdateProduct">상품 수정</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- 예약관리 페이지 -->
                            <div v-if="currentMenu === 'reservation'">
                                <div class="section-header">
                                    <h2>예약 관리 : <span style="color:#9b8fd4;">새 예약 {{ resCount }}건</span></h2>
                                </div><!-- 티켓 목록 -->
                                <template v-if="!selectedRes">
                                    <div class="ticket-card" v-for="(res, idx) in pagedResList" :key="idx"
                                        @click="selectedRes = res">
                                        <img class="ticket-img"
                                            :src="registeredProductList.find(p => p.productName === res.productName)?.imgUrl"
                                            :alt="res.productName"
                                            v-if="registeredProductList.find(p => p.productName === res.productName)?.imgUrl">
                                        <div class="ticket-info">
                                            <div class="ticket-no">No. {{ reservationList.length - ((resCurrentPage - 1)
                                                * 5 + idx ) }}</div>
                                            <div class="ticket-name">{{ res.productName }}</div>
                                            <div class="ticket-date">예약 날짜/시간 : {{ res.useDate }} {{ res.useTime }}
                                            </div>
                                            <div style="margin-top:6px;">
                                                <span class="ticket-status"
                                                    :class="res.resStatus === 'WAIT' ? 'wait' : res.resStatus === 'CANCEL' ? 'cancel' : 'done'">
                                                    {{ getResStatusText(res.resStatus)}}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="ticket-detail-label">DETAIL</div>
                                    </div>

                                    <!-- 페이징 -->
                                    <div class="pagination1">
                                        <span v-for="num in totalResPageCount" :key="num">
                                            <a @click="resCurrentPage = num" href="javascript:;"
                                                :style="resCurrentPage === num ? 'color: #9b8fd4; border:1px solid  \#9b8fd4 ;' : ''">
                                                {{ num }}
                                            </a>
                                        </span>
                                    </div>
                                </template>

                                <template v-else>
                                    <button class="btn-back" @click="selectedRes = null">← 목록으로</button>
                                    <table>
                                        <tr>
                                            <th>예약 상품</th>
                                            <td>{{ selectedRes.productName }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약 내용/요청 사항</th>
                                            <td>{{ selectedRes.resContent === '' ? '요청사항 없음' : selectedRes.resContent }}
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>예약저장</th>
                                            <td>{{ selectedRes.resDate }} {{ selectedRes.resTime }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약결제</th>
                                            <td>{{ selectedRes.payDate === undefined ? '(미결제)' : '(결제완료)' +
                                                selectedRes.payDate }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약 날짜/시간</th>
                                            <td>{{ selectedRes.useDate }} {{ selectedRes.useTime }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약자명</th>
                                            <td>{{ selectedRes.resUserId }}</td>
                                        </tr>
                                        <tr>
                                            <th>연락처</th>
                                            <td>{{ selectedRes.tel }}</td>
                                        </tr>
                                        <tr>
                                            <th>예약금</th>
                                            <td>{{ Number(selectedRes.deposit).toLocaleString() }}원</td>
                                        </tr>
                                        <tr>
                                            <th>예약 처리상태</th>
                                            <td
                                                :style="selectedRes.resStatus === 'WAIT' ? 'color:#3714ff;' : selectedRes.resStatus === 'CANCEL' ? 'color:red;' : ''">
                                                {{ selectedRes.resStatus }}
                                            </td>
                                        </tr>
                                    </table>
                                </template>
                           
                            </div>

                            <div v-if="currentMenu === 'inquiry'">
                                <!-- {{productPage}}
                                {{viewPage}} -->
                                <template v-if="viewPage === 'main'">
                                    <div class="section-header">
                                        <h2>문의 관리 : <span style="color:#9b8fd4;">전체 문의 {{inquiryList.length}}건</span>
                                        </h2>
                                    </div>
                                    <div class="content-card" v-for="i in fnPaginatedInquiry" :key="i">

                                        <div style="display: flex;">
                                            <div
                                                style="width: 100px; height: 100px;  margin-right: 20px; text-align: center;">
                                                <img :src="fnThumbnail(i)" :alt="i.productName"
                                                    class="productImg">

                                            </div>
                                            <h3>상품명 : <span style="color: #d6336c;">{{i.productName}}</span> </h3>

                                        </div>
                                        <table>
                                            <tr>
                                                <th>제목</th>
                                                <td>{{i.inquiryTitle}}</td>
                                            </tr>
                                            <tr>
                                                <th>작성자</th>
                                                <td>{{i.userId}}</td>
                                            </tr>
                                            <tr>
                                                <th>내용</th>
                                                <td>{{i.inquiryContents}}</td>
                                            </tr>
                                            <tr>
                                                <th>답변 여부</th>
                                                <td v-if="i.inquiryAns === '1'" style="color:#0099ff">답변 완료</td>
                                                <td v-else>아직 답변하지 않음</td>
                                            </tr>
                                        </table>
                                        <button class="btn-reply" @click="fnAnswerToProductInquiry(i)">답변하기</button>

                                    </div>
                                    <div class="pagination1">
                                        <span v-for="num in inquiryList.length" :key="num">
                                            <a @click="currentPage = num" href="javascript:;"
                                                :style="currentPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
                                                {{num}}
                                            </a> <!-- 1,2-->
                                        </span>
                                    </div>

                                </template>
                                <template v-if="viewPage === 'answer'">
                                    <div
                                        style="padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff; max-width: 800px; margin: 0 auto;">

                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #333;">
                                            <h2 style="margin: 0; font-size: 1.5rem; color: #333;">문의 답변 등록</h2>
                                            <button @click="fnBacktoInquiry"
                                                style="padding: 8px 16px; background-color: #f4f4f4; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; font-size: 0.9rem;">
                                                ← 리스트로 돌아가기
                                            </button>
                                        </div>

                                        <div
                                            style="margin-bottom: 30px; padding: 15px; background-color: #f9f9f9; border-radius: 4px; border: 1px solid #eaeaea;">
                                            <h3
                                                style="margin-top: 0; color: #555; border-bottom: 1px solid #ddd; padding-bottom: 8px;">
                                                원본 문의 내용</h3>

                                            <table
                                                style="width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 0.95rem;">
                                                <colgroup>
                                                    <col style="width: 20%; background-color: #eee;">
                                                    <col style="width: 30%;">
                                                    <col style="width: 20%; background-color: #eee;">
                                                    <col style="width: 30%;">
                                                </colgroup>
                                                <tr>
                                                    <th
                                                        style="padding: 10px; border: 1px solid #ddd; text-align: left;">
                                                        문의 번호</th>
                                                    <td style="padding: 10px; border: 1px solid #ddd;">{{
                                                        inquiryDetails.inquiryNo }}</td>
                                                    <th
                                                        style="padding: 10px; border: 1px solid #ddd; text-align: left;">
                                                        작성자 ID</th>
                                                    <td style="padding: 10px; border: 1px solid #ddd;">{{
                                                        inquiryDetails.userId }}</td>
                                                </tr>
                                                <tr>
                                                    <th
                                                        style="padding: 10px; border: 1px solid #ddd; text-align: left;">
                                                        문의 제목</th>
                                                    <td colspan="3"
                                                        style="padding: 10px; border: 1px solid #ddd; font-weight: bold;">
                                                        {{ inquiryDetails.inquiryTitle }}</td>
                                                </tr>
                                                <tr>
                                                    <th
                                                        style="padding: 10px; border: 1px solid #ddd; text-align: left; vertical-align: top;">
                                                        문의 내용</th>
                                                    <td colspan="3"
                                                        style="padding: 10px; border: 1px solid #ddd; min-height: 100px; white-space: pre-wrap;">
                                                        {{ inquiryDetails.inquiryContents }}</td>
                                                </tr>
                                            </table>
                                        </div>

                                        <div>
                                            <h3 style="margin-top: 0; color: #333;">답변 달기</h3>
                                            <!-- {{inquiryAnswer}} -->

                                            <div style="margin-top: 15px;">
                                                <label
                                                    style="display: block; margin-bottom: 8px; font-weight: bold; color: #555;">답변자</label>
                                                <input v-model="inquiryAnswer.ansUserId"
                                                    placeholder="답변을 작성한 담당자명을 입력해주세요."
                                                    style="width: 50%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; resize: vertical; font-family: inherit; font-size: 1rem; box-sizing: border-radius;">
                                            </div>


                                            <div style="margin-top: 15px;">
                                                <label
                                                    style="display: block; margin-bottom: 8px; font-weight: bold; color: #555;">답변
                                                    내용</label>
                                                <textarea v-model="inquiryAnswer.answerContents"
                                                    placeholder="문의에 대한 정성스러운 답변을 작성해 주세요."
                                                    style="width: 100%; height: 200px; padding: 12px; border: 1px solid #ccc; border-radius: 4px; resize: vertical; font-family: inherit; font-size: 1rem; box-sizing: border-radius;"></textarea>
                                            </div>

                                            <div
                                                style="margin-top: 25px; text-align: center; display: flex; justify-content: center; gap: 15px;">
                                                <button @click="fnBacktoInquiry"
                                                    style="padding: 12px 24px; background-color: #fff; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; font-size: 1rem; color: #333;">
                                                    취소
                                                </button>
                                                <button @click="fnSaveAnswer"
                                                    style="padding: 12px 24px; background-color: #ff1493; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; color: #fff; font-weight: bold;">
                                                    <span v-if="inquiryAnswer.inquiryAns === '0'">답변 등록하기</span>
                                                    <span v-else>답변 수정하기</span>
                                                </button>

                                            </div>
                                        </div>

                                    </div>

                                </template>

                            </div>

                            <div v-if="currentMenu === 'review'">
                                <!--viewPage 이 main인경우-->
                                <template v-if="viewPage === 'main'">
                                    <div class="tab-menu">
                                        <button :class="{ active: reviewTab === 'detail' }" @click="fnReview">유료
                                            리뷰({{totalReviewCnt}})
                                        </button>

                                        <button :class="{ active: reviewTab === 'simple' }" @click="fnSimple">무료
                                            리뷰({{totalSimpleReviewCnt}})
                                        </button>
                                    </div>

                                    <div v-if="reviewTab === 'detail'" class="content-card">
                                        <!-- 유료 리뷰 탭 -->
                                        <h3>유료 리뷰 내역 : <span style="color: #ff1493;">새 리뷰 {{newReviewCnt}}건</span></h3>
                                        <template v-for="(w, idx) in pagedRegisteredProductList" :key="idx">
                                            <div class="review-header-info" style="margin-bottom: 10px;"
                                                @click="fnReviewDetails(w)">
                                                <div class="review-thumb-box">
                                                    <img :src="w.imgUrl"
                                                        class="productImg">
                                                </div>

                                                <div class="review-product-name">
                                                    <div class="ticket-no">No. {{ registeredProductList.length - ((reviewListPage - 1)
                                                * 5 + idx ) }}</div>
                                                    <a href="javascript:;"
                                                        style="text-decoration: none; color:#0b3f8e;"><strong>{{w.productName}}</strong></a>
                                                </div>
                                                
                                                <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                                            </div>
                                        </template>
                                        <!-- 페이징 추가 -->
                                        <div class="pagination1">
                                            <span v-for="num in totalReviewListPages" :key="num">
                                                <a @click="reviewListPage = num" href="javascript:;"
                                                    :style="reviewListPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
                                                    {{ num }}
                                                </a>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- 무료 리뷰 탭 -->
                                    <div v-if="reviewTab === 'simple'" class="content-card">

                                        <h3>무료 리뷰 내역 : <span style="color: #ff1493;">새 리뷰 {{newUnpaidReviewCnt}}건</span>
                                        </h3>

                                        <template v-for="(w,idx) in pagedProductListForSimpleReviews" :key="idx">

                                            <div class="review-header-info" style="margin-bottom: 10px;"
                                                @click="fnSimpleReviewDetails(w)">
                                                <div class="review-thumb-box">
                                                    <img :src="w.imgUrl"
                                                        class="imgUrl">
                                                </div>
                                                <div class="review-product-name">
                                                    <!--totalSimpleReviewCnt-->
                                                    <div class="ticket-no">No. {{ registeredProductList.length - ((reviewListPage - 1)
                                                * 5 + idx ) }}</div>
                                                    <a href="javascript:;"
                                                        style="text-decoration: none; color:#0b3f8e;"><strong>{{w.productName}}</strong></a>

                                                </div>
                                                <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                                            </div>
                                        </template>
                                        <!-- 페이징 추가 -->
                                        <div class="pagination1">
                                            <span v-for="num in totalSimpleReviewListPages" :key="num">
                                                <a @click="reviewListPage = num" href="javascript:;"
                                                    :style="reviewListPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
                                                    {{ num }}
                                                </a>
                                            </span>
                                        </div>
                                    </div>
                                </template>

                                <!--viewPage이 main이 아닌 경우-->
                                <template v-else> <!--viewPage != 'main'-->
                                    <!-- 1
                                    {{reviewTab}}
                                    {{reviews}} -->
                                    <!-- reviewTab === 'detail' 인 경우-->
                                    <template v-if="reviewTab === 'detail'">
                                        <button class="btn-back" @click="fnGoBackToList()">← 목록으로</button>
                                        <template v-if="reviews && reviews.length > 0">

                                            <div v-for="(rev, idx) in paginatedReviews" :key="idx" @click="rev.isExpanded = !rev.isExpanded" style="cursor: pointer; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px;"
                                                class="detail-review-item">
                                                <!-- {{rev}} -->
                                                <div class="star-rating">평점 : {{starRating(rev)}}</div>
                                                <!-- {{rev.rating}}/5 -->

                                                <div style="display: flex; gap: 20px;">
                                                    <div style="position: relative;">
                                                        <span class="new-label" v-if="rev.updated === '1'"
                                                            style="position: absolute; top: -5px; left: -5px;">NEW
                                                        </span>
                                                        <div class="review-photo">
                                                            <img :src="rev.thumbnailUrl" :alt="rev.imgDescription"
                                                                class="imgUrl">
                                                        </div>
                                                    </div>
                                                    <div :class="{ 'review-text-limit' : !rev.isExpanded }" style="color: #666; font-size: 15px;" > 
                                                        {{cleanText(rev.content)}}
                                                    </div>

                                                    <div style="margin-top: 5px; color: #9a8cff; font-size: 13px; font-weight: bold;">
                                                        {{ rev.isExpanded ? '접기 ▲' : '더보기 ▼' }}
                                                    </div>
                                                </div>
                                                <div
                                                    style="text-align: right; font-size: 13px; color: #888; margin-top: 15px; border-top: 1px dashed #eee; padding-top: 10px;">
                                                    작성자: <strong>{{rev.userId}}</strong> | 작성일자: {{rev.regDate}}
                                                </div>
                                                <hr>
                                            </div>
                                            <div class="pagination1">
                                                <span v-for="num in totalPages" :key="num">
                                                    <a @click="fnPageChange(num)" href="javascript:;"
                                                        :style="currentPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
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
                                        <button class="btn-back" @click="fnGoBackToList()">← 목록으로</button>

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
                                                            <td>{{ (currentPage - 1) * 5 + idx + 1 }} <span class="new-label"
                                                                    v-if="rev.updated === '1'">NEW</span></td>
                                                            <td style="color: #666; font-size: 15px;">
                                                                <div :class="{ 'review-text-limit' : !rev.isExpanded }" style="color: #666; font-size: 15px;" > 
                                                                    {{cleanText(rev.content)}}
                                                                </div>

                                                            </td>
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
                                                    <a @click="currentPage = num" href="javascript:;"
                                                        :style="currentPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4;' : ''">
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
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            el: '#app',
            data() {
                return {
                    currentMenu: 'main',
                    // 리뷰 내역 페이지 사이징
                    reviewListPage: 1,   // 리뷰 상품 목록 페이지
                    reviewListPageSize: 5,
                    // 예약 관리 페이지 사이징
                    selectedRes: null,
                    resCurrentPage: 1,
                    resPageSize: 5,
                    // 상품관리 페이지 사이징//
                    productCurrentPage: 1,
                    productPageSize: 5,   // 한 페이지에 보여줄 상품 수
                    /*문의 답변과 관련된 맵*/
                    inquiryAnswer: {
                        inquiryNo: '',
                        ansUserId: '',
                        answerNo: '',
                        answerContents: '',
                        inquiryAns: ''
                    },
                    inquiryDetails: {},
                    resCount: '',
                    newReviewCnt: 0,
                    newUnpaidReviewCnt: 0,
                    totalSimpleReviewCnt: 0,
                    // 변수 - (key : value)
                    totalReviewCnt: 0,
                    registeredProductList: [],
                    productListForSimpleReviews: [],
                    inquiryList: [],
                    user: {},
                    reviewTab: 'detail',
                    viewPage: 'main', // 상품별 리뷰 페이지 구분 변수
                    productPage: 'list', //(list: 목록, reg: 등록, edit: 수정)
                    currentPage: 1,
                    product: '',
                    oneProductDetails: {},
                    productList: [],
                    simpleReviews: [],
                    reviews: [],
                    reservationList: [],
                    category: ["스튜디오", "드레스", "메이크업"],
                    previewUrl: null, // 미리보기용 URL
                    uploadFile: null,  // 서버로 보낼 실제 파일 객체
                    initializedOneProductDetails: {
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
                        input1: '',
                        input2: '',
                        input3: '',
                        input4: '',
                        input5: ''
                    },
                    serverTagList: []
                }

            }, // data
            computed: {
                tagMapToList() {
                    const filteredtagArray = Object.values(this.tagMap).filter(tag => tag.trim() !== "");
                    return filteredtagArray;
                },
                newTagsOnly() {
                    if (!this.serverTagList) {
                        return tagMapToList();
                    }
                    return this.tagMapToList.filter(t => !this.serverTagList.includes(t));
                },
                filteredReviews() {
                    return this.reviews;
                },
                filteredSimpleReviews() {
                    return this.simpleReviews;
                },
                paginatedReviews() {
                    const start = (this.currentPage - 1) * 5;
                    const end = start + 5;
                    return this.filteredReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },
                paginatedSimpleReviews() {
                    const start = (this.currentPage - 1) * 5;
                    const end = start + 5;
                    return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
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
                },
                // 상품 관리 페이지 사이징
                fnPaginatedProductList() {
                    const start = (this.productCurrentPage - 1) * this.productPageSize;
                    const end = start + this.productPageSize;
                    return this.registeredProductList.slice(start, end);
                },
                totalProductPages() {
                    return Math.ceil(this.registeredProductList.length / this.productPageSize);
                },
                // 예약관리 페이지
                pagedResList() {
                    const start = (this.resCurrentPage - 1) * this.resPageSize;
                    const end = start + this.resPageSize;
                    return this.reservationList.slice(start, end);
                },
                totalResPageCount() {
                    return Math.ceil(this.reservationList.length / this.resPageSize);
                },
                // 리뷰 내역 페이지
                pagedRegisteredProductList() {
                    const start = (this.reviewListPage - 1) * this.reviewListPageSize;
                    return this.registeredProductList.slice(start, start + this.reviewListPageSize);
                },
                pagedProductListForSimpleReviews() {
                    const start = (this.reviewListPage - 1) * this.reviewListPageSize;
                    return this.productListForSimpleReviews.slice(start, start + this.reviewListPageSize);
                },
                totalReviewListPages() {
                    return Math.ceil(this.registeredProductList.length / this.reviewListPageSize);
                },
                totalSimpleReviewListPages() {
                    return Math.ceil(this.productListForSimpleReviews.length / this.reviewListPageSize);
                }
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnGoBackToList: function () {
                    this.viewPage = 'main';
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

                            self.user = {
                                ...self.user, // 기존 user의 다른 데이터들을 유지하고 싶을 때 사용
                                name: data.info.comName,
                                payDate: data.info.payDate,
                                grade: data.info.role,
                                lastPayment: data.info.previousPayment,
                                regDate: data.info.regDate
                            };
                        }
                    });
                },
                fnProductList: function () {
                    this.productCurrentPage = 1;

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
                            self.registeredProductList = data.list; //덮어씌우기
                        }
                    });
                },
                fnEditPage(item) {
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
                            self.oneProductDetails = data.info;//덮어씌우기
                            self.serverTagList = data.tagList;

                            // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                            // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                            if (typeof self.oneProductDetails.proType === 'string') {
                                try {
                                    let rawArray = JSON.parse(self.oneProductDetails.proType);//["MAKEUP" , "STUDIO"]

                                    self.oneProductDetails.proType = rawArray.map(val => {
                                        if (val === 'MAKEUP') {
                                            return '메이크업';
                                        } else if (val === 'DRESS') {
                                            return '드레스';
                                        } else if (val === 'STUDIO') {
                                            return '스튜디오';
                                        } else {
                                            return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                        } //self.oneProductDetails.proType = ["메이크업", "스튜디오"]
                                    })
                                } catch (e) {
                                    // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                                    self.oneProductDetails.proType = [];
                                }
                            }
                            if (typeof self.oneProductDetails.tag === 'string') {
                                try {
                                    let rawArry = JSON.parse(self.oneProductDetails.tag);

                                    self.oneProductDetails.tag = rawArry;

                                    for (let i = 0; i < 5; i++) {
                                        self.tagMap[`input${i + 1}`] = self.oneProductDetails.tag[i] || "";
                                    }
                                } catch (e) {
                                    self.oneProductDetails.tag = [];
                                }
                            }

                        }
                    });
                },
                fnRegPage() {
                    this.oneProductDetails = {
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: '',
                        deposit: 0,
                        tag: []
                    }
                    for(let i = 0; i < 5; i++){
                        this.tagMap[`input${i + 1}`] = '';
                    }
                    this.initializedOneProductDetails = {
                        ...this.initializedOneProductDetails,
                        productName : '',
                        proType : [],
                        productDetails : '',
                        originalPrice : '',
                        deposit : 0
                    }
                    this.productPage = 'reg';

                    let self = this;
                    let param = {};
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
                fnThumbnail(i) {    //fnThumbnail(개별문의) 해변스냅
                    return this.inquiryList.find(p => p.productName === i.productName).imgUrl;
                },
                handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
                    this.currentMenu = menuId;
                    this.productPage = 'list';
                    this.currentPage = 1;
                    this.viewPage = 'main';
                    this.reviewTab = 'detail';

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
                    } else if (menuId === 'inquiry') {
                        this.fnInquiryProduct();
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
                    formData.append("productNo", this.oneProductDetails.productNo);
                    formData.append("productName", this.oneProductDetails.productName);
                    formData.append("productDetails", this.oneProductDetails.productDetails);
                    formData.append("originalPrice", this.oneProductDetails.originalPrice);

                    formData.append("deposit", this.oneProductDetails.deposit);
                    formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));

                    formData.append("proType", JSON.stringify(this.oneProductDetails.proType));

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
                    formData.append("productNo", this.initializedOneProductDetails.productNo);
                    formData.append("productName", this.initializedOneProductDetails.productName);
                    formData.append("productDetails", this.initializedOneProductDetails.productDetails);
                    formData.append("originalPrice", this.initializedOneProductDetails.originalPrice);

                    formData.append("deposit", this.initializedOneProductDetails.deposit);
                    formData.append("proType", JSON.stringify(this.initializedOneProductDetails.proType));
                    formData.append("userId", "${sessionScope.sessionId}");

                    formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));
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
                fnRemoveProduct(item) {  //item in productList
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
                fnReservationList: function () {

                    this.resCurrentPage = 1;

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
                    this.reviewTab = 'detail';
                    this.reviewListPage = 1;
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
                            self.registeredProductList = data.list;
                            self.newReviewCnt = data.info.reviewCount;

                            let reviewCntList = self.registeredProductList.map(p => p.reviewCount); //[3,0,1..];

                            let sum = 0;
                            for (let i = 0; i < reviewCntList.length; i++) {
                                sum += reviewCntList[i];
                            }
                            self.totalReviewCnt = sum;
                        }
                    });
                },
                fnSimple() {
                    this.reviewTab = 'simple';
                    this.reviewListPage = 1;
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
                            self.productListForSimpleReviews = data.list;
                            self.newUnpaidReviewCnt = data.info.reviewCount;

                            let reviewCntList = self.productListForSimpleReviews.map(p => p.reviewCount); //[3,0,1..];
                            let sum = 0;
                            for (let i = 0; i < reviewCntList.length; i++) {
                                sum += reviewCntList[i];
                            }
                            self.totalSimpleReviewCnt = sum;

                        }
                    });
                },
                fnReviewDetails(w) {
                    this.viewPage = 1;
                    this.currentPage = 1;

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
                            console.log(data);
                            self.reviews = data.list;
                            self.reviews = self.reviews.map(r => ({...r, isExpanded: false})); //추가된부분
                            //console.log(self.reviews);
                        }
                    });

                },
                fnSimpleReviewDetails(w) {
                    this.viewPage = 1;
                    this.currentPage = 1;

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
                fnPageChange(num) {
                    this.currentPage = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                },
                starRating(rev) {

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
                uniqueNewTagsOnly() {
                    return [...new Set(this.newTagsOnly)];
                },
                fnBackToList() {
                    this.tagMap = {};
                    this.productPage = 'list'
                    this.initializedOneProductDetails.deposit = 0;
                    this.previewUrl = null;
                },
                fnInquiryProduct() {
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    console.log(param);
                    $.ajax({
                        url: "/getInquiryProductList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            self.inquiryList = data.list;
                        }
                    });
                },
                //문의에 답변하러 넘어가는 타이밍
                fnAnswerToProductInquiry(i) { //매개변수를 이용!
                    this.viewPage = 'answer';
                    this.inquiryDetails = i;

                    let self = this;
                    let param = {
                        inquiryNo: self.inquiryDetails.inquiryNo
                    };
                    console.log(param);
                    $.ajax({
                        url: "/getInquiryAnsYn.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            if (data.result === 'success') {
                                self.inquiryAnswer.inquiryNo = data.info.inquiryNo || '';
                                self.inquiryAnswer.ansUserId = data.info.ansUserId || '';
                                self.inquiryAnswer.answerNo = data.info.answerNo || '';
                                self.inquiryAnswer.answerContents = data.info.answerContents || '';
                                self.inquiryAnswer.inquiryAns = data.info.inquiryAns || '';
                            }
                        }
                    });
                },
                fnBacktoInquiry() {
                    this.viewPage = 'main';
                    //console.log(this.viewPage);
                },
                /*상품문의에 답변하기*/
                fnSaveAnswer() {
                    if (!this.inquiryAnswer.ansUserId || this.inquiryAnswer.ansUserId.trim() === '') {
                        alert("답변자를 작성해주세요!");
                        return;
                    }
                    if(!this.inquiryAnswer.answerContents || this.inquiryAnswer.answerContents.trim() === ''){
                        alert("답변내용을 작성해주세요!");
                        return;
                    } 
                    let self = this;
                    let param = {
                        inquiryNo: self.inquiryAnswer.inquiryNo,
                        answerContents: self.inquiryAnswer.answerContents,
                        ansUserId: self.inquiryAnswer.ansUserId,
                        inquiryAns: self.inquiryAnswer.inquiryAns //0 또는 1
                    };
                    console.log(param);
                    $.ajax({
                        url: "/addProductInquiryAnswer.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            //답변이 등록되면서 답변여부가 업데이트 된다
                            if (data.result === 'success') {
                                alert("답변 등록/수정 완료!");
                                self.viewPage = 'main';
                            } else {
                                alert("서버 오류!");
                            }
                        }
                    });
                },
                /* 제휴업체로 등록하러가기 */
                fnRegPTN() {
                    location.href = "/adminRegistration.do"
                },
                // 1. 이미지 제거 정규식
                removeImages(content) {
                    const regex = /<img[^>]*>/gi;
                    return content.replace(regex, "");
                },
                // 2. 모든 HTML 태그 제거 및 텍스트 추출
                stripHtml(html) {
                    let doc = new DOMParser().parseFromString(html, 'text/html');
                    return doc.body.textContent || "";
                },
                // 3. 두 기능을 합친 최종 함수
                cleanText(content) {
                    // 이미지를 먼저 지운 문자열을 stripHtml에 전달
                    const noImage = this.removeImages(content);
                    return this.stripHtml(noImage);
                },
                getResStatusText(status) {
                    switch (status) {
                        case 'CONFIRM': return '✅ 예약이 확정되었습니다.';
                        case 'CANCEL': return '❌ 취소된 예약입니다.';
                        case 'DONE': return '만료된 예약입니다.';
                        case 'WAIT': return '결제 대기 상태입니다.';
                        default: return status;
                    }
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnCom();
                self.fnReservationList();
                self.fnSimple();
                self.fnReview();
                const urlParams = new URLSearchParams(window.location.search);
                const menu = urlParams.get('menu');
                if (menu) {
                    this.currentMenu = menu;
                }
            }
        });
        app.mount('#app');
    </script>