

fnRemove(item) {
    // 1. 상품 삭제
    this.productList = this.productList.filter(p => p.id !== item.id);

    // 2. (선택사항) 해당 상품의 리뷰들도 같이 삭제하고 싶다면?
    this.reviews = this.reviews.filter(r => r.product !== item.name);
    this.simpleReviews = this.simpleReviews.filter(r => r.product !== item.name);
}
//fnRemove(프로덕트의 요소)

------------------------------------------------------------------
paginatedSimpleReviews() {
                    const start = (this.page - 1) * 5;
                    const end = start + 5;
                    return this.filteredSimpleReviews.slice(start, end); // 페이지에 맞는 리뷰만 반환 (5개씩) (page가 1이면 0~4, page가 2면 5~9) //[] 리스트..
                }

                //11개자료 인덱스기준: 0~2(3개), 3~5(3개), 6~8(3개), 9~10(2개)
                //slice기준 : (0, 3), (3, 6) , (6, 9), (9, 12)
                //             1,      2,        3,      4
                start = 3 * (currentPage -1)
                end = start + 3
                this.reservationList.slice(start, end)

            
productList.find(p => p.name === i)


inquiryList : [
    {id: 1, product: '화려하게', title:'투어 일정 변경하고 싶습니다.', userid: '김결혼', content:'04.01일 예약했는데 04.08일로 변경하고 싶어요.'},
    {id: 2, product: '스몰 웨딩', title:'메이크업 추가되나요?', userid: '아리랑', content:'메이크업 여기서 받고싶어요.'},


                            i=item
    productList = [{productNo: '11', productName: '야외 스냅 기본', productDetails: '야외 스냅 촬영 2시간 + 보정 사진 30장', originalPrice: '400000', imgUrl: '/img/imsi1.PNG'}}

product1 : {}
                                페이지에서 필요한 속성 모두 파악 -> 디비에 다 담기 (-> 시간있으면 디비 재설계 )순인거같다?
                                페이지에서 호출 -> 디비에서 호출, 반환 
                    usePeriod 디비에 담기(+) ->

        product1
                {productNo: '11', proType:["MAKEUP"], productName: '야외 스냅 기본', productDetails: '야외 스냅 촬영 2시간 + 보정 사진 30장', originalPrice: '400000', imgUrl: '/img/imsi1.PNG'}


                product1 : {}

        product2 : {companyNo: '', productNo: '',proType: [""], productName: '', productDetails: '', originalPrice: '', imgUrl: ''}
                product1.proType = ["메이크업", "스튜디오"]

v-for="i in productList"

fnRemove(i)

삭제하기 누르면 productNo 넘겨받고 -> 삭제하시겟습니까? -> delete쿼리문 작동


fnList: function () {
                    let self = this;
                    let param = {};
                    $.ajax({
                        url: "http://localhost:8080/",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                        }
                    });
                }

                list
: 
Array(4)
0
:  data.list 이면서 paidReviewList 에 담긴거
{reviewNo: '142', userId: 'junho0324', companyNo: '9', rating: '5.0', imgUrl: '/uploads/review/uuid_make_09.png', …}
1
: 
{reviewNo: '221', userId: 'hellow', companyNo: '9', rating: '4.2', imgUrl: '/img2/uuid_hellow_09.jpg', …}
2
: 
{reviewNo: '230', userId: 'glossy_ceo', companyNo: '9', rating: '5.0', imgUrl: '/img2/uuid_add_06.jpg', …}
3
: 
{reviewNo: '239', userId: 'bride_ceo', companyNo: '9', rating: '4.1', imgUrl: '/img2/uuid_add_15.jpg', …}
paidReviewList :[],
                    paidRivew1 :{}

                    handleMenuClick

                    {{w.name}} <- 이거 하다말았음..

                    fnProductList에
                    productList3 해주기