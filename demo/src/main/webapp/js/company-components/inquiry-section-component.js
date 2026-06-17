// 문의 관리 컴포넌트 명세서
const InquirySectionComponent = {
    template: '#inquiry-section-template',
    props: [
        'viewPage', 'inquiryList', 'fnPaginatedInquiry', 'fnThumbnail', 
        'fnAnswerToProductInquiry', 'currentPage', 'inquiryDetails', 
        'inquiryAnswer', 'fnBacktoInquiry', 'fnSaveAnswer'
    ]
};