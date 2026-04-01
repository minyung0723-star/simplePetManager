<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<div class="container mt-4">
    <div class="review-create-wrapper">
        <div class="hospital-header d-flex justify-content-center align-items-center position-relative mb-4 pb-3 border-bottom">
            <h2 class="fw-bold mb-0">${hospitalName}병원</h2>
            <a href="reviewPage" class="text-secondary position-absolute end-0 top-0 fs-2" style="line-height: 1; text-decoration: none;">✕</a>
        </div>

        <form id="reviewForm" enctype="multipart/form-data"> <div class="text-center py-4">
            <div id="star-rating-container" class="star-rating-container">
                <div class="star-rating-empty">★★★★★</div>
                <div id="star-rating-fill" class="star-rating-fill">★★★★★</div>
            </div>
            <input type="hidden" name="rating" id="rating-value" value="0">
            <div id="rating-display" class="fw-bold mt-2">0.0 점</div>
        </div>

            <div class="py-2">
        <textarea name="reviewContent" id="reviewContent" class="form-control review-textarea"
                  placeholder="진료가 좋았어요!" rows="10" maxlength="199"></textarea>
                <div class="text-muted text-end small mt-1">
                    <span id="charCount">0</span>/200
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <button type="button" onclick="submitReview()" class="btn btn-primary btn-submit shadow-sm fw-bold">
                    작성완료
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        loadReviews();

        // 글자 수 세기 기능 추가
        const textarea = document.getElementById('reviewContent');
        const charCount = document.getElementById('charCount');
        textarea.addEventListener('input', () => {
            charCount.innerText = textarea.value.length;
        });
    });

    const loadReviews = async () => {
        const storeId = 1; // 나중에 실제 storeId를 동적으로 받게 수정하세요!

        try {
            const response = await fetch(`/review/list?storeId=${storeId}`);
            const data = await response.json();

            const container = document.getElementById("review-container");
            const countElement = document.querySelector(".review-total-count"); // 개수 표시할 곳

            if (!container) return;

            // 1. 리뷰 개수 업데이트 (HTML에 .review-total-count 요소가 있어야 함)
            if (countElement) {
                countElement.innerText = `리뷰(${data.length})`;
            }

            // 2. 초기화
            container.innerHTML = "";

            // 3. 리뷰가 하나도 없을 때 (Empty State)
            if (data.length === 0) {
                container.innerHTML = `
                <div class="text-center py-5">
                    <i class="bi bi-chat-left-dots text-muted" style="font-size: 3rem;"></i>
                    <p class="mt-3 text-muted">아직 작성된 리뷰가 없네요.<br>첫 번째 리뷰의 주인공이 되어보세요! ✨</p>
                </div>`;
                return;
            }

            // 4. 리뷰가 있을 때 (목록 생성)
            let html = "";
            data.forEach(review => {
                // 어제 우리가 만든 별점 생성 함수 호출!
                const stars = generateStars(review.rating);

                html += `
                <article class="review-card mb-3 p-3 border-bottom">
                    <div class="d-flex align-items-start">
                        <img src="${review.profileImage || '/resources/images/default-profile.png'}"
                             class="review-profile-img me-3" alt="프로필">

                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <strong class="user-name">${review.nickname || '익명 테스터'}</strong>
                                <span class="review-meta text-muted small">${review.createdDate}</span>
                            </div>

                            <div class="star-rating mb-2">
                                ${stars}
                            </div>

                            <p class="review-content mb-0">
                                ${review.reviewContent || '내용이 없는 리뷰입니다.'}
                            </p>
                        </div>
                    </div>
                </article>
            `;
            });
            container.innerHTML = html;

        } catch (error) {
            console.error("리뷰 로딩 에러:", error);
            const container = document.getElementById("review-container");
            if(container) {
                container.innerHTML = "<p class='text-center py-5 text-danger'>리뷰를 불러오는 중 오류가 발생했습니다.</p>";
            }
        }
    };


    // 별점 마우스 이동 로직
    const container = document.getElementById('star-rating-container');
    const fill = document.getElementById('star-rating-fill');
    const ratingValue = document.getElementById('rating-value');
    const ratingDisplay = document.getElementById('rating-display');

    // 마우스 움직임에 따라 실시간으로 별 채우기
    container.addEventListener('mousemove', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left; // 마우스의 X 좌표
        const width = rect.width;        // 전체 별 영역 너비

        // 0.5단위 계산
        let score = (x / width) * 5;
        score = Math.ceil(score * 2) / 2; // 0.5 단위로 올림

        if (score < 0.5) score = 0.5;
        if (score > 5) score = 5;

        renderStars(score);
    });

    // 클릭 시 값 확정
    container.addEventListener('click', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const score = Math.ceil(((x / rect.width) * 5) * 2) / 2;

        ratingValue.value = score;
        ratingDisplay.innerText = score.toFixed(1) + " 점";
    });

    // 마우스를 떼면 마지막으로 클릭(확정)한 값으로 복구
    container.addEventListener('mouseleave', () => {
        const fixedValue = parseFloat(ratingValue.value) || 0;
        renderStars(fixedValue);
    });

    // 핵심 함수: 숫자에 따라 CSS 너비를 조절함
    function renderStars(score) {
        const percentage = (score / 5) * 100;
        fill.style.width = percentage + "%";
    }

    // 별점 및 리뷰내용을 작성 시 작성완료 버튼 활성화
    const submitReview = async () => {
        const content = document.getElementById('reviewContent').value;
        const rating = document.getElementById('rating-value').value;

        if (rating == 0 || rating == "0.0") {
            alert("별점을 선택해 주세요! ");
            return;
        }

        if (content.trim().length < 1) {
            alert("리뷰 내용을 작성해 주세요! ✍");
            document.getElementById('reviewContent').focus();
            return;
        }

        const form = document.getElementById('reviewForm');
        const formData = new FormData(form);

        try {
            const response = await fetch('insertReview', {
                method: 'POST',
                body: formData
            });

            const data = await response.text();

            if (data === "success") {
                alert("리뷰가 성공적으로 완료되었습니다. ");
                location.href = "reviewPage";
            } else {
                alert("등록 중 오류가 발생했습니다.");
            }
        } catch (error) {
            console.error('Error:', error);
            alert("서버 통신 오류가 발생했습니다.");
        }
    };

</script>
<script src="${pageContext.request.contextPath}/js/design.js"></script>
<%@include file="../common/footer.jsp"%>