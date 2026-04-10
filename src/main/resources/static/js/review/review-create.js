document.addEventListener("DOMContentLoaded", () => {
    const container = document.getElementById('review-star-rating-container');
    const fill = document.getElementById('review-star-rating-fill');
    const ratingValue = document.getElementById('rating-value');
    const ratingDisplay = document.getElementById('rating-display');
    const textarea = document.getElementById('reviewContent');
    const charCount = document.getElementById('charCount');

    // 1. 글자 수 세기
    if (textarea) {
        textarea.addEventListener('input', (e) => {
            charCount.innerText = e.target.value.length;
        });
    }

    const renderStars = (score) => {
        const percentage = (score / 5) * 100;
        fill.style.width = `${percentage}%`;
    };

    // 2. 별점 이벤트 (mousemove, click, mouseleave)
    if (container) {
        container.addEventListener('mousemove', (e) => {
            const rect = container.getBoundingClientRect();
            let score = Math.ceil(((e.clientX - rect.left) / rect.width) * 10) / 2;
            score = Math.min(Math.max(score, 0.5), 5);
            renderStars(score);
            ratingDisplay.innerText = `${score.toFixed(1)} 점`;
        });

        container.addEventListener('click', (e) => {
            const rect = container.getBoundingClientRect();
            let score = Math.ceil(((e.clientX - rect.left) / rect.width) * 10) / 2;
            score = Math.min(Math.max(score, 0.5), 5);
            ratingValue.value = score;
            ratingDisplay.innerText = `${score.toFixed(1)} 점`;
        });

        container.addEventListener('mouseleave', () => {
            const fixedValue = parseFloat(ratingValue.value) || 0;
            renderStars(fixedValue);
            ratingDisplay.innerText = `${fixedValue.toFixed(1)} 점`;
        });
    }
});

// 3. 리뷰 등록 (submitReview)
const submitReview = async () => {
    const content = document.getElementById('reviewContent').value;
    const rating = document.getElementById('rating-value').value;
    const urlParams = new URLSearchParams(window.location.search);
    const storeId = urlParams.get('storeId') || 1;

    if (rating == 0 || rating == "0.0") return alert("별점을 선택해 주세요!");
    if (content.trim().length < 1) return alert("리뷰 내용을 작성해 주세요!");

    const reviewData = {
        storeId: parseInt(storeId),
        reviewContent: content,
        rating: parseFloat(rating),
        userNumber: 1 // [임시]
    };

    try {
        const response = await fetch('/api/review/insert', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(reviewData)
        });
        if (await response.text() === "success") {
            alert("리뷰 등록이 완료되었습니다!");
            location.href = `/api/hospital/detail?storeId=${storeId}`;
        }
    } catch (error) {
        console.error('Error:', error);
    }
};