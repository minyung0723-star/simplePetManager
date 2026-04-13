<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-design.css">
<div class="container mt-4">
    <div class="review-create-wrapper">
        <div class="hospital-header d-flex justify-content-center align-items-center position-relative mb-4 pb-3 border-bottom">
            <h2 class="fw-bold mb-0">${hospitalName}병원</h2>
            <a href="reviewPage" class="text-secondary position-absolute end-0 top-0 fs-2" style="line-height: 1; text-decoration: none;">✕</a>
        </div>

        <form id="reviewForm" enctype="multipart/form-data"> <div class="text-center py-4">
            <div id="review-star-rating-container" class="review-star-rating-container">
                <div class="review-star-rating-empty">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                </div>
                <div id="review-star-rating-fill" class="review-star-rating-fill">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                </div>
            </div>
            <input type="hidden" name="rating" id="rating-value" value="0">
            <div id="rating-display" class="fw-bold mt-2">0.0 점</div>
        </div>

            <div class="py-2">
        <textarea name="reviewContent" id="reviewContent" class="form-control review-textarea"
                  placeholder="진료가 좋았어요!" rows="10" maxlength="200"></textarea>
                <div class="text-muted text-end small mt-1">
                    <span id="charCount">0</span>/200
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <button type="button" onclick="submitReview()" class="btn btn-primary review-btn-submit shadow-sm fw-bold">
                    작성완료
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/review/review-common.js"></script>
<script src="${pageContext.request.contextPath}/js/review/review-create.js"></script>
<script src="${pageContext.request.contextPath}/js/design.js"></script>
<%@include file="../common/footer.jsp"%>