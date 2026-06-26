/**
 * ABC Dress Shop - 파트너 페이지 공통 유틸리티 메서드
 */
const PartnerUtils = {
    // 1. 이미지 태그 제거 정규식
    removeImages(content) {
        if (!content) return "";
        const regex = /<img[^>]*>/gi;
        return content.replace(regex, "");
    },

    // 2. 모든 HTML 태그 제거 및 순수 텍스트 추출
    stripHtml(html) {
        if (!html) return "";
        let doc = new DOMParser().parseFromString(html, 'text/html');
        return doc.body.textContent || "";
    },

    // 3. 이미지와 HTML 태그를 모두 지운 최종 텍스트 반환
    cleanText(content) {
        const noImage = this.removeImages(content);
        return this.stripHtml(noImage);
    },

    // 4. 별점 문자열 변환 유틸
    starRating(rev) {
        if (!rev || !rev.rating) return '★☆☆☆☆';
        const ratingStr = rev.rating + "";
        
        if (ratingStr.slice(0, 1) == 5) return '★★★★★';
        if (ratingStr.slice(0, 1) == 4) return '★★★★☆';
        if (ratingStr.slice(0, 1) == 3) return '★★★☆☆';
        if (ratingStr.slice(0, 1) == 2) return '★★☆☆☆';
        return '★☆☆☆☆';
    },

    // 5. 예약 상태 텍스트 변환 유틸
    getResStatusText(status) {
        switch (status) {
            case 'CONFIRM': return '✅ 예약이 확정되었습니다.';
            case 'CANCEL': return '❌ 취소된 예약입니다.';
            case 'DONE': return '만료된 예약입니다.';
            case 'WAIT': return '결제 대기 상태입니다.';
            default: return status;
        }
    }
};