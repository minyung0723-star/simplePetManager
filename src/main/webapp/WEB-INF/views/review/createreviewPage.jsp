<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<div class="container mt-4">
    <div class="review-create-wrapper">
        <div class="hospital-header d-flex justify-content-center align-items-center position-relative mb-4 pb-3 border-bottom">
            <h2 class="fw-bold mb-0">${hospitalName}병원</h2>
            <a href="reviewPage" class="text-secondary position-absolute end-0 top-0 fs-2" style="line-height: 1; text-decoration: none;">✕</a>
        </div>

        <form action="insertReview.do" method="post" enctype="multipart/form-data">
            <div class="text-center py-4">
                <div class="star-rating-input fs-1">
                    <input type="radio" name="rating" value="5" id="5-stars"><label for="5-stars">★</label>
                    <input type="radio" name="rating" value="4" id="4-stars"><label for="4-stars">★</label>
                    <input type="radio" name="rating" value="3" id="3-stars"><label for="3-stars">★</label>
                    <input type="radio" name="rating" value="2" id="2-stars"><label for="2-stars">★</label>
                    <input type="radio" name="rating" value="1" id="1-stars"><label for="1-stars">★</label>
                </div>
            </div>

            <div class="py-2">
            <textarea name="content" id="reviewContent" class="form-control review-textarea"
                      placeholder="진료가 좋았어요!" rows="10" maxlength="199"></textarea>
                <div class="text-muted text-end small mt-1">
                    <span id="charCount">0</span>/200
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <button type="submit" class="btn btn-primary btn-submit shadow-sm fw-bold">
                    작성완료
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/design.js"></script>
<%@include file="../common/footer.jsp"%>