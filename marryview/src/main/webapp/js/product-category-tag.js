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
			userid: window.SESSION_ID || '', // 로그인 연동 세션 ID
			
			/* 부모 템플릿 프레임과 완벽 연동되는 전용 탭 복원선 변수 정식 선언 */
			currentSearchMode: 'product',
			
			/* 자식 업체 목록에서 쏘아올린 고유 업체 번호를 저장할 독립 레일용 센서 방 */
			selectedCompanyNo: null,
			
			/* 💡 [히스토리 레지스트리 신설] 상품 상세방에서 뒤로가기를 누를 때 롤백 복귀할 목적지 변수 방 */
			detailBackTarget: 'list'
		};
	},
	methods: {
		// 고도화 핵심 파이프라인: 자식의 필터 변동 무전을 수신하여 상용 jQuery $.ajax로 백엔드 실시간 필터링 완전 구동
		fnLoadProductList(filterData) {
			var self = this;
			$.ajax({
				url: '/productList.dox',
				type: 'POST',
				data: {
					largeCategory: filterData.largeCategory,
					mediumCategory: filterData.mediumCategory,
					tags: filterData.tags, // 콤마로 결합된 다중 태그 문자열 전달 ("화려한,가성비")
					loginUserId: self.userid
				},
				dataType: 'json',
				success: function(data) {
					if (data.result === 'success') {
						// 백엔드 고도화 쿼리가 반환한 완벽한 교집합 정답 리스트를 부모 인스턴스에 수혈합니다.
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
		
		/* 독립형 업체 목록 자식이 쏘아올린 무전을 수신하여 업체 상세 레일로 상태를 전이시키는 핸들러 */
		goCompanyDetailPage(companyNo) {
			this.selectedCompanyNo = companyNo; // 클릭된 고유 업체 번호를 부모 센서 방에 격납
			this.productPage = 'companyDetail'; // 화면을 업체 상세 레이아웃 컴포넌트로 전격 스위칭
		},
		
		/* 💡 [메인 루트 진입] 메인 상품 목록에서 클릭 시에는 복귀 타겟을 'list'로 안전 조율 */
		goDetailPage(item) {
			this.detailBackTarget = 'list';
			this.product1 = item;
			this.productPage = 'detail';
		},
		
		/* 💡 [상세방 우회 루트 신설] 업체 상세방 내 추천 상품을 클릭했을 때 작동하는 고도화 전용 다차원 라우터 선선 */
		goProductDetailPageFromCompany(item) {
			this.detailBackTarget = 'companyDetail'; // 🎯 뒤로가기를 대비해 직전 복귀 타겟을 '업체 상세'로 기록 변조!
			this.product1 = item;
			this.productPage = 'detail';
		},
		
		goMyResPage() {
			this.productPage = 'resultOfReservation';
		},
		goMyInquiryPage() {
			this.productPage = 'myRealInquiryList';
		},
		
		/* 💡 [추적 복귀 개정] 하드코딩 상수를 파괴하고, 유저가 인입된 이전 히스토리 목적지 궤도로 자석 롤백 처리 */
		fnBack() {
			this.productPage = this.detailBackTarget;
		},
		
		goInquiry() {
			this.productPage = 'inquiry';
		},
		// 실전 디버깅 완결: 자식 컴포넌트가 쏘아 올린 { date, time, content } 단일 포장 상자(객체)를 
		// 안전하게 인자로 수신받아 부모창의 개별 반응성 변수들에 조각조각 완벽하게 해체 및 분배 대입 완료!
		onDetailReserve(reserveData) {
			this.selectedDate = reserveData.date;
			this.selectedTime = reserveData.time;
			this.res_content = reserveData.content; // 유저님이 작성하신 내용이 이 방으로 안전하게 정착합니다!
			this.productPage = 'payment';
			window.scrollTo(0, 0); // 화면 상단으로 쾌적하게 스크롤 포커싱
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
		// 자동으로 날아오면서 부모의 fnLoadProductList가 실행되므로 중복 마운트 조합니다.
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

/* 새롭게 개설되는 독립형 업체 목록 및 상세 자식 컴포넌트들의 가동 의존성 엔진 등록선 */
if (typeof companyListComponent !== 'undefined') {
	app.component('company-list-component', companyListComponent);
}
if (typeof companyDetailComponent !== 'undefined') {
	app.component('company-detail-component', companyDetailComponent);
}

// Vue 3 앱 구동 시작
app.mount('#app');