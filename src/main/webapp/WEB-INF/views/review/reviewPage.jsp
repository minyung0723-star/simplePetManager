<%-- =====================================================
     reviewPage.jsp  |  병원 상세 + 리뷰 목록 페이지
     ===================================================== --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>

<%--
  잠깐! 지니야, 만약 header.jsp 안에 <body> 태그가 있다면
  거기에 <body class="d-flex flex-column min-vh-100"> 가 적용되어 있어야 해.
--%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-design.css">

<%--
     1. flex-grow-1을 가진 <main> 태그로 컨텐츠를 감쌉니다.
     이 태그가 남는 공간을 모두 차지해서 푸터를 바닥으로 밀어버려요!
--%>
<main class="flex-grow-1">
    <div class="container mt-4">
        <div class="review-wrapper px-4">

            <%-- 병원명 + 평균 별점 + 북마크 버튼 --%>
            <section class="hospital-header d-flex justify-content-between align-items-start mb-4">
                <div>
                    <h2 class="fw-bold mb-1" id="hospitalName">불러오는 중...</h2>

                    <div class="d-flex align-items-center gap-2 mt-2">
                        <span id="average-score-text" class="fs-4 fw-bold">0.0</span>
                        <div id="average-stars-container" class="review-star-rating"></div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="button" id="bookmarkBtn"
                            onclick="toggleBookmark()"
                            class="btn review-btn-circle review-bookmark-btn">
                        <i class="bi-bookmark-fill"></i>
                    </button>
                </div>
            </section>

            <%-- 리뷰 작성 버튼 및 카운트 표시 --%>
            <div class="action-bar d-flex justify-content-end align-items-center pb-3">
                <%-- 리뷰 개수 표시 영역 (지니의 TODO_2 반영!) --%>
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

        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/review/review-common.js"></script>
<script src="${pageContext.request.contextPath}/js/app-common.js"></script>
<script src="${pageContext.request.contextPath}/js/review/review-list.js"></script>

<%@include file="../common/footer.jsp"%>