<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<div class="container mt-4">
    <div class="review-wrapper px-4">
        <section class="hospital-header d-flex justify-content-between align-items-start mb-4">
            <div>
                <h2 class="fw-bold mb-1" id="hospitalName">불러오는 중...</h2>
                <div class="d-flex align-items-center gap-2 mt-2">
                    <span class="fs-4 fw-bold">3.0</span>
                    <div class="star-rating">
                        <span class="star-filled">★★★</span><span class="star-empty">☆☆</span>
                    </div>
                </div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" id="bookmarkBtn" onclick="toggleBookmark()" class="btn btn-outline-secondary btn-circle bookmark-btn">
                    <i class="bi bi-bookmark-fill"></i>
                </button>
            </div>
        </section>

        <div class="action-bar d-flex justify-content-end pb-3">
            <button type="button" onclick="checkUserLogin()" class="btn btn-outline-primary btn-write-review shadow-sm">
                <i class="bi bi-chat-dots me-1"></i> 리뷰 작성
            </button>
        </div>

        <div class="review-list" id="review-container">
            <div class="text-center py-5 text-muted">리뷰를 불러오는 중입니다...</div>
        </div>
    </div>
</div>
<script>
    const checkUserLogin = () => {
        // [임시 변수] 나중에 실제 로그인 세션이나 정보가 들어오면 이 부분을 수정할 거예요!
        // 지금은 false로 두면 "로그인 필요"가 뜨고, true로 바꾸면 "작성 페이지"로 이동합니다.
        const isLogined = true;

        if (!isLogined) {
            // 1. 로그인 안 된 경우: 알림 띄우고 로그인 페이지로!
            alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다! ");
            location.href = "/user/login"; // 나중에 만드실 로그인 페이지 주소를 여기에 적으세요.
        } else {
            // 2. 로그인 된 경우: 작성 페이지로 이동!
            location.href = "createreviewPage";
        }
    };
    //===============  즐겨찾기버튼  ===============//
    const checkBookmarkStatus = async () => {
        const btn = document.getElementById('bookmarkBtn');
        const storeId = 1; // 임시 아이디

        try {
            const response = await fetch(`/review/bookmark/check?storeId=\${storeId}`);
            if (response.ok) {
                const isBookmarked = await response.json();
                if (isBookmarked) {
                    btn.classList.add('active');
                }
            }
        } catch (error) {
            console.error("북마크 상태 확인 실패:", error);
        }
    };

    const toggleBookmark = async () => {
        const btn = document.getElementById('bookmarkBtn');
        const storeId = 1;

        try {
            const response = await fetch('/review/bookmark/toggle', { // 주소 슬래시(/) 주의!
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ storeId: storeId })
            });

            if (response.ok) {
                const result = await response.text();
                // 서비스에서 반환한 "inserted", "deleted"에 따라 클래스 토글!
                if (result === "inserted") {
                    btn.classList.add('active');
                } else if (result === "deleted") {
                    btn.classList.remove('active');
                }
            }
        } catch (error) {
            console.error("북마크 통신 에러:", error);
        }
    };

    // 1 별점 나오게 하기!
    const generateStars = (rating) => {
        let starsHtml = '';
        // 0.5단위를 처리하기 위해 반올림이나 로직을 추가합니다.

        for (let i = 1; i <= 5; i++) {
            if (i <= rating) {
                // 꽉 찬 별
                starsHtml += `<i class="bi bi-star-fill star-filled"></i>`;
            } else if (i - 0.5 <= rating) {
                // 반 별
                starsHtml += `<i class="bi bi-star-half star-filled"></i>`;
            } else {
                // 빈 별
                starsHtml += `<i class="bi bi-star"></i>`;
            }
        }
        return starsHtml;
    };

    // 2. 리뷰 목록 로드 함수 (핵심!)
    const loadReviews = async (storeId) => {
        //const storeId = 1;

        try {
            const response = await fetch(`/review/list?storeId=\${storeId}`);
            const data = await response.json();

            const container = document.getElementById("review-container");
            const countElement = document.querySelector(".review-total-count");

            if (!container) return;

            // 1. 개수 표시 (예: 리뷰(5))
            if (countElement) {
                countElement.innerText = `리뷰(${data.length})`;
            }

            container.innerHTML = "";

            // 2.(데이터가 없을 때)
            if (data.length === 0) {
                container.innerHTML = `
                <div class="text-center py-5">
                    <i class="bi bi-chat-left-dots text-muted" style="font-size: 3rem;"></i>
                    <p class="mt-3 text-muted" style="font-weight: 500;">
                        등록된 리뷰가 없습니다! <br>
                        <span class="text-primary" style="cursor:pointer;" onclick="location.href='createreviewPage'">
                           첫 번째 리뷰를 작성해보세요! ✍
                        </span>
                    </p>
                </div>`;
                return;
            }

            // 3. 데이터가 있을 때 (목록 뿌리기)
            let html = "";
            data.forEach(review => {
                // 별점 아이콘 생성
                const stars = generateStars(review.rating);
                // 날짜 포맷팅 (T 이후 시간 제거)
                const formattedDate = review.createdDate?.split('T')[0]??'날짜 없음';

                // JSP 내에서 JS 변수를 쓸 때는 \${} 형태를 권장합니다.
                html += `
        <article class="review-card border-bottom p-3 mb-3">
            <div class="d-flex align-items-start">
                <div class="flex-shrink-0 me-3">
                    <img src="\${review.profileImage || '/resources/images/default-profile.png'}"
                         class="review-profile-img" alt="프로필">
                </div>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <strong class="user-name">\${review.nickname || '익명'}</strong>
                        <span class="review-meta text-muted small">\${formattedDate}</span>
                    </div>
                    <div class="star-rating mb-2">
                        \${stars}
                    </div>
                    <p class="review-content mb-0">
                        \${review.reviewContent || '내용이 없는 리뷰입니다.'}
                    </p>
                </div>
            </div>
        </article>
    `;
            });
            container.innerHTML = html;

        } catch (error) {
            console.error("리뷰 로딩 에러:", error);
        }
    };

    // 3. 페이지가 로드되면 자동으로 실행
    document.addEventListener("DOMContentLoaded", async () => {
        const urlParams = new URLSearchParams(window.location.search);
        let storeId = urlParams.get('storeId');

        if(!storeId) storeId = 1; // 기본값 방어 코드

        try {
            // 병원 정보 가져오기
            const response = await fetch(`/review/store/info?storeId=\${storeId}`);
            if (response.ok) {
                const store = await response.json();
                document.getElementById("hospitalName").innerText = store.storeName;

                // 정보를 성공적으로 가져온 뒤 목록과 북마크 실행
                loadReviews(storeId);
                checkBookmarkStatus(storeId);
            }
        } catch (error) {
            console.error("데이터 로드 중 에러:", error);
        }
    });
</script>
<%@include file="../common/footer.jsp"%>