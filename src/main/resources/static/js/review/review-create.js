// =====================================================
//  review-create.js  |  리뷰 작성 페이지 전용 스크립트
// =====================================================

// 병원 정보 가져와서 제목 바꾸기
document.addEventListener("DOMContentLoaded", async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const storeId = urlParams.get('storeId');
    if(!storeId) {
        alert("병원 정보가 없습니다.");
        history.back();
        return;
    }

    try {
        const res = await fetch(`/api/review/store/info?storeId=${storeId}`);
        if (res.ok) {
            const store = await res.json();
            const hospitalNameElement = document.getElementById("hospitalName"); // JSP에 이 ID가 있어야 함!
            if (hospitalNameElement) {
                hospitalNameElement.innerText = store.storeName || "병원 정보";
            }
            document.title = `${store.storeName} - 리뷰 작성`;
        }
    } catch (e) {
        console.error("병원 정보를 불러오지 못했습니다.", e);
    }
});

document.addEventListener("DOMContentLoaded", () => {
    const container    = document.getElementById('review-star-rating-container');
    const fill         = document.getElementById('review-star-rating-fill');
    const ratingValue  = document.getElementById('rating-value');
    const ratingDisplay = document.getElementById('rating-display');
    const textarea     = document.getElementById('reviewContent');
    const charCount    = document.getElementById('charCount');

    // 페이지 진입 시 로그인 상태 확인
    (async () => {
        const res = await fetch('/mypage/info');
        const data = await res.json();
        if (!data.success) {
            alert("로그인이 필요합니다.");
            location.href = "/login";
        }
    })();

    // ==================== 글자 수 카운터 ====================
    // maxlength 200자로 통일 및 제어
    if (textarea) {
        textarea.addEventListener('input', (e) => {
            let content = e.target.value;

            // 만약 200자를 넘어가면 강제로 잘라버리기 (안전장치)
            if (content.length > 200) {
                e.target.value = content.substring(0, 200);
                content = e.target.value;
            }

            // 카운터 업데이트
            charCount.innerText = content.length;
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
    // [에러 원인 수정] 함수 스코프 내에서 URL의 storeId를 직접 파싱하도록 추가
    const urlParams = new URLSearchParams(window.location.search);
    const storeId = urlParams.get('storeId');

    if (!storeId) {
        alert("병원 정보가 없습니다.");
        return;
    }

    const content  = document.getElementById('reviewContent').value.trim();
    const rating   = parseFloat(document.getElementById('rating-value').value);

    if (!rating || rating === 0) return alert('별점을 선택해 주세요!');
    if (content.length < 1)      return alert('리뷰 내용을 작성해 주세요!');

    const reviewData = {
        storeId: parseInt(storeId, 10), // 서버 안전성을 위해 정수로 변환하여 전송
        reviewContent: content,
        rating,
    };

    try {
        const res  = await fetch('/api/review/insert', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify(reviewData),
        });

        if (res.status === 401) {
            alert('로그인이 필요합니다.');
            location.href = '/login';
            return;
        }

        const data = await res.json();
        if (data.success) {
            alert('리뷰 등록이 완료되었습니다!');
            location.href = `/api/hospital/detail?storeId=${storeId}`;
        } else {
            alert(data.message || '등록에 실패했습니다.');
        }
    } catch (err) {
        console.error('insertReview error:', err);
        alert('서버 오류가 발생했습니다.');
    }
};

/* ──────────────────────────────────
   리뷰 수정
────────────────────────────────── */
const updateReview = async (reviewId) => {
    const content  = document.getElementById('editReviewContent').value.trim();
    const rating   = parseFloat(document.getElementById('editRatingValue').value);

    if (!rating || rating === 0) return alert('별점을 선택해 주세요!');
    if (content.length < 1)      return alert('리뷰 내용을 작성해 주세요!');

    try {
        const res = await fetch('/api/review/update', {
            method:  'PUT',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({ reviewId, reviewContent: content, rating }),
        });

        if (res.status === 401) { alert('로그인이 필요합니다.'); location.href = '/login'; return; }
        if (res.status === 403) { alert('수정 권한이 없습니다.'); return; }
        if (res.status === 404) { alert('존재하지 않는 리뷰입니다.'); return; }

        const data = await res.json();
        if (data.success) {
            alert('리뷰가 수정되었습니다.');
            location.reload();
        } else {
            alert(data.message || '수정에 실패했습니다.');
        }
    } catch (err) {
        console.error('updateReview error:', err);
        alert('서버 오류가 발생했습니다.');
    }
};

/* ──────────────────────────────────
   리뷰 삭제
────────────────────────────────── */
const deleteReview = async (reviewId) => {
    if (!confirm('리뷰를 삭제하시겠습니까?')) return;

    try {
        const res = await fetch(`/api/review/delete?reviewId=${reviewId}`, {
            method: 'DELETE',
        });

        if (res.status === 401) { alert('로그인이 필요합니다.'); location.href = '/login'; return; }
        if (res.status === 403) { alert('삭제 권한이 없습니다.'); return; }
        if (res.status === 404) { alert('이미 삭제된 리뷰입니다.'); return; }

        const data = await res.json();
        if (data.success) {
            alert('리뷰가 삭제되었습니다.');
            location.reload();
        } else {
            alert(data.message || '삭제에 실패했습니다.');
        }
    } catch (err) {
        console.error('deleteReview error:', err);
        alert('서버 오류가 발생했습니다.');
    }
};