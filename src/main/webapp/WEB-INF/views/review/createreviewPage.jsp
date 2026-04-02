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
    document.addEventListener("DOMContentLoaded",()=> {

        // 글자 수 세기 기능 추가
        const textarea = document.getElementById('reviewContent');
        const charCount = document.getElementById('charCount');
        if (textarea) {
            textarea.addEventListener('input',(event)=>{
                    charCount.innerText= `\${event.target.value.length}`;
            })
        }
    });

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
        ratingDisplay.innerText = `\${score.toFixed(1)} 점`;
    });

    // 마우스를 떼면 마지막으로 클릭(확정)한 값으로 복구
    container.addEventListener('mouseleave', () => {
        const fixedValue = parseFloat(ratingValue.value) || 0;
        renderStars(fixedValue);
    });

    // 핵심 함수: 숫자에 따라 CSS 너비를 조절함
    const renderStars=(score)=> {
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