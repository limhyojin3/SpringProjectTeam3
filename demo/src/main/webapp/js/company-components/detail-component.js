const ProductDetailComponent = {
    template: '#product-detail-template',
    props: ['productInfo'],
    emits: ['back', 'reserve', 'inquiry'],
    data() {
        return {
            res_content: '',
            selectedDate: '',
            selectedTime: '',
            amTimes: ['10:00', '11:00'],
            pmTimes: ['13:00', '14:00', '15:00', '16:00', '17:00'],
            bookedTimes: []
        };
    },
    watch: {
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
        fnGetBookedTimes() {
            let self = this;
            let param = {
                productNo: self.productInfo.id,
                useDate: self.selectedDate
            };
            $.ajax({
                url: "/getBookedTimes.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function (data) {
                    let newList = data.list.map(p => p.slice(0, 5)); 
                    self.bookedTimes = newList;
                }
            });
        },
        submitReserve() {
            if (!this.selectedDate) return alert("예약 날짜를 선택해주세요!");
            if (!this.selectedTime) return alert("예약 시간을 선택해주세요!");
            
            // 💡 부모에게 선택 완료된 일정 데이터를 오브젝트(payload)로 쏘아 올립니다.
            this.$emit('reserve', {
                selectedDate: this.selectedDate,
                selectedTime: this.selectedTime,
                res_content: this.res_content
            });
        },
        submitInquiry() {
            this.$emit('inquiry');
        }
    }
};