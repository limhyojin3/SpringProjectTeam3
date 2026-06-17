<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/mainTemplate.css">

    <template id="main-menu-template">
        <div>
            <h2>안녕하세요, '{{ user.name }}'님!</h2>
            <div class="section-title" v-if="user.grade === 'PARTNER'">제휴업체</div>
            <div class="section-title" v-else-if="user.grade === 'NPARTNER'">일반업체</div>
            <div class="content-card">
                <h3><span v-if="user.grade === 'PARTNER'">제휴업체 등록(결제) 일자</span></h3>
                <h3><span v-if="user.grade === 'NPARTNER'">일반업체 등록 일자</span></h3>
                <p v-if="user.grade === 'PARTNER'" class="user-grade">{{ user.payDate }}</p>
                <p v-if="user.grade === 'NPARTNER'" class="user-grade">{{ user.regDate }}</p>
            </div>
            <div v-if="user.grade === 'NPARTNER'" class="user-nopartner">
                <button class="btn-product-reg" @click="$emit('reg-ptn')">제휴 업체로 등록하기</button>
            </div>
            <div><span v-if="user.grade === 'NPARTNER'">*관리자가 승인후 제휴업체 등급이 됩니다!</span></div>
        </div>
    </template>