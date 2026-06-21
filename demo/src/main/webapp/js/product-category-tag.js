const { createApp } = Vue;

const app = createApp({
    data() {
        return {
            currentMenu: 'main',
            productPage: 'list',
            productList: [],          // 자식 컴포넌트(product-list-component)로 props 바인딩되는 실제 상품 리스트
            productTag: [],           // 부모 관리용 태그 바구니
            product1: {},             // 단건 상세 진입용 임시 저장 객체
            selectedDate: '',         // 예약 날짜
            selectedTime: '',         // 예약 시간
            res_content: '',          // 예약 요청 사항
            myReservation1: {},       // 단건 예약 내역 상세 정보 주머니
            myInquiry1: {},           // 단건 문의 상세 정보 주머니
            userid: window.SESSION_ID || '' // 로그인 연동 세션 ID
        };
    },
    methods: {
        // 💡 고도화 핵심 파이프라인: 자식의 필터 변동 무전을 수신하여 상용 jQuery $.ajax로 백엔드 실시간 필터링 완전 구동
        fnLoadProductList(filterData) {
            var self = this;
            $.ajax({
                url: '/productList.dox',
                type: 'POST',
                data: {
                    largeCategory: filterData.largeCategory,
                    mediumCategory: filterData.mediumCategory,
                    tags: filterData.tags // 콤마로 결합된 다중 태그 문자열 전달 ("화려한,가성비")
                },
                dataType: 'json',
                success: function(data) {
                    if (data.result === 'success') {
                        // 백엔드 고도화 쿼리가 반환한 완벽한 교집합 정답 리스트를 부모 인스턴스에 수혈합니다.
                        // 부모의 데이터가 바뀌면 Vue 3의 반응성 원리에 의거해 자식의 :product-list 화면도 즉시 자동 리렌더링됩니다.
                        self.productList = data.list;
                    } else {
                        console.error("서버 비즈니스 처리 오류:", data.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("jQuery AJAX 기반 실시간 상품 필터링 목록 로드 실패:", error);
                }
            });
        },
        goDetailPage(item) {
            this.product1 = item;
            this.productPage = 'detail';
        },
        goMyResPage() {
            this.productPage = 'resultOfReservation';
        },
        goMyInquiryPage() {
            this.productPage = 'myRealInquiryList';
        },
        fnBack() {
            this.productPage = 'list';
        },
        goInquiry() {
            this.productPage = 'inquiry';
        },
        onDetailReserve(date, time, content) {
            this.selectedDate = date;
            this.selectedTime = time;
            this.res_content = content;
            this.productPage = 'payment';
        },
        onReservationSuccess() {
            this.productPage = 'resultOfReservation';
        },
        fnGoDetail(resItem) {
            this.myReservation1 = resItem;
            this.productPage = 'reservaionPaymentDetails';
        },
        fnInquiryAnswerDetails(inquiryItem) {
            this.myInquiry1 = inquiryItem;
            this.productPage = 'inquiry1Details';
        }
    },
    mounted() {
        // 초기 데이터 로드는 자식 컴포넌트의 created 시점에 triggerFilterReload 무전이 
        // 자동으로 날아오면서 부모의 fnLoadProductList가 실행되므로 중복 마운트 조회를 방어합니다.
    }
});

// 하위 연동 자식 컴포넌트 인프라 의존성 주입 등록 (가상 생략 방지 완결)
if (typeof productListComponent !== 'undefined') {
    app.component('product-list-component', productListComponent);
}
if (typeof productDetailComponent !== 'undefined') {
    app.component('product-detail-component', productDetailComponent);
}
if (typeof productInquiryWriteComponent !== 'undefined') {
    app.component('product-inquiry-write-component', productInquiryWriteComponent);
}
if (typeof productReservationPaymentComponent !== 'undefined') {
    app.component('product-reservation-payment-component', productReservationPaymentComponent);
}
if (typeof myReservationListComponent !== 'undefined') {
    app.component('my-reservation-list-component', myReservationListComponent);
}
if (typeof reservationDetailComponent !== 'undefined') {
    app.component('reservation-detail-component', reservationDetailComponent);
}
if (typeof myInquiryListComponent !== 'undefined') {
    app.component('my-inquiry-list-component', myInquiryListComponent);
}
if (typeof inquiryDetailComponent !== 'undefined') {
    app.component('inquiry-detail-component', inquiryDetailComponent);
}

// Vue 3 앱 구동 시작
app.mount('#app');