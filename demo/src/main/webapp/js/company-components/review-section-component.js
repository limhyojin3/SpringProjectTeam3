const ReviewSectionComponent = {
    template: '#review-section-template',
    
    // 1. 오직 리뷰 관리방에서만 사용하는 독립된 변수들
    data() {
        return {
            viewPage: 'main',             // 상품별 리뷰 페이지 구분 변수 ('main' 또는 1 등)
            reviewTab: 'detail',          // 'detail'(유료), 'simple'(무료) 탭 구분
            reviewListPage: 1,            // 리뷰 상품 목록 페이지 번호
            reviewListPageSize: 5,        // 한 페이지당 보여줄 상품 수
            currentPage: 1,               // 상세 리뷰 목록의 현재 페이지 번호
            
            newReviewCnt: 0,              // 새 유료 리뷰 건수
            newUnpaidReviewCnt: 0,        // 새 무료 리뷰 건수
            totalReviewCnt: 0,            // 전체 유료 리뷰 건수
            totalSimpleReviewCnt: 0,      // 전체 무료 리뷰 건수
            
            registeredProductList: [],       // 유료 리뷰 대상 상품 목록
            productListForSimpleReviews: [], // 무료 리뷰 대상 상품 목록
            reviews: [],                     // 선택한 상품의 유료 상세 리뷰 리스트
            simpleReviews: []                // 선택한 상품의 무료 상세 리뷰 리스트
        };
    },

    // 2. 메인에 흩어져 있던 리뷰 관련 계산식(Computed) 통째로 이사
    computed: {
        filteredReviews() {
            return this.reviews;
        },
        filteredSimpleReviews() {
            return this.simpleReviews;
        },
        paginatedReviews() {
            const start = (this.currentPage - 1) * 5;
            const end = start + 5;
            return this.filteredReviews.slice(start, end);
        },
        paginatedSimpleReviews() {
            const start = (this.currentPage - 1) * 5;
            const end = start + 5;
            return this.filteredSimpleReviews.slice(start, end);
        },
        // 리뷰 대상 상품 목록 페이징
        pagedRegisteredProductList() {
            const start = (this.reviewListPage - 1) * this.reviewListPageSize;
            return this.registeredProductList.slice(start, start + this.reviewListPageSize);
        },
        pagedProductListForSimpleReviews() {
            const start = (this.reviewListPage - 1) * this.reviewListPageSize;
            return this.productListForSimpleReviews.slice(start, start + this.reviewListPageSize);
        },
        totalReviewListPages() {
            return Math.ceil(this.registeredProductList.length / this.reviewListPageSize);
        },
        totalSimpleReviewListPages() {
            return Math.ceil(this.productListForSimpleReviews.length / this.reviewListPageSize);
        },
        totalPages() {
            return Math.ceil(this.filteredReviews.length / 5);
        },
        totalSimplePages() {
            return Math.ceil(this.filteredSimpleReviews.length / 5);
        }
    },

    // 3. 리뷰 비동기 통신 및 헬퍼 함수들 이사
    methods: {
        fnGoBackToList() {
            this.viewPage = 'main';
        },
        fnReview() {
            this.reviewTab = 'detail';
            this.reviewListPage = 1;
            let self = this;
            let param = { userId: window.SESSION_ID };
            $.ajax({
                url: "/getReviewCnt.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.registeredProductList = data.list;
                    self.newReviewCnt = data.info.reviewCount;

                    let reviewCntList = self.registeredProductList.map(p => p.reviewCount);
                    let sum = 0;
                    for (let i = 0; i < reviewCntList.length; i++) {
                        sum += reviewCntList[i];
                    }
                    self.totalReviewCnt = sum;
                }
            });
        },
        fnSimple() {
            this.reviewTab = 'simple';
            this.reviewListPage = 1;
            let self = this;
            let param = { userId: window.SESSION_ID };
            $.ajax({
                url: "/getSimpleReviewCnt.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.productListForSimpleReviews = data.list;
                    self.newUnpaidReviewCnt = data.info.reviewCount;

                    let reviewCntList = self.productListForSimpleReviews.map(p => p.reviewCount);
                    let sum = 0;
                    for (let i = 0; i < reviewCntList.length; i++) {
                        sum += reviewCntList[i];
                    }
                    self.totalSimpleReviewCnt = sum;
                }
            });
        },
        fnReviewDetails(w) {
            this.viewPage = 1;
            this.currentPage = 1;
            let self = this;
            let param = {
                userId: window.SESSION_ID,
                productNo: w.productNo
            };
            $.ajax({
                url: "/ReviewDetails3.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.reviews = data.list.map(r => ({ ...r, isExpanded: false }));
                }
            });
        },
        fnSimpleReviewDetails(w) {
            this.viewPage = 1;
            this.currentPage = 1;
            let self = this;
            let param = {
                userId: window.SESSION_ID,
                productNo: w.productNo
            };
            $.ajax({
                url: "/SimpleReviewDetails3.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.simpleReviews = data.list;
                }
            });
        },
        fnPageChange(num) {
            this.currentPage = num;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        },
        // 공통 유틸 함수 연결
        cleanText(content) { 
            return PartnerUtils.cleanText(content); 
        },
        starRating(rev) { 
            return PartnerUtils.starRating(rev); 
        }
    },

    // 4. 리뷰 관리 탭이 활성화되면 자동으로 유료/무료 리뷰의 초기 상태를 갱신
    mounted() {
        this.fnReview();
        this.fnSimple();
    }
};