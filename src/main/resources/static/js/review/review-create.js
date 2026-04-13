// =====================================================
//  review-create.js  |  리뷰 작성 페이지 전용 스크립트
// =====================================================

document.addEventListener("DOMContentLoaded", () => {
    const container    = document.getElementById('review-star-rating-container');
    const fill         = document.getElementById('review-star-rating-fill');
    const ratingValue  = document.getElementById('rating-value');
    const ratingDisplay = document.getElementById('rating-display');
    const textarea     = document.getElementById('reviewContent');
    const charCount    = document.getElementById('charCount');

    // TODO_1 ___________________________________________
    // 페이지 진입 시 로그인 상태 확인 로직 추가 필요
    // ReviewController에서 서버 측 체크를 하더라도
    // 클라이언트 측에서도 이중으로 확인하는 것을 권장:
    //
    // (async () => {
    //     const res = await fetch('/mypage/info');
    //     const data = await res.json();
    //     if (!data.success) {
    //         alert("로그인이 필요합니다.");
    //         location.href = "/login";
    //     }
    // })();


    // ==================== 글자 수 카운터 ====================

    // TODO_2 ___________________________________________
    // maxlength 불일치 버그 수정 필요
    // createreviewPage.jsp 에서 maxlength="199" 인데
    // 카운터 표시는 /200 으로 되어 있음
    // 199 또는 200 중 하나로 통일 필요 (JSP와 여기서 동시 수정)
    if (textarea) {
        textarea.addEventListener('input', (e) => {
            charCount.innerText = e.target.value.length;
        });
    }


    // ==================== 별점 렌더링 ====================

    const renderStars = (score) => {
        const percentage = (score / 5) * 100;
        fill.style.width = `${percentage}%`;
    };


    // ==================== 별점 이벤트 ====================

    if (container) {
        // 마우스 이동 시 별점 미리보기
        container.addEventListener('mousemove', (e) => {
            const rect = container.getBoundingClientRect();
            let score = Math.ceil(((e.clientX - rect.left) / rect.width) * 10) / 2;
            score = Math.min(Math.max(score, 0.5), 5);
            renderStars(score);
            ratingDisplay.innerText = `${score.toFixed(1)} 점`;
        });

        // 클릭 시 별점 고정
        container.addEventListener('click', (e) => {
            const rect = container.getBoundingClientRect();
            let score = Math.ceil(((e.clientX - rect.left) / rect.width) * 10) / 2;
            score = Math.min(Math.max(score, 0.5), 5);
            ratingValue.value = score;
            ratingDisplay.innerText = `${score.toFixed(1)} 점`;
        });

        // 마우스가 별점 영역을 벗어나면 클릭된 값으로 복원
        container.addEventListener('mouseleave', () => {
            const fixedValue = parseFloat(ratingValue.value) || 0;
            renderStars(fixedValue);
            ratingDisplay.innerText = `${fixedValue.toFixed(1)} 점`;
        });
    }
});


// ==================== 리뷰 등록 ====================

const submitReview = async () => {
    const content  = document.getElementById('reviewContent').value;
    const rating   = document.getElementById('rating-value').value;
    const urlParams = new URLSearchParams(window.location.search);
    const storeId  = urlParams.get('storeId') || 1;

    // 유효성 검사
    if (rating == 0 || rating == "0.0") return alert("별점을 선택해 주세요!");
    if (content.trim().length < 1)      return alert("리뷰 내용을 작성해 주세요!");

    const reviewData = {
        storeId:       parseInt(storeId),
        reviewContent: content,
        rating:        parseFloat(rating),
        // TODO_3 ___________________________________________
        // userNumber 하드코딩 제거 필요
        // 현재: userNumber: 1  ← 이 줄 삭제
        // JWT 연동 후 서버(ReviewApiController)에서
        // loginUser.getUserNumber() 로 자동 세팅하므로
        // 프론트에서 userNumber를 보낼 필요 없음
        // → reviewData 객체에서 userNumber 키 자체를 삭제
        userNumber: 1 // ← TODO_3 완료 후 이 줄 삭제
    };

    try {
        const response = await fetch('/api/review/insert', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(reviewData)
        });

        const result = await response.text();

        // TODO_4 ___________________________________________
        // 서버에서 "unauthorized" 응답 시 처리 로직 추가 필요
        // JWT 연동 완료 후 아래 조건 추가:
        // if (result === "unauthorized") {
        //     alert("로그인이 필요합니다.");
        //     location.href = "/login";
        //     return;
        // }

        if (result === "success") {
            alert("리뷰 등록이 완료되었습니다!");
            // TODO_5 ___________________________________________
            // 리뷰 등록 완료 후 이동 경로 확인 필요
            // 현재: /api/hospital/detail?storeId=... (ReviewController 매핑과 일치 확인)
            // ReviewController에 해당 경로가 @GetMapping("/api/hospital/detail") 로 있으므로 현재는 정상
            location.href = `/api/hospital/detail?storeId=${storeId}`;
        }
    } catch (error) {
        console.error('Error:', error);
    }
};