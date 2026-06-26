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