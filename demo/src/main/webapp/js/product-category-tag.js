const app = Vue.createApp({
    data() {
        return {
            // 1. 페이지 및 메뉴 라우팅 상태
            currentMenu: 'main',
            productPage: 'list',

            // 2. 유저 세션 및 마스터 데이터
            userid: window.SESSION_ID,
            productList: [],
            productTag: [],

            // 3. [중요] 자식 컴포넌트 간 데이터를 공유하기 위한 징검다리 바구니
            product1: {},       // 현재 선택된 상품 상세 정보
            myInquiry1: {},     // 상세보기 선택된 문의 내역
            myReservation1: {}, // 상세보기 선택된 예약 내역

            // 4. [상세 화면] -> [결제 대기 화면] 데이터 전달 브릿지
            selectedDate: '',
            selectedTime: '',
            res_content: '',
        }
    },
    methods: {
        // 1. 메인 상품 및 태그 리스트 최초 조회 (필수 함수)
        fnGetTagAndProductList() {
            let self = this;
            ProductService.getTagAndProductList(function(tags, products) {
                self.productTag = tags;
                self.productList = products;
            });
        },

        // 2. [상세 화면] -> [예약 대기 화면] 데이터 연결 브릿지 핸들러
        onDetailReserve(payload) {
            this.selectedDate = payload.date;
            this.selectedTime = payload.time;
            this.res_content = payload.content;
            this.productPage = 'payment';
            window.scrollTo(0, 0);
        },

        // 3. 예약 저장 / 결제 완료 성공 시 전역 상태 초기화 함수
        onReservationSuccess() {
            this.selectedDate = '';
            this.selectedTime = '';
            this.res_content = '';
            this.productPage = 'list';
        },

        // 4. 네비게이션 및 화면 뒤로가기 제어
        fnBack() {
            this.productPage = 'list';
            this.selectedDate = '';
            this.selectedTime = '';
        },
        goDetailPage(item) {
            this.productPage = 'detail';
            this.product1 = { ...item };
            window.scrollTo(0, 0);
        },
        goMyResPage() {
            this.productPage = 'resultOfReservation';
        },
        fnGoDetail(r) {
            this.productPage = "reservaionPaymentDetails";
            this.myReservation1 = r;
        },
        goMyInquiryPage() {
            this.productPage = 'myRealInquiryList';
        },
        fnInquiryAnswerDetails(inquiry) {
            this.myInquiry1 = inquiry;
            this.productPage = 'inquiry1Details';
        },
        goInquiry() {
            this.productPage = 'inquiry';
        },
        // ⭕ 메인 상품 및 태그 리스트를 서비스 파일로부터 조회해오는 필수 함수입니다!
        fnGetTagAndProductList() {
            let self = this;
            ProductService.getTagAndProductList(function(tags, products) {
                self.productTag = tags;
                self.productList = products;
            });
        }
    },
    mounted() {
        this.fnGetTagAndProductList();
    }
});

// 💡 요청하신 방식대로 변수화된 객체를 각각 컴포넌트로 등록합니다.
app.component('product-list-component', productListComponent);
app.component('product-detail-component', productDetailComponent);

// 💡 새롭게 만든 문의 관련 컴포넌트 변수 3개를 등록합니다!
app.component('product-inquiry-write-component', productInquiryWriteComponent);
app.component('my-inquiry-list-component', myInquiryListComponent);
app.component('inquiry-detail-component', inquiryDetailComponent);

// 💡 새롭게 만든 예약/결제 컴포넌트 객체 3개를 최종 부착(등록)합니다!
app.component('product-reservation-payment-component', productReservationPaymentComponent);
app.component('my-reservation-list-component', myReservationListComponent);
app.component('reservation-detail-component', reservationDetailComponent);

app.mount('#app');