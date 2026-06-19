const productListComponent = {
    template: '#product-list-template',
    // 💡 부모가 던져주는 데이터만 순수하게 받습니다. (결합도 낮음)
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