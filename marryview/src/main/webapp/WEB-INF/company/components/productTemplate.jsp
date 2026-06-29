<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!-- ==========================================================================
       👑 [부모 메인 라우터 관제소 템플릿]
       자식들이 완전히 독립해 나갔으므로, 부모는 오직 화면 스위칭 상태만 가볍게 중계합니다.
       ========================================================================== -->
    <template id="product-section-template">
        <div>
            <!-- ① 상품 목록 완전 독립 컴포넌트 태그 주입 -->
            <product-list-sub 
                v-if="productPage === 'list'" 
                @go-reg="productPage = 'reg'"
                @go-edit="handleGoEdit">
            </product-list-sub>

            <!-- ② 상품 등록 폼 완전 독립 컴포넌트 태그 주입 -->
            <product-reg-sub 
                v-else-if="productPage === 'reg'"
                @back="productPage = 'list'">
            </product-reg-sub>

            <!-- ③ 상품 수정 폼 완전 독립 컴포넌트 태그 주입 (선택한 상품 번호를 props로 전달) -->
            <product-edit-sub 
                v-else-if="productPage === 'edit'"
                :product-no="selectedProductNo"
                @back="productPage = 'list'">
            </product-edit-sub>
        </div>
    </template>

    <!-- 2단: 서브 자식 JSP 파일 물리 인클루드 레이어 트랙 -->
    <jsp:include page="/WEB-INF/company/components/productListSub.jsp" />
    <jsp:include page="/WEB-INF/company/components/productRegSub.jsp" />
    <jsp:include page="/WEB-INF/company/components/productEditSub.jsp" />

    <!-- 3단: 오직 자기 부모 뼈대의 화면 전환만 조율하는 코어 자바스크립트 직통 로드 레일 -->
    <script src="${pageContext.request.contextPath}/js/company-components/product-section-component.js"></script>