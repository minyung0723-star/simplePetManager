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
                <button type="button" class="btn btn-outline-secondary btn-circle bookmark-btn">
                    <i class="bi bi-bookmark-fill"></i>
                </button>
            </div>
        </section>

        <div class="action-bar d-flex justify-content-end pb-3">
            <a href="createreviewPage" class="btn btn-outline-primary btn-write-review shadow-sm">
                <i class="bi bi-chat-dots me-1"></i> 리뷰 작성
            </a>
        </div>

        <div class="review-list">
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

            <%-- 리뷰가 없을 경우 처리 --%>
            <c:if test="${empty reviewList}">
                <div class="text-center py-5 text-muted border-top">
                    등록된 리뷰가 없습니다. 첫 리뷰를 작성해 보세요!
                </div>
            </c:if>
        </div>
    </div>
</div>
<%@include file="../common/footer.jsp"%>