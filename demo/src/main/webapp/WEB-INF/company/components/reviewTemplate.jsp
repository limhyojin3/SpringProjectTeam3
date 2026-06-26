<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/review-tabs.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/review-product-list.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/review-detail-view.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/review-simple-table.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/review-pagination.css">

<template id="review-section-template">
    <div> 
        <div v-if="viewPage === 'main'">
            <div class="tab-menu">
                <button :class="{ active: reviewTab === 'detail' }" @click="fnReview">
                    유료 리뷰({{totalReviewCnt}})
                </button>
                <button :class="{ active: reviewTab === 'simple' }" @click="fnSimple">
                    무료 리뷰({{totalSimpleReviewCnt}})
                </button>
            </div>

            <div v-if="reviewTab === 'detail'" class="content-card">
                <h3>
                    <i class="fas fa-gem mr-2 icon-paid"></i>
                    <span class="title-paid">유료 리뷰 내역</span> : <span class="res-count-highlight">새 리뷰 {{newReviewCnt}}건</span>
                </h3>
                <div v-for="(w, idx) in pagedRegisteredProductList" :key="idx">
                    <div class="review-header-info" style="margin-bottom: 10px;" @click="fnReviewDetails(w)">
                        <div class="review-thumb-box">
                            <img :src="w.imgUrl" class="productImg">
                        </div>
                        <div class="review-product-name">
                            <div class="ticket-no">No. {{ registeredProductList.length - ((reviewListPage - 1) * 5 + idx ) }}</div>
                            <a href="javascript:;" class="review-product-link"><strong>{{w.productName}}</strong></a>
                        </div>
                        <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                    </div>
                </div>
                <div class="pagination1">
                    <a @click="reviewListPage > 1 ? reviewListPage-- : null" href="javascript:;" :class="{ 'disabled-arrow': reviewListPage === 1 }">◀</a>
                    <span v-for="num in visibleReviewListPages" :key="num">
                        <a @click="reviewListPage = num" href="javascript:;" :class="{ 'active-page-node': reviewListPage === num }">
                            {{ num }}
                        </a>
                    </span>
                    <a @click="reviewListPage < totalReviewListPages ? reviewListPage++ : null" href="javascript:;" :class="{ 'disabled-arrow': reviewListPage === totalReviewListPages || totalReviewListPages === 0 }">▶</a>
                </div>
            </div>

            <div v-if="reviewTab === 'simple'" class="content-card">
                <h3>
                    <i class="fas fa-gift mr-2 icon-free"></i>
                    <span class="title-free">무료 리뷰 내역</span> : <span class="res-count-highlight">새 리뷰 {{newUnpaidReviewCnt}}건</span>
                </h3>
                <div v-for="(w, idx) in pagedProductListForSimpleReviews" :key="idx">
                    <div class="review-header-info" style="margin-bottom: 10px;" @click="fnSimpleReviewDetails(w)">
                        <div class="review-thumb-box">
                            <img :src="w.imgUrl" class="productImg">
                        </div>
                        <div class="review-product-name">
                            <div class="ticket-no">No. {{ productListForSimpleReviews.length - ((reviewListPage - 1) * 5 + idx ) }}</div>
                            <a href="javascript:;" class="review-product-link"><strong>{{w.productName}}</strong></a>
                        </div>
                        <div class="review-count-badge">리뷰 갯수: {{w.reviewCount}}개 </div>
                    </div>
                </div>
                <div class="pagination1">
                    <a @click="reviewListPage > 1 ? reviewListPage-- : null" href="javascript:;" :class="{ 'disabled-arrow': reviewListPage === 1 }">◀</a>
                    <span v-for="num in visibleSimpleReviewListPages" :key="num">
                        <a @click="reviewListPage = num" href="javascript:;" :class="{ 'active-page-node': reviewListPage === num }">
                            {{ num }}
                        </a>
                    </span>
                    <a @click="reviewListPage < totalSimpleReviewListPages ? reviewListPage++ : null" href="javascript:;" :class="{ 'disabled-arrow': reviewListPage === totalSimpleReviewListPages || totalSimpleReviewListPages === 0 }">▶</a>
                </div>
            </div>
        </div>

        <div v-else>
            <div v-if="reviewTab === 'detail'">
                <button class="btn-back" @click="fnGoBackToList()">← 목록으로</button>
                <div v-if="reviews && reviews.length > 0">
                    <div v-for="(rev, idx) in paginatedReviews" :key="idx" @click="rev.isExpanded = !rev.isExpanded" class="detail-review-item">
                        <div class="star-rating">평점 : {{starRating(rev)}}</div>
                        <div class="review-item-flex-row">
                            <div class="review-photo-wrapper">
                                <span class="new-label-absolute" v-if="rev.updated === '1'">NEW</span>
                                <div class="review-photo">
                                    <div class="review-photo-bg" :style="{ backgroundImage: 'url(' + rev.thumbnailUrl + ')' }"></div>
                                </div>
                            </div>
                            <div :class="{ 'review-text-limit' : !rev.isExpanded }" class="review-item-text">
                                {{cleanText(rev.content)}}
                            </div>
                            <div class="review-toggle-btn">
                                {{ rev.isExpanded ? '접기 ▲' : '더보기 ▼' }}
                            </div>
                        </div>
                        <div class="review-item-meta">
                            작성자: <strong>{{rev.userId}}</strong> | 작성일자: {{rev.regDate}}
                        </div>
                        <hr>
                    </div>
                    <div class="pagination1">
                        <a @click="currentPage > 1 ? fnPageChange(currentPage - 1) : null" href="javascript:;" :class="{ 'disabled-arrow': currentPage === 1 }">◀</a>
                        <span v-for="num in visibleDetailPages" :key="num">
                            <a @click="fnPageChange(num)" href="javascript:;" :class="{ 'active-page-node': currentPage === num }">
                                {{num}}
                            </a>
                        </span>
                        <a @click="currentPage < totalPages ? fnPageChange(currentPage + 1) : null" href="javascript:;" :class="{ 'disabled-arrow': currentPage === totalPages || totalPages === 0 }">▶</a>
                    </div>
                </div>
                <div v-else>
                    <div class="no-data-box">
                        <h2 class="no-data-title">아직 작성된 리뷰가 없습니다!</h2>
                    </div>
                </div>
            </div>

            <div v-else-if="reviewTab === 'simple'">
                <button class="btn-back" @click="fnGoBackToList()">← 목록으로</button>
                <div v-if="simpleReviews && simpleReviews.length > 0">
                    <table class="simple-review-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>내용</th>
                                <th>작성자</th>
                                <th>평점</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(rev, idx) in paginatedSimpleReviews" :key="rev.reviewNo">
                                <td>
                                    {{ (currentPage - 1) * 5 + idx + 1 }}
                                    <span class="new-label" v-if="rev.updated === '1'">NEW</span>
                                </td>
                                <td class="simple-review-text-td">
                                    <div :class="{ 'review-text-limit' : !rev.isExpanded }" class="review-item-text">
                                        {{cleanText(rev.content)}}
                                    </div>
                                </td>
                                <td>{{rev.userId}}</td>
                                <td>
                                    <span class="rating-num-highlight">{{rev.rating}}</span><span>/5</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="pagination1">
                        <a @click="currentPage > 1 ? currentPage-- : null" href="javascript:;" :class="{ 'disabled-arrow': currentPage === 1 }">◀</a>
                        <span v-for="num in visibleSimpleDetailPages" :key="num">
                            <a @click="currentPage = num" href="javascript:;" :class="{ 'active-page-node': currentPage === num }">
                                {{num}}
                            </a>
                        </span>
                        <a @click="currentPage < totalSimplePages ? currentPage++ : null" href="javascript:;" :class="{ 'disabled-arrow': currentPage === totalSimplePages || totalSimplePages === 0 }">▶</a>
                    </div>
                </div>
                <div v-else>
                    <div class="no-data-box">
                        <h2 class="no-data-title">아직 작성된 리뷰가 없습니다!</h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script src="${pageContext.request.contextPath}/js/company-components/review-section-component.js"></script>