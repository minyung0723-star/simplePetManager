<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-design.css">
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

<script src="${pageContext.request.contextPath}/js/review/review-common.js"></script>
<script src="${pageContext.request.contextPath}/js/review/review-list.js"></script>
<%@include file="../common/footer.jsp"%>