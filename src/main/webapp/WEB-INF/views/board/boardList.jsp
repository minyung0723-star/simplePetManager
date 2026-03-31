<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>동물병원 / 호텔 / 약국 찾기 - SimplePetManager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board-design.css">
</head>
<body>

<%@ include file="../common/header.jsp" %>

<%-- JS 초기값 --%>
<div id="board-data"
     data-my-user-number="${myUserNumber}"
     data-category="${category}"
     data-context-path="${pageContext.request.contextPath}"
     style="display:none;"></div>

<!-- ===================== 메인 레이아웃 ===================== -->
<div class="bl-wrap">

    <!-- ========== 검색바 ========== -->
    <div class="bl-search-section">
        <div class="bl-search-bar">
            <select class="bl-select" id="search-type">
                <option value="all"     ${searchType == 'all'     ? 'selected' : ''}>전체</option>
                <option value="title"   ${searchType == 'title'   ? 'selected' : ''}>제목</option>
                <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                <option value="writer"  ${searchType == 'writer'  ? 'selected' : ''}>작성자</option>
            </select>
            <input type="text" class="bl-search-input" id="search-input"
                   placeholder="검색을 입력하세요..." value="${keyword}" maxlength="50">
            <button class="bl-btn-search" id="btn-search">검색</button>
        </div>
    </div>

    <!-- ========== 카테고리 탭 ========== -->
    <div class="bl-category-tabs">
        <button class="bl-cat-tab ${'hospital' eq category ? 'active' : ''}" data-cat="hospital">동물병원</button>
        <button class="bl-cat-tab ${'hotel'    eq category ? 'active' : ''}" data-cat="hotel">동물호텔</button>
        <button class="bl-cat-tab ${'pharmacy' eq category ? 'active' : ''}" data-cat="pharmacy">동물약국</button>
        <button class="bl-cat-tab ${(category == '' || category == null) ? 'active' : ''}" data-cat="">전체</button>
    </div>

    <!-- ========== 결과 요약 + 글쓰기 버튼 ========== -->
    <div class="bl-list-meta">
        <span class="bl-result-info" id="result-info">
            총 <strong>${total}</strong>건
        </span>
        <a href="${pageContext.request.contextPath}/review/reviewPage" class="bl-btn-write">리뷰 목록</a>
    </div>

    <!-- ========== 게시글 목록 ========== -->
    <div class="bl-post-list" id="post-list">
        <c:choose>
            <c:when test="${empty boardList}">
                <div class="bl-empty">등록된 게시글이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="b" items="${boardList}">
                    <div class="bl-post-card" data-num="${b.board_number}" onclick="openDetail(${b.board_number})">
                        <div class="bl-card-left">
                            <div class="bl-card-top">
                                <span class="bl-badge badge-${b.board_category}">${b.board_category}</span>
                                <span class="bl-date">${fn:substring(b.created_date, 0, 10)}</span>
                            </div>
                            <div class="bl-title">${b.board_title}</div>
                            <div class="bl-card-bottom">
                                <span class="bl-writer">
                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    ${b.user_name}
                                </span>
                                <span class="bl-views">
                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    ${b.view_count}
                                </span>
                            </div>
                        </div>
                        <div class="bl-card-arrow">›</div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ========== 페이지네이션 ========== -->
    <div class="bl-pagination" id="pagination"></div>

</div><!-- /bl-wrap -->

<!-- ========== 글 상세 모달 ========== -->
<div class="bl-detail-backdrop" id="detail-backdrop"></div>
<div class="bl-detail-modal" id="detail-modal">
    <div class="bl-detail-header">
        <div class="bl-detail-badge-wrap"><span class="bl-detail-badge" id="dm-badge"></span></div>
        <button class="bl-detail-close" id="btn-detail-close">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
        </button>
    </div>
    <div class="bl-detail-body">
        <div class="bl-detail-title" id="dm-title"></div>
        <div class="bl-detail-meta" id="dm-meta"></div>
        <div class="bl-detail-content" id="dm-content"></div>
    </div>
    <div class="bl-detail-footer" id="dm-footer"></div>
</div>



<%@ include file="../common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/board.js"></script>

</body>
</html>
