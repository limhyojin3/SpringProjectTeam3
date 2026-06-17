
const app = Vue.createApp({
    el: '#app',
    data() {
        return {
            currentMenu: 'main',
            // 리뷰 내역 페이지 사이징
            reviewListPage: 1,   // 리뷰 상품 목록 페이지
            reviewListPageSize: 5,
            inquiryAnswer: {
                inquiryNo: '',
                ansUserId: '',
                answerNo: '',
                answerContents: '',
                inquiryAns: ''
            },
            inquiryDetails: {},
            newReviewCnt: 0,
            newUnpaidReviewCnt: 0,
            totalSimpleReviewCnt: 0,
            // 변수 - (key : value)
            totalReviewCnt: 0,
            productListForSimpleReviews: [],
            inquiryList: [],
            user: {},
            reviewTab: 'detail',
            viewPage: 'main', // 상품별 리뷰 페이지 구분 변수
            currentPage: 1,
            product: '',
            productList: [],
            simpleReviews: [],
            reviews: [],
        }
    }, // data
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
            return this.filteredReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
        },
        paginatedSimpleReviews() {
            const start = (this.currentPage - 1) * 5;
            const end = start + 5;
            return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
        },
        fnPaginatedInquiry() {
            let start = this.currentPage - 1;
            let end = start + 1;
            return this.inquiryList.slice(start, end);
            //(0, 1), (1, 2)
        },
        totalPages() {
            return Math.ceil(this.filteredReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
        },
        totalSimplePages() {
            return Math.ceil(this.filteredSimpleReviews.length / 5); // 총 페이지 수 계산 (5개씩 보여줄 때) // 숫자
        },
        // 리뷰 내역 페이지
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
        }
    },
    methods: {
        // 함수(메소드) - (key : function())
        fnGoBackToList: function() {
            this.viewPage = 'main';
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
       
        fnThumbnail(i) {    //fnThumbnail(개별문의) 해변스냅
            return this.inquiryList.find(p => p.productName === i.productName).imgUrl;
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
            else if (menuId === 'product') {
                //this.fnProductList();
            } else if (menuId === 'reservation') {
                //this.fnReservationList();
            } else if (menuId === 'review') {

                this.fnSimple();
                this.fnReview();
            } else if (menuId === 'inquiry') {
                this.fnInquiryProduct();
            }
        },
        
        fnReservationList: function() {

            this.resCurrentPage = 1;

            let self = this;
            let param = {
                userId: window.SESSION_ID
            };
            $.ajax({
                url: "/ReservationList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.reservationList = data.list;
                    self.resCount = data.newResCnt;
                }
            });
        },
        fnReview() {
            this.reviewTab = 'detail';
            this.reviewListPage = 1;
            let self = this;
            let param = {
                userId: window.SESSION_ID
            };
            $.ajax({
                url: "/getReviewCnt.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.registeredProductList = data.list;
                    self.newReviewCnt = data.info.reviewCount;

                    let reviewCntList = self.registeredProductList.map(p => p.reviewCount); //[3,0,1..];

                    let sum = 0;
                    for (let i = 0;i < reviewCntList.length;i++) {
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
            let param = {
                userId: window.SESSION_ID
            };
            $.ajax({
                url: "/getSimpleReviewCnt.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    //console.log(data);
                    self.productListForSimpleReviews = data.list;
                    self.newUnpaidReviewCnt = data.info.reviewCount;

                    let reviewCntList = self.productListForSimpleReviews.map(p => p.reviewCount); //[3,0,1..];
                    let sum = 0;
                    for (let i = 0;i < reviewCntList.length;i++) {
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
            console.log(param.productNo);
            $.ajax({
                url: "/ReviewDetails3.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.reviews = data.list;
                    self.reviews = self.reviews.map(r => ({ ...r, isExpanded: false })); //추가된부분
                    //console.log(self.reviews);
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
                    console.log(data);

                    self.simpleReviews = data.list;
                    //reviews, simpleReviews
                }
            });
        },
        fnPageChange(num) {
            this.currentPage = num;

            window.scrollTo({
                top: 0,
                behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
            });
        },
        starRating(rev) {

            rev.rating = rev.rating + "";

            if (rev.rating.slice(0, 1) == 5) {
                return '★★★★★';
            } else if (rev.rating.slice(0, 1) == 4) {
                return '★★★★☆';
            } else if (rev.rating.slice(0, 1) == 3) {
                return '★★★☆☆';
            } else if (rev.rating.slice(0, 1) == 2) {
                return '★★☆☆☆';
            } else {
                return '★☆☆☆☆';
            }
        },
        
        fnInquiryProduct() {
            let self = this;
            let param = {
                userId: window.SESSION_ID
            };
            console.log(param);
            $.ajax({
                url: "/getInquiryProductList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);

                    self.inquiryList = data.list;
                }
            });
        },
        //문의에 답변하러 넘어가는 타이밍
        fnAnswerToProductInquiry(i) { //매개변수를 이용!
            this.viewPage = 'answer';
            this.inquiryDetails = i;

            let self = this;
            let param = {
                inquiryNo: self.inquiryDetails.inquiryNo
            };
            console.log(param);
            $.ajax({
                url: "/getInquiryAnsYn.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);

                    if (data.result === 'success') {
                        self.inquiryAnswer.inquiryNo = data.info.inquiryNo || '';
                        self.inquiryAnswer.ansUserId = data.info.ansUserId || '';
                        self.inquiryAnswer.answerNo = data.info.answerNo || '';
                        self.inquiryAnswer.answerContents = data.info.answerContents || '';
                        self.inquiryAnswer.inquiryAns = data.info.inquiryAns || '';
                    }
                }
            });
        },
        fnBacktoInquiry() {
            this.viewPage = 'main';
            //console.log(this.viewPage);
        },
        /*상품문의에 답변하기*/
        fnSaveAnswer() {
            if (!this.inquiryAnswer.ansUserId || this.inquiryAnswer.ansUserId.trim() === '') {
                alert("답변자를 작성해주세요!");
                return;
            }
            if (!this.inquiryAnswer.answerContents || this.inquiryAnswer.answerContents.trim() === '') {
                alert("답변내용을 작성해주세요!");
                return;
            }
            let self = this;
            let param = {
                inquiryNo: self.inquiryAnswer.inquiryNo,
                answerContents: self.inquiryAnswer.answerContents,
                ansUserId: self.inquiryAnswer.ansUserId,
                inquiryAns: self.inquiryAnswer.inquiryAns //0 또는 1
            };
            console.log(param);
            $.ajax({
                url: "/addProductInquiryAnswer.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    //답변이 등록되면서 답변여부가 업데이트 된다
                    if (data.result === 'success') {
                        alert("답변 등록/수정 완료!");
                        self.viewPage = 'main';
                    } else {
                        alert("서버 오류!");
                    }
                }
            });
        },
        /* 제휴업체로 등록하러가기 */
        fnRegPTN() {
            location.href = "/adminRegistration.do"
        },
		cleanText(content) { return PartnerUtils.cleanText(content); },
        starRating(rev) { return PartnerUtils.starRating(rev); },
	}, // methods
    mounted() {
        // 처음 시작할 때 실행되는 부분
        let self = this;
        self.fnCom();
        //self.fnReservationList();
        self.fnSimple();
        self.fnReview();
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