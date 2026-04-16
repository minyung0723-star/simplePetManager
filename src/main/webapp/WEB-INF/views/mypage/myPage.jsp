<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - SimplePetManager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage-design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-design.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="mypage-container">
    <h1 class="mypage-title">마이페이지</h1>

    <div class="mypage-grid">

        <div class="profile-card">
            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${not empty user.imageUrl}">
                        <img src="${pageContext.request.contextPath}${user.imageUrl}" alt="프로필 사진">
                    </c:when>
                    <c:otherwise>
                        <span>${fn:substring(user.userName, 0, 1)}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="profile-name">${user.userName}</div>
            <div class="profile-email">${user.userEmail}</div>
            <div class="profile-review-count">리뷰 ${fn:length(myReviews)}개</div>
        </div>

        <div class="review-card">
            <div class="review-card-title">작성한 리뷰</div>

            <c:choose>
                <c:when test="${empty myReviews}">
                    <div class="review-empty">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#ddd" stroke-width="1.5">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                        <p>아직 작성한 리뷰가 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="review-list-scroll">
                        <c:forEach var="review" items="${myReviews}">
                            <div class="review-item"
                                 data-shop="${review.shop_name}"
                                 data-rating="${review.review_rating}"
                                 data-date="${fn:substring(String.valueOf(review.created_date), 0, 10)}"
                                 data-content="${review.review_content}"
                                 onclick="openReviewDetail(this)">
                                <div class="review-item-header">
                                    <div class="review-place">
                                    <span class="review-badge
                                        <c:choose>
                                            <c:when test='${fn:containsIgnoreCase(review.review_category, "호텔")}'>hotel</c:when>
                                            <c:when test='${fn:containsIgnoreCase(review.review_category, "약국")}'>pharmacy</c:when>
                                            <c:otherwise>hospital</c:otherwise>
                                        </c:choose>
                                    ">${review.review_category}</span>
                                        <span class="review-shop-name">${review.shop_name}</span>
                                    </div>
                                    <span class="review-stars" data-star="${review.review_rating}"></span>
                                </div>
                                <div class="review-content" id="review-text-${review.review_id}">
                                    <c:choose>
                                        <%-- 글자 수가 30자보다 크면 30자까지 자르고 ... 추가 --%>
                                        <c:when test="${fn:length(review.review_content) > 30}">
                                            ${fn:substring(review.review_content, 0, 30)}...
                                        </c:when>
                                        <%-- 30자 이하일 때는 원문 그대로 출력 --%>
                                        <c:otherwise>
                                            ${review.review_content}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="review-footer">
                                    <div class="review-date">${fn:substring(String.valueOf(review.created_date), 0, 10)}</div>
                                    <button type="button" class="btn-review-delete"
                                            onclick="event.stopPropagation(); deleteMyReview(${review.review_id})">삭제
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="bottom-actions">
        <a href="${pageContext.request.contextPath}/mypage/myPageEdit" class="btn-edit">회원정보 수정</a>
        <button class="btn-withdraw" id="btn-withdraw-open">회원탈퇴</button>
    </div>
</div>

<%-- 리뷰 상세 모달 --%>
<div class="review-detail-overlay" id="review-detail-modal">
    <div class="review-detail-box">
        <button class="rdm-close" id="btn-rdm-close">&#x2715;</button>
        <div class="rdm-header">
            <span class="rdm-shop"  id="rdm-shop"></span>
            <span class="rdm-stars" id="rdm-stars"></span>
        </div>
        <div class="rdm-date" id="rdm-date"></div>
        <hr class="rdm-divider">
        <div class="rdm-content" id="rdm-content"></div>
    </div>
</div>

<div class="mypage-modal-overlay" id="withdraw-modal">
    <div class="mypage-modal-box">
        <div class="modal-title">정말 탈퇴하시겠어요?</div>
        <div class="modal-desc">탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.</div>
        <div class="form-group">
            <label for="modal-withdraw-pw">비밀번호 확인</label>
            <input type="password" id="modal-withdraw-pw" placeholder="비밀번호 입력">
        </div>
        <div class="modal-actions">
            <button class="btn-cancel" id="btn-modal-cancel">취소</button>
            <button class="btn-danger" id="btn-modal-confirm">탈퇴하기</button>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/review/review-common.js"></script>
<script src="${pageContext.request.contextPath}/js/mypage.js"></script>
</body>
</html>