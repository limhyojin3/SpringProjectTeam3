/**
 * ==========================================================================
 * [ProductEditCategoryModule] 수정 폼 전용 카테고리 및 태그 칩 제어 모듈
 * ==========================================================================
 */
const productEditCategoryModule = {
    // 1. 수정 폼 카테고리 구역 독립 데이터 그릇 일체 보존
    data() {
        return {
            categoryTree: {},      
            availableMediums: [],  
            availableTags: [],     
            selectedTags: []       
        };
    },

    // 2. 카테고리/태그 연산 전용 메서드 관로 일체 보존
    methods: {
        /**
         * [AJAX] 컴포넌트 기동 시 백엔드의 카테고리 트리 사전을 독립 수급하는 파이프라인
         */
        loadCategoryTree() {
            let self = this;
            $.ajax({
                url: "/getCategoryTree.dox",
                dataType: "json",
                type: "POST",
                success: function(data) {
                    self.categoryTree = data;
                    console.log("📂 [Module] 수정 폼 내부 카테고리 사전 수급 성공");
                    
                    // 사전 수급이 안전하게 완료된 후, 기존 데이터 상세조회를 체이닝 트리거합니다.
                    self.fnFetchDetail();
                }
            });
        },

        /**
         * 대분류 칩 클릭 처리 단자
         */
        selectLargeCategory(largeName) {
            this.oneProductDetails.largeCategory = largeName;
            this.oneProductDetails.mediumCategory = '';
            this.availableTags = [];
            this.selectedTags = [];

            if (this.categoryTree[largeName] && this.categoryTree[largeName].mediums) {
                this.availableMediums = this.categoryTree[largeName].mediums;
            } else {
                this.availableMediums = [];
            }
        },

        /**
         * 중분류 칩 클릭 처리 단자
         */
        selectMediumCategory(mediumName) {
            this.oneProductDetails.mediumCategory = mediumName;
            this.selectedTags = [];

            if (this.oneProductDetails.largeCategory === '결혼') {
                if (this.categoryTree['결혼'] && this.categoryTree['결혼'].tags && this.categoryTree['결혼'].tags[mediumName]) {
                    this.availableTags = this.categoryTree['결혼'].tags[mediumName];
                } else {
                    this.availableTags = [];
                }
            } else {
                this.availableTags = [];
            }
        },

        /**
         * 태그 칩 활성화 및 최대 3개 상한 강제 차단막 제어 매커니즘
         */
        toggleTagSelection(tagName) {
            let index = this.selectedTags.indexOf(tagName);
            if (index > -1) {
                this.selectedTags.splice(index, 1);
            } else {
                if (this.selectedTags.length >= 3) {
                    return;
                }
                this.selectedTags.push(tagName);
            }
        }
    }
};