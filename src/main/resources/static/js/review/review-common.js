/**
 * 공통 별점 HTML 생성 (ES6)
 */
const generateStars = (rating) => {
    const numRating = parseFloat(rating) || 0;
    const percentage = (numRating / 5) * 100;
    const stars = '<i class="bi bi-star-fill"></i>'.repeat(5);

    return `
        <div class="review-star-rating-container readonly">
            <div class="review-star-rating-empty"${stars}</div>
            <div class="review-star-rating-fill" style="width: ${percentage}%">
                ${stars}
            </div>
        </div>
    `;
};