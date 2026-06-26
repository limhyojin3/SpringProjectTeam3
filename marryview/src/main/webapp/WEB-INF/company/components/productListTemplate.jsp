<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productListTemplate.css">

<script type="text/x-template" id="product-list-template">
    <div>
        <div class="top-action-bar">
            <button @click="$emit('go-my-res')" class="btn-sub-action">나의 예약 보러가기</button>
            <button @click="$emit('go-my-inquiry')" class="btn-sub-action">나의 문의 보러가기</button>
        </div>

        <div class="master-toggle-container">
            <button type="button" 
                    :class="['large-tab-btn', 'btn-master-product', { active: searchMode === 'product' }]" 
                    @click="searchMode = 'product'">
                🔍 상품 패키지 찾기
            </button>
            <button type="button" 
                    :class="['large-tab-btn', 'btn-master-company', { active: searchMode === 'company' }]" 
                    @click="searchMode = 'company'">
                🏢 등록 업체 찾기
            </button>
        </div>
        
        <div v-if="searchMode === 'product'" class="filter-section">
            <div class="large-category-container">
                <button v-for="(value, key, index) in categoriesData" 
                        :key="key" 
                        type="button"
                        :class="[
                            'large-tab-btn', 
                            { active: selectLargeCategory === key },
                            index === 0 ? 'btn-cat-wedding' : '',
                            index === 1 ? 'btn-cat-family' : '',
                            index === 2 ? 'btn-cat-friends' : ''
                        ]"
                        @click="changeLargeCategory(key)">
                    {{ key }}
                </button>
            </div>

            <div class="medium-category-container">
                <h3>카테고리 상세</h3>
                <div class="chips-flex-box">
                    <label v-for="cat in currentMediums" 
                           :key="cat" 
                           :class="[
                               'chip-toggle-label', 
                               { active: selectCategory === cat },
                               selectLargeCategory === '결혼' ? 'theme-wedding' : '',
                               selectLargeCategory === '가족행사' ? 'theme-family' : '',
                               selectLargeCategory === '친구와함께' ? 'theme-friends' : ''
                           ]">
                        <input type="radio" v-model="selectCategory" :value="cat" @change="selectTags = []" class="custom-hidden-input"> 
                        {{ cat }}
                    </label>
                </div>
            </div>

            <div v-if="currentTags && currentTags.length > 0" class="tag-filter-container">
                <h3>태그 선택</h3> 
                <div class="sub-tag-group-box">
                    <h4 class="sub-group-title">{{ selectCategory }}</h4>
                    <div class="chips-flex-box">
                        <label v-for="tag in currentTags" 
                               :key="selectCategory + '_' + tag" 
                               :class="[
                                   'chip-toggle-label', 
                                   'tag-specific-chip', 
                                   { active: selectTags.includes(tag), disabled: selectTags.length >= 2 && !selectTags.includes(tag) },
                                   selectLargeCategory === '결혼' ? 'theme-wedding' : '',
                                   selectLargeCategory === '가족행사' ? 'theme-family' : '',
                                   selectLargeCategory === '친구와함께' ? 'theme-friends' : ''
                               ]">
                            <input type="checkbox" :value="tag" v-model="selectTags" :disabled="selectTags.length >= 2 && !selectTags.includes(tag)" class="custom-hidden-input"> 
                            {{ tag }}
                        </label>
                    </div>
                </div>
            </div>
        </div>
        
        <div v-if="searchMode === 'company'" class="filter-section company-slim-filter">
            <div class="large-category-container" style="border-bottom: none; padding-bottom: 0;">
                <button v-for="(value, key, index) in categoriesData" 
                        :key="key" 
                        type="button"
                        :class="[
                            'large-tab-btn', 
                            { active: selectLargeCategory === key },
                            index === 0 ? 'btn-cat-wedding' : '',
                            index === 1 ? 'btn-cat-family' : '',
                            index === 2 ? 'btn-cat-friends' : ''
                        ]"
                        @click="changeLargeCategory(key)">
                    {{ key }}
                </button>
            </div>
        </div>

        <div v-if="searchMode === 'product'" class="product-pokemon-grid">
            <div v-for="item in filteredList" :key="item.id" class="product-item" @click="$emit('go-detail', item)">
                <div class="product-img-box">
                    <img :src="item.thumbnail" :alt="item.name">
                </div>
                <div class="product-info">
                    <h4>{{item.name}}</h4>
                    <p class="product-content">{{item.content}}</p>
                    <div v-if="item.tag" class="product-tags-wrapper">
                        <span v-for="t in item.tag" class="tag-span"><span>#</span>{{t}}</span>
                    </div>
                    <div class="product-price-row">
                        <p class="product-price">{{Number(item.price).toLocaleString()}}원</p>
                        <div @click.stop="fnToggleProductLike(item)" :class="['like-chip-btn', { active: item.isLiked === 1 }]">
                            <span>{{ item.isLiked === 1 ? '❤️' : '🤍' }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div v-if="searchMode === 'company'">
            <div v-for="comp in uniqueCompanies" :key="comp.companyNo" class="product-item company-card-item" @click="$emit('go-company-detail', comp.companyNo)">
                <div class="product-img-box">
                    <img :src="comp.thumbnail" :alt="comp.comName">
                </div>
                <div class="product-info">
                    <div class="company-card-header">
                        <h4>{{ comp.comName }}</h4>
                        <div @click.stop="fnToggleCompanyLike(comp)" :class="['like-chip-btn', { active: comp.isCompanyLiked === 1 }]">
                            <span>{{ comp.isCompanyLiked === 1 ? '❤️' : '🤍' }}</span>
                        </div>
                    </div>
                    <p class="company-location-text">📍 위치: {{ comp.comAddress || '주소 정보 없음' }}</p>
                    <p class="company-intro-box">
                        {{ comp.comIntro || '등록된 한 줄 소개글이 없는 업체입니다. 대분류 기반 패키지 상품 구성을 확인해 주세요.' }}
                    </p>
                </div>
            </div>
        </div>
    </div>
</script>
<script src="${pageContext.request.contextPath}/js/company-components/product-list-component.js"></script>