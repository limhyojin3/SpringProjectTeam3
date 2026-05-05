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
            .content-box {
                width: 1040px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                padding: 20px;
            }

            .page-title {
                font-size: 26px;
                font-weight: 700;
                color: #222;
                margin-bottom: 25px;
            }

            /* 탭 메뉴 */
            .tab-menu {
                display: flex;
                gap: 12px;
                margin-bottom: 25px;
                flex-wrap: wrap;
            }

            .tab-menu button {
                border: none;
                background: #eef1f6;
                color: #555;
                padding: 12px 24px;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 600;
                transition: all 0.25s ease;
                cursor: pointer;
            }

            .tab-menu button:hover {
                background: #dbe7ff;
                color: #2b62ff;
                transform: translateY(-2px);
            }

            .tab-menu button.active {
                background: linear-gradient(135deg, #4a7dff, #275df7);
                color: #fff;
                box-shadow: 0 6px 14px rgba(39, 93, 247, 0.25);
            }

            /* 테이블 */
            .report-table {
                width: 100%;
                border-collapse: collapse;
                overflow: hidden;
                border-radius: 14px;
            }

            .report-table thead {
                background: #f4f6fa;
            }

            .report-table th {
                padding: 16px;
                text-align: center;
                font-size: 14px;
                font-weight: 700;
                color: #444;
                border-bottom: 1px solid #e6eaf0;
            }

            .report-table td {
                padding: 15px;
                text-align: center;
                font-size: 14px;
                color: #555;
                border-bottom: 1px solid #f0f2f5;
            }

            .report-table tbody tr {
                transition: 0.2s;
            }

            .report-table tbody tr:hover {
                background: #f8fbff;
            }

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
                    <div class="content-box">
                        <div class="tab-menu">
                            <button :class="{active: activeTab === 'product'}"
                                @click="fnChangeTab('product')">상품관리</button>
                            <button :class="{active: activeTab === 'coupon'}"
                                @click="fnChangeTab('coupon')">쿠폰관리</button>
                            <button :class="{active: activeTab === 'pass'}" @click="fnChangeTab('pass')">패스관리</button>
                        </div>

                        <!-- 상품 -->
                        <div v-if="activeTab === 'product'" style="margin-bottom:15px; display:flex; gap:10px;">

                            <input type="text" v-model="keyword" placeholder="상품명 / 업체명 검색" class="form-control"
                                style="width:250px;">

                            <select v-model="status" class="form-control" style="width:140px;">
                                <option value="">전체상태</option>
                                <option value="1">판매중</option>
                                <option value="0">중지</option>
                            </select>

                            <button class="btn btn-primary" @click="fnSearch()">검색</button>

                        </div>
                        <table v-if="activeTab === 'product'" class="report-table">
                            <thead>
                                <tr>
                                    <th>상품번호</th>
                                    <th>업체명</th>
                                    <th>상품명</th>
                                    <th>가격</th>
                                    <th>상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="p in list" :key="p.productNo">
                                    <td>{{ p.productNo }}</td>
                                    <td>{{ p.comName}}</td>
                                    <td>{{ p.productName }}</td>
                                    <td>{{ p.originalPrice.toLocaleString() }}</td>
                                    <td>
                                        <span :class="p.isActive === '1' ? 'badge-on' : 'badge-off'">
                                            {{ p.isActive === '1' ? '판매중' : '중지' }}
                                        </span>
                                    </td>
                                    <td>
                                        <!-- <button class="btn btn-sm btn-info" @click="fnView(p.productNo)">상세</button> -->

                                        <button v-if="p.isActive == 1" class="btn btn-sm btn-warning"
                                            @click="fnStatus(p.productNo,0)">중지</button>

                                        <button v-else class="btn btn-sm btn-success"
                                            @click="fnStatus(p.productNo,1)">재판매</button>

                                        <!-- <button class="btn btn-sm btn-danger" @click="fnDelete(p.productNo)">삭제</button> -->
                                    </td>
                                </tr>
                                <tr v-for="n in emptyRows" class="empty-row">
                                    <td colspan="7">&nbsp;</td>
                                </tr>
                            </tbody>
                        </table>
                        <div v-if="activeTab === 'product'" class="page-box">

                            <button @click="fnPageMove(currentPage - 1)" :disabled="currentPage == 1"><</button>

                            <button v-for="n in index" :key="n" @click="fnPageMove(n)"
                                :class="{active : currentPage == n}">
                                {{n}}
                            </button>

                            <button @click="fnPageMove(currentPage + 1)" :disabled="currentPage == index">
                                >
                            </button>

                        </div>
                        <!-- 쿠폰 -->
                        <div v-if="activeTab === 'coupon'" style="margin-bottom:15px; display:flex; gap:10px;">

                            <input type="text" v-model="keyword" placeholder="쿠폰코드 / 쿠폰명 검색" class="form-control"
                                style="width:250px;">

                            <button class="btn btn-primary" @click="fnSearch()">검색</button>

                            <button class="btn btn-success" @click="fnCouponModal()">
                                쿠폰등록
                            </button>

                        </div>
                        <table v-if="activeTab === 'coupon'" class="report-table">
                            <thead>
                                <tr>
                                    <th>코드</th>
                                    <th>쿠폰명</th>
                                    <th>할인율</th>
                                    <th>발급방식</th>
                                    <th>최대수량</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="c in list" :key="c.couponCode">
                                    <td>{{ c.couponCode }}</td>
                                    <td>{{ c.couponName }}</td>
                                    <td>{{ c.discountRate }}%</td>
                                    <td>{{ c.issueType }}</td>
                                    <td>{{ c.maxIssueCnt }}</td>
                                    <td>
                                        <button class="btn btn-sm btn-danger" @click="fnCouponDelete(c.couponCode)">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- 패스 -->
                        <div v-if="activeTab === 'pass'" style="margin-bottom:15px; display:flex; gap:10px;">
                            <input type="text" v-model="keyword" placeholder="패스명 검색" class="form-control"
                                style="width:220px;">

                            <select v-model="status" class="form-control" style="width:140px;">
                                <option value="">판매상태</option>
                                <option value="1">판매중</option>
                                <option value="0">중지</option>
                            </select>

                            <button class="btn btn-primary" @click="fnSearch()">검색</button>

                            <button class="btn btn-success" @click="fnOpenPassModal()">패스등록</button>
                        </div>
                        <table v-if="activeTab === 'pass'" class="report-table">
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
                                        <span :class="p.isActive === '1' ? 'badge-on' : 'badge-off'">
                                            {{ p.isActive === '1' ? '사용중' : '중지' }}
                                        </span>
                                    </td>
                                    <td>
                                        <button v-if="p.isActive == 1" class="btn btn-sm btn-warning"
                                            @click="fnPassStatus(p.passNo,0)">
                                            중지
                                        </button>

                                        <button v-else class="btn btn-sm btn-success" @click="fnPassStatus(p.passNo,1)">
                                            재판매
                                        </button>

                                        <button class="btn btn-sm btn-danger" @click="fnDeletePass(p.passNo)">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- ========================= -->
                        <!-- 쿠폰 등록 모달 -->
                        <!-- ========================= -->
                        <div class="modal fade" id="couponModal">
                            <div class="modal-dialog">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h5 class="modal-title">쿠폰 등록</h5>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>

                                    <div class="modal-body">

                                        <input class="form-control mb-2" v-model="coupon.couponCode" placeholder="쿠폰코드">

                                        <input class="form-control mb-2" v-model="coupon.couponName" placeholder="쿠폰명">

                                        <input class="form-control mb-2" v-model="coupon.discountRate"
                                            placeholder="할인율">

                                        <select class="form-control mb-2" v-model="coupon.issueType">

                                            <option value="AUTO">AUTO</option>
                                            <option value="CODE">CODE</option>

                                        </select>

                                        <input class="form-control" v-model="coupon.maxIssueCnt" placeholder="최대 발급 수량">

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
                                            <input type="number" v-model="passForm.reviewCnt" class="form-control">
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
                                            <textarea v-model="passForm.description" placeholder="패스 설명 입력"></textarea>
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
                </div>
            </div>
            <jsp:include page="/WEB-INF/common/footer.jsp" />
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        // 변수 - (key : value)
                        activeMenu: "",
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
                    };
                },
                methods: {
                    // 함수(메소드) - (key : function())
                    fnPage: function (url) {
                        location.href = url;
                    },

                    fnChangeTab(tab) {
                        console.log(tab);
                        this.activeTab = tab;
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

                        if (self.activeTab === 'product') {
                            url = "/productAdminList.dox";
                        } else if (self.activeTab === 'coupon') {
                            url = "/couponList.dox";
                        } else if (self.activeTab === 'pass') {
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
                                status: self.status
                            },
                            success: function (res) {
                                console.log("응답:", res);
                                console.log("응답 전체 =", JSON.stringify(res));
                                console.log("list =", res.list);
                                self.list = res.list || [];
                                self.index = Math.ceil((res.totalCount || 0) / self.pageSize);
                                self.emptyRows = 5 - data.list.length;
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
                                console.log(res);

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
                            discountRate: 1,
                            issueType: "AUTO",
                            maxIssueCnt: 1
                        };

                        $("#couponModal").modal("show");
                    },


                    // 쿠폰 저장
                    fnCouponSave() {

                        let self = this;

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
                    this.activeMenu =
                        path.includes('adminProduct') ? 'product' : '';
                    console.log("mounted 실행");
                    self.fnGetList();
                }
            });

            app.mount('#app');
        </script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>
    </body>

    </html>