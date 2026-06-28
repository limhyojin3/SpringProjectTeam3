<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminNavi.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css">

        <style>
            /* 상태 뱃지 */
            .badge-on {
                display: inline-block;
                background: #e7f8ee;
                color: #1c9b52;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }

            .badge-off {
                display: inline-block;
                background: #fff0f0;
                color: #e04a4a;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }

            /* 반응형 */
            @media (max-width: 1200px) {
                .middle {
                    grid-template-columns: 220px 1fr;
                }
            }

            @media (max-width: 900px) {
                .middle {
                    grid-template-columns: 1fr;
                }

                .main {
                    padding: 20px;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/common/header.jsp" />

        <div id="app">
            <div class="middle">
                <jsp:include page="/WEB-INF/admin/adminNavi.jsp" />
                <div class="main">
                    <div class="container admin-fade-up">

                        <h2>상품 관리</h2>
                        <div class="tab-menu">
                            <button :class="{active: activeTab == 'product'}"
                                @click="fnChangeTab('product')">상품관리</button>
                            <button :class="{active: activeTab == 'coupon'}"
                                @click="fnChangeTab('coupon')">쿠폰관리</button>
                            <button :class="{active: activeTab == 'pass'}" @click="fnChangeTab('pass')">패스관리</button>
                        </div>

                        <transition name="tab-fade-slide" mode="out-in">
                            <div :key="activeTab">
                                <!-- 상품 -->
                                <div v-if="activeTab == 'product'">
                                    <div class="header">
                                        <div class="keyword-group">
                                            <input type="text" v-model="keyword" placeholder="상품명 / 업체명 검색">
                                            <button @click="fnSearch()">검색</button>
                                        </div>
                                        <div class="filter-group">
                                            <select v-model="largeCategory" @change="fnChangeLargeCategory">
                                                <option value="">카테고리</option>
                                                <option v-for="category in largeCategoryList" :key="category"
                                                    :value="category">
                                                    {{ category }}
                                                </option>
                                            </select>

                                            <select v-model="mediumCategory" @change="fnCategorySearch"
                                                :disabled="!largeCategory">
                                                <option value="">태그</option>
                                                <option v-for="category in filteredMediumCategoryList" :key="category"
                                                    :value="category">
                                                    {{ category }}
                                                </option>
                                            </select>
                                            <select v-model="status" @change="fnGetList">
                                                <option value="">상태</option>
                                                <option value="1">판매중</option>
                                                <option value="0">중지</option>
                                            </select>
                                            <button @click="fnResetSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>

                                <table v-if="activeTab == 'product'" class="table">
                                    <thead>
                                        <tr>
                                            <th>상품번호</th>
                                            <th>업체명</th>
                                            <th>카테고리</th>
                                            <th>태그</th>
                                            <th>상품명</th>
                                            <th>가격</th>
                                            <th>상태</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-if="list.length === 0" class="no-data-row">
                                            <td colspan="8">조건에 맞는 상품이 없습니다.</td>
                                        </tr>
                                        <tr v-for="p in list" :key="p.productNo">
                                            <td>{{ p.productNo }}</td>
                                            <td>{{ p.comName}}</td>
                                            <td>{{ p.largeCategory}}</td>
                                            <td>{{ p.mediumCategory}}</td>
                                            <td>{{ p.productName }}</td>
                                            <td>{{ p.originalPrice.toLocaleString() }}</td>
                                            <td>
                                                <span :class="p.isActive == '1' ? 'badge-on' : 'badge-off'">
                                                    {{ p.isActive == '1' ? '판매중' : '중지' }}
                                                </span>
                                            </td>
                                            <td>
                                                <!-- <button class="btn btn-sm btn-info" @click="fnView(p.productNo)">상세</button> -->

                                                <button v-if="p.isActive == 1" class="btn-stop"
                                                    @click="fnStatus(p.productNo,0)">중지</button>

                                                <button v-else class="btn-done"
                                                    @click="fnStatus(p.productNo,1)">재판매</button>

                                                <!-- <button class="btn btn-sm btn-danger" @click="fnDelete(p.productNo)">삭제</button> -->
                                            </td>
                                        </tr>
                                        <tr v-for="n in emptyRows" class="empty-row">
                                            <td colspan="8">&nbsp;</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div v-if="activeTab == 'product'" class="page-box">

                                    <button @click="fnPageMove(currentPage - 1)" :disabled="currentPage == 1">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <template v-for="p in index">
                                        <button
                                            v-if="p > Math.floor((currentPage - 1) / 5) * 5 && p <= Math.ceil(currentPage / 5) * 5"
                                            :key="p" @click="fnPageMove(p)" :class="{active: currentPage == p}">
                                            {{ p }}
                                        </button>
                                    </template>
                                    <button @click="fnPageMove(currentPage + 1)" :disabled="currentPage == index">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>

                                </div>
                                <!-- 쿠폰 -->
                                <div v-if="activeTab == 'coupon'">
                                    <div class="header">
                                        <div class="keyword-group">
                                            <input type="text" v-model="keyword" placeholder="코드 / 이름 검색">
                                            <button @click="fnSearch()">검색</button>
                                        </div>
                                        <div class="filter-group">
                                            <select v-model="status" @change="fnGetList">
                                                <option value="">종류</option>
                                                <option value="COUPON">쿠폰</option>
                                                <option value="GIFTCON">기프티콘</option>
                                            </select>
                                            <button class="btn-done" @click="fnCouponModal()">쿠폰등록</button>
                                            <button @click="fnResetSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>
                                <table v-if="activeTab == 'coupon'" class="table">
                                    <thead>
                                        <tr>
                                            <th>코드</th>
                                            <th>종류</th>
                                            <th>이름</th>
                                            <th>할인율</th>
                                            <th>발급방식</th>
                                            <th>최대수량</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="c in list" :key="c.couponCode">
                                            <td>{{ c.couponCode }}</td>
                                            <td>{{ c.couponType }}</td>
                                            <td>{{ c.couponName }}</td>
                                            <td>{{ c.discountRate }}%</td>
                                            <td>{{ c.issueType }}</td>
                                            <td>{{ c.maxIssueCnt }}</td>
                                            <td>
                                                <button class="btn-warn" @click="fnCouponDelete(c.couponCode)">
                                                    삭제
                                                </button>
                                            </td>
                                        </tr>
                                        <tr v-for="n in emptyRows" class="empty-row">
                                            <td colspan="6">&nbsp;</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div v-if="activeTab == 'coupon'" class="page-box">

                                    <button @click="fnPageMove(currentPage - 1)" :disabled="currentPage == 1">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <template v-for="p in index">
                                        <button
                                            v-if="p > Math.floor((currentPage - 1) / 5) * 5 && p <= Math.ceil(currentPage / 5) * 5"
                                            :key="p" @click="fnPageMove(p)" :class="{active: currentPage == p}">
                                            {{ p }}
                                        </button>
                                    </template>
                                    <button @click="fnPageMove(currentPage + 1)" :disabled="currentPage == index">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>

                                </div>
                                <!-- 패스 -->
                                <div v-if="activeTab == 'pass'">
                                    <div class="header">
                                        <div class="keyword-group">
                                            <input type="text" v-model="keyword" placeholder="패스명 검색">
                                            <button @click="fnSearch()">검색</button>
                                        </div>
                                        <div class="filter-group">
                                            <select v-model="status" @change="fnGetList">
                                                <option value="">판매상태</option>
                                                <option value="1">판매중</option>
                                                <option value="0">중지</option>
                                            </select>
                                            <button class="btn btn-success" @click="fnOpenPassModal()">패스등록</button>
                                            <button @click="fnResetSearch">초기화</button>
                                        </div>
                                    </div>
                                </div>
                                <table v-if="activeTab == 'pass'" class="table">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>이름</th>
                                            <th>가격</th>
                                            <th>리뷰수</th>
                                            <th>상태</th>
                                            <th>관리</th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="p in list" :key="p.passNo">
                                            <td>{{ p.passNo }}</td>
                                            <td>{{ p.passName }}</td>
                                            <td>{{ p.price.toLocaleString() }}</td>
                                            <td>{{ p.reviewCnt }}</td>
                                            <td>
                                                <span :class="p.isActive == '1' ? 'badge-on' : 'badge-off'">
                                                    {{ p.isActive == '1' ? '판매중' : '중지' }}
                                                </span>
                                            </td>
                                            <td>
                                                <button v-if="p.isActive == 1" class="btn-stop"
                                                    @click="fnPassStatus(p.passNo,0)">
                                                    중지
                                                </button>

                                                <button v-else class="btn-done" @click="fnPassStatus(p.passNo,1)">
                                                    재판매
                                                </button>

                                                <button class="btn-warn" @click="fnDeletePass(p.passNo)">
                                                    삭제
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!-- 쿠폰 등록 모달 -->
                                <div class="modal fade" id="couponModal">
                                    <div class="modal-dialog">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title">등록</h5>
                                                <button type="button" class="close" data-dismiss="modal">
                                                    &times;
                                                </button>
                                            </div>

                                            <div class="modal-body">
                                                코드
                                                <input class="form-control mb-2" v-model="coupon.couponCode"
                                                    placeholder="코드">
                                                이름
                                                <input class="form-control mb-2" v-model="coupon.couponName"
                                                    placeholder="이름">
                                                할인율(%)
                                                <input class="form-control mb-2" v-model="coupon.discountRate"
                                                    placeholder="할인율">
                                                발급방식
                                                <select class="form-control mb-2" v-model="coupon.issueType">

                                                    <option value="AUTO">AUTO</option>
                                                    <option value="CODE">CODE</option>

                                                </select>
                                                최대 발급 수
                                                <input class="form-control mb-2" v-model="coupon.maxIssueCnt"
                                                    placeholder="최대 발급 수량">
                                                기프티콘 url
                                                <input class="form-control mb-2" v-model="coupon.giftconImage"
                                                    placeholder="기프티콘 url">
                                            </div>

                                            <div class="modal-footer">
                                                <button class="btn btn-primary" @click="fnCouponSave()">
                                                    저장
                                                </button>

                                                <button class="btn btn-secondary" data-dismiss="modal">
                                                    닫기
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- 패스 등록 모달 -->
                                <div class="modal fade" id="passModal">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">패스 등록</h5>
                                                <button type="button" class="close" data-dismiss="modal">
                                                    &times;
                                                </button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="form-group">
                                                    <label>패스명</label>
                                                    <input type="text" v-model="passForm.passName" class="form-control">
                                                </div>

                                                <div class="form-group">
                                                    <label>가격</label>
                                                    <input type="number" v-model="passForm.price" class="form-control">
                                                </div>

                                                <div class="form-group">
                                                    <label>리뷰수</label>
                                                    <input type="number" v-model="passForm.reviewCnt"
                                                        class="form-control">
                                                </div>

                                                <div class="form-group">
                                                    <label>상태</label>
                                                    <select v-model="passForm.isActive" class="form-control">
                                                        <option value="1">사용중</option>
                                                        <option value="0">중지</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label>설명</label>
                                                    <textarea class="form-control" v-model="passForm.description"
                                                        placeholder="패스 설명 입력"></textarea>
                                                </div>
                                            </div>

                                            <div class="modal-footer">
                                                <button class="btn btn-primary" @click="fnSavePass()">
                                                    저장
                                                </button>

                                                <button class="btn btn-secondary" data-dismiss="modal">
                                                    닫기
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </transition>
                    </div>
                </div>
                <jsp:include page="/WEB-INF/common/footer.jsp" />
            </div>
            <script>
                const app = Vue.createApp({
                    data() {
                        return {
                            // 변수 - (key : value)
                            activeTab: "product",
                            list: [],
                            info: {},
                            keyword: "",
                            status: "",
                            pageSize: 5,
                            currentPage: 1,
                            index: 1,
                            emptyRows: 0,
                            coupon: {
                                couponCode: "",
                                couponName: "",
                                discountRate: "",
                                issueType: "AUTO",
                                maxIssueCnt: ""
                            },
                            passForm: {
                                passName: "",
                                price: 0,
                                reviewCnt: 0,
                                isActive: "1"
                            },
                            largeCategory: "",
                            mediumCategory: "",

                            largeCategoryList: [
                                "결혼",
                                "가족행사",
                                "친구와 함께"
                            ],

                            mediumCategoryMap: {
                                "결혼": [
                                    "웨딩홀",
                                    "스튜디오",
                                    "드레스",
                                    "메이크업"
                                ],
                                "가족행사": [
                                    "돌잔치",
                                    "환갑",
                                    "칠순",
                                    "가족모임"
                                ],
                                "친구와 함께": [
                                    "파티룸",
                                    "여행",
                                    "체험"
                                ]
                            }
                        };
                    },

                    computed: {
                        filteredMediumCategoryList() {
                            return this.mediumCategoryMap[this.largeCategory] || [];
                        }
                    },

                    methods: {
                        // 함수(메소드) - (key : function())
                        fnPage: function (url) {
                            location.href = url;
                        },

                        fnChangeTab(tab) {
                            this.activeTab = tab;
                            this.fnResetSearch();
                        },
                        fnChangeLargeCategory() {
                            // 카테고리가 변경되면 기존 태그 선택 제거
                            this.mediumCategory = "";
                            this.currentPage = 1;
                            this.fnGetList();
                        },

                        fnCategorySearch() {
                            this.currentPage = 1;
                            this.fnGetList();
                        },
                        fnResetSearch() {
                            this.keyword = "";
                            this.status = "";
                            this.largeCategory = "";
                            this.mediumCategory = "";
                            this.currentPage = 1;
                            this.fnGetList();
                        },

                        fnPageMove(p) {
                            if (p < 1 || p > this.index) return;
                            this.currentPage = p;
                            this.fnGetList();
                        },

                        fnGetList() {
                            let self = this;
                            let url = "";

                            if (self.activeTab == 'product') {
                                url = "/productAdminList.dox";
                            } else if (self.activeTab == 'coupon') {
                                url = "/couponList.dox";
                            } else if (self.activeTab == 'pass') {
                                url = "/passList.dox";
                            }

                            $.ajax({
                                url: url,
                                type: "POST",
                                dataType: "json",
                                data: {
                                    pageSize: self.pageSize,
                                    offSet: self.pageSize * (self.currentPage - 1),
                                    keyword: self.keyword,
                                    status: self.status,
                                    largeCategory: self.largeCategory,
                                    mediumCategory: self.mediumCategory,
                                },
                                success: function (res) {
                                    self.list = res.list || [];
                                    self.index = Math.ceil((res.totalCount || 0) / self.pageSize);
                                    self.emptyRows = 5 - res.list.length;
                                },
                            });
                        },

                        fnSearch() {
                            this.currentPage = 1;
                            this.fnGetList();
                        },

                        fnView(no) {
                            let self = this;

                            $.ajax({
                                url: "/productView.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    productNo: no
                                },
                                success: function (res) {
                                    if (res.result == "success") {
                                        self.info = res.info;

                                        $("#productModal").modal("show");
                                    } else {
                                        alert("조회 실패");
                                    }
                                }
                            });
                        },

                        fnStatus(no, status) {
                            let self = this;

                            let msg = status == 1 ? "재판매 하시겠습니까?" : "판매중지 하시겠습니까?";

                            if (!confirm(msg)) {
                                return;
                            }

                            $.ajax({
                                url: "/productStatusUpdate.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    productNo: no,
                                    isActive: status
                                },
                                success: function (res) {
                                    alert(res.message);
                                    self.fnGetList();
                                }
                            });
                        },

                        fnDelete(no) {
                            let self = this;

                            if (!confirm("정말 삭제하시겠습니까?")) {
                                return;
                            }

                            $.ajax({
                                url: "/productDelete.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    productNo: no
                                },
                                success: function (res) {
                                    alert(res.message);
                                    self.fnGetList();
                                }
                            });
                        },

                        fnCouponModal() {

                            this.coupon = {
                                couponCode: "",
                                couponName: "",
                                discountRate: 10,
                                issueType: "AUTO",
                                maxIssueCnt: 1
                            };

                            $("#couponModal").modal("show");
                        },


                        // 쿠폰 저장
                        fnCouponSave() {
                            let self = this;
                            if (!self.coupon.couponCode || self.coupon.couponCode.trim() == "") {
                                alert("코드를 입력해주세요.");
                                return; // 저장 로직이 실행되지 않도록 중단
                            }

                            if (!self.coupon.couponName || self.coupon.couponName.trim() == "") {
                                alert("이름을 입력해주세요.");
                                return;
                            }
                            $.ajax({
                                url: "http://localhost:8080/couponInsert.dox",
                                type: "POST",
                                dataType: "json",
                                data: self.coupon,
                                success: function (res) {
                                    alert(res.message);
                                    if (res.result == "success") {
                                        $("#couponModal").modal("hide");
                                        self.fnGetList();
                                    }
                                },
                                error: function (err) {
                                    console.log(err);
                                }
                            });
                        },


                        // 쿠폰 삭제
                        fnCouponDelete(code) {

                            let self = this;

                            if (!confirm("삭제하시겠습니까?")) {
                                return;
                            }

                            $.ajax({
                                url: "/couponDelete.dox",
                                type: "POST",
                                dataType: "json",
                                data: { couponCode: code },
                                success: function (res) {

                                    alert(res.message);
                                    self.fnGetList();

                                }
                            });
                        },
                        fnOpenPassModal() {

                            this.passForm = {
                                passName: "",
                                price: 0,
                                reviewCnt: 0,
                                isActive: "1"
                            };

                            $("#passModal").modal("show");
                        },

                        fnSavePass() {

                            let self = this;

                            $.ajax({
                                url: "http://localhost:8080/passAdd.dox",
                                type: "POST",
                                dataType: "json",
                                data: self.passForm,
                                success: function (res) {
                                    alert(res.message);

                                    if (res.result == "success") {
                                        $("#passModal").modal("hide");
                                        self.fnGetList();
                                    }
                                }
                            });
                        },

                        fnDeletePass(no) {

                            let self = this;

                            if (!confirm("삭제하시겠습니까?")) return;

                            $.ajax({
                                url: "/passDelete.dox",
                                type: "POST",
                                dataType: "json",
                                data: { passNo: no },
                                success: function (res) {
                                    alert(res.message);
                                    self.fnGetList();
                                }
                            });
                        },

                        fnPassStatus(no, status) {

                            let self = this;
                            let msg = status == 1 ? "재판매 하시겠습니까?" : "중지 하시겠습니까?";
                            if (!confirm(msg)) {
                                return;
                            }
                            $.ajax({
                                url: "/passStatusUpdate.dox",
                                type: "POST",
                                dataType: "json",
                                data: {
                                    passNo: no,
                                    isActive: status
                                },
                                success: function (res) {
                                    alert(res.message);
                                    self.fnGetList();
                                }
                            });
                        },
                    }, // methods
                    mounted() {
                        // 처음 시작할 때 실행되는 부분
                        let self = this;
                        const path = location.pathname;
                        self.fnGetList();
                    }
                });
                app.mount('#app');
            </script>
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>
    </body>

    </html>