<%-- =====================================================
     reviewPage.jsp  |  병원 상세 + 리뷰 목록 페이지
     ===================================================== --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-design.css">

<div class="container mt-4">
    <div class="review-wrapper px-4">

        <%-- 병원명 + 평균 별점 + 북마크 버튼 --%>
        <section class="hospital-header d-flex justify-content-between align-items-start mb-4">
            <div>
                <%-- JS(review-list.js)에서 loadReviews() 실행 시 innerText로 채워짐 --%>
                <h2 class="fw-bold mb-1" id="hospitalName">불러오는 중...</h2>

                <div class="d-flex align-items-center gap-2 mt-2">
                    <span id="average-score-text" class="fs-4 fw-bold">0.0</span>
                    <div id="average-stars-container" class="review-star-rating"></div>
                </div>
            </div>

            <div class="d-flex gap-2">
                <%--
                TODO_1 ___________________________________________
                북마크 버튼: 비로그인 상태에서 클릭 시 로그인 유도 처리 필요
                현재는 toggleBookmark() 호출 시 서버에서 "unauthorized" 를 반환하면
                JS 에서 별도 처리 없이 alert("북마크 처리 중 오류") 로 떨어짐
                review-list.js 의 toggleBookmark 함수 TODO_6 참고
                --%>
                <button type="button" id="bookmarkBtn"
                        onclick="toggleBookmark()"
                        class="btn btn-outline-secondary review-btn-circle review-bookmark-btn">
                    <i class="bi-bookmark-fill"></i>
                </button>
            </div>
        </section>

        <%-- 리뷰 작성 버튼 --%>
        <div class="action-bar d-flex justify-content-end pb-3">
            <%--
            TODO_2 ___________________________________________
            리뷰 개수 표시 영역 추가 권장
            review-list.js 에서 .review-total-count 클래스를 찾아서 개수를 업데이트하고 있음
            현재 해당 클래스를 가진 요소가 없어서 카운트가 표시되지 않음:--%>
            <span class="review-total-count text-muted me-3">리뷰(0)</span>

            <button type="button" onclick="checkUserLogin()"
                    class="btn btn-outline-primary review-btn-write-review shadow-sm">
                <i class="bi bi-chat-dots me-1"></i> 리뷰 작성
            </button>
        </div>

        <%-- 리뷰 목록 (JS로 동적 렌더링) --%>
        <div class="review-list" id="review-container">
            <div class="text-center py-5 text-muted">리뷰를 불러오는 중입니다...</div>
        </div>

        <%-- !!!!!!!!!!!!!!!!!!!!!!
        TODO_3 ___________________________________________
        페이지네이션 추가 고려 (리뷰 수가 많아질 경우)
        현재는 전체 리뷰를 한 번에 로드하는 방식
        향후 /api/review/list?storeId=1&page=0&size=10 형태로
        백엔드 페이지네이션 API 추가 후 무한스크롤 또는 더보기 버튼 구현 권장
        --%>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/review/review-common.js"></script>
<script src="${pageContext.request.contextPath}/js/review/review-list.js"></script>
<%@include file="../common/footer.jsp"%>
