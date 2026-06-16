// 1. [파일 최상단에 추가] 메인 메뉴 컴포넌트의 명세서 정의
const MainMenuComponent = {
    template: '#main-menu-template', // JSP 하단에 만든 template id와 연결
    props: ['user'] // 부모로부터 넘겨받을 데이터 이름을 지정
};

const app = Vue.createApp({
    el: '#app',
    data() {
        return {
            currentMenu: 'main',
            // 리뷰 내역 페이지 사이징
            reviewListPage: 1,   // 리뷰 상품 목록 페이지
            reviewListPageSize: 5,
            // 예약 관리 페이지 사이징
            selectedRes: null,
            resCurrentPage: 1,
            resPageSize: 5,
            // 상품관리 페이지 사이징//
            productCurrentPage: 1,
            productPageSize: 5,   // 한 페이지에 보여줄 상품 수
            /*문의 답변과 관련된 맵*/
            inquiryAnswer: {
                inquiryNo: '',
                ansUserId: '',
                answerNo: '',
                answerContents: '',
                inquiryAns: ''
            },
            inquiryDetails: {},
            resCount: '',
            newReviewCnt: 0,
            newUnpaidReviewCnt: 0,
            totalSimpleReviewCnt: 0,
            // 변수 - (key : value)
            totalReviewCnt: 0,
            registeredProductList: [],
            productListForSimpleReviews: [],
            inquiryList: [],
            user: {},
            reviewTab: 'detail',
            viewPage: 'main', // 상품별 리뷰 페이지 구분 변수
            productPage: 'list', //(list: 목록, reg: 등록, edit: 수정)
            currentPage: 1,
            product: '',
            oneProductDetails: {},
            productList: [],
            simpleReviews: [],
            reviews: [],
            reservationList: [],
            category: ["스튜디오", "드레스", "메이크업"],
            previewUrl: null, // 미리보기용 URL
            uploadFile: null,  // 서버로 보낼 실제 파일 객체
            initializedOneProductDetails: {
                companyNo: '',
                productNo: '',
                proType: [],
                productName: '',
                productDetails: '',
                originalPrice: '',
                imgUrl: '',
                deposit: 0,
                tag: []
            },
            tagMap: {
                input1: '',
                input2: '',
                input3: '',
                input4: '',
                input5: ''
            },
            serverTagList: []
        }

    }, // data
    computed: {
        tagMapToList() {
            const filteredtagArray = Object.values(this.tagMap).filter(tag => tag.trim() !== "");
            return filteredtagArray;
        },
        newTagsOnly() {
            if (!this.serverTagList) {
                return tagMapToList();
            }
            return this.tagMapToList.filter(t => !this.serverTagList.includes(t));
        },
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
        // 상품 관리 페이지 사이징
        fnPaginatedProductList() {
            const start = (this.productCurrentPage - 1) * this.productPageSize;
            const end = start + this.productPageSize;
            return this.registeredProductList.slice(start, end);
        },
        totalProductPages() {
            return Math.ceil(this.registeredProductList.length / this.productPageSize);
        },
        // 예약관리 페이지
        pagedResList() {
            const start = (this.resCurrentPage - 1) * this.resPageSize;
            const end = start + this.resPageSize;
            return this.reservationList.slice(start, end);
        },
        totalResPageCount() {
            return Math.ceil(this.reservationList.length / this.resPageSize);
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
        fnProductList: function() {
            this.productCurrentPage = 1;

            let self = this;
            let param = {
                userid: window.SESSION_ID
            };
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    //console.log(data);
                    self.registeredProductList = data.list; //덮어씌우기
                }
            });
        },
        fnEditPage(item) {
            let self = this;
            self.productPage = 'edit';

            let param = {
                userid: window.SESSION_ID,
                productNo: item.productNo //파라미터로 보내주면되는구나~
            };
            $.ajax({
                url: "http://localhost:8080/productDetail.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    // 1. 일단 전체 데이터를 담습니다.
                    self.oneProductDetails = data.info;//덮어씌우기
                    self.serverTagList = data.tagList;

                    // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                    // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                    if (typeof self.oneProductDetails.proType === 'string') {
                        try {
                            let rawArray = JSON.parse(self.oneProductDetails.proType);//["MAKEUP" , "STUDIO"]

                            self.oneProductDetails.proType = rawArray.map(val => {
                                if (val === 'MAKEUP') {
                                    return '메이크업';
                                } else if (val === 'DRESS') {
                                    return '드레스';
                                } else if (val === 'STUDIO') {
                                    return '스튜디오';
                                } else {
                                    return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                } //self.oneProductDetails.proType = ["메이크업", "스튜디오"]
                            })
                        } catch (e) {
                            // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                            self.oneProductDetails.proType = [];
                        }
                    }
                    if (typeof self.oneProductDetails.tag === 'string') {
                        try {
                            let rawArry = JSON.parse(self.oneProductDetails.tag);

                            self.oneProductDetails.tag = rawArry;

                            for (let i = 0;i < 5;i++) {
                                self.tagMap[`input${i + 1}`] = self.oneProductDetails.tag[i] || "";
                            }
                        } catch (e) {
                            self.oneProductDetails.tag = [];
                        }
                    }

                }
            });
        },
        fnRegPage() {
            this.oneProductDetails = {
                productNo: '',
                proType: [],
                productName: '',
                productDetails: '',
                originalPrice: '',
                imgUrl: '',
                deposit: 0,
                tag: []
            }
            for (let i = 0;i < 5;i++) {
                this.tagMap[`input${i + 1}`] = '';
            }
            this.initializedOneProductDetails = {
                ...this.initializedOneProductDetails,
                productName: '',
                proType: [],
                productDetails: '',
                originalPrice: '',
                deposit: 0
            }
            this.productPage = 'reg';

            let self = this;
            let param = {};
            $.ajax({
                url: "/getTagList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    console.log(data);
                    self.serverTagList = data.tagList;
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
                this.fnProductList();
            } else if (menuId === 'reservation') {
                this.fnReservationList();
            } else if (menuId === 'review') {

                this.fnSimple();
                this.fnReview();
            } else if (menuId === 'inquiry') {
                this.fnInquiryProduct();
            }
        },
        fnFileChange(event) {
            // 1. 이벤트가 일어난 대상(input)에서 선택된 파일들 중 첫 번째[0]를 가져와요.
            const file = event.target.files[0];

            if (file) {
                // 2. 진짜 파일 덩어리를 우리 변수에 쏙 넣어둡니다.
                this.uploadFile = file;

                // 3. 브라우저가 "이 파일 내가 잠깐 보여줄 수 있게 가짜 주소 만들어줄게!" 하는 기능이에요.
                this.previewUrl = URL.createObjectURL(file);

            }
        },
        fnUpdateProduct() {
            // 1. 택배 박스(FormData)를 하나 만듭니다.
            // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
            let self = this;
            let formData = new FormData();

            // 1. 사진 파일 담기(선택했을 때만)
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }

            // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
            formData.append("productNo", this.oneProductDetails.productNo);
            formData.append("productName", this.oneProductDetails.productName);
            formData.append("productDetails", this.oneProductDetails.productDetails);
            formData.append("originalPrice", this.oneProductDetails.originalPrice);

            formData.append("deposit", this.oneProductDetails.deposit);
            formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));

            formData.append("proType", JSON.stringify(this.oneProductDetails.proType));

            formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

            $.ajax({
                url: "/upload.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                    // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                    if (res.result === "success") {
                        alert("상품 정보가 모두 수정되었습니다!");
                        console.log(res.message1);
                        window.location.href = "/partnerManagement.do";  //
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }

                }
            })
        },
        fnInsertProduct() {
            // 1. 택배 박스(FormData)를 하나 만듭니다.
            // 파일은 일반 텍스트가 아니라서 반드시 이 'FormData'라는 박스에 담아야 해요.
            let self = this;
            let formData = new FormData();

            // 1. 사진 파일 담기(선택했을 때만)
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }

            // 2. 다른 모든 정보들 싹 다 담기(자바의 변수명과 똑같이!)
            formData.append("productNo", this.initializedOneProductDetails.productNo);
            formData.append("productName", this.initializedOneProductDetails.productName);
            formData.append("productDetails", this.initializedOneProductDetails.productDetails);
            formData.append("originalPrice", this.initializedOneProductDetails.originalPrice);

            formData.append("deposit", this.initializedOneProductDetails.deposit);
            formData.append("proType", JSON.stringify(this.initializedOneProductDetails.proType));
            formData.append("userId", window.SESSION_ID);

            formData.append("tag", JSON.stringify([...new Set(this.tagMapToList)]));
            formData.append("uniqueNewTagsOnly", this.uniqueNewTagsOnly());

            $.ajax({
                url: "/upload2.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    console.log("서버가 보낸 데이터:", data); // [체크!] 이 데이터가 어떻게 생겼는지 확인

                    // 만약 data가 JSON 문자열로 넘어왔다면 파싱이 필요할 수도 있어요
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                    if (res.result === "success") {
                        alert("상품 정보가 모두 등록되었습니다!");
                        console.log(res.message1);
                        window.location.href = "/partnerManagement.do"; //
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }

                }
            })
        },
        fnRemoveProduct(item) {  //item in productList
            if (confirm("정말 삭제하시겠습니까?")) {

                let self = this;
                let param = {
                    productNo: item.productNo
                };
                console.log(item);
                $.ajax({
                    url: "/productRemove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {

                        alert(data.message);
                        location.href = "/partnerManagement.do"
                    }
                });
            } else {
                alert("삭제가 취소되었습니다.");
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
        uniqueNewTagsOnly() {
            return [...new Set(this.newTagsOnly)];
        },
        fnBackToList() {
            this.tagMap = {};
            this.productPage = 'list'
            this.initializedOneProductDetails.deposit = 0;
            this.previewUrl = null;
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
        // 1. 이미지 제거 정규식
        removeImages(content) {
            const regex = /<img[^>]*>/gi;
            return content.replace(regex, "");
        },
        // 2. 모든 HTML 태그 제거 및 텍스트 추출
        stripHtml(html) {
            let doc = new DOMParser().parseFromString(html, 'text/html');
            return doc.body.textContent || "";
        },
        // 3. 두 기능을 합친 최종 함수
        cleanText(content) {
            // 이미지를 먼저 지운 문자열을 stripHtml에 전달
            const noImage = this.removeImages(content);
            return this.stripHtml(noImage);
        },
        getResStatusText(status) {
            switch (status) {
                case 'CONFIRM': return '✅ 예약이 확정되었습니다.';
                case 'CANCEL': return '❌ 취소된 예약입니다.';
                case 'DONE': return '만료된 예약입니다.';
                case 'WAIT': return '결제 대기 상태입니다.';
                default: return status;
            }
        }
    }, // methods
    mounted() {
        // 처음 시작할 때 실행되는 부분
        let self = this;
        self.fnCom();
        self.fnReservationList();
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

app.mount('#app');