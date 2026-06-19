const ProductDetailComponent = {
    template: '#product-detail-template',
    props: ['productInfo'],
    emits: ['back', 'go-checkout'],
    data() {
        return {
            res_content: '',
            selectedDate: '',
            selectedTime: '',
            amTimes: ['10:00', '11:00'],
            pmTimes: ['13:00', '14:00', '15:00', '16:00', '17:00'],
            bookedTimes: [] // 서버에서 받아온 마감된 일정 리스트
        };
    },
    watch: {
        // 사용자가 날짜를 변경할 때마다 과거 날짜인지 체크 후 마감 시간대 조회
        selectedDate(newVal) {
            if (!newVal) return;
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(today.getDate() + 1);
            tomorrow.setHours(0, 0, 0, 0);
            
            const selected = new Date(newVal);
            selected.setHours(0, 0, 0, 0);

            if (selected < tomorrow) {
                alert("날짜는 내일 이후부터 선택 가능합니다!");
                this.selectedDate = '';
            } else {
                this.fnGetBookedTimes();
            }
        }
    },
    methods: {
        // 이미 다른 유저들이 선점한 시간대를 DB에서 긁어오는 AJAX
        fnGetBookedTimes() {
            let self = this;
            $.ajax({
                url: "/getBookedTimes.dox",
                type: "POST",
                dataType: "json",
                data: {
                    productNo: self.productInfo.id,
                    useDate: self.selectedDate
                },
                success: function (data) {
                    // HH:mm:ss -> HH:mm 형태로 파싱하여 마감 바인딩
                    self.bookedTimes = data.list.map(p => p.slice(0, 5));
                }
            });
        },
        // 예약서 작성 화면으로 캘린더 세부 정보 토스
        handleReserve() {
            if (!this.selectedDate) return alert("예약 날짜를 선택해주세요!");
            if (!this.selectedTime) return alert("예약 시간을 선택해주세요!");
            
            this.$emit('go-checkout', {
                targetPage: 'payment',
                date: this.selectedDate,
                time: this.selectedTime,
                content: this.res_content
            });
        },
        // 문의서 작성 화면으로 이동 요청
        handleInquiry() {
            this.$emit('go-checkout', { targetPage: 'inquiry' });
        }
    }
};