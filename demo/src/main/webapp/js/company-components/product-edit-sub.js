/**
 * ==========================================================================
 * [ProductEditSub] 기등록 상품 수정 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductEditSub = {
    template: '#product-edit-sub-template',
    
    // 부모로부터 인계받는 단건 상품 고유 마스터 키 단자 보존
    props: ['productNo'],

    // ① 두 독립 기능 모듈의 data() 리턴 그릇을 스프레드 연산자로 완전 조립
    data() {
        return {
            ...productEditCoreModule.data(),
            ...productEditCategoryModule.data()
        };
    },

    // ② 코어 제어실에 선언된 실시간 상태 변화 감지 로직을 완벽 이식
    computed: {
        ...productEditCoreModule.computed
    },

    // ③ 두 독립 모듈의 핵심 비즈니스 로직 함수들을 전량 결합 병합
    methods: {
        ...productEditCoreModule.methods,
        ...productEditCategoryModule.methods
    },

    // ④ 수정 폼 활성화 시 최초의 찰나 마스터 카테고리 사전 수급 트리거 점화
    mounted() {
        this.loadCategoryTree();
    }
};

// 상위 Vue 부모 엔진과의 독립 결합 단자선 유지
if (typeof app !== 'undefined') {
    // 부모 components 등록소 융합 연동 유도
}