

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


                    weddinglist

                    productList: [  //상품 리스트
                        { id: 1, thumbnail: 'https://img1.newsis.com/2021/09/26/NISI20210926_0000834715_web.jpg', name: '스몰 웨딩', content: '스몰 웨딩 상품 설명입니다.', price: '1,700,000원', category: ['스튜디오', '드레스'] },
                        { id: 2, thumbnail: 'gorgeous.jpg', name: '화려하게', content: '화려하게 상품 설명입니다.', price: '2,500,000원', category: ['스튜디오', '메이크업'] },
                        { id: 3, thumbnail: 'fairy_tale.jpg', name: '동화같은 분위기', content: '동화같은 분위기 상품 설명입니다.', price: '1,200,000원', category: ['메이크업'] }
                    ]
                    productList: [  //상품 리스트
                        { id: 1, thumbnail: 'https://i.imgur.com/JyVciZk.jpeg', name: '스몰 웨딩', content: '스몰 웨딩 상품 설명입니다.', price: '1,700,000원', category: ['스튜디오', '드레스'] },
                        { id: 2, thumbnail: 'gorgeous.jpg', name: '화려하게', content: '화려하게 상품 설명입니다.', price: '2,500,000원', category: ['스튜디오', '메이크업'] },
                        { id: 3, thumbnail: 'fairy_tale.jpg', name: '동화같은 분위기', content: '동화같은 분위기 상품 설명입니다.', price: '1,200,000원', category: ['메이크업'] }
                    ]
                    <img :src="w.thumbnail">



                    fnPageChange(num) {
                    this.currentPage = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                }


                fnPageChange2(num) {
                    this.page = num;

                    window.scrollTo({
                        top: 0,
                        behavior: 'smooth' // 'smooth'는 부드럽게, 'auto'는 즉시 이동합니다.
                    });
                }

userId : self.myReservation1.userId,
                            amount: self.payAmount,
                            resNo: self.myReservation1.resNo

                <div v-if="currentMenu === 'main' && productPage === 'payment'" class="payment-container">

                            <div class="reservation-ticket">
                                <div class="ticket-header">
                                    <span class="ticket-brand">MERRY VIEW RESERVATION</span>
                                    <span class="ticket-type">OFFICIAL TICKET</span>
                                </div>
                                <!-- {{product1}}
                                {{selectedDate}}
                                {{selectedTime}} -->
                                <!-- <div style="text-align: right;">
                                    <img :src="product1.thumbnail" style="max-height: 200px; margin-top: 10px; margin-right: 20px;">
                                </div> -->
Number(p.deposit).toLocaleString() + '원'
                                <div class="ticket-body">
                                    <div class="ticket-info">
                                        <div class="info-row product-name">
                                            <label>예약 상품</label>
                                            <div class="value">{{ product1.name }} <small>({{ product1.company
                                                    }})</small></div>
                                        </div>

                                        <div class="info-grid">
                                            <div class="info-row">
                                                <label>예약 일시</label>
                                                <div class="value date-time">{{ selectedDate }} <span
                                                        class="time-tag">{{ selectedTime }}</span></div>
                                            </div>
                                            <div class="info-row">
                                                <label>예약자명</label>
                                                <div class="value">{{ user.name }}님</div>
                                            </div>
                                        </div>


                                        <div class="info-row">
                                            <label>휴대폰 번호</label>
                                            <div class="value">{{ user.contact }}</div>
                                        </div>

                                        <div class="info-row">
                                            <label>요청 사항</label>
                                            <div class="value">{{res_content}}</div>
                                        </div>



                                    </div>

                                    <div class="ticket-side">
                                        <div class="side-content">
                                            <img :src="product1.thumbnail" style="max-height: 200px;">
                                            <div class="amount-label">TOTAL DEPOSIT</div>
                                            <div class="amount-value">{{ product1.deposit }}</div>
                                            <div class="agreement-text">필수 항목 동의 : 노쇼관련</div>
                                            <!-- <div class="ticket-barcode">|| ||| || |||| | ||</div> -->
                                        </div>
                                    </div>
                                </div>

                                <!-- {{user.name}}
                                {{product1.id}}
                                {{product1.companyNo}}
                                {{res_content}}
                                {{selectedDate}}
                                {{selectedTime}} -->



                                <div class="payment-btn-group">
                                    <button class="btn-cancel-pay" @click="productPage = 'detail'">뒤로가기</button>
                                    <button class="btn-final-reserve" @click="fnFinalOrder(user)">결제 및 예약 확정</button>
                                </div>
                            </div>
                        </div>