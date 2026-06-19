const app = Vue.createApp({
    data() {
        return {
			productTag: [],
            myInquiryList: [],
            myInquiry1: {},
            inquiry: {
                title: '',
                contents: ''
            },
            userid: window.SESSION_ID,
            flag: false,
            payAmount: '',
            myReservation1: {},
            myReservationList: [],
            amTimes: ['10:00', '11:00'],
            pmTimes: ['13:00', '14:00', '15:00', '16:00', '17:00'],
            bookedTimes: [], 
            selectedTime: '', 
            res_content: '',
            selectedDate: '',
            productList3: [],
            inquiryList: [],
            user: {},
            currentMenu: 'main', 
            reviewTab: 'detail',
            page1: 'main', 
            productPage: 'list', 
            page: 1,
            product: '',
            product1: {},
            proType: [],
            productList: [],
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
            previewUrl: null, 
            uploadFile: null,  
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
    }, 
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
        },
        resCount() {
            return this.reservationList.length;
        },
        revCnt() {
            return this.reviews.filter(r => r.updated === 'new').length
                + this.simpleReviews.filter(r => r.updated === 'new').length;
        },
        editingProduct() {
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
            return this.reviews.filter(rev => rev.product === this.page1); 
        },
        filteredSimpleReviews() {
            return this.simpleReviews.filter(rev => rev.product === this.page1); 
        },
        paginatedReviews() {
            const start = (this.page - 1) * 5;
            const end = start + 5;
            return this.filteredReviews.slice(start, end); 
        },
        paginatedSimpleReviews() {
            const start = (this.page - 1) * 5;
            const end = start + 5;
            return this.filteredSimpleReviews.slice(start, end); 
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
        },
        totalPages() {
            return Math.ceil(this.filteredReviews.length / 5); 
        },
        totalSimplePages() {
            return Math.ceil(this.filteredSimpleReviews.length / 5); 
        },
        totalPageReservation() {
            return Math.ceil(this.reservationList.length / 3);
        }
    },
    watch: {
        // 💡 날짜 감시 watch 로직은 자식 컴포넌트 내부로 이사하여 완전히 비워졌습니다.
    },
    methods: {
        // 💡 상세 보기 컴포넌트 전용 커스텀 이벤트 바인딩 핸들러 함수 2개 추가
        onDetailDateChanged(date) {
            this.selectedDate = date;
            this.fnGetBookedTimes();
        },
        onDetailReserve(payload) {
            this.selectedDate = payload.date;
            this.selectedTime = payload.time;
            this.res_content = payload.content;
            this.productPage = 'payment';
            window.scrollTo(0, 0);
        },
        fnPageChange(num) {
            this.currentPage = num;
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }, 
        fnCom: function() {
            let self = this;
            let param = { userid: window.SESSION_ID };
            $.ajax({
                url: "http://localhost:8080/company.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.user.name = data.info.comName;
                    self.user.usePeriod = data.info.usePeriod;
                    self.user.grade = data.info.grade;
                    self.user.lastPayment = data.info.lastPayment;
                }
            });
        },
        fnProductList: function() {
            let self = this;
            let param = { userid: window.SESSION_ID };
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.productList3 = data.list;
                }
            });
        },
        withdraw: function() {
            if (confirm("정말 탈퇴하시겠습니까?")) {
                alert("탈퇴되었습니다.");
            } else {
                alert("탈퇴가 취소되었습니다.");
            }
        },
        updateProduct: function() {
            alert("상품이 수정되었습니다.");
            this.productPage = 'list'; 
        },
        goEditPage(item) {
            let self = this;
            self.productPage = 'edit';
            let param = {
                userid: window.SESSION_ID,
                productNo: item.productNo 
            };
            $.ajax({
                url: "http://localhost:8080/productDetail.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.product1 = data.info;
                    if (typeof self.product1.proType === 'string') {
                        try {
                            let rawArray = JSON.parse(self.product1.proType);
                            self.product1.proType = rawArray.map(val => {
                                if (val === 'MAKEUP') return '메이크업';
                                else if (val === 'DRESS') return '드레스';
                                else if (val === 'STUDIO') return '스튜디오';
                                else return val;
                            })
                        } catch (e) {
                            self.product1.proType = [];
                        }
                    }
                }
            });
        },
        goRegPage() {
            this.productPage = 'reg';
            this.product = ''; 
            this.selectedItems = []; 
        },
        fnSave() {
            const item = this.productList.find(p => p.name === this.product);
            if (item) {
                item.category = [...this.selectedItems];
                alert("수정되었습니다!");
                this.productPage = 'list';
            } else {
                alert("수정 대상을 찾지 못했습니다.");
            }
        },
        fnAdd() {
            const newProduct = {
                id: this.productList.length > 0 ? Math.max(...this.productList.map(p => p.id)) + 1 : 1,
                thumbnail: this.productForm.thumbnail || "images/default-thumbnail.png",
                name: this.productForm.name,
                content: this.productForm.content,
                price: this.productForm.price,
                category: [...this.selectedItems]
            }
            this.productList.push({ ...newProduct });  
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
                id: "", thumbnail: "", name: "", content: "", price: "", category: []
            }
            this.selectedItems = [];
        },
        fnRemove(item) {
            if (confirm("정말 삭제하시겠습니까?")) {
                const removed = this.productList.find(p => p.id === item.id);
                const index = this.productList.indexOf(removed);
                if (index !== -1) {
                    this.productList.splice(index, 1);
                    this.reviews = this.reviews.filter(r => r.product !== item.name);
                    this.simpleReviews = this.simpleReviews.filter(r => r.product !== item.name);
                }
                alert("삭제되었습니다.");
            } else {
                alert("삭제가 취소되었습니다.");
            }
        },
        fnThumbnail(inquiry) {    
            return this.productList.find(p => p.name === inquiry.product).thumbnail;
        },
        handleMenuClick(menuId) {   
            this.currentMenu = menuId;
            this.productPage = 'list';
            this.page = 1;
            this.page1 = 'main';
            this.reviewTab = 'detail';
            this.currentPage = 1;
            if (menuId === 'main') {
                this.fnCom();
            } else if (menuId === 'product') {
                this.fnProductList();
            }
        },
        fnFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadFile = file;
                this.previewUrl = URL.createObjectURL(file);
            }
        },
        fnUpdateProduct() {
            let self = this;
            let formData = new FormData();
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
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
                success: function(data) {
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
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
            let self = this;
            let formData = new FormData();
            if (this.uploadFile) {
                formData.append("file", this.uploadFile);
            }
            formData.append("productNo", this.product2.productNo);
            formData.append("productName", this.product2.productName);
            formData.append("productDetails", this.product2.productDetails);
            formData.append("originalPrice", this.product2.originalPrice);
            formData.append("proType", JSON.stringify(this.product2.proType));
            formData.append("userId", window.SESSION_ID);
            $.ajax({
                url: "/upload2.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    let res = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (res.result === "success") {
                        alert("상품 정보가 모두 수정되었습니다!");
                        window.location.href = "/partnerManagement.do";
                    } else {
                        alert("서버 응답은 성공했지만, result가 success가 아닙니다.");
                    }
                }
            })
        },
        fnRemove2(item) {  
            if (confirm("정말 삭제하시겠습니까?")) {
                let self = this;
                let param = { productNo: item.productNo };
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
        fnList: function() {
            let self = this;
            let param = {};
            $.ajax({
                url: "http://localhost:8080/",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {}
            });
        },
        goDetailPage(item) {
            this.productPage = 'detail';
            this.product1 = { ...item };
            window.scrollTo(0, 0); 
        },
        fnReserve() {
            // 💡 예약 버튼 로직은 컴포넌트 내부(submitReserve)에서 전담 처리 후 상단 onDetailReserve 메소드로 위임됩니다.
        },
        fnSaveReservation(user) {  
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            if (confirm("예약사항을 모두 확인하셨습니까?")) {
                let self = this;
                let param = {
                    userId: window.SESSION_ID,
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
                    success: function(data) {
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
        fnGetTagAndProductList() {
            let self = this;
            let param = {};
            $.ajax({
                url: "/getTagAndProductList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.productTag = data.taglist;
                    let productList1 = data.productListForTag.map(p => {
                        return {
                            id: p.productNo,
                            companyNo: p.companyNo,
                            thumbnail: p.imgUrl,
                            name: p.productName,
                            company: p.comName,
                            content: p.productDetails,
                            price: p.originalPrice,
                            category: typeof p.proType === 'string' ? JSON.parse(p.proType) : p.proType,
                            tag: typeof p.tag === 'string' ? JSON.parse(p.tag) : p.tag,
                            deposit: p.deposit || 0
                        }
                    });
                    self.productList = productList1;
                }
            });
        },
        fnSelectTime(time) {
            this.selectedTime = time;
        },
        fnBack() {
            this.productPage = 'list';
            this.selectedDate = '';
            this.selectedTime = '';
            this.bookedTimes = [];
        },
        fnBack2() {
            this.productPage = 'list';
            this.selectedDate = '';
            this.selectedTime = '';
            this.bookedTimes = [];
        },
        fnGetBookedTimes() {
            let self = this;
            let param = {
                productNo: self.product1.id,
                useDate: self.selectedDate
            };
            $.ajax({
                url: "/getBookedTimes.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    let newList = data.list.map(p => p.slice(0, 5)); 
                    self.bookedTimes = newList;
                }
            });
        },
        goMyResPage() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            this.productPage = 'resultOfReservation';
            let self = this;
            let param = { userId: window.SESSION_ID };
            $.ajax({
                url: "/getMyReservationList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.myReservationList = data.list.map(p => {
                        return {
                            companyNo: p.companyNo,
                            deposit: p.deposit,       
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
            let self = this;
            let param = {
                userId: window.SESSION_ID,
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
                success: function(data) {
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
                    merchant_uid: "order_" + window.SESSION_ID + "_" + new Date().getTime(), 
                    name: self.myReservation1.productName,
                    amount: self.myReservation1.deposit,      
                },
                function(response) {
                    if (response.imp_uid) {
                        self.fnVerifyPayment(response);
                    } else {
                        alert("결제가 취소되었습니다");
                    }
                },
            );
        },
        fnVerifyPayment(response) {
            let self = this;
            $.ajax({
                url: "http://localhost:8080/verifyPayment3.dox",
                type: "POST",
                data: {
                    userId: window.SESSION_ID,     
                    imp_uid: response.imp_uid,           
                    merchant_uid: response.merchant_uid,
                    amount: self.myReservation1.deposit,
                    type: "RES"
                },
                success: function(res) {
                    if (res.result == "success") {
                        self.fnPaymentFinal2(res);
                    } else {
                        alert("결제 검증 실패");
                    }
                }, error: function(xhr, status, err) {
                    alert("서버 통신 오류");
                }
            });
        },
        fnInquiryAboutProduct() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            let self = this;
            let param = {
                userId: window.SESSION_ID,
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
                success: function(data) {
                    if (data.result == 'success') {
                        alert('문의가 등록되었습니다!');
                        self.productPage = 'list';
                    } else {
                        alert("문의 등록 실패! 서버 오류입니다");
                    }
                }
            });
        },
        goMyInquiryPage() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            this.productPage = 'myRealInquiryList';
            let self = this;
            let param = { userId: window.SESSION_ID };
            $.ajax({
                url: "/getMyInquiryList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result == 'success') {
                        self.myInquiryList = data.list;
                    } else {
                        alert("서버오류!");
                    }
                }
            });
        },
        fnInquiryAnswerDetails(inquiry) {
            this.myInquiry1 = { ...inquiry };
            this.productPage = 'inquiry1Details'; 
            let self = this;
            let param = { inquiryNo: self.myInquiry1.inquiryNo };
            $.ajax({
                url: "/getInquiry1Answer.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    if (data.result === "success") {
                        self.myInquiry1.answerContents = data.info.answerContents;
                        self.myInquiry1.ansCompany = data.info.userId;
                    } else {
                        alert("서버 오류!");
                    }
                }
            });
        },
        goInquiry() {
            this.inquiry.title = '';
            this.inquiry.contents = '';
            this.productPage = 'inquiry';
        }
    }, 
    mounted() {
        let self = this;
        self.fnGetTagAndProductList();
    }
});

// 💡 요청하신 방식대로 변수화된 객체를 각각 컴포넌트로 등록합니다.
app.component('product-list-component', productListComponent);
app.component('product-detail-component', productDetailComponent);

app.mount('#app');