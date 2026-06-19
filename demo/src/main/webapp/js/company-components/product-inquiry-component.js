// 1️⃣ 상품 문의 작성 컴포넌트 객체
const productInquiryWriteComponent = {
    template: '#product-inquiry-write-template',
    props: ['product', 'sessionId'],
    data() {
        return {
            title: '',
            contents: ''
        };
    },
    methods: {
        submitInquiry() {
            if (!this.title.trim()) return alert("문의 제목을 입력해주세요!");
            if (!this.contents.trim()) return alert("문의 내용을 입력해주세요!");
            
            // 부모에게 입력값 보따리를 전달합니다.
            this.$emit('submit', { title: this.title, contents: this.contents });
        }
    }
};

// 2️⃣ 나의 문의 리스트 컴포넌트 객체
const myInquiryListComponent = {
    template: '#my-inquiry-list-template',
    props: ['inquiryList']
};

// 3️⃣ 문의 상세 보기 컴포넌트 객체
const inquiryDetailComponent = {
    template: '#inquiry-detail-template',
    props: ['inquiry']
};