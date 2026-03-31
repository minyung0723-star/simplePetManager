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
</head>
<body>

<%@ include file="../common/header.jsp" %>

<div class="mypage-container">
    <h1 class="mypage-title">마이페이지</h1>

    <div class="mypage-grid">

        <!-- 프로필 카드 (왼쪽) -->
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
        </div>

        <!-- 작성한 리뷰 (오른쪽) -->
        <div class="review-card">
            <div class="review-card-title">작성한 리뷰</div>

            <c:choose>
                <c:when test="${empty myReviews}">
                    <div class="review-empty">작성한 리뷰가 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="review" items="${myReviews}">
                        <div class="review-item">
                            <div class="review-item-header">
                                <div class="review-place">
                                    <span class="review-badge
                                        <c:if test='${fn:containsIgnoreCase(review.review_category, "호텔")}'>hotel</c:if>
                                        <c:if test='${fn:containsIgnoreCase(review.review_category, "약국")}'>pharmacy</c:if>
                                    ">${review.review_category}</span>
                                    <span class="review-shop-name">${review.shop_name}</span>
                                </div>
                                <span class="review-stars">
                                    <c:forEach begin="1" end="${review.review_rating}">★</c:forEach>
                                    <c:forEach begin="${review.review_rating + 1}" end="5">☆</c:forEach>
                                </span>
                            </div>
                            <div class="review-content">${review.review_content}</div>
                            <div class="review-date">${fn:substring(review.created_date, 0, 10)}</div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

    <!-- 하단 버튼 -->
    <div class="bottom-actions">
        <a href="${pageContext.request.contextPath}/mypage/myPageEdit" class="btn-edit">회원정보 수정</a>
        <button class="btn-withdraw" id="btn-withdraw-open">회원탈퇴</button>
    </div>
</div>

<!-- 탈퇴 확인 모달 -->
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

<%-- 탈퇴 모달 이벤트만 담당하는 mypage.js --%>
<script src="${pageContext.request.contextPath}/js/mypage.js"></script>

</body>
</html>
