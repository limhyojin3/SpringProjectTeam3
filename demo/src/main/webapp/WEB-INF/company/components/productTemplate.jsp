<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <template id="product-section-template">
        <div v-if="productPage === 'list'">
            <div class="productlist-productReg">
                <div class="section-header">
                    <h2>등록한 상품({{ registeredProductList.length }})</h2>
                </div>
                <button @click="fnRegPage()" class="btn-product-reg">상품등록</button>
            </div>
            <div v-for="(i, idx) in fnPaginatedProductList" :key="idx" class="content-card PaginatedProductList">
                <div class="imgUrl">
                    <img :src="i.imgUrl" :alt="i.productName" class="productImg">
                </div>
                <div class="registeredProductList">
                    <div class="ticket-no">No. {{ registeredProductList.length - ((productCurrentPage - 1) * 5 + idx )
                        }}</div>
                    <div style="flex: 1; font-weight: bold;">{{ i.productName }}</div>
                </div>

                <div class="originalPrice">
                    <div>{{ Number(i.originalPrice).toLocaleString() }}원</div>
                    <button @click="fnEditPage(i)" class="btn-edit">수정하기</button>
                    <button @click="fnRemoveProduct(i)" class="btn-delete">삭제하기</button>
                </div>
            </div>

            <div class="pagination1">
                <span v-for="num in totalProductPages" :key="num">
                    <a @click="productCurrentPage = num" href="javascript:;"
                        :style="productCurrentPage === num ? 'color: #9b8fd4; border: 1px solid #9b8fd4;' : ''">
                        {{ num }}
                    </a>
                </span>
            </div>
        </div>

        <div v-else-if="productPage === 'reg'">
            <div class="product-form-wrapper">
                <h2>상품 등록하기</h2>
                <div class="product-form-section">
                    <div class="form-title-box">상품 기본 정보</div>
                    <div class="form-content-box">
                        <div class="form-group">
                            <label class="form-label">상품 이름</label>
                            <div class="form-info-box">
                                <input type="text" placeholder="여기에 상품 이름을 적어주세요."
                                    v-model="initializedOneProductDetails.productName">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">카테고리</label>
                            <div class="category-group">
                                <div class="category-item" v-for="item in category" :key="item">
                                    <label>
                                        <input type="checkbox" :value="item"
                                            v-model="initializedOneProductDetails.proType">{{item}}
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">상품 태그</label>
                            <div>
                                <input type="text" placeholder="첫번째 태그" v-model="tagMap.input1">
                                <input type="text" placeholder="두번째 태그" v-model="tagMap.input2">
                                <input type="text" placeholder="세번째 태그" v-model="tagMap.input3">
                                <input type="text" placeholder="네번째 태그" v-model="tagMap.input4">
                                <input type="text" placeholder="다섯번째 태그" v-model="tagMap.input5">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">상품 설명</label>
                            <div class="form-info-box">
                                <textarea placeholder="상품에 대한 자세한 설명을 입력하세요."
                                    v-model="initializedOneProductDetails.productDetails"></textarea>
                            </div>
                        </div>
                        <div>
                            <div class="form-group">
                                <label class="form-label"><span class="form-info-label">예상 견적</span></label>
                                <div class="form-info-box">
                                    <input placeholder="여기에 견적을 적어주세요." type="text"
                                        v-model="initializedOneProductDetails.originalPrice">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><span class="form-info-label">예약금</span></label>
                                <div class="form-info-box">
                                    <input placeholder="여기에 예약금을 적어주세요." type="text"
                                        v-model="initializedOneProductDetails.deposit">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="product-form-section">
                    <div class="form-title-box">상품 이미지</div>
                    <div class="form-content-box">
                        <div class="form-group">
                            <div>등록할 이미지 :</div>
                            <label>
                                사진 선택하기
                                <input type="file" @change="fnFileChange($event)" ref="fileInput"
                                    style="display: none;">
                            </label>
                            <div class="image-editor-box">
                                <div v-if="previewUrl">
                                    <p>선택된 이미지 미리보기:</p>
                                    <img :src="previewUrl">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-button-group">
                    <button class="btn-cancel" @click="fnBackToList()">취소(돌아가기)</button>
                    <button class="btn-submit" @click="fnInsertProduct()">상품 등록</button>
                </div>
            </div>
        </div>

        <div v-else-if="productPage === 'edit'">
            <div class="product-form-wrapper">
                <h2>상품 수정하기</h2>
                <div class="product-form-section">
                    <div class="form-title-box">상품 기본 정보</div>
                    <div class="form-content-box">
                        <div class="form-group">
                            <label class="form-label">상품 이름</label>
                            <div class="form-info-box">
                                <input type="text" class="input-product-name" placeholder="여기에 상품 이름을 적어주세요."
                                    v-model="oneProductDetails.productName">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">카테고리</label>
                            <div class="category-group">
                                <div class="category-item" v-for="item in category" :key="item">
                                    <label>
                                        <input type="checkbox" :value="item"
                                            v-model="oneProductDetails.proType">{{item}}
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">상품 태그</label>
                            <div class="tag-grid-container">
                                <input type="text" placeholder="첫번째 태그" v-model="tagMap.input1">
                                <input type="text" placeholder="두번째 태그" v-model="tagMap.input2">
                                <input type="text" placeholder="세번째 태그" v-model="tagMap.input3">
                                <input type="text" placeholder="네번째 태그" v-model="tagMap.input4">
                                <input type="text" placeholder="다섯번째 태그" v-model="tagMap.input5">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">상품 설명</label>
                            <div class="form-info-box">
                                <textarea placeholder="상품에 대한 자세한 설명을 입력하세요."
                                    v-model="oneProductDetails.productDetails"></textarea>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label"><span class="form-info-label">예상 견적</span></label>
                                <div class="form-info-box">
                                    <input type="text" placeholder="여기에 견적을 적어주세요."
                                        v-model="oneProductDetails.originalPrice">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><span class="form-info-label">예약금</span></label>
                                <div class="form-info-box">
                                    <input placeholder="여기에 예약금을 적어주세요." type="text"
                                        v-model="oneProductDetails.deposit">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="product-form-section">
                    <div class="form-title-box">상품 이미지</div>
                    <div class="form-content-box">
                        <div class="form-group">
                            <div class="image-status-label">기존 이미지 : </div>
                            <div class="image-editor-box">
                                <img :src="oneProductDetails.imgUrl">
                            </div>
                            <br>
                            <div class="image-status-label">수정할 이미지 : </div>
                            <label class="btn-file-select">
                                사진 선택하기
                                <input type="file" @change="fnFileChange($event)" ref="fileInput">
                            </label>
                            <div class="image-editor-box">
                                <div v-if="previewUrl" class="image-preview-wrapper">
                                    <p>선택된 이미지 미리보기:</p>
                                    <img :src="previewUrl">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-button-group">
                    <button class="btn-cancel" @click="fnBackToList()">취소(돌아가기)</button>
                    <button class="btn-submit" @click="fnUpdateProduct()">상품 수정</button>
                </div>
            </div>
        </div>
    </template>