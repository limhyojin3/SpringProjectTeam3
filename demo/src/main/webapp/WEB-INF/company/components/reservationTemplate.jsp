<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <template id="reservation-section-template">
        <div>
            <div class="section-header">
                <h2>예약 관리 : <span style="color:#9b8fd4;">새 예약 {{ resCount }}건</span></h2>
            </div>

            <div v-if="!selectedRes">
                <div class="ticket-card" v-for="(res, idx) in pagedResList" :key="idx" @click="selectedRes = res">
                    <img class="ticket-img"
                        :src="registeredProductList.find(p => p.productName === res.productName)?.imgUrl"
                        :alt="res.productName"
                        v-if="registeredProductList.find(p => p.productName === res.productName)?.imgUrl">
                    <div class="ticket-info">
                        <div class="ticket-no">No. {{ reservationList.length - ((resCurrentPage - 1) * 5 + idx ) }}
                        </div>
                        <div class="ticket-name">{{ res.productName }}</div>
                        <div class="ticket-date">예약 날짜/시간 : {{ res.useDate }} {{ res.useTime }}</div>
                        <div style="margin-top:6px;">
                            <span class="ticket-status"
                                :class="res.resStatus === 'WAIT' ? 'wait' : res.resStatus === 'CANCEL' ? 'cancel' : 'done'">
                                {{ getResStatusText(res.resStatus)}}
                            </span>
                        </div>
                    </div>
                    <div class="ticket-detail-label">DETAIL</div>
                </div>

                <div class="pagination1">
                    <span v-for="num in totalResPageCount" :key="num">
                        <a @click="resCurrentPage = num" href="javascript:;"
                            :style="resCurrentPage === num ? 'color: #9b8fd4; border:1px solid #9b8fd4 ;' : ''">
                            {{ num }}
                        </a>
                    </span>
                </div>
            </div>

            <div v-else>
                <button class="btn-back" @click="selectedRes = null">← 목록으로</button>
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
                        <td>{{ selectedRes.resDate }} {{ selectedRes.resTime }}</td>
                    </tr>
                    <tr>
                        <th>예약결제</th>
                        <td>{{ selectedRes.payDate === undefined ? '(미결제)' : '(결제완료)' + selectedRes.payDate }}</td>
                    </tr>
                    <tr>
                        <th>예약 날짜/시간</th>
                        <td>{{ selectedRes.useDate }} {{ selectedRes.useTime }}</td>
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
                        <td>{{ Number(selectedRes.deposit).toLocaleString() }}원</td>
                    </tr>
                    <tr>
                        <th>예약 처리상태</th>
                        <td
                            :style="selectedRes.resStatus === 'WAIT' ? 'color:#3714ff;' : selectedRes.resStatus === 'CANCEL' ? 'color:red;' : ''">
                            {{ selectedRes.resStatus }}</td>
                    </tr>
                </table>
            </div>
        </div>
    </template>