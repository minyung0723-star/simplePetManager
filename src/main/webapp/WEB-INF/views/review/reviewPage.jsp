<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<div class="container mt-4">
    <div class="review-wrapper px-4">
        <section class="hospital-header d-flex justify-content-between align-items-start mb-4">
            <div>
                <h2 class="fw-bold mb-1" id="hospitalName">불러오는 중...</h2>

                <div class="d-flex align-items-center gap-2 mt-2">
                    <span id="average-score-text" class="fs-4 fw-bold">0.0</span>

                    <div id="average-stars-container" class="review-star-rating">
                    </div>
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="button" id="bookmarkBtn" onclick="toggleBookmark()" class="btn btn-outline-secondary review-btn-circle review-bookmark-btn">
                    <i class="bi bi-bookmark-fill"></i>
                </button>
            </div>
        </section>

        <div class="action-bar d-flex justify-content-end pb-3">
            <button type="button" onclick="checkUserLogin()" class="btn btn-outline-primary review-btn-write-review shadow-sm">
                <i class="bi bi-chat-dots me-1"></i> 리뷰 작성
            </button>
        </div>

        <div class="review-list" id="review-container">
            <div class="text-center py-5 text-muted">리뷰를 불러오는 중입니다...</div>
        </div>
    </div>
</div>
<script>
    // [임시 변수] 나중에 실제 로그인 세션이나 정보가 들어오면 이 부분을 수정
    // 지금은 false로 두면 "로그인 필요"가 뜨고, true로 바꾸면 "작성 페이지"로 이동
    const isLogined = true;

    const checkUserLogin = () => {

        if (!isLogined) {
            // 1. 로그인 안 된 경우: 알림 띄우고 로그인 페이지로!
            alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다! ");
            location.href = "/user/login"; // 나중에 만드실 로그인 페이지 주소를 여기에 적기
        } else {
            // 2. 로그인 된 경우: 작성 페이지로 이동!
            location.href = "/review/create";
        }
    };
    //===============  즐겨찾기버튼  ===============//
    const checkBookmarkStatus = async (storeId) => {
        const btn = document.getElementById('bookmarkBtn');
        if (!btn) return;

        try {
            const response = await fetch(`/api/review/bookmark/check?storeId=\${storeId}`);
            if (response.ok) {
                const isBookmarked = await response.json();
                if (isBookmarked) {
                    btn.classList.add('active');
                }else {
                    btn.classList.remove('active'); // 아니면 불 끄기!
                }
            }
        } catch (error) {
            console.error("북마크 상태 확인 실패:", error);
        }
    };

    const toggleBookmark = async () => {
        // 1. 로그인 체크 먼저!
        if (!isLogined) {
            alert("로그인 후 즐겨찾기를 이용하실 수 있습니다");
            location.href = "/user/login";
            return;
        }

        const btn = document.getElementById('bookmarkBtn');
        const urlParams = new URLSearchParams(window.location.search);
        const storeId = urlParams.get('storeId') || 1;

        try {
            const response = await fetch('/api/review/bookmark/toggle', { // 주소 슬래시(/) 주의!
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
        for (let i = 1; i <= 5; i++) {
            // 꽉 찬 별: 현재 루프(i)가 점수보다 작거나 같을 때
            if (i <= Math.floor(rating)) {
                starsHtml += `<i class="bi bi-star-fill review-star-filled"></i>`;
            }
            // 반 별: 현재 루프(i)가 올림한 점수와 같고, 소수점이 있을 때
            else if (i === Math.ceil(rating) && rating % 1 !== 0) {
                starsHtml += `<i class="bi bi-star-half review-star-filled"></i>`;
            }
            // 빈 별
            else {
                starsHtml += `<i class="bi bi-star review-star-empty"></i>`;
            }
        }
        return starsHtml;
    };

    // 2. 리뷰 목록 로드 함수 (핵심!)
    const loadReviews = async (storeId) => {

        try {
            const response = await fetch(`/api/review/list?storeId=\${storeId}`);
            const data = await response.json();

            const container = document.getElementById("review-container");
            const countElement = document.querySelector(".review-total-count");

            if (!container) return;

            // ====================[추가] 가게 리뷰 평균 별점==================
            if (data.length > 0) {
                const avgRating = data[0].averageRating;
                const reviewCount = data[0].reviewCount;

                // JSP에 이 ID들이 있어야 해! (없으면 에러 나니까 꼭 확인!)
                const avgScoreElement = document.getElementById("average-score-text"); // 숫자 표시 (예: 4.5)
                const avgStarsElement = document.getElementById("average-stars-container"); // 별 모양 표시

                if (avgScoreElement) {
                    avgScoreElement.innerText = avgRating.toFixed(1);
                }
                if (avgStarsElement) {
                    avgStarsElement.innerHTML = generateStars(avgRating);
                }
            } else {
                // 리뷰가 아예 없을 때 디폴트 처리
                const avgScoreElement = document.getElementById("average-score-text");
                const avgStarsElement = document.getElementById("average-stars-container");
                if (avgScoreElement) avgScoreElement.innerText = "0.0";
                if (avgStarsElement) avgStarsElement.innerHTML = generateStars(0);
            }

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
                        <span class="text-primary" style="cursor:pointer;" onclick="location.href='/review/create'">
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
                // 좀 더 안전한 버전
                const rawDate = review.createdDate;
                const formattedDate = (typeof rawDate === 'string') ? rawDate.split('T')[0] : '날짜 정보 없음';
                const currentLoginUserNumber = 1; // =====================================[임시] 지니 번호가 1번이라면!  임시삭제 아이디   =====================
                const isMyReview = (review.userNumber === currentLoginUserNumber); // [권한 체크] 내 리뷰거나, 혹은 나중에 관리자(ADMIN)일 때 버튼이 보이게!
                const deleteBtnHtml = isMyReview ? `
                <button class="btn btn-sm btn-outline-danger ms-2"
                        onclick="deleteReview(\${review.reviewId})">
                    삭제
                </button>` : '';
                // JSP 내에서 JS 변수를 쓸 때는 \${} 형태를 권장
                html += `
                <article class="review-card border-bottom p-3 mb-3">
                    <div class="d-flex align-items-start">
                    <div class="flex-shrink-0 me-3">
                        <img src="\${review.profileImage || '/resources/images/default-profile.png'}"
                             class="review-profile-img" alt="프로필">
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <div>
                                <strong class="user-name">\${review.nickname || '익명'}</strong>
                                \${deleteBtnHtml} </div>
                            <span class="review-meta text-muted small">\${formattedDate}</span>
                        </div>
                        <div class="review-star-rating mb-2">
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
            container.innerHTML = html

        } catch (error) {
            console.error("리뷰 로딩 에러:", error);
        }
    };

    // 3. 페이지가 로드되면 자동으로 실행
    document.addEventListener("DOMContentLoaded", async () => {
        const urlParams = new URLSearchParams(window.location.search);
        let storeId = urlParams.get('storeId') || 1;

        try {
            const response = await fetch(`/api/review/store/info?storeId=\${storeId}`);

            if (response.ok) {
                // 응답 텍스트를 먼저 확인하거나 에러 방지 처리
                const text = await response.text();
                if (!text || text.trim() === "") {
                    document.getElementById("hospitalName").innerText = "정보 없음 (존재하지 않는 가게)";
                    return; // 여기서 멈춤!
                }

                const store = JSON.parse(text); // 텍스트가 있을 때만 JSON으로 변신!

                const nameElement = document.getElementById("hospitalName");
                if (nameElement) {
                    // store가 아예 비어있거나 이름이 없을 때 처리
                    if (!store || !store.storeName) {
                        nameElement.innerText = "정보 없음";
                    } else {
                        nameElement.innerText = store.storeName;
                    }
                }

                loadReviews(storeId);
                checkBookmarkStatus(storeId);
            } else {
                console.error("서버 응답 에러:", response.status);
                document.getElementById("hospitalName").innerText = "서버 연결 오류";
            }
        } catch (error) {
            console.error("네트워크 통신 에러:", error);
            // 에러가 나더라도 사용자에게 알려주기!
            document.getElementById("hospitalName").innerText = "정보를 불러올 수 없습니다.";
        }
    });

    // 4.============================================ 임시 삭제버튼 ======================================================
    const deleteReview = async (reviewId) => {
        // 1. 진짜 지울 건지 물어보기 (실수 방지!)
        if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) {
            return;
        }

        try {
            // 2. 서버에 삭제 요청 (POST 또는 DELETE)
            // 지니야, 우리 컨트롤러 주소 규칙에 맞춰서 /api/review/delete 로 가보자!
            const response = await fetch(`/api/review/delete?reviewId=\${reviewId}`, {
                method: 'POST'
            });

            const result = await response.text();

            if (result === "success") {
                alert("게시물이 삭제되었습니다!");
                // 3. 화면 새로고침 없이 목록만 다시 불러오기 (지니 기술력 UP!)
                const urlParams = new URLSearchParams(window.location.search);
                const storeId = urlParams.get('storeId');
                loadReviews(storeId);
            } else {
                alert("삭제에 실패했습니다. 다시 시도해 주세요.");
            }
        } catch (error) {
            console.error("삭제 에러:", error);
            alert("서버와 통신 중 오류가 발생했습니다.");
        }
    };
</script>
<%@include file="../common/footer.jsp"%>