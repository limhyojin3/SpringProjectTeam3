/**
 * ==========================================================================
 * [ProductListSub] 상품 목록 전용 - 100% 완전 자립형 독립 서브 컴포넌트 객체
 * ==========================================================================
 */
const ProductListSub = {
    template: '#product-list-sub-template',
    
    // 🎯 속 시원한 완전 자립 격리: 목록 전용의 데이터 그릇을 자식 내부 고유 영역으로 봉인
    data() {
        return {
            registeredProductList: [],
            productCurrentPage: 1,
            productPageSize: 4 // 프리미엄 카드 크기를 완벽 보존한 채 4개 스케일 다운 피팅 규격 확정
        };
    },

    // 🎯 4단 페이지네이션 슬라이싱 연산 수식 자식 전독점 탑재 완료
    computed: {
        // 정확히 4개 단위씩 실시간 분할 컷팅하여 화면 카드를 사출하는 동적 리스트
        fnPaginatedProductList() {
            const start = (this.productCurrentPage - 1) * this.productPageSize;
            const end = start + this.productPageSize;
            return this.registeredProductList.slice(start, end);
        },
        // 토탈 상품 개수를 4로 나누어 인덱스 넘버를 정밀 연산 동기화하는 식
        totalProductPages() {
            return Math.ceil(this.registeredProductList.length / this.productPageSize);
        }
    },

    methods: {
        // [AJAX] 상품 전체 목록 로드 파이프라인 (파트너 전역 세션ID 매핑 직통 가동)
        fnProductList() {
            let self = this;
            $.ajax({
                url: "http://localhost:8080/productList.dox",
                dataType: "json",
                type: "POST",
                data: { userid: window.SESSION_ID },
                success: function(data) {
                    self.registeredProductList = data.list;
                }
            });
        },

        // [AJAX] 선택 상품 목록 내부 즉시 영구 삭제 파이프라인
        fnRemoveProduct(item) {
            if (confirm("정말 삭제하시겠습니까?")) {
                let self = this;
                let param = {
                    productNo: item.productNo
                };
                $.ajax({
                    url: "/productRemove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        alert(data.message);
                        self.productCurrentPage = 1;
                        self.fnProductList(); // 부모 간섭 없이 자식 데이터만 깔끔하게 새로고침!
                    }
                });
            } else {
                alert("삭제가 취소되었습니다.");
            }
        },

        // ◀ 화살표 무빙 제어
        fnPrevPage() {
            if (this.productCurrentPage > 1) {
                this.productCurrentPage--;
            }
        },
        // ▶ 화살표 무빙 제어
        fnNextPage() {
            if (this.productCurrentPage < this.totalProductPages) {
                this.productCurrentPage++;
            }
        },
        // 상위 부모 라우터 관제소로 화면 상태값 변경 액션만 위임 통보하는 에밋 규격
        fnRegPage() {
            this.$emit('go-reg');
        },
        fnEditPage(item) {
            this.$emit('go-edit', item.productNo);
        }
    },

    // 활성화되는 순간 자가 구동 목록 AJAX 트리거 점화
    mounted() {
        this.fnProductList();
    }
};