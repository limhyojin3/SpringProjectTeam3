const ProductCatalogComponent = {
    template: '#product-catalog-template',
    props: ['productList', 'productTag'],
    emits: ['go-detail', 'change-page'],
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