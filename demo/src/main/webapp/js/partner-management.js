
const app = Vue.createApp({
    el: '#app',
    data() {
        return {
            currentMenu: 'main',
            user: {},
            product: '',
            productList: [],
            productCurrentPage: 1
        }
    }, // data
    methods: {
        // 함수(메소드) - (key : function())
        fnProductList() {
            let self = this;
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: { userid: window.SESSION_ID }, // 전역 세션ID 사용
                success: function(data) {
                    self.productList = data.list; // 이제 내 방의 변수에 저장!
                }
            });
        },
        fnCom: function() {
            let self = this;
            let param = {
                userid: window.SESSION_ID
            };
            $.ajax({
                url: "http://localhost:8080/company.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data); //info,result,message

                    self.user = {
                        ...self.user, // 기존 user의 다른 데이터들을 유지하고 싶을 때 사용
                        name: data.info.comName,
                        payDate: data.info.payDate,
                        grade: data.info.role,
                        lastPayment: data.info.previousPayment,
                        regDate: data.info.regDate
                    };
                }
            });
        },
        handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
            this.currentMenu = menuId;
            this.productPage = 'list';
            this.currentPage = 1;
            this.viewPage = 'main';
            this.reviewTab = 'detail';

            if (menuId === 'main') {
                this.fnCom();
            }
            // 💡 예약 관리나 상품 관리 메뉴를 누르면 상품 목록을 새로고침 하도록 설정
            else if (menuId === 'reservation' || menuId === 'product') {
                this.fnProductList();
            }
        },
        /* 제휴업체로 등록하러가기 */
        fnRegPTN() {
            location.href = "/adminRegistration.do"
        },
    }, // methods
    mounted() {
        // 처음 시작할 때 실행되는 부분
        let self = this;
        self.fnCom();
        // 💡 페이지가 처음 켜질 때 상품 목록도 미리 받아옵니다.
        self.fnProductList();
		
        const urlParams = new URLSearchParams(window.location.search);
        const menu = urlParams.get('menu');
        if (menu) {
            this.currentMenu = menu;
        }
    }
});

// 2. [파일 최하단 app.mount 직전에 추가] 앱에 컴포넌트를 장착합니다.
app.component('main-menu-component', MainMenuComponent);
app.component('product-section-component', ProductSectionComponent);
app.component('reservation-section-component', ReservationSectionComponent);
app.component('inquiry-section-component', InquirySectionComponent);
app.component('review-section-component', ReviewSectionComponent);

app.mount('#app');