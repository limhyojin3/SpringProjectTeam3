// 💡 독립된 객체로 컴포넌트를 정의합니다.
const productListComponent = {
    template: '#product-list-template',
    props: ['productList', 'productTag'], 
    data() {
        return {
            selectCategory: [],
            selectTags: []
        };
    },
    computed: {
        filteredList() {
            return this.productList.filter(product => {
                const matchCategory = this.selectCategory.length === 0 || (
                    product.category && Array.isArray(product.category) &&
                    this.selectCategory.some(cat => product.category.includes(cat))
                );
                const matchTag = this.selectTags.length === 0 || (
                    product.tag && Array.isArray(product.tag) &&
                    this.selectTags.some(tag => product.tag.includes(tag))
                );
                return matchCategory && matchTag;
            });
        }
    }
};