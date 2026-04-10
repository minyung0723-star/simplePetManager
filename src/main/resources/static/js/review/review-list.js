
const getStoreIdFromUrl = () => {
    const params = new URLSearchParams(window.location.search);
    // 주소창에 storeId가 없으면 기본값으로 1을 사용해!
    return params.get('storeId') || 1;
};
// 1. 함수 정의
const loadReviews = async (storeId) => {
    try {
        // 1. 가게 정보 가져오기 (리뷰 유무 상관없이 실행)
        const storeResponse = await fetch(`/api/review/store/info?storeId=${storeId}`);
        let currentStoreName = "병원 정보"; // 기본값 설정

        if (storeResponse.ok) {
            const store = await storeResponse.json();
            // 🛡️ 방어막 적용: 필드명이 storeName이든 title이든 찾아내기
            currentStoreName = store.storeName || store.title || "가게 정보";

            const hospitalNameElement = document.getElementById("hospitalName");
            if (hospitalNameElement) {
                hospitalNameElement.innerText = currentStoreName; // 이름 먼저 박기
            }
            document.title = `${currentStoreName} - 리뷰 목록`;
        }

        // 2. 리뷰 목록 가져오기
        const response = await fetch(`/api/review/list?storeId=${storeId}`);
        const data = await response.json();
        const container = document.getElementById("review-container");

        if (!container) return;

        if (data && data.length > 0) {
            // 평균 별점 및 총 개수 업데이트
            const avgRating = data[0].averageRating || 0;
            document.getElementById("average-score-text").innerText = avgRating.toFixed(1);
            document.getElementById("average-stars-container").innerHTML = generateStars(avgRating);

            const totalCountElement = document.querySelector(".review-total-count");
            if (totalCountElement) {
                totalCountElement.innerText = `리뷰(${data.length})`;
            }

            // 리뷰 목록 그리기
            container.innerHTML = data.map(review => `
                <article class="review-card border-bottom p-3 mb-3">
                    <div class="d-flex align-items-start">
                        <div class="flex-shrink-0 me-3">
                            <img src="${review.profileImage || '/images/user.png'}"
                                 onerror="this.onerror=null; this.src='/images/user.png';"
                                 class="review-profile-img" alt="프로필">
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <div>
                                    <strong>${review.nickname || '익명'}</strong>
                                    ${review.userNumber === 1 ? `
                                        <button class="btn btn-sm btn-outline-danger ms-2" onclick="deleteReview(${review.reviewId})">삭제</button>
                                    ` : ''}
                                </div>
                                <span class="review-meta text-muted small">${review.createdDate?.split('T')[0] || '날짜 없음'}</span>
                            </div>
                            <div class="review-star-rating mb-2">
                                ${generateStars(review.rating)}
                            </div>
                            <p class="review-content mb-0">${review.reviewContent || '내용이 없는 리뷰입니다.'}</p>
                        </div>
                    </div>
                </article>
            `).join('');

        } else {
            // ✅ 2. 데이터가 없을 때 (리뷰 0개)
            container.innerHTML = `<div class="text-center py-5 text-muted">첫 번째 리뷰를 남겨주세요!</div>`;

            // 별점은 0으로 초기화하되, 위에서 가져온 이름(currentStoreName)은 건드리지 않음!
            document.getElementById("average-score-text").innerText = "0.0";
            document.getElementById("average-stars-container").innerHTML = generateStars(0);
        }
    } catch (e) {
        console.error("데이터 로드 중 에러 발생:", e);
        const container = document.getElementById("review-container");
        if(container) container.innerHTML = "리뷰를 불러오는 중 오류가 발생했습니다.";
    }

};

// 2. 실행 루틴
document.addEventListener("DOMContentLoaded", () => {
    const currentStoreId = getStoreIdFromUrl(); // 현재 ID를 딱 한 번만 변수에 담아서

    loadReviews(currentStoreId);        // 리뷰 로드할 때 쓰고
    checkBookmarkStatus(currentStoreId); // 북마크 확인할 때도 쓰고!
});

// 삭제 함수 정의
window.deleteReview = async (reviewId) => {
    if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) return;

    try {
        const response = await fetch(`/api/review/delete?reviewId=${reviewId}`, { method: 'POST' });
        if (response.ok) {
            alert("삭제되었습니다.");
            loadReviews(getStoreIdFromUrl()); // 여기서도 공통 함수 사용!
        }
    } catch (e) { console.error(e); }
};

// 2. 로그인 체크 기능 (수정됨!)
window.checkUserLogin = () => {

    const isLogined = true;

    if (!isLogined) {
        if (confirm("로그인이 필요한 서비스입니다.")) location.href = "/login";
    } else {
        //  여기서 storeId를 붙여서 보내야 1번 병원으로 안 튀어!
        location.href = `/review/createreviewPage?storeId=${getStoreIdFromUrl()}`;
    }
};

//==================== 초기 로딩 북마크 ===========================//
const checkBookmarkStatus = async (storeId) => {
    try {
        const response = await fetch(`/api/review/bookmark/check?storeId=${storeId}`);
        const isBookmarked = await response.json();

        const btn = document.getElementById("bookmarkBtn");
        const icon = btn.querySelector("i");

        if (isBookmarked) {
            // ✅ 이미 등록된 상태라면 색 반전 효과!
            btn.classList.add("inserted");
            icon.classList.remove("bi-bookmark");
            icon.classList.add("bi-bookmark-fill");
        } else {
            // ✅ 아니라면 기본 상태!
            btn.classList.remove("inserted");
            icon.classList.remove("bi-bookmark-fill");
            icon.classList.add("bi-bookmark");
        }
    } catch (e) {
        console.error("북마크 상태 확인 실패:", e);
    }
};

//=================== 북마크 토글 기능====================//
window.toggleBookmark = async () => {
    const btn = document.getElementById("bookmarkBtn");
    const icon = btn.querySelector("i");
    const storeId = getStoreIdFromUrl();

    try {
        const response = await fetch('/api/review/bookmark/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ storeId: storeId })
        });

        if (response.ok) {
            const result = await response.text();

            if (result === "inserted") {
                // ✅ 등록됨 (Inserted) 상태로 확정!
                btn.classList.add("inserted"); // 버튼에 보라색 배경!
                icon.classList.remove("bi-bookmark"); // 비어있는 아이콘 제거
                icon.classList.add("bi-bookmark-fill"); // 채워진 아이콘 추가
            } else if (result === "deleted") {
                // ✅ 기본 (Deleted) 상태로 확정!
                btn.classList.remove("inserted"); // 버튼 배경 투명!
                icon.classList.remove("bi-bookmark-fill"); // 채워진 아이콘 제거
                icon.classList.add("bi-bookmark"); // 비어있는 아이콘 추가
            }
        } else {
            alert("북마크 처리 중 오류가 발생했습니다.");
        }
    } catch (error) {
        console.error("북마크 통신 에러:", error);
    }
};

