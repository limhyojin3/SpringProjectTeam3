<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productListLayout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productCardSkin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productPriceControl.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productPagination.css">

<template id="product-list-sub-template">
    <div class="product-management-list-container">
        <div class="productlist-productReg">
            <div class="section-header">
                <h2>등록한 상품 <span class="header-count-badge">{{ registeredProductList.length }}</span></h2>
            </div>
            <button @click="fnRegPage()" class="btn-product-reg">✨ 신규 상품 등록</button>
        </div>
        
        <div v-for="(i, idx) in fnPaginatedProductList" :key="idx" class="content-card PaginatedProductList">
            <div class="imgUrl">
                <img :src="i.imgUrl" :alt="i.productName" class="productImg">
            </div>
            
            <div class="registeredProductList">
                <div class="badge-pill-ticket">
                    No. {{ registeredProductList.length - ((productCurrentPage - 1) * 4 + idx) }}
                </div>
                <h3 class="product-display-name">{{ i.productName }}</h3>
                <p class="product-display-desc" v-if="i.productDetails">{{ i.productDetails }}</p>
            </div>

            <div class="originalPrice">
                <div class="price-tag-display">
                    <span class="price-value">{{ Number(i.originalPrice).toLocaleString() }}</span>원
                </div>
                <div class="action-btn-group">
                    <button @click="fnEditPage(i)" class="btn-edit">수정하기</button>
                    <button @click="fnRemoveProduct(i)" class="btn-delete">삭제하기</button>
                </div>
            </div>
        </div>

        <div class="pagination1">
            <a @click="fnPrevPage" href="javascript:;" :class="{ 'disabled-arrow': productCurrentPage === 1 }">◀</a>
            
            <span v-for="num in visiblePageNumbers" :key="num">
                <a @click="productCurrentPage = num" href="javascript:;"
                    :class="{ 'active-page-node': productCurrentPage === num }">
                    {{ num }}
                </a>
            </span>
            
            <a @click="fnNextPage" href="javascript:;" :class="{ 'disabled-arrow': productCurrentPage === totalProductPages || totalProductPages === 0 }">▶</a>
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/product-list-sub.js"></script>