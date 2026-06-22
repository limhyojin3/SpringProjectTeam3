/**
 * ==========================================================================
 * [ProductSectionComponent] 상품 관리 - 코어 메인 컴포넌트 (스프레드 레고 조립 공법)
 * ==========================================================================
 */
const ProductSectionComponent = {
    template: '#product-section-template',

    // 오직 상품 관리 컴포넌트 전역 상태 주머니
    data() {
        return {
            productPage: 'list',
            productCurrentPage: 1,
            productPageSize: 5,
            registeredProductList: [], 
            oneProductDetails: {},
            category: ["스튜디오", "드레스", "메이크업"],
            previewUrl: null,
            uploadFile: null,
            initializedOneProductDetails: {
                companyNo: '', productNo: '', proType: [], productName: '',
                productDetails: '', originalPrice: '', imgUrl: '', deposit: 0, tag: []
            },
            tagMap: { input1: '', input2: '', input3: '', input4: '', input5: '' },
            serverTagList: []
        };
    },

    // 목록 실시간 5개 단위 페이징 및 인풋 태그 동적 배열 필터식
    computed: {
        tagMapToList() {
            return Object.values(this.tagMap).filter(tag => tag.trim() !== "");
        },
        newTagsOnly() {
            if (!this.serverTagList) return this.tagMapToList;
            return this.tagMapToList.filter(t => !this.serverTagList.includes(t));
        },
        fnPaginatedProductList() {
            const start = (this.productCurrentPage - 1) * this.productPageSize;
            const end = start + this.productPageSize;
            return this.registeredProductList.slice(start, end);
        },
        totalProductPages() {
            return Math.ceil(this.registeredProductList.length / this.productPageSize);
        }
    },

    // 💡 아키텍처 핵심 조립 레일: 쪼개진 외부 독립 모듈 메서드들을 스프레드로 펼쳐 무파괴 결합 집행
    methods: {
        ...ProductListService,   // 1번 리스트 서비스 무파괴 수혈
        ...ProductMutateService, // 2번 인서트/업데이트 서비스 무파괴 수혈
        
        // 화면 상태 롤백 전용 제어 단자
        fnBackToList() {
            this.tagMap = {};
            this.productPage = 'list';
            this.initializedOneProductDetails.deposit = 0;
            this.previewUrl = null;
        }
    },

    // 최초 무대 활성화 시 자가 구동 목록 로드 트리거
    mounted() {
        this.fnProductList();
    }
};