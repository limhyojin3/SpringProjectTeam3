/**
 * ==========================================================================
 * [ProductSectionComponent] 상품 관리 - 최상위 코어 관제소 컴포넌트 (UI 라우터)
 * ==========================================================================
 */
const ProductSectionComponent = {
    template: '#product-section-template',

    // 🎯 백지 버그 박멸 핵무기: 세상에 아직 인스턴스화 되지 않은 app 전역 선을 끊어버리고,
    // 부모 관제소가 가방 메고 대기 중인 자식 설정 객체 삼형제를 자가 영토 내에 로컬 조립 컴파일 집행합니다!
    components: {
        'product-list-sub': ProductListSub,
        'product-reg-sub': ProductRegSub,
        'product-edit-sub': ProductEditSub
    },

    // 자식 컴포넌트들이 각자 살림살이와 AJAX를 들고 완전히 독립해 나갔으므로 부모는 극강의 미니멀리즘 유지
    data() {
        return {
            productPage: 'list',       // 화면 상태 분기 제어 레일 ('list', 'reg', 'edit')
            selectedProductNo: null    // 목록 자식이 전달해 준 "수정 대상 정밀 타격 일련번호" 임시 보초그릇
        };
    },

    methods: {
        // 목록 자식이 [수정하기] 신호를 쏘며 던져준 번호를 받아서 보관하고 수정 화면으로 스위칭 전환 집행
        handleGoEdit(productNo) {
            this.selectedProductNo = productNo;
            this.productPage = 'edit';
        }
    }
};