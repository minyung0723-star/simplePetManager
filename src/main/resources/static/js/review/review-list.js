// =====================================================
//  review-list.js  |  리뷰 목록 페이지 전용 스크립트
// =====================================================

/**
 * 현재 URL에서 storeId 파라미터 추출
 * storeId 없으면 기본값 1 사용
 */
const getStoreIdFromUrl = () => {
    const params = new URLSearchParams(window.location.search);
    return params.get('storeId') || 1;
};


// ==================== 리뷰 목록 로드 ====================

const loadReviews = async (storeId) => {
    try {
        // 1. 병원 정보 가져오기 (리뷰 유무 상관없이 항상 실행)
        const storeResponse = await fetch(`/api/review/store/info?storeId=${storeId}`);
        let currentStoreName = "병원 정보";

        if (storeResponse.ok) {
            const store = await storeResponse.json();
            currentStoreName = store.storeName || store.title || "가게 정보";

            const hospitalNameElement = document.getElementById("hospitalName");
            if (hospitalNameElement) {
                hospitalNameElement.innerText = currentStoreName;
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

            // TODO_1 ___________________________________________
            // 삭제 버튼 표시 조건이 하드코딩 (userNumber === 1) 으로 되어 있음
            // 로그인한 유저의 userNumber를 서버에서 받아와서 비교해야 함
            // 해결 방법 두 가지 중 선택:
            //
            // [방법 A] 리뷰 목록 API 응답에 "내 userNumber" 필드 추가
            //   → getReviewList() 결과에 로그인 유저 번호를 함께 내려주도록
            //     ReviewApiController 수정 필요
            //
            // [방법 B] 페이지 로드 시 /mypage/info 로 내 정보를 먼저 fetch
            //   → 아래처럼 loadReviews() 호출 전에 내 userNumber를 변수에 저장 후 비교
            //   const myInfoRes = await fetch('/mypage/info');
            //   const myInfo = await myInfoRes.json();
            //   const myUserNumber = myInfo.success ? myInfo.userNumber : null;
            //   그 후 review.userNumber === myUserNumber 로 조건 변경

            // 리뷰 목록 렌더링
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
                                        <button class="btn btn-sm btn-outline-danger ms-2"
                                                onclick="deleteReview(${review.reviewId})">삭제</button>
                                    ` : ''}
                                    <!-- TODO_1 참고: review.userNumber === 1 → review.userNumber === myUserNumber 로 교체 -->
                                </div>
                                <span class="review-meta text-muted small">
                                    ${review.createdDate?.split('T')[0] || '날짜 없음'}
                                </span>
                            </div>
                            <div class="review-star-rating mb-2">
                                ${generateStars(review.rating)}
                            </div>
                            <p class="review-content mb-0">
                                ${review.reviewContent || '내용이 없는 리뷰입니다.'}
                            </p>
                        </div>
                    </div>
                </article>
            `).join('');

        } else {
            // 리뷰 0개
            container.innerHTML = `<div class="text-center py-5 text-muted">첫 번째 리뷰를 남겨주세요!</div>`;
            document.getElementById("average-score-text").innerText = "0.0";
            document.getElementById("average-stars-container").innerHTML = generateStars(0);
        }

    } catch (e) {
        console.error("데이터 로드 중 에러 발생:", e);
        const container = document.getElementById("review-container");
        if (container) container.innerHTML = "리뷰를 불러오는 중 오류가 발생했습니다.";
    }
};


// ==================== 초기 실행 ====================

document.addEventListener("DOMContentLoaded", () => {
    const currentStoreId = getStoreIdFromUrl();
    loadReviews(currentStoreId);
    checkBookmarkStatus(currentStoreId);
});


// ==================== 리뷰 삭제 ====================

window.deleteReview = async (reviewId) => {
    if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) return;

    try {
        const response = await fetch(`/api/review/delete?reviewId=${reviewId}`, { method: 'POST' });

        // TODO_2 ___________________________________________
        // 서버에서 "unauthorized" 또는 "forbidden" 응답 시 처리 로직 추가 필요
        // JWT 연동 완료 후 컨트롤러가 해당 값을 내려주면 아래처럼 처리:
        // const result = await response.text();
        // if (result === "unauthorized") {
        //     alert("로그인이 필요합니다.");
        //     location.href = "/login";
        //     return;
        // }
        // if (result === "forbidden") {
        //     alert("본인의 리뷰만 삭제할 수 있습니다.");
        //     return;
        // }

        if (response.ok) {
            alert("삭제되었습니다.");
            loadReviews(getStoreIdFromUrl());
        }
    } catch (e) {
        console.error(e);
    }
};


// ==================== 로그인 체크 후 리뷰 작성 이동 ====================

window.checkUserLogin = () => {

    // TODO_3 ___________________________________________
    // const isLogined = true 하드코딩 제거 필요
    // /mypage/info API를 fetch 해서 로그인 여부 판단하는 방식으로 교체:
    //
    // window.checkUserLogin = async () => {
    //     try {
    //         const res = await fetch('/mypage/info');
    //         const data = await res.json();
    //
    //         if (!data.success) {
    //             if (confirm("로그인이 필요한 서비스입니다.")) {
    //                 location.href = "/login";
    //             }
    //         } else {
    //             // TODO_4 _______________________________________
    //             // 경로를 /review/create 와 /review/createreviewPage 중 하나로 통일 필요
    //             // ReviewController.java 의 매핑과 반드시 일치해야 함 (ReviewController TODO_5 참고)
    //             location.href = `/review/createreviewPage?storeId=${getStoreIdFromUrl()}`;
    //         }
    //     } catch (e) {
    //         console.error("로그인 상태 확인 실패:", e);
    //     }
    // };

    const isLogined = true; // ← TODO_3 완료 후 이 줄과 아래 블록 전체 삭제

    if (!isLogined) {
        if (confirm("로그인이 필요한 서비스입니다.")) location.href = "/login";
    } else {
        location.href = `/review/createreviewPage?storeId=${getStoreIdFromUrl()}`;
    }
};


// ==================== 북마크 상태 초기 확인 ====================

const checkBookmarkStatus = async (storeId) => {
    try {
        const response = await fetch(`/api/review/bookmark/check?storeId=${storeId}`);
        const isBookmarked = await response.json();

        const btn = document.getElementById("bookmarkBtn");
        const icon = btn.querySelector("i");

        if (isBookmarked) {
            btn.classList.add("inserted");
            icon.classList.remove("bi-bookmark");
            icon.classList.add("bi-bookmark-fill");
        } else {
            btn.classList.remove("inserted");
            icon.classList.remove("bi-bookmark-fill");
            icon.classList.add("bi-bookmark");
        }

        // TODO_5 ___________________________________________
        // 비로그인 상태에서 /api/review/bookmark/check 가 "unauthorized" 를 반환할 경우
        // JSON 파싱 에러 발생 가능
        // isBookmarked 값이 boolean 이 아닐 때를 대비한 방어 로직 추가 권장:
        // const isBookmarked = typeof result === 'boolean' ? result : false;

    } catch (e) {
        console.error("북마크 상태 확인 실패:", e);
    }
};


// ==================== 북마크 토글 ====================

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

            // TODO_6 ___________________________________________
            // 서버에서 "unauthorized" 응답 시 처리 로직 추가 필요
            // JWT 연동 완료 후 아래 조건 추가:
            // if (result === "unauthorized") {
            //     alert("로그인이 필요합니다.");
            //     location.href = "/login";
            //     return;
            // }

            if (result === "inserted") {
                btn.classList.add("inserted");
                icon.classList.remove("bi-bookmark");
                icon.classList.add("bi-bookmark-fill");
            } else if (result === "deleted") {
                btn.classList.remove("inserted");
                icon.classList.remove("bi-bookmark-fill");
                icon.classList.add("bi-bookmark");
            }
        } else {
            alert("북마크 처리 중 오류가 발생했습니다.");
        }
    } catch (error) {
        console.error("북마크 통신 에러:", error);
    }
};