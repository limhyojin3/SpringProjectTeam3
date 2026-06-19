const productDetailComponent = {
    template: '#product-detail-template',
    
    // 부모로부터는 오직 '어떤 상품을 클릭했는지' 정보 딱 하나만 props로 받습니다.
    props: ['product'],
    
    // 💡 부모창 주머니를 쓰지 않고, 자식 "그 자체"가 소유하는 자율 데이터들입니다.
    data() {
        return {
            selectedDate: '',
            selectedTime: '',
            res_content: '',
            amTimes: ['10:00', '11:00'],
            pmTimes: ['13:00', '14:00', '15:00', '16:00', '17:00'],
            bookedTimes: [] // 👈 서버에서 조회해 온 예약 시간들을 여기에 스스로 담습니다.
        };
    },
     
    watch: {
        // 자식이 직접 자기 날짜를 감시하고 검증합니다.
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
                this.bookedTimes = [];
            } else {  
                // 💡 부모 함수를 부르지 않고, 자식 고유의 내부 AJAX 메소드를 직접 호출합니다!
                this.fnGetBookedTimes();
            }
        }
    },
    
    methods: {
        // 💡 기존에 부모 파일에 있던 예약 시간 조회 AJAX를 이쪽으로 통째로 뜯어왔습니다!
        fnGetBookedTimes() {
            let self = this;
            $.ajax({
                url: "/getBookedTimes.dox",
                dataType: "json",
                type: "POST",
                data: {
                    productNo: self.product.id, // 전달받은 상품 ID 사용
                    useDate: self.selectedDate   // 자식의 선택 날짜 사용
                },
                success: function(data) {
                    // 받아온 데이터 가공 후 자식 고유 데이터인 bookedTimes에 직접 바인딩!
                    self.bookedTimes = data.list.map(p => p.slice(0, 5));
                }
            });
        },
        
        // 예약하기 버튼 누를 때 호출되는 자식 함수
        submitReserve() {
            if (!this.selectedDate) return alert("예약 날짜를 선택해주세요!");
            if (!this.selectedTime) return alert("예약 시간을 선택해주세요!");
            
			// ⭕ 정석: 내 방(자식)에서 검증이 끝난 데이터 보따리를 부모에게 신호로 쏘아 올립니다!
		    this.$emit('reserve', {
		        date: this.selectedDate,
		        time: this.selectedTime,
		        content: this.res_content
		    });
            
            parent.productPage = 'payment'; // 결제 대기 화면으로 이동
            window.scrollTo(0, 0);
        }
    }
};