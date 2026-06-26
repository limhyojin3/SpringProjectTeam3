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