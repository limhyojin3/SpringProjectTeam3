const ReservationSectionComponent = {
    template: '#reservation-section-template',
    
    // 1. 오직 예약 관리에서만 쓰는 독립된 변수들
    data() {
        return {
            selectedRes: null,
            resCurrentPage: 1,
            resPageSize: 5,
            reservationList: [],
            resCount: ''
        };
    },

    // 2. 메인에 있던 예약 페이징 computed 이사
    computed: {
        pagedResList() {
            const start = (this.resCurrentPage - 1) * this.resPageSize;
            const end = start + this.resPageSize;
            return this.reservationList.slice(start, end);
        },
        totalResPageCount() {
            return Math.ceil(this.reservationList.length / this.resPageSize);
        }
    },

    // 3. 예약 조회 및 상태 텍스트 메서드 이사
    methods: {
        fnReservationList() {
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
        // 예약 템플릿 안에서 상태 텍스트를 그리므로 함께 이사합니다.
        getResStatusText(status) { 
            return PartnerUtils.getResStatusText(status); 
        }
    },

    // 4. 예약 관리 화면이 켜지는 순간 스스로 목록을 불러옴
    mounted() {
        this.fnReservationList();
    }
};