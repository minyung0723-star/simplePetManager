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

    async function loadReviews() {
        /* [나중에 수정/제거 대상] 현재는 팀원 기능 미완성으로 storeId를 1로 고정함 */
        const storeId = 1;

        try {
            // 1. 서버에 데이터를 요청하고 응답이 올 때까지 기다립니다.
            const response = await fetch(`/review/list?storeId=${storeId}`);

            // 2. 응답받은 데이터를 JSON 형태로 파싱할 때까지 기다립니다.
            const data = await response.json();

            const container = document.getElementById("review-container");
            if (!container) return;

            container.innerHTML = "";

            // 데이터가 없을 때의 처리 (방어 코드)
            if (data.length === 0) {
                container.innerHTML = '<div class="text-center py-5 text-muted">등록된 리뷰가 없습니다.</div>';
                return;
            }

            // 3. 받아온 데이터를 화면에 그립니다.
            data.forEach(review => {
                const reviewHtml = `
            <article class="review-card mb-3 p-3 border-bottom">
                <div class="d-flex">
                    <div class="flex-grow-1">
                        <div class="mb-1 d-flex align-items-center">
                            <span class="fw-bold me-2">유저 \${review.userNumber}</span>
                        </div>
                        <div class="mb-2">
                            <span class="star-rating text-warning">
                                \${generateStars(review.rating)}
                            </span>
                            <span class="ms-2 small text-muted">\${review.rating}점</span>
                        </div>
                        <p class="review-content">
                            \${review.reviewContent}
                        </p>
                    </div>
                </div>
            </article>
            `;
                container.innerHTML += reviewHtml;
            });
        } catch (error) {
            // 네트워크 에러나 JSON 파싱 에러 등을 여기서 한꺼번에 처리합니다.
            console.error("리뷰 로딩 에러:", error);
        }
        }

    function generateStars(rating) {
        let stars = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars += '★';
            } else if (i - 0.5 <= rating) {
                stars += '½';
            } else {
                stars += '☆';
            }
        }
        return stars;
    }

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

    async function submitReview() {
        // 1. 값 가져오기 및 유효성 검사
        const content = document.getElementById('reviewContent').value;
        const rating = document.getElementById('rating-value').value;

        // 별점 체크 (0.5점 이상 조건)
        if (rating == 0 || rating == "0.0") {
            alert("별점을 선택해 주세요!");
            return;
        }

        // 내용 체크 (공백 제외 1자 이상)
        if (content.trim().length < 1) {
            alert("리뷰 내용을 작성해 주세요!");
            document.getElementById('reviewContent').focus();
            return;
        }

        // 2. 서버 전송 준비
        const form = document.getElementById('reviewForm');
        const formData = new FormData(form);

        try {
            // [수업시간 복습!] await를 써서 서버 응답이 올 때까지 기다립니다.
            const response = await fetch('insertReview', {
                method: 'POST',
                body: formData
            });

            // 텍스트 데이터를 읽어올 때까지 또 기다립니다.
            const data = await response.text();

            if (data === "success") {
                alert("리뷰가 성공적으로 완료되었습니다.");
                location.href = "reviewPage"; // 목록으로 이동
            } else {
                alert("등록 중 오류가 발생했습니다. 다시 시도해 주세요.");
            }
        } catch (error) {
            // 네트워크 장애 등 서버 통신 자체가 실패했을 때 실행됩니다.
            console.error('Error:', error);
            alert("서버 통신 오류가 발생했습니다.");
        }
    }

</script>
<script src="${pageContext.request.contextPath}/js/design.js"></script>
<%@include file="../common/footer.jsp"%>