// 💡 오직 서버에서 데이터를 가져오는 역할만 100% 응집된 통신 파일입니다.
const ProductService = {
    // 상품 및 태그 리스트를 가져오는 함수
    getTagAndProductList(callback) {
        $.ajax({
            url: "/getTagAndProductList.dox",
            dataType: "json",
            type: "POST",
            data: {},
            success: function(data) {
                // 데이터를 예쁘게 가공합니다.
                let formattedTags = data.taglist;
                let formattedProducts = data.productListForTag.map(p => ({
                    id: p.productNo,
                    companyNo: p.companyNo,
                    thumbnail: p.imgUrl,
                    name: p.productName,
                    company: p.comName,
                    content: p.productDetails,
                    price: p.originalPrice,
                    category: typeof p.proType === 'string' ? JSON.parse(p.proType) : p.proType,
                    tag: typeof p.tag === 'string' ? JSON.parse(p.tag) : p.tag,
                    deposit: p.deposit || 0
                }));

                // 💡 조회가 완료되면 나를 불러준 곳으로 가공된 데이터를 돌려줍니다.
                callback(formattedTags, formattedProducts);
            }
        });
    }
};