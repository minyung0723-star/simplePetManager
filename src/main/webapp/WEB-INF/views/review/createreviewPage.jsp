<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<div class="container mt-4">
    <div class="review-create-wrapper">
        <div class="hospital-header d-flex justify-content-center align-items-center position-relative mb-4 pb-3 border-bottom">
            <h2 class="fw-bold mb-0">${hospitalName}병원</h2>
            <a href="reviewPage" class="text-secondary position-absolute end-0 top-0 fs-2" style="line-height: 1; text-decoration: none;">✕</a>
        </div>

        <form id="reviewForm" enctype="multipart/form-data"> <div class="text-center py-4">
            <div id="review-star-rating-container" class="review-star-rating-container">
                <div class="review-star-rating-empty">★★★★★</div>
                <div id="review-star-rating-fill" class="review-star-rating-fill">★★★★★</div>
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
                <button type="button" onclick="submitReview()" class="btn btn-primary review-btn-submit shadow-sm fw-bold">
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
    const container = document.getElementById('review-star-rating-container');
    const fill = document.getElementById('review-star-rating-fill');
    const ratingValue = document.getElementById('rating-value');
    const ratingDisplay = document.getElementById('rating-display');

    // 마우스 움직임에 따라 실시간으로 별 채우기
    container.addEventListener('mousemove', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const width = rect.width;

        // 0.5단위 계산
        let score = (x / width) * 5;
        score = Math.ceil(score * 2) / 2;

        if (score < 0.5) score = 0.5;
        if (score > 5) score = 5;

        // ★ 실시간으로 별 색깔 채우기
        renderStars(score);
        // 마우스 움직일 때 숫자도 미리 보여주면
        ratingDisplay.innerText = `\${score.toFixed(1)} 점`;
    });

    // 클릭 시 값 확정
    container.addEventListener('click', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const width = rect.width;

        let score = (x / width) * 5;
        score = Math.ceil(score * 2) / 2;

        if (score < 0.5) score = 0.5;
        if (score > 5) score = 5;

        ratingValue.value = score; // hidden input에 저장
        ratingDisplay.innerText = `\${score.toFixed(1)} 점`;
        renderStars(score); // 별 너비 고정!
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
        // 1. 값 가져오기
        const content = document.getElementById('reviewContent').value;
        const rating = document.getElementById('rating-value').value;

        // URL에서 storeId 가져오기 (이거 없으면 DB 저장 안 됨!)
        const urlParams = new URLSearchParams(window.location.search);
        const storeId = urlParams.get('storeId') || 1;

        // 2. 유효성 검사
        if (rating == 0 || rating == "0.0") {
            alert("별점을 선택해 주세요! ");
            return;
        }
        if (content.trim().length < 1) {
            alert("리뷰 내용을 작성해 주세요!");
            document.getElementById('reviewContent').focus();
            return;
        }

        // 3. 서버에 보낼 '진짜 데이터' 만들기 (DTO 필드명과 똑같이!)
        const reviewData = {
            storeId: parseInt(storeId),
            reviewContent: content,
            rating: parseFloat(rating),
            userNumber: 1 // [임시] 나중에 세션에서 가져올 값!
        };

        try {
            const response = await fetch('/api/review/insert', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(reviewData)
            });

            const result = await response.text();

            if (result === "success") {
                alert("리뷰 등록이 완료되었습니다! ");
                // 주소 앞에 / 붙여서 상세페이지로 튕겨주기!
                location.href = `/api/hospital/detail?storeId=\${storeId}`;
            } else {
                alert("등록 중 오류가 발생했습니다. (서버 응답: " + result + ")");
            }
        } catch (error) {
            console.error('Error:', error);
            alert("서버 통신 오류가 발생했습니다. ");
        }
    };

</script>
<script src="${pageContext.request.contextPath}/js/design.js"></script>
<%@include file="../common/footer.jsp"%>