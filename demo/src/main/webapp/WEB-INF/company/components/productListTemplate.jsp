<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/productListTemplate.css">

<script type="text/x-template" id="product-list-template">
    <div>
        <div class="top-action-bar">
            <button @click="$emit('go-my-res')" class="btn-sub-action">나의 예약 보러가기</button>
            <button @click="$emit('go-my-inquiry')" class="btn-sub-action">나의 문의 보러가기</button>
        </div>

        <div class="filter-section">
            <div class="large-category-container">
                <button v-for="(value, key) in categoriesData" 
                        :key="key" 
                        type="button"
                        :class="['large-tab-btn', { active: selectLargeCategory === key }]"
                        @click="changeLargeCategory(key)">
                    {{ key }}
                </button>
            </div>

            <div class="medium-category-container">
                <h3>카테고리 상세</h3>
                <div class="chips-flex-box">
                    <label v-for="cat in currentMediums" 
                           :key="cat" 
                           :class="['chip-toggle-label', { active: selectCategory === cat }]">
                        <input type="radio" 
                               v-model="selectCategory" 
                               :value="cat" 
                               @change="selectTags = []" 
                               class="custom-hidden-input"> 
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
                               :class="['chip-toggle-label', 'tag-specific-chip', { 
                                   active: selectTags.includes(tag), 
                                   disabled: selectTags.length >= 2 && !selectTags.includes(tag) 
                               }]">
                            <input type="checkbox" 
                                   :value="tag" 
                                   v-model="selectTags" 
                                   :disabled="selectTags.length >= 2 && !selectTags.includes(tag)"
                                   class="custom-hidden-input"> 
                            {{ tag }}
                        </label>
                    </div>
                </div>
            </div>
        </div>

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
                <p class="product-price">{{Number(item.price).toLocaleString()}}원</p>
            </div>
        </div>
    </div>
</script>