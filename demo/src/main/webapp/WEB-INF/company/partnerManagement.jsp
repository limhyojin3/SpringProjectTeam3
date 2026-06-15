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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/partner-management.css">
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
        // 💡 중요: 외부 JS 파일이 JSP 세션 ID를 쓸 수 있도록 전역 변수에 먼저 담아줍니다.
        window.SESSION_ID = "${sessionScope.sessionId}";
    </script>
    <script src="/js/partner-management.js"></script>