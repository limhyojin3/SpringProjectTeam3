<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/x-template" id="product-list-template">
    <div>
        <div class="top-action-bar">
            <button @click="$emit('go-my-res')" class="btn-sub-action">나의 예약 보러가기</button>
            <button @click="$emit('go-my-inquiry')" class="btn-sub-action">나의 문의 보러가기</button>
        </div>

        <div class="filter-section">
            <h2>카테고리</h2>
            <label><input type="checkbox" v-model="selectCategory" value="스튜디오"> 스튜디오</label>
            <label><input type="checkbox" v-model="selectCategory" value="드레스"> 드레스</label>
            <label><input type="checkbox" v-model="selectCategory" value="메이크업"> 메이크업</label>

            <div class="tag-filter">
                <h4>분위기 선택</h4> 
                <label v-for="tag in productTag" :key="tag">
                    <input type="checkbox" :value="tag" v-model="selectTags"> {{ tag }}
                </label>
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
                    <span v-for="t in item.tag" class="tag-span">{{t}}</span>
                </div>
                <p class="product-price">{{Number(item.price).toLocaleString()}}원</p>
            </div>
        </div>
    </div>
</script>