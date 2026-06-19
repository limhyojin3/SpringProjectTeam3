// 💡 독립된 객체로 상품 상세 보기 컴포넌트를 정의합니다.
const productDetailComponent = {
    template: '#product-detail-template',
    
    // 부모로부터 내려받을 프로퍼티 정의
    props: ['product', 'amTimes', 'pmTimes', 'bookedTimes'],
    
    data() {
        return {
            selectedDate: '',  // 컴포넌트 내부에서 사용할 선택 날짜
            selectedTime: '',  // 컴포넌트 내부에서 사용할 선택 시간
            res_content: ''    // 컴포넌트 내부에서 사용할 고객 요청사항
        };
    },
    
    watch: {
        // 날짜가 변경되었을 때 유효성을 검사하는 Watch 로직입니다.
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
                // 💡 올바른 날짜라면 부모에게 알려서 예약 불가능한 시간을 다시 조회하게 만듭니다.
                this.$emit('date-changed', newVal);
            }
        }
    },
    
    methods: {
        // 예약하기 버튼 클릭 시 입력 상태를 검증하고 부모에게 보따리 데이터를 올립니다.
        submitReserve() {
            if (!this.selectedDate) {
                alert("예약 날짜를 선택해주세요!");
                return;
            }
            if (!this.selectedTime) {
                alert("예약 시간을 선택해주세요!");
                return;
            }
            
            // 💡 부모 컴포넌트에 최종 사용자가 고른 정보를 오브젝트 구조로 넘깁니다.
            this.$emit('reserve', {
                date: this.selectedDate,
                time: this.selectedTime,
                content: this.res_content
            });
        }
    }
};