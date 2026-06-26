/**
 * ==========================================================================
 * [ProductRegSub] 신규 상품 등록 - 완전 자립형 독립 서브 컴포넌트 명세 객체
 * ==========================================================================
 */
const ProductRegSub = {
    template: '#product-reg-sub-template',
    props: [],
    
    // ① 두 독립 서랍 모듈의 data() 리턴 그릇을 스프레드(...) 연산자로 완전 조립
    data() {
        return {
            ...productRegCoreModule.data(),
            ...productRegCategoryModule.data()
        };
    },

    // ② 두 독립 서랍 모듈의 구현 비즈니스 로직 함수들을 빈틈없이 병합 이식
    methods: {
        ...productRegCoreModule.methods,
        ...productRegCategoryModule.methods
    },

    // ③ 컴포넌트 마운트 활성화 시 카테고리 트리 마스터 사전 조회 도화선 점화
    mounted() {
        this.loadCategoryTree();
    }
};

// 상위 Vue 엔진 인프라 연동 확인 자립선 유지
if (typeof app !== 'undefined') {
    // 부모 components 풀에 안전하게 안착되도록 유도
}