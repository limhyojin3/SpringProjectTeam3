

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

    productList: [  //상품 리스트
                        { id: 1, thumbnail: 'https://img1.newsis.com/2021/09/26/NISI20210926_0000834715_web.jpg', name: '스몰 웨딩', content: '스몰 웨딩 상품 설명입니다.', price: '1,700,000원', category: ['스튜디오', '드레스'] },
                        { id: 2, thumbnail: 'gorgeous.jpg', name: '화려하게', content: '화려하게 상품 설명입니다.', price: '2,500,000원', category: ['스튜디오', '메이크업'] },
                        { id: 3, thumbnail: 'fairy_tale.jpg', name: '동화같은 분위기', content: '동화같은 분위기 상품 설명입니다.', price: '1,200,000원', category: ['메이크업'] }
                    ],

list  -> productList 에 담는다.
: 
(3) [
{productNo: '11', productName: '야외 스냅 기본', productDetails: '야외 스냅 촬영 2시간 + 보정 사진 30장', originalPrice: '400000', imgUrl: '/img/imsi1.PNG'}}
, {…}
, {…}]
product1 : {}
<div
                                    style="width: 120px; height: 80px; background: #ffcef0; display: flex; align-items: center; justify-content: center; margin-right: 20px;">
                                    <!--{{ i.thumbnail }}-->
                                    <img :src="i.thumbnail" :alt="i.name"  style="max-width: 100%; max-height: 100%">
                                </div>
                                user: {
                        id: 1, name: 'ABC 드레스 샵', usePeriod: '25.01.01 ~ 26.01.01', lastPayment: '신협 ***', grade: '제휴업체' /* 일반업체, 제휴업체 구분 변수 */
                                }            -> 디비에 이것들이 있는지 확인!

                                페이지에서 필요한 속성 모두 파악 -> 디비에 다 담기 (-> 시간있으면 디비 재설계 )순인거같다?
                                페이지에서 호출 -> 디비에서 호출, 반환 
                    usePeriod 디비에 담기(+) ->

                    menuList() {
                    return [
                        { id: 'main', name: '마이 페이지', count: 0 },
                        { id: 'product', name: '상품 관리', count: 0 },
                        { id: 'reservation', name: '예약 관리', count: this.resCount },
                        { id: 'inquiry', name: '문의 내역', count: 2 },
                        { id: 'review', name: '리뷰 내역', count: this.revCnt },
                        { id: 'customer', name: '고객센터', count: 0 }
                    ];
                },
        product1
                {productNo: '11', proType:["MAKEUP"], productName: '야외 스냅 기본', productDetails: '야외 스냅 촬영 2시간 + 보정 사진 30장', originalPrice: '400000', imgUrl: '/img/imsi1.PNG'}

                selectedItems: []

                product1 : {}

                category : ['스튜디오', '드레스', '메이크업']
                product1.proType : ["MAKEUP"],
                string 이면 json 형태로 파싱해라..뭐를. self.product1.proType을
                let rawArray = ["MAKEUP", "STUDIO"]
                rawArray.map(val => {
                    if(val === 'MAKEUP'){

                    }
                })

        product2 : {companyNo: '', productNo: '',proType: [""], productName: '', productDetails: '', originalPrice: '', imgUrl: ''}
                product1.proType = ["메이크업", "스튜디오"]


                previewUrl: null, // 미리보기용 URL
        uploadFile: null  // 서버로 보낼 실제 파일 객체


        <img v-if="previewUrl" :src="previewUrl">
        <label style="background: #ff1493; color: white; padding: 5px 15px; cursor: pointer; border-radius: 5px;">
    사진 선택하기
    <input type="file" @change="fnFileChange" style="display: none;">
</label>

INSERT INTO PRODUCT 
SET
	PRODUCT_NAME = #{productName},
    PRODUCT_DETAILS = #{productDetails},
    ORIGINAL_PRICE = #{originalPrice},
    IMG_URL = #{imgUrl},
    PRO_TYPE = #{proType}
WHERE PRODUCT_NO = #{productNo};

<div v-else-if="productPage === 'edit'">
                            <div class="product-form-wrapper">
                                <h2 style="color: #333; margin-bottom: 30px;">상품 수정하기</h2>

                                <div class="product-form-section">
                                    <div class="form-title-box">상품 기본 정보</div>
                                    <div class="form-content-box">

                                        <div class="form-group">
                                            <label class="form-label">상품 이름</label>
                                            <div class="form-info-box">
                                                <input type="text"
                                                    style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                    v-model="product1.productName">
                                            </div>
                                        </div>




                                        <div class="form-group">
                                            <label class="form-label">카테고리</label>
                                            <div class="category-group">


                                                <div class="category-item" v-for="item in category" :key="item">
                                                    <input type="checkbox" :value="item"
                                                        v-model="product1.proType">{{item}}
                                                </div>
                                            </div>
                                        </div>


                                        <div class="form-group">
                                            <label class="form-label">상품 설명</label>
                                            <div class="form-info-box">
                                                <textarea
                                                    style="width: 60%; height: 100px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                    placeholder="상품에 대한 자세한 설명을 입력하세요."
                                                    v-model="product1.productDetails"></textarea>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label"><span class="form-info-label">예상 견적</span></label>
                                            <div class="form-info-box">

                                                <input type="text"
                                                    style="width: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
                                                    v-model="product1.originalPrice">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="product-form-section">
                                    <div class="form-title-box">상품 이미지</div>
                                    <div class="form-content-box">
                                        <div class="form-group">


                                            <div style="margin-bottom: 10px; font-weight: bold;">기존 이미지 : </div>
                                            <div class="image-editor-box">
                                                <img :src="product1.imgUrl">
                                            </div>
                                            <br>








                                            <div style="margin-bottom: 10px; font-weight: bold;">수정할 이미지 : </div>
                                            <!-- 이미지 첨부 -->
                                            <label
                                                style="background: #ff1493; color: white; padding: 5px 15px; cursor: pointer; border-radius: 5px;">
                                                사진 선택하기
                                                <input type="file" @change="fnFileChange" ref="fileInput"
                                                    style="display: none;">
                                            </label>
                                            <div class="image-editor-box">

                                                <div v-if="previewUrl" style="margin-top: 10px;">
                                                    <p>선택된 이미지 미리보기:</p>
                                                    <img :src="previewUrl"
                                                        style="max-width: 80%; border: 1px solid #ccc;">
                                                </div>
                                            </div>









                                        </div>
                                    </div>
                                </div>

                                <div class="form-button-group">
                                    <button class="btn-cancel" @click="productPage = 'list'">취소(돌아가기)</button>
                                    <button class="btn-submit" @click="fnUpdateProduct">상품 수정</button>
                                </div>
                            </div>
                        </div>
                    </div>