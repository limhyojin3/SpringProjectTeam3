// 1️⃣ 결제 및 예약 저장 대기 확인서 컴포넌트 객체
const productReservationPaymentComponent = {
    template: '#product-reservation-payment-template',
    props: ['product', 'selectedDate', 'selectedTime', 'userid', 'resContent']
};

// 2️⃣ 나의 예약 리스트 컴포넌트 객체
const myReservationListComponent = {
    template: '#my-reservation-list-template',
    props: ['reservationList']
};

// 3️⃣ 단건 예약 상세 내역 및 포트원 결제 연동 컴포넌트 객체
const reservationDetailComponent = {
    template: '#reservation-detail-template',
    props: ['reservation', 'buttonName']
};