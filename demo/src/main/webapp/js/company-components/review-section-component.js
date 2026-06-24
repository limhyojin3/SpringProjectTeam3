const ReviewSectionComponent = {
    template: '#review-section-template',

    data() {
        return {
            viewPage: 'main', reviewTab: 'detail', reviewListPage: 1, reviewListPageSize: 5, currentPage: 1,
            newReviewCnt: 0, newUnpaidReviewCnt: 0, totalReviewCnt: 0, totalSimpleReviewCnt: 0,
            registeredProductList: [], productListForSimpleReviews: [], reviews: [], simpleReviews: []
        };
    },

    computed: {
        paginatedReviews() {
            const start = (this.currentPage - 1) * 5;
            return this.reviews.slice(start, start + 5);
        },
        paginatedSimpleReviews() {
            const start = (this.currentPage - 1) * 5;
            return this.simpleReviews.slice(start, start + 5);
        },
        pagedRegisteredProductList() {
            const start = (this.reviewListPage - 1) * this.reviewListPageSize;
            return this.registeredProductList.slice(start, start + this.reviewListPageSize);
        },
        pagedProductListForSimpleReviews() {
            const start = (this.reviewListPage - 1) * this.reviewListPageSize;
            return this.productListForSimpleReviews.slice(start, start + this.reviewListPageSize);
        },
        totalReviewListPages() { return Math.ceil(this.registeredProductList.length / this.reviewListPageSize); },
        totalSimpleReviewListPages() { return Math.ceil(this.productListForSimpleReviews.length / this.reviewListPageSize); },
        totalPages() { return Math.ceil(this.reviews.length / 5); },
        totalSimplePages() { return Math.ceil(this.simpleReviews.length / 5); },

        /* 💡 고도화 핵심: 현재 활성화된 페이지를 기준으로 오직 '최대 3개'의 숫자 배열만 반환하는 슬라이딩 파이프라인 */
        visibleReviewListPages() { return this.calcSliding(this.reviewListPage, this.totalReviewListPages); },
        visibleSimpleReviewListPages() { return this.calcSliding(this.reviewListPage, this.totalSimpleReviewListPages); },
        visibleDetailPages() { return this.calcSliding(this.currentPage, this.totalPages); },
        visibleSimpleDetailPages() { return this.calcSliding(this.currentPage, this.totalSimplePages); }
    },

    methods: {
        /* 🎯 최대 3개 노출 동적 슬라이딩 윈도우 헬퍼 연산식 */
        calcSliding(current, total) {
            if (total <= 3) { return Array.from({ length: total }, (_, i) => i + 1); }
            let start = Math.max(1, current - 1);
            if (start + 2 > total) { start = total - 2; }
            return [start, start + 1, start + 2];
        },
        fnGoBackToList() { this.viewPage = 'main'; },
        fnReview() {
            this.reviewTab = 'detail'; this.reviewListPage = 1; let self = this;
            $.ajax({
                url: "/getReviewCnt.dox", dataType: "json", type: "POST", data: { userId: window.SESSION_ID },
                success: function(data) {
                    self.registeredProductList = data.list; self.newReviewCnt = data.info.reviewCount;
                    self.totalReviewCnt = self.registeredProductList.reduce((sum, p) => sum + p.reviewCount, 0);
                }
            });
        },
        fnSimple() {
            this.reviewTab = 'simple'; this.reviewListPage = 1; let self = this;
            $.ajax({
                url: "/getSimpleReviewCnt.dox", dataType: "json", type: "POST", data: { userId: window.SESSION_ID },
                success: function(data) {
                    self.productListForSimpleReviews = data.list; self.newUnpaidReviewCnt = data.info.reviewCount;
                    self.totalSimpleReviewCnt = self.productListForSimpleReviews.reduce((sum, p) => sum + p.reviewCount, 0);
                }
            });
        },
        fnReviewDetails(w) {
            this.viewPage = 1; this.currentPage = 1; let self = this;
            $.ajax({
                url: "/ReviewDetails3.dox", dataType: "json", type: "POST", data: { userId: window.SESSION_ID, productNo: w.productNo },
                success: function(data) { self.reviews = data.list.map(r => ({ ...r, isExpanded: false })); }
            });
        },
        fnSimpleReviewDetails(w) {
            this.viewPage = 1; this.currentPage = 1; let self = this;
            $.ajax({
                url: "/SimpleReviewDetails3.dox", dataType: "json", type: "POST", data: { userId: window.SESSION_ID, productNo: w.productNo },
                success: function(data) { self.simpleReviews = data.list; }
            });
        },
        fnPageChange(num) { this.currentPage = num; window.scrollTo({ top: 0, behavior: 'smooth' }); },
        cleanText(content) { return PartnerUtils.cleanText(content); },
        starRating(rev) { return PartnerUtils.starRating(rev); }
    },

    mounted() { this.fnReview(); this.fnSimple(); }
};