<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company-css/reservationTemplate.css">

    <template id="reservation-section-template">
        <div>
            <div class="productlist-productReg">
                <div class="section-header">
                    <h2><i class="fas fa-calendar-alt mr-2"></i>예약 관리 : <span class="res-count-highlight">새 예약 {{ resCount }}건</span></h2>
                </div>
            </div>

            <div v-if="!selectedRes">
                <div class="ticket-card" v-for="(res, idx) in pagedResList" :key="idx" @click="selectedRes = res">
                    <img class="ticket-img"
                        :src="registeredProductList?.find(p => p.productName === res.productName)?.imgUrl"
                        :alt="res.productName"
                        v-if="registeredProductList?.find(p => p.productName === res.productName)?.imgUrl">
                    <div class="ticket-info">
                        <div class="ticket-no">No. {{ reservationList.length - ((resCurrentPage - 1) * 5 + idx ) }}
                        </div>
                        <div class="ticket-name">{{ res.productName }}</div>
                        <div class="ticket-date">예약 날짜/시간 : {{ res.useDate }} {{ res.useTime }}</div>
                        <div class="ticket-status-wrap">
                            <span class="ticket-status"
                                :class="res.resStatus === 'WAIT' ? 'wait' : res.resStatus === 'CANCEL' ? 'cancel' : 'done'">
                                {{ res.resStatus === 'WAIT' ? '결제 대기' : res.resStatus === 'CANCEL' ? '취소된 예약' : '완료된 예약' }}
                            </span>

                        </div>
                    </div>
                    <div class="ticket-detail-label">DETAIL</div>
                </div>

                <div class="pagination1">
                    <a @click="fnPrevPage" href="javascript:;" :class="{ 'disabled-arrow': resCurrentPage === 1 }">◀</a>

                    <span v-for="num in visibleResPageNumbers" :key="num">
                        <a @click="resCurrentPage = num" href="javascript:;"
                            :class="{ 'active-page-node': resCurrentPage === num }">
                            {{ num }}
                        </a>
                    </span>

                    <a @click="fnNextPage" href="javascript:;"
                        :class="{ 'disabled-arrow': resCurrentPage === totalResPageCount || totalResPageCount === 0 }">▶</a>
                </div>
            </div>

            <div v-else>
                <button class="res-btn-back " @click="selectedRes = null">← 목록으로</button>
                <div class="reservation-detail">
                    <table>
                        <tr>
                            <th>예약 상품</th>
                            <td>{{ selectedRes.productName }}</td>
                        </tr>
                        <tr>
                            <th>예약 내용</th>
                            <td>{{ selectedRes.resContent === '' ? '요청사항 없음' : selectedRes.resContent }}</td>
                        </tr>
                        <tr>
                            <th>예약저장</th>
                            <td>{{ selectedRes.resDate ? selectedRes.resDate.substring(0, 10) : '' }} {{ selectedRes.resTime
                                ? selectedRes.resTime.substring(0, 5) : '' }}</td>
                        </tr>
                        <tr>
                            <th>예약결제</th>
                            <td>{{ selectedRes.payDate === undefined ? '(미결제)' : '(결제완료) ' + selectedRes.payDate }}</td>
                        </tr>
                        <tr>
                            <th>예약 날짜/시간</th>
                            <td>{{ selectedRes.useDate }} {{ selectedRes.useTime ? selectedRes.useTime.substring(0, 5) : ''
                                }}</td>
                        </tr>
                        <tr>
                            <th>예약자명</th>
                            <td>{{ selectedRes.resUserId }}</td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td>{{ selectedRes.tel }}</td>
                        </tr>
                        <tr>
                            <th>예약금</th>
                            <td class="price-highlight">{{ Number(selectedRes.deposit).toLocaleString() }}원</td>
                        </tr>
                        <tr>
                            <th>예약 처리상태</th>
                            <td :class="selectedRes.resStatus === 'WAIT' ? 'status-wait' : 
                                        selectedRes.resStatus === 'CANCEL' ? 'status-cancel' : 'status-done'">
                                {{ selectedRes.resStatus === 'WAIT' ? '결제 대기' : 
                                selectedRes.resStatus === 'CANCEL' ? '취소된 예약' : '완료된 예약' }}
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </template>

    <script src="${pageContext.request.contextPath}/js/company-components/reservation-section-component.js"></script>