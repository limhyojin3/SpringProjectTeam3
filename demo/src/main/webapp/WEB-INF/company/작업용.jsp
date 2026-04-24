

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

                    selectCategory: [],
                     productList: [  //상품 리스트
                        { id: 1, thumbnail: 'https://img1.newsis.com/2021/09/26/NISI20210926_0000834715_web.jpg', name: '스몰 웨딩', content: '스몰 웨딩 상품 설명입니다.', price: '1,700,000원', category: ['스튜디오', '드레스'] },
                        { id: 2, thumbnail: 'gorgeous.jpg', name: '화려하게', content: '화려하게 상품 설명입니다.', price: '2,500,000원', category: ['스튜디오', '메이크업'] },
                        { id: 3, thumbnail: 'fairy_tale.jpg', name: '동화같은 분위기', content: '동화같은 분위기 상품 설명입니다.', price: '1,200,000원', category: ['메이크업'] }
                    ]

                    selectTags: [],

filteredList() {


                    if (this.selectCategory.length === 0) {
                        return this.productList;
                    }
                    if (this.selectTags.length === 0) {
                        return this.productList;
                    }

                    // 선택된 카테고리가 있다면 필터링 시작!
                    return this.productList.filter(product => {
                        // product.category 배열 안에 selectCategory에 담긴 값이 하나라도 있는지 확인
                        // some() 함수는 "하나라도 포함되면 true"를 반환합니다.
                        return this.selectCategory.some(cat => product.category.includes(cat));
                    });

                    // 2. 필터링 시작
                    return this.productList.filter(product => {
                        // product.tag 배열 안에 사용자가 선택한 selectTags 중 하나라도 들어있는가?
                        return this.selectTags.some(tag => product.tag.includes(tag));
                    });

                    //만약 selectCategory에 '스튜디오'를 포함하고 있고 and productList.category에 '스튜디오' 를 포함하고 있다면
                    //productList의 해당 상품을 보여준다.


                }


                <div v-if="currentMenu === 'main'">

                        <h2>카테고리</h2>
                        <label><input type="checkbox" v-model="selectCategory" value="스튜디오">스튜디오</label>
                        <label><input type="checkbox" v-model="selectCategory" value="드레스">드레스</label>
                        <label><input type="checkbox" v-model="selectCategory" value="메이크업">메이크업</label>

                        <div class="tag-filter">
                            <h4>분위기 선택</h4>
                            <label v-for="tag in productTag" :key="tag">
                                <input type="checkbox" :value="tag" v-model="selectTags">
                                {{ tag }}
                            </label>
                        </div>

                        <!-- <p>선택한 카테고리: {{ selectCategory }}</p> -->
                        <!-- {{filteredList}} -->
                        <div v-for="i in filteredList" style="display: flex;">
                            <div
                                style="box-sizing: border-box; display: inline-block;height: 100px; width: 100px; border: 1px solid black;">
                                <img :src="i.thumbnail" alt="i.name" style="height: 100%; width: 100%;">
                            </div>
                            <h4>{{i.name}}</h4>
                            <p>{{i.content}}</p>
                            <p>{{i.price}}</p>
                        </div>



                    </div>













                    <main>
    <div v-if="currentMenu === 'main' && productPage === 'list'">
        <div class="filter-section">
            <div class="section-title">조회 필터</div>
            </div>

        <div v-for="item in filteredList" :key="item.id" class="product-item" @click="goDetailPage(item)" style="cursor:pointer;">
            <div class="product-img-box">
                <img :src="item.thumbnail" alt="item.name">
            </div>
            <div class="product-info">
                <h4>{{item.name}}</h4>
                <p class="product-content">{{item.content}}</p>
                <p class="product-price">{{item.price}}</p>
            </div>
        </div>
    </div>

    <div v-if="currentMenu === 'main' && productPage === 'detail'">
        <button @click="productPage = 'list'" style="margin-bottom:10px;">← 뒤로가기</button>
        
        <div class="detail-container">
            <div class="detail-left">
                <img :src="product1.thumbnail" class="detail-main-img">
                <div class="detail-company-name">
                    {{ product1.company }} </div>
                <div class="detail-description-card">
                    <h3 style="margin-top:0;">{{ product1.name }}</h3>
                    <p>{{ product1.content }}</p>
                    <hr>
                    <p>※ 상세 옵션 안내 및 유의사항이 여기에 들어갑니다.</p>
                </div>
            </div>

            <div class="detail-right">
                <div class="reservation-box">
                    <div style="font-weight:bold; border-bottom:1px solid #ddd; padding-bottom:10px;">예약하기</div>
                    <div class="calendar-placeholder">
                        날짜 선택 캘린더 API 영역<br>(FullCalendar 등)
                    </div>
                </div>

                <div class="price-info-box">
                    <div class="price-row">
                        <span>예상 견적 :</span>
                        <span>{{ product1.price }}</span>
                    </div>
                </div>

                <div class="price-info-box">
                    <div class="price-row">
                        <span>예약금 :</span>
                        <span>100,000원</span>
                    </div>
                </div>

                <button class="btn-reserve" @click="fnReserve">예약하기</button>
                <button class="btn-inquiry" @click="currentMenu = 'inquiry'">상품 문의하기</button>
            </div>
        </div>
    </div>
</main>


<div class="filter-section">
                            <div class="section-title">조회 필터</div>
                            <h2>카테고리</h2>
                            <label><input type="checkbox" v-model="selectCategory" value="스튜디오"> 스튜디오</label>
                            <label><input type="checkbox" v-model="selectCategory" value="드레스"> 드레스</label>
                            <label><input type="checkbox" v-model="selectCategory" value="메이크업"> 메이크업</label>

                            <div class="tag-filter">
                                <h4 style="width: 100%;">분위기 선택</h4>
                                <label v-for="tag in productTag" :key="tag">
                                    <input type="checkbox" :value="tag" v-model="selectTags">
                                    {{ tag }}
                                </label>
                            </div>
                        </div>