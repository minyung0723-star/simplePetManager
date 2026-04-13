// =====================================================
//  review-common.js  |  리뷰 공통 유틸 (목록 + 작성 페이지 모두 사용)
// =====================================================

/**
 * 공통 별점 HTML 생성 (읽기 전용)
 * @param {number} rating  0~5 사이 숫자 (소수점 허용)
 * @returns {string}       별점 HTML 문자열
 */
const generateStars = (rating) => {
    const numRating = parseFloat(rating) || 0;
    const percentage = (numRating / 5) * 100;
    const stars = '<i class="bi bi-star-fill"></i>'.repeat(5);

    // TODO_1 ___________________________________________
    // 버그 수정 완료:
    // 기존 코드: `<div class="review-star-rating-empty"${stars}</div>`
    //            → > 빠져서 stars 변수가 속성으로 인식됨 (UI 완전 깨짐)
    // 수정 코드: `<div class="review-star-rating-empty">${stars}</div>`
    //            → 닫는 꺾쇠(>) 추가

    return `
        <div class="review-star-rating-container readonly">
            <div class="review-star-rating-empty">${stars}</div>
            <div class="review-star-rating-fill" style="width: ${percentage}%">
                ${stars}
            </div>
        </div>
    `;
};