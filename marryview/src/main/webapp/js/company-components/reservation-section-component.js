/**
 * ==========================================================================
 * [ReservationSectionComponent] 예약 관리 전용 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ReservationSectionComponent = {
    template: '#reservation-section-template',
	
	// 💡 부모 컴포넌트로부터 전달받을 변수 선언
    props: {
        registeredProductList: {
            type: Array,
            default: () => [] // 데이터가 넘어오기 전 초기값은 빈 배열로 설정
        }
    },
    
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

    // 2. 메인에 있던 예약 페이징 및 최대 3개 제한 슬라이딩 연산 주머니 수식 결합
    computed: {
        pagedResList() {
            const start = (this.resCurrentPage - 1) * this.resPageSize;
            const end = start + this.resPageSize;
            return this.reservationList.slice(start, end);
        },
        totalResPageCount() {
            return Math.ceil(this.reservationList.length / this.resPageSize);
        },
        /**
         * 🎯 [신규 추가] 현재 예약 페이지 번호를 기점으로 상시 최대 3개의 칩만 유연하게 밀고 당기는 슬라이딩 엔진
         * @returns {Array} [1, 2, 3] 또는 [5, 6, 7] 형태의 넘버링 배열 사출
         */
        visibleResPageNumbers() {
            const total = this.totalResPageCount;
            const current = this.resCurrentPage;
            
            // 만약 총 예약 페이지 수가 3개 이하로 작다면 전체 페이지 번호를 그대로 리턴 안전 처리
            if (total <= 3) {
                let pages = [];
                for (let i = 1; i <= total; i++) {
                    pages.push(i);
                }
                return pages;
            }
            
            // 현재 활성화된 예약 페이지를 중심으로 좌우 밸런스 윈도우 개통
            let start = current - 1;
            let end = current + 1;
            
            // 양 끝 구역 터치 시 인덱스 번호 튕김 방지용 가드 레일 장착
            if (start < 1) {
                start = 1;
                end = 3;
            } else if (end > total) {
                end = total;
                start = total - 2;
            }
            
            let pages = [];
            for (let i = start; i <= end; i++) {
                pages.push(i);
            }
            return pages;
        }
    },

    // 3. 예약 조회 및 상태 텍스트 메서드 + 화살표 액션 단자 스위치 배치
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
                    self.reservationList = data.list;
                    self.resCount = data.newResCnt;
                }
            });
        },
        // 예약 템플릿 안에서 상태 텍스트를 그리므로 함께 이사합니다.
        getResStatusText(status) { 
            return PartnerUtils.getResStatusText(status); 
        },
        // 🎯 [신규 추가] 왼쪽 화살표(＜) 무빙 액션 처리 단자
        fnPrevPage() {
            if (this.resCurrentPage > 1) {
                this.resCurrentPage--;
            }
        },
        // 🎯 [신규 추가] 오른쪽 화살표(＞) 무빙 액션 처리 단자
        fnNextPage() {
            if (this.resCurrentPage < this.totalResPageCount) {
                this.resCurrentPage++;
            }
        }
    },

    // 4. 예약 관리 화면이 켜지는 순간 스스로 목록을 불러옴
    mounted() {
        this.fnReservationList();
    }
};