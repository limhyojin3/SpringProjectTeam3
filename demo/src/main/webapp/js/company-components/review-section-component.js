// 리뷰 관리 컴포넌트 명세서
const ReviewSectionComponent = {
    template: '#review-section-template',
    props: [
        'viewPage', 'reviewTab', 'totalReviewCnt', 'totalSimpleReviewCnt',
        'newReviewCnt', 'pagedRegisteredProductList', 'registeredProductList',
        'reviewListPage', 'totalReviewListPages', 'newUnpaidReviewCnt',
        'pagedProductListForSimpleReviews', 'totalSimpleReviewListPages',
        'reviews', 'paginatedReviews', 'currentPage', 'totalPages',
        'simpleReviews', 'paginatedSimpleReviews', 'totalSimplePages',
        'fnReview', 'fnSimple', 'fnReviewDetails', 'fnSimpleReviewDetails',
        'fnGoBackToList', 'starRating', 'cleanText', 'fnPageChange'
    ]
};