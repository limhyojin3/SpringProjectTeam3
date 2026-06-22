// 1️⃣ 결제 및 예약 저장 대기 확인서 컴포넌트 객체 (자체 예약 저장 통신 및 필수 동의 제어)
const productReservationPaymentComponent = {
    template: '#product-reservation-payment-template',
    props: ['product', 'selectedDate', 'selectedTime', 'userid', 'resContent'],
    // 💡 인터랙션 확장: 동의 상태값(isAgreed)과 모달 오픈 스위치(isModalOpen) 상태 저장
    data() {
        return {
            isAgreed: false,
            isModalOpen: false
        };
    },
    methods: {
        fnOpenModal() {
            this.isModalOpen = true;
        },
        fnCloseModal() {
            this.isModalOpen = false;
        },
        fnAgreeAndClose() {
            this.isAgreed = true;
            this.isModalOpen = false;
        },
        fnSaveReservation() {  
            // 💡 안전 제어 레일 장착: 혹시 모를 비정상 우회 클릭 시 안전망 작동
            if (!this.isAgreed) {
                alert("필수 항목 동의(노쇼 관련)에 동의해주셔야 예약 진행이 가능합니다!");
                return;
            }
            let loginId = this.userid;
            if (!loginId || loginId === "") {
                alert("로그인 해주세요!");
                return;
            }
            if (confirm("예약사항을 모두 확인하셨습니까?")) {
                let self = this;
                let param = {
                    userId: loginId,
                    productNo: self.product.id,
                    companyNo: self.product.companyNo,
                    resContent: self.resContent,
                    useDate: self.selectedDate,
                    useTime: self.selectedTime
                };
                // 부모 파일에 무겁게 묶여있던 예약 저장 AJAX를 완벽히 뜯어왔습니다.
                $.ajax({
                    url: "/addReservation.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        if (data.result == 'success') {
                            alert("예약이 저장되었습니다.");
                            // 저장이 끝나면 부모에게 성공 신호를 보내 화면 목록을 바꿉니다.
                            self.$emit('success');
                        }
                    }
                });
            } else {
                alert("취소되었습니다.");
            }
        }
    }
};

// 2️⃣ 나의 예약 리스트 컴포넌트 객체 (자체 목록 조회 통신)
const myReservationListComponent = {
    template: '#my-reservation-list-template',
    data() {
        return {
            // 부모창 주머니 대신, 리스트 데이터를 자식이 직접 소유합니다.
            reservationList: []
        };
    },
    methods: {
        fnGetMyReservationList() {
            let loginId = window.SESSION_ID;
            if (!loginId || loginId === "") {
                return;
            }
            let self = this;
            let param = { userId: loginId };
            // 부모 함수 내부에 가둬져 있던 예약 조회 AJAX를 완벽히 이사했습니다.
            $.ajax({
                url: "/getMyReservationList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    self.reservationList = data.list.map(p => {
                        return {
                            companyNo: p.companyNo,
                            deposit: p.deposit,       
                            imgUrl: p.imgUrl,
                            isActive: p.isActive,
                            originalPrice: p.originalPrice,
                            payDate: p.payDate,
                            payNo: p.payNo,
                            proType: typeof p.proType === 'string' ? JSON.parse(p.proType) : p.proType,
                            productDetails: p.productDetails,
                            productName: p.productName,
                            resContent: p.resContent != "" ? p.resContent : "요청사항 없음",
                            resNo: p.resNo,
                            resStatus: p.resStatus,
                            resDate: p.resDate,
                            resTime: p.resTime,
                            tag: typeof p.tag === 'string' ? JSON.parse(p.tag) : p.tag,
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
                    });
                }
            });
        }
    },
    mounted() {
        // 화면이 켜지자마자 자식이 주도적으로 서버 리스트를 당겨옵니다.
        this.fnGetMyReservationList();
    }
};

// 3️⃣ 단건 예약 상세 내역 및 포트원 결제 연동 컴포넌트 객체 (자체 결제 및 검증 통신)
const reservationDetailComponent = {
    template: '#reservation-detail-template',
    props: ['reservation'], // 결합도를 더 낮추기 위해 buttonName 프롭 의존성을 지우고 내부 계산식으로 승격!
    computed: {
        // 부모창 computed 연산식을 이쪽으로 가져와 결합도를 극도로 낮췄습니다.
        buttonName() {
            if (this.reservation.resStatus === 'WAIT') {
                return '결제 및 예약 확정하기';
            } else if (this.reservation.resStatus === 'CANCEL') {
                return '취소된 예약';
            } else if (this.reservation.resStatus === 'CONFIRM') {
                return '확정된 예약';
            } else {
                return '만료된 예약';
            }
        }
    },
    methods: {
        fnPaymentFinal() {
            if (confirm("예약사항을 모두 확인하셨습니까?")) {
                this.fnPaymentReal();
            } else {
                alert("취소되었습니다.");
            }
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
                    name: self.reservation.productName,
                    amount: self.reservation.deposit,      
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
                    amount: self.reservation.deposit,
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
        fnPaymentFinal2(res) {
            let self = this;
            let param = {
                userId: window.SESSION_ID,
                amount: self.reservation.deposit,
                resNo: self.reservation.resNo,
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
                        // 결제 완료 신호를 쏘아 부모창이 메인 목록으로 보내주도록 처리합니다.
                        self.$emit('payment-success');
                    } else {
                        alert("결제 실패! 서버 오류입니다");
                    }
                } 
            });
        }
    }
};