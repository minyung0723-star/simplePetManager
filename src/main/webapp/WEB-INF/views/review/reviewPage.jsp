<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<div class="container mt-4">
    <div class="review-wrapper">
        <section class="hospital-header d-flex justify-content-between align-items-start mb-4">
            <div>
                <h2 class="fw-bold mb-1">${hospitalName}병원</h2>
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
            <%-- JSTL로 만든 화면 javaScript(fetch)로 교체
            <c:forEach var="review" items="${reviewList}">
                <article class="review-card">
                    <div class="d-flex">
                        <div class="flex-shrink-0 me-3">
                            <img src="${review.profileImg}" class="review-profile-img" alt="유저 프로필">
                        </div>

                        <div class="flex-grow-1">
                            <div class="mb-1 d-flex align-items-center">
                                <span class="fw-bold me-2">${review.nickname}</span>
                                <span class="review-meta">@${review.userId}</span>
                            </div>

                            <div class="mb-2">
                            <span class="star-rating">
                                <c:forEach begin="1" end="${review.rating}">★</c:forEach><c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                            </span>
                                <span class="review-meta ms-2">${review.regDate}</span>
                            </div>

                            <p class="review-content">
                                    ${review.content}
                            </p>

                            <div class="d-flex align-items-center">
                                <button type="button" class="btn-like-sm">
                                    <span class="me-1">👍</span> ${review.likeCount != null ? review.likeCount : 0}
                                </button>
                                <button type="button" class="btn btn-link ms-auto text-muted p-0 text-decoration-none">
                                    <i class="bi bi-three-dots-vertical"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </article>
            </c:forEach>
            --%>
            <%--
            <c:if test="${empty reviewList}">
                <div class="text-center py-5 text-muted border-top">
                    등록된 리뷰가 없습니다. 첫 리뷰를 작성해 보세요!
                </div>
            </c:if>
            --%>
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

    const toggleBookmark = async () => {
        const btn = document.getElementById('bookmarkBtn');
        const icon = btn.querySelector('i');

        // [임시 데이터] 나중에 실제 병원 ID로 바뀔 부분입니다.
        const hospitalId = 1;

        // 1. UI 먼저 반응하기 (사용자 경험을 위해!)
        const isActive = btn.classList.toggle('active');

        if (isActive) {
            btn.style.backgroundColor = '#6750A4'; // 즐겨찾기 활성화 (노란색)
            btn.style.color = 'white';
        } else {
            btn.style.backgroundColor = 'transparent'; // 해제
            btn.style.color = '#6c757d';
        }

    };

    // 1 별점 나오게 하기!
    const generateStars = (rating) => {
        let starsHtml = '';
        // 0.5단위를 처리하기 위해 반올림이나 로직을 추가합니다.

        for (let i = 1; i <= 5; i++) {
            if (i <= rating) {
                // 꽉 찬 별
                starsHtml += '<i class="bi bi-star-fill star-filled"></i>';
            } else if (i - 0.5 <= rating) {
                // 반 별
                starsHtml += '<i class="bi bi-star-half star-filled"></i>';
            } else {
                // 빈 별
                starsHtml += '<i class="bi bi-star"></i>';
            }
        }
        return starsHtml;
    };

    // 2. 리뷰 목록 로드 함수 (핵심!)
    const loadReviews = async () => {
        const container = document.getElementById("review-container");
        const storeId = 1; // [임시] 나중에 동적으로 바꿀 부분

        try {
            // 서버의 API 컨트롤러에 데이터를 요청합니다.
            const response = await fetch(`/review/list?storeId=\${storeId}`);

            if (!response.ok) throw new Error("데이터를 가져오지 못했습니다.");

            const reviews = await response.json(); // JSON 데이터를 자바스크립트 배열로 변환

            // 컨테이너 비우기
            container.innerHTML = "";

            if (reviews.length === 0) {
                container.innerHTML = `<div class="text-center py-5 text-muted border-top">등록된 리뷰가 없습니다. 첫 리뷰를 작성해 보세요!</div>`;
                return;
            }

            // 데이터 개수만큼 반복하며 HTML 생성 (백틱 활용!)
            reviews.forEach(review => {
                // 날짜 예쁘게 만들기 (2026-03-31T16:00 -> 2026.03.31)
                const formattedDate = review.createdDate ? review.createdDate.split('T')[0] : '날짜 없음';

                const reviewHtml = `
                    <article class="review-card border-bottom p-3 mb-3">
                        <div class="d-flex">
                            <div class="flex-shrink-0 me-3">
                                <img src="\${review.profileImage || '/resources/images/default-profile.png'}"
                                     class="review-profile-img"
                                     alt="유저 프로필">
                            </div>
                            <div class="flex-grow-1">
                                <div class="mb-1 d-flex align-items-center">
                                    <span class="fw-bold me-2">\${review.nickname || '익명'}</span>
                                    </div>
                                <div class="mb-2">
                                    <span class="text-warning">\${generateStars(review.rating)}</span>
                                    <span class="ms-2 small text-muted">\${formattedDate}</span>
                                </div>
                                <p class="review-content">\${review.reviewContent || '내용이 없습니다.'}</p>
                            </div>
                        </div>
                    </article>
                    `;
                container.innerHTML += reviewHtml;
            });

        } catch (error) {
            console.error("리뷰 로드 에러:", error);
            container.innerHTML = `<div class="text-center py-5 text-danger">리뷰를 불러오는 중 오류가 발생했습니다.</div>`;
        }
    };

    // 3. 페이지가 로드되면 자동으로 실행
    document.addEventListener("DOMContentLoaded", () => {
        loadReviews();
    });
</script>
<%@include file="../common/footer.jsp"%>