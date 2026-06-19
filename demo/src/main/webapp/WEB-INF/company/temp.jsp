const app = Vue.createApp({

            

            data() {
                return {
                    myInquiryList: [],
                    //inquiryList v-for 돌릴때 각각이 담기는 곳
                    myInquiry1: {},
                    inquiry: {
                        title: '',
                        contents: ''
                    },
                    userid: "${sessionScope.sessionId}",
                    flag: false,
                    payAmount: '',
                    myReservation1: {},
                    myReservationList: [],
                    selectTags: [],
                    selectCategory: [],
                    productList3: [],
                    inquiryList: [],
                    user: {},
                    currentMenu: 'main', // 초기 화면
                    reviewTab: 'detail',
                    page1: 'main', // 상품별 리뷰 페이지 구분 변수
                    page: 1,
                    product: '',
                    proType: [],
                    simpleReviews: [],
                    reviews: [],
                    reservationList: [],
                    category: ["스튜디오", "드레스", "메이크업"],
                    selectedItems: [],
                    productForm: {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    },
                    pageSize: 0,
                    currentPage: 1,
                    previewUrl: null, // 미리보기용 URL
                    uploadFile: null,  // 서버로 보낼 실제 파일 객체
                    product2: {
                        companyNo: '',
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: ''
                    },
                    userReservationList: []
                }

            }, // data
            computed: {
                fnButtonName() {
                    if (this.myReservation1.resStatus === 'WAIT') {
                        return '결제 및 예약 확정하기';
                    } else if (this.myReservation1.resStatus === 'CANCEL') {
                        return '취소된 예약';
                    } else if (this.myReservation1.resStatus === 'CONFIRM') {
                        return '확정된 예약';
                    } else {
                        return '만료된 예약';
                    }
                }
                ,
                filteredList() {
                    return this.productList.filter(product => {

                        // 카테고리 조건 (선택 안 했으면 pass, 선택했으면 포함 여부 확인)
                        const matchCategory = this.selectCategory.length === 0 || (

                            product.category &&
                            Array.isArray(product.category) &&
                            this.selectCategory.some(cat => product.category.includes(cat))
                            //[]            //과즙팡팡   과즙팡팡,스몰웨딩
                        );
                        // 태그 조건
                        const matchTag = this.selectTags.length === 0 || (

                            product.tag &&
                            Array.isArray(product.tag) &&
                            this.selectTags.some(tag => product.tag.includes(tag))
                        );

                        // 둘 다 만족하는 것만 리턴 (AND 조건)
                        return matchCategory && matchTag;
                    });
                }
                ,
                resCount() {
                    return this.reservationList.length;
                }
                ,
                revCnt() {
                    return this.reviews.filter(r => r.updated === 'new').length
                        + this.simpleReviews.filter(r => r.updated === 'new').length;
                }
                ,
                editingProduct() {
                    // productList에서 이름이 일치하는 녀석을 찾고, 없으면 빈 객체{}를 반환
                    return this.productList.find(p => p.name === this.product) || {};
                },
                menuList() {
                    return [
                        { id: 'main', name: '마이 페이지', count: 0 },
                        { id: 'product', name: '상품 관리', count: 0 },
                        { id: 'reservation', name: '예약 관리', count: this.resCount },
                        { id: 'inquiry', name: '문의 내역', count: 0 },
                        { id: 'review', name: '리뷰 내역', count: this.revCnt },
                        { id: 'customer', name: '고객센터', count: 0 }
                    ];
                },
                weddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.reviews.filter(r => r.product === product.name).length
                        }
                    })
                },
                simpleweddinglist() {
                    return this.productList.map(product => {
                        return {
                            name: product.name,
                            reviewcount: this.simpleReviews.filter(r => r.product === product.name).length
                        }
                    })
                },
                filteredReviews() {
                    return this.reviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },
                filteredSimpleReviews() {
                    return this.simpleReviews.filter(rev => rev.product === this.page1); // 현재 선택된 상품(page1)에 해당하는 리뷰만 반환 //[] 리스트..
                },
                paginatedReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },
                paginatedSimpleReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                },
                fnPaginatedReservation() {
                    let start = (this.currentPage - 1) * 3;
                    let end = start + 3;
                    return this.reservationList.slice(start, end);
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
                }
                ,
                totalPageReservation() {
                    return Math.ceil(this.reservationList.length / 3);
                },
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnPageChange(num) {
                    this.currentPage = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                },
                fnCom: function () {
                    let self = this;
                    let param = {
                        userid: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "http://localhost:8080/company.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.user.name = data.info.comName;
                            self.user.usePeriod = data.info.usePeriod;
                            self.user.grade = data.info.grade;
                            self.user.lastPayment = data.info.lastPayment;
                        }
                    });
                },
                fnProductList: function () {
                    let self = this;
                    let param = {
                        userid: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "http://localhost:8080/productList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.productList3 = data.list; //덮어씌우기
                        }
                    });
                },

                withdraw: function () {
                    if (confirm("정말 탈퇴하시겠습니까?")) {
                        alert("탈퇴되었습니다.");
                    } else {
                        alert("탈퇴가 취소되었습니다.");
                    }
                },
                updateProduct: function () {
                    alert("상품이 수정되었습니다.");
                    this.productPage = 'list'; // 수정 후 상품 목록으로 돌아가기
                },

                goEditPage(item) {
                    let self = this;
                    self.productPage = 'edit';

                    let param = {
                        userid: "${sessionScope.sessionId}",
                        productNo: item.productNo //파라미터로 보내주면되는구나~
                    };
                    $.ajax({
                        url: "http://localhost:8080/productDetail.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // 1. 일단 전체 데이터를 담습니다.
                            self.product1 = data.info;//덮어씌우기
                            // 2. 문자열로 들어온 proType을 실제 배열로 변환합니다.
                            // 만약 데이터가 '["MAKEUP"]' 형태라면 JSON.parse를 써서 ["MAKEUP"] 배열로 만듭니다.
                            if (typeof self.product1.proType === 'string') {
                                try {
                                    let rawArray = JSON.parse(self.product1.proType);//["MAKEUP" , "STUDIO"]

                                    self.product1.proType = rawArray.map(val => {
                                        if (val === 'MAKEUP') {
                                            return '메이크업';
                                        } else if (val === 'DRESS') {
                                            return '드레스';
                                        } else if (val === 'STUDIO') {
                                            return '스튜디오';
                                        } else {
                                            return val; // 혹시 모르는 값이 들어올 경우 원래 값을 유지
                                        } //self.product1.proType = ["메이크업", "스튜디오"]
                                    })
                                } catch (e) {
                                    // 혹시 JSON 형식이 아닐 경우를 대비해 빈 배열로 초기화하거나 예외 처리
                                    self.product1.proType = [];
                                }
                            }



                        }
                    });
                },
                // [2] 등록 버튼 누를 때: 바구니 깨끗이 비우기
                goRegPage() {
                    this.productPage = 'reg';
                    this.product = ''; // 수정 대상이 없으므로 비워줍니다.
                    this.selectedItems = []; // 바구니를 비워야 등록창이 깨끗합니다.
                },

                // [3] 수정 완료 버튼 (Save)
                fnSave() {
                    // 2. productList에서 해당 상품 찾기
                    const item = this.productList.find(p => p.name === this.product);

                    if (item) {
                        item.category = [...this.selectedItems];
                        alert("수정되었습니다!");
                        this.productPage = 'list';
                    } else {
                        // 4. 만약 못 찾았다면 왜 못 찾았는지 경고!
                        alert("수정 대상을 찾지 못했습니다.");
                    }
                },
                fnAdd() {
                    const newProduct = {
                        id: this.productList.length > 0 ?
                            Math.max(...this.productList.map(p => p.id)) + 1 : 1,
                        thumbnail: this.productForm.thumbnail || "images/default-thumbnail.png",
                        name: this.productForm.name,
                        content: this.productForm.content,
                        price: this.productForm.price,
                        category: [...this.selectedItems]
                    }

                    this.productList.push({ ...newProduct });  //{...newProduct} <- 이게 복사본이야? (+)

                    alert("등록되었습니다!");
                    this.resetForm();
                    this.productPage = "list";
                },
                goRegPage2() {
                    this.product1 = {
                        productNo: '',
                        proType: [],
                        productName: '',
                        productDetails: '',
                        originalPrice: '',
                        imgUrl: ''
                    }
                    this.productPage = 'reg';
                },
                resetForm() {
                    this.productForm = {
                        id: "",
                        thumbnail: "",
                        name: "",
                        content: "",
                        price: "",
                        category: []
                    }
                    this.selectedItems = [];

                },
                fnRemove(item) {
                    //fnRemove(프로덕트 리스트에 있는요소)
                    if (confirm("정말 삭제하시겠습니까?")) {
                        const removed = this.productList.find(p => p.id === item.id);
                        const index = this.productList.indexOf(removed);
                        //removed 객체의 인덱스를 구해라. 담아라.
                        if (index !== -1) {
                            this.productList.splice(index, 1);
                            //index 위치에서부터1개 데이터 삭제하고 인덱스들을 앞으로 당김.
                            this.reviews = this.reviews.filter(r => r.product !== item.name);
                            this.simpleReviews = this.simpleReviews.filter(r => r.product !== item.name);
                        }
                        alert("삭제되었습니다.");
                    } else {
                        alert("삭제가 취소되었습니다.");
                    }
                },
                fnThumbnail(inquiry) {    //fnThumbnail(개별문의)
                    return this.productList.find(p => p.name === inquiry.product).thumbnail;
                },
                handleMenuClick(menuId) {   //main,product,reservation,inquiry,review,customer
                    this.currentMenu = menuId;
                    this.productPage = 'list';
                    this.page = 1;
                    this.page1 = 'main';
                    this.reviewTab = 'detail';
                    this.currentPage = 1;
                    if (menuId === 'main') {
                        this.fnCom();
                    }
                    else if (menuId === 'product') {
                        this.fnProductList();
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
                    formData.append("productNo", this.product1.productNo);
                    formData.append("productName", this.product1.productName);
                    formData.append("productDetails", this.product1.productDetails);
                    formData.append("originalPrice", this.product1.originalPrice);

                    formData.append("proType", JSON.stringify(this.product1.proType));

                    $.ajax({
                        url: "/upload.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                            if (res.result === "success") {
                                alert("상품 정보가 모두 수정되었습니다!");
                                window.location.href = "/partnerManagement.do";
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
                    //formData.append("companyNo", this.product2.companyNo);
                    formData.append("productNo", this.product2.productNo);
                    formData.append("productName", this.product2.productName);
                    formData.append("productDetails", this.product2.productDetails);
                    formData.append("originalPrice", this.product2.originalPrice);

                    formData.append("proType", JSON.stringify(this.product2.proType));
                    formData.append("userId", "${sessionScope.sessionId}");
                    $.ajax({
                        url: "/upload2.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            let res = (typeof data === 'string') ? JSON.parse(data) : data;
                            //data가 string으로 넘어왓다면? 자바스크립트가 읽을수있게 객체로 바꿔주기(parse해주기)
                            if (res.result === "success") {
                                alert("상품 정보가 모두 수정되었습니다!");
                                window.location.href = "/partnerManagement.do";
                            } else {
                                alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                            }
                        }
                    })
                },
                fnRemove2(item) {  //item in productList
                    if (confirm("정말 삭제하시겠습니까?")) {
                        let self = this;
                        let param = {
                            productNo: item.productNo
                        };
                        $.ajax({
                            url: "/productRemove.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {

                                alert(data.message);
                                location.href = "/partnerManagement.do"
                            }
                        });
                    } else {
                        alert("삭제가 취소되었습니다.");
                    }
                },
                fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "http://localhost:8080/",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                        }
                    });
                },
                fnSaveReservation(user) {  //user
                    let loginId = "${sessionScope.sessionId}";
                    if (!loginId || loginId === "") {
                        alert("로그인 해주세요!");
                        return;

                    }
                    if (confirm("예약사항을 모두 확인하셨습니까?")) {

                        let self = this;
                        let param = {
                            userId: "${sessionScope.sessionId}",
                            productNo: self.product1.id,
                            companyNo: self.product1.companyNo,
                            resContent: self.res_content,
                            useDate: self.selectedDate,
                            useTime: self.selectedTime
                        };
                        $.ajax({
                            url: "/addReservation.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                if (data.result == 'success') {
                                    alert("예약이 저장되었습니다.");
                                    self.fnBack2();
                                }
                            }
                        });
                    } else {
                        alert("취소되었습니다.");
                    }
                },
                // 시간 버튼 클릭 시 호출
                fnSelectTime(time) {
                    this.selectedTime = time;
                },
                fnBack2() {
                    this.productPage = 'list';
                    this.selectedDate = '';
                    this.selectedTime = '';
                    this.bookedTimes = [];
                },
                goMyResPage() {
                    let loginId = "${sessionScope.sessionId}";
                    if (!loginId || loginId === "") {
                        alert("로그인 해주세요!");
                        return;
                    }
                    this.productPage = 'resultOfReservation';
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "/getMyReservationList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.myReservationList = data.list.map(p => {
                                return {
                                    companyNo: p.companyNo,
                                    deposit: p.deposit,       //Number(p.deposit).toLocaleString() + '원'
                                    imgUrl: p.imgUrl,
                                    isActive: p.isActive,
                                    originalPrice: p.originalPrice,
                                    payDate: p.payDate,
                                    payNo: p.payNo,
                                    proType: JSON.parse(p.proType),
                                    productDetails: p.productDetails,
                                    productName: p.productName,
                                    resContent: p.resContent != "" ? p.resContent : "요청사항 없음",
                                    resNo: p.resNo,
                                    resStatus: p.resStatus,
                                    resDate: p.resDate,
                                    resTime: p.resTime,
                                    tag: JSON.parse(p.tag),
                                    useDate: p.useDate,
                                    useTime: p.useTime,
                                    userId: p.userId,
                                    amount: p.amount,
                                    payStatus: p.payStatus,
                                    refund: p.refund,
                                    refundDate: p.refundDate,
                                    comName: p.comName,
                                    tel: p.tel
                                }
                            })
                        }
                    });
                },
                fnGoDetail(r) {
                    this.productPage = "reservaionPaymentDetails";
                    this.myReservation1 = r;
                },
                fnPaymentFinal() {
                    if (confirm("예약사항을 모두 확인하셨습니까?")) {
                        this.fnPaymentReal();
                    } else {
                        alert("취소되었습니다.");
                    }
                },
                fnPaymentFinal2(res) {
                    // myReservation1.deposit 은 예약금을 의미함.
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}",
                        amount: self.myReservation1.deposit,
                        resNo: self.myReservation1.resNo,
                        imp_uid: res.impUid,
                        merchant_uid: res.merchantUid
                    };
                    $.ajax({
                        url: "/addAndEditPaymentFinal.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == 'success') {
                                alert('결제 완료되었습니다! 예약이 확정되었습니다!');

                                self.productPage = 'list';
                                self.payAmount = '';
                            } else {
                                alert("결제 실패! 서버 오류입니다");
                            }
                        }
                    });
                },
                fnPaymentReal() {
                    let self = this;
                    var IMP = window.IMP;
                    IMP.init("imp48518435");
                    IMP.request_pay(
                        {
                            channelKey: "channel-key-1ebd3d65-20bd-412e-83f3-b7e0c3b368ff",
                            pay_method: "card",
                            merchant_uid: "order_" + "${sessionScope.sessionId}" + "_" + new Date().getTime(), // 주문 고유 번호
                            name: self.myReservation1.productName,
                            amount: self.myReservation1.deposit,      //제품 가격
                        },
                        function (response) {
                            // 결제 종료 시 호출되는 콜백 함수
                            // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
                            // 결제 결과를 처리하는 로직을 작성합니다.
                            console.log(response);
                            console.log("전체 response:", response);
                            console.log("success:", response.success);
                            console.log("imp_uid:", response.imp_uid);
                            console.log("status:", response.status);
                            console.log("paid_amount:", response.paid_amount);
                            if (response.imp_uid) {
                                console.log("포트원 번호: " + response.imp_uid);
                                // 우리쪽 db에 결제정보 저장
                                // 페이지 이동 필요하면 페이지 이동 (메인 or 마이)
                                // 결제 성공 후 서버 검증
                                console.log("imp_uid:", response.imp_uid);
                                self.fnVerifyPayment(response);
                            } else {
                                console.log("에러내용: " + response.error_msg);
                                // self.isPaying = false;
                                alert("결제가 취소되었습니다");
                            }
                        },
                    );
                },

                fnVerifyPayment(response) {
                    let self = this;
                    console.log("서버로 보내는 imp_uid:", response.imp_uid);
                    console.log("서버로 보내는 merchant_uid:", response.merchant_uid);
                    $.ajax({
                        url: "http://localhost:8080/verifyPayment3.dox",
                        type: "POST",
                        data: {
                            userId: "${sessionScope.sessionId}",     // 로그인 아이디
                            imp_uid: response.imp_uid,           // 결제 고유 값(중복)
                            merchant_uid: response.merchant_uid,
                            amount: self.myReservation1.deposit,
                            type: "RES"
                        },
                        success: function (res) {
                            console.log(res);
                            if (res.result == "success") {
                                console.log("포트원 번호: " + res.impUid);
                                console.log("포트원 번호: " + res.merchantUid);
                                // self.isModalOpen = false; 모달 끄기
                                // location.href = "/adminPayFinish.do?payNo=" + res.pay_no + "&type=PASS";
                                //예약이면 &type=RES 등록이면 &type=REG
                                self.fnPaymentFinal2(res);
                            } else {
                                console.log("에러내용: " + res.error_msg);
                                self.isPaying = false;
                                alert("결제 검증 실패");
                            }
                        }, error: function (xhr, status, err) {
                            console.log("ERROR:", xhr.responseText);
                            console.log("STATUS:", status);
                            console.log("ERR:", err);
                            self.isPaying = false;
                            alert("서버 통신 오류");
                            console.log(xhr);
                        }
                    });
                },
                fnInquiryAboutProduct() {

                    let loginId = "${sessionScope.sessionId}";

                    if (!loginId || loginId === "") {
                        alert("로그인 해주세요!");
                        return;
                    }
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}",
                        productNo: self.product1.id,
                        companyNo: self.product1.companyNo,
                        inquiryTitle: self.inquiry.title,
                        inquiryContents: self.inquiry.contents
                    };
                    $.ajax({
                        url: "/addInquiryProduct.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == 'success') {
                                alert('문의가 등록되었습니다!');

                                self.productPage = 'list';

                            } else {
                                alert("문의 등록 실패! 서버 오류입니다");
                            }
                            //payAmount='';
                        }
                    });
                },
                //나의 문의내역 보러가기
                goMyInquiryPage() {

                    let loginId = "${sessionScope.sessionId}";

                    if (!loginId || loginId === "") {
                        alert("로그인 해주세요!");
                        return;
                    }
                    //페이지 변경
                    this.productPage = 'myRealInquiryList';
                    let self = this;
                    let param = {
                        userId: "${sessionScope.sessionId}"
                    };
                    $.ajax({
                        url: "/getMyInquiryList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == 'success') {
                                self.myInquiryList = data.list;
                            } else {
                                alert("서버오류!");
                            }
                        }
                    });
                },
                //특정 문의를 클릭하면 실행되는거// 문의내용 상세보기로 간다
                fnInquiryAnswerDetails(inquiry) {
                    this.myInquiry1 = { ...inquiry };
                    this.productPage = 'inquiry1Details'; //문의내용상세보기

                    let self = this;
                    let param = {
                        inquiryNo: self.myInquiry1.inquiryNo
                    };
                    $.ajax({
                        url: "/getInquiry1Answer.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === "success") {
                                self.myInquiry1.answerContents = data.info.answerContents;
                                self.myInquiry1.ansCompany = data.info.userId;
                            } else {
                                alert("서버 오류!");
                            }
                        }
                    });
                },
            }, // methods
            mounted() {
                let self = this;
                self.fnGetTagAndProductList();
            }
        });
        

        app.mount('#app');