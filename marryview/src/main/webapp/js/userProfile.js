const app = Vue.createApp({
    data() {
        return {
            activeTab: 'review',
            reviewList: [],
            postList: [],
            commentList: [],
            reviewPage: 1,
            postPage: 1,
            commentPage: 1,
            reviewTotal: 0,
            postTotal: 0,
            commentTotal: 0,
            targetUserId: document.getElementById('targetUserId').value,
            pageSize: 5
        };
    },
    computed: {
        reviewTotalPages() { return Math.ceil(this.reviewTotal / this.pageSize); },
        postTotalPages() { return Math.ceil(this.postTotal / this.pageSize); },
        commentTotalPages() { return Math.ceil(this.commentTotal / this.pageSize); }
    },
    mounted() {
        this.loadData();
    },
    methods: {
        loadData() {
            const url = new URLSearchParams(window.location.search);
            axios.get('/userProfileData.dox', {
                params: {
                    userId: this.targetUserId,
                    reviewPage: this.reviewPage,
                    postPage: this.postPage,
                    commentPage: this.commentPage
                }
            }).then(res => {
                this.reviewList = res.data.reviewList;
                this.postList = res.data.postList;
                this.commentList = res.data.commentList;
                this.reviewTotal = res.data.reviewTotal;
                this.postTotal = res.data.postTotal;
                this.commentTotal = res.data.commentTotal;
            });
        },
        goPage(type, page) {
            if (type === 'review') this.reviewPage = page;
            else if (type === 'post') this.postPage = page;
            else if (type === 'comment') this.commentPage = page;
            this.loadData();
        }
    }
}).mount('#app');