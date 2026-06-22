/**
 * ==========================================================================
 * [ProductListService] 상품 관리 - 목록 조회 및 단건 삭제 전용 비즈니스 로직
 * ==========================================================================
 */
const ProductListService = {
    // 상품 전체 목록 로드 파이프라인 (파트너 전역 세션ID 매핑)
    fnProductList() {
        this.productCurrentPage = 1;
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

    // 선택 상품 영구 삭제 파이프라인
    fnRemoveProduct(item) {
        if (confirm("정말 삭제하시겠습니까?")) {
            let self = this;
            let param = {
                productNo: item.productNo
            };
            console.log(item);
            $.ajax({
                url: "/productRemove.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function(data) {
                    alert(data.message);
                    location.href = "/partnerManagement.do";
                }
            });
        } else {
            alert("삭제가 취소되었습니다.");
        }
    }
};