/**
 * ==========================================================================
 * [ProductRegCategoryModule] 카테고리 트리 및 태그 칩 토글 독점 제어 모듈
 * ==========================================================================
 */
const productRegCategoryModule = {
    // 카테고리/태그 구역 변수 데이터 그릇 일체 보존
    data() {
        return {
            categoryTree: {},     
            availableMediums: [], 
            availableTags: [],    
            selectedTags: []      
        };
    },

    // 카테고리/태그 관련 순수 비즈니스 메서드 관로 일체 보존
    methods: {
        /**
         * [AJAX] 백엔드의 카테고리 트리 사전을 독립 수급하는 파이프라인
         */
        loadCategoryTree() {
            let self = this;
            $.ajax({
                url: "/getCategoryTree.dox",
                dataType: "json",
                type: "POST",
                success: function(data) {
                    self.categoryTree = data;
                    console.log("📂 [Module] 카테고리 사전 수급 성공:", self.categoryTree);
                }
            });
        },

        /**
         * 대분류 칩 클릭 처리 단자
         */
        selectLargeCategory(largeName) {
            this.initializedOneProductDetails.largeCategory = largeName;
            this.initializedOneProductDetails.mediumCategory = '';
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
            this.initializedOneProductDetails.mediumCategory = mediumName;
            this.selectedTags = [];

            if (this.initializedOneProductDetails.largeCategory === '결혼') {
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