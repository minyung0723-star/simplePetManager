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

<%-- JS 초기값 (카테고리, 유저번호 등 서버값을 JS로 전달) --%>
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
                <option value="name"    ${searchType == 'name'    ? 'selected' : ''}>가게명</option>
                <option value="address" ${searchType == 'address' ? 'selected' : ''}>주소</option>
            </select>
            <input type="text" class="bl-search-input" id="search-input"
                   placeholder="검색을 입력하세요..." value="${keyword}" maxlength="50">
            <button class="bl-btn-search" id="btn-search">검색</button>
        </div>
    </div>

    <!-- ========== 카테고리 탭 ========== -->
    <div class="bl-category-tabs">
        <button class="bl-cat-tab ${'hospital' eq category ? 'active' : ''}" data-cat="hospital">🏥 동물병원</button>
        <button class="bl-cat-tab ${'hotel'    eq category ? 'active' : ''}" data-cat="hotel">🏨 동물호텔</button>
        <button class="bl-cat-tab ${'pharmacy' eq category ? 'active' : ''}" data-cat="pharmacy">💊 동물약국</button>
        <button class="bl-cat-tab ${(empty category) ? 'active' : ''}" data-cat="">전체</button>
    </div>

    <!-- ========== 결과 요약 ========== -->
    <div class="bl-list-meta">
        <span class="bl-result-info">
            총 <strong>${total}</strong>건
        </span>
        <a href="${pageContext.request.contextPath}/review/reviewPage" class="bl-btn-write">리뷰 목록</a>
    </div>

    <!-- ========== 가게 카드 목록 ========== -->
    <div class="bl-post-list" id="post-list">
        <c:choose>
            <c:when test="${empty storeList}">
                <div class="bl-empty">등록된 가게가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="store" items="${storeList}">
                    <%-- 카드 클릭 → boardDetail 페이지로 storeId 전달 --%>
                    <div class="bl-post-card"
                         data-store-id="${store.storeId}"
                         onclick="goToDetail(${store.storeId})">

                        <div class="bl-card-thumb">
                            <c:choose>
                                <c:when test="${not empty store.storeImage}">
                                    <img src="${fn:startsWith(store.storeImage, 'http') ? store.storeImage : pageContext.request.contextPath.concat('/images/').concat(store.storeImage)}"
                                         alt="가게 이미지"
                                         onerror="this.parentNode.outerHTML='<div class=\'bl-card-thumb-placeholder\'>🐾</div>'">
                                </c:when>
                                <c:otherwise>
                                    <div class="bl-card-thumb-placeholder">
                                        <c:choose>
                                            <c:when test="${store.category eq 'hospital'}">🏥</c:when>
                                            <c:when test="${store.category eq 'hotel'}">🏨</c:when>
                                            <c:when test="${store.category eq 'pharmacy'}">💊</c:when>
                                            <c:otherwise>🐾</c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="bl-card-left">
                            <div class="bl-card-top">
                                <span class="bl-badge badge-${store.category}">
                                    <c:choose>
                                        <c:when test="${store.category eq 'hospital'}">동물병원</c:when>
                                        <c:when test="${store.category eq 'hotel'}">동물호텔</c:when>
                                        <c:when test="${store.category eq 'pharmacy'}">동물약국</c:when>
                                        <c:otherwise>${store.category}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="bl-title">${store.storeName}</div>
                            <div class="bl-store-address">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/>
                                </svg>
                                    ${store.storeAddress}
                            </div>
                            <div class="bl-card-bottom">
                                <span class="bl-phone">
                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8 19.79 19.79 0 01.22 1.18 2 2 0 012.18 0h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.09 7.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 14.92z"/>
                                    </svg>
                                    ${store.storePhone}
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

<%@ include file="../common/footer.jsp" %>

<script>
    // ─── 가게 상세 페이지로 이동 ───────────────────────────
    function goToDetail(storeId) {
        const ctx = document.getElementById('board-data').dataset.contextPath;
        window.location.href = ctx + '/board/boardDetail?storeId=' + storeId;
    }

    // ─── 카테고리 탭 ──────────────────────────────────────
    document.querySelectorAll('.bl-cat-tab').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const cat = this.dataset.cat;
            const ctx = document.getElementById('board-data').dataset.contextPath;
            window.location.href = ctx + '/board/boardList?category=' + cat;
        });
    });

    // ─── 검색 ─────────────────────────────────────────────
    document.getElementById('btn-search').addEventListener('click', function() {
        const type    = document.getElementById('search-type').value;
        const keyword = document.getElementById('search-input').value.trim();
        const cat     = document.getElementById('board-data').dataset.category || '';
        const ctx     = document.getElementById('board-data').dataset.contextPath;
        window.location.href = ctx + '/board/boardList?category=' + cat
            + '&searchType=' + type
            + '&keyword=' + encodeURIComponent(keyword)
            + '&page=1';
    });

    // 엔터키 검색
    document.getElementById('search-input').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') document.getElementById('btn-search').click();
    });

    // ─── 페이지네이션 (서버에서 total, currentPage, pageSize 넘겨줄 것) ───
    (function buildPagination() {
        const total       = parseInt('${total}')       || 0;
        const currentPage = parseInt('${currentPage}') || 1;
        const pageSize    = parseInt('${pageSize}')    || 10;
        const totalPages  = Math.ceil(total / pageSize);
        if (totalPages <= 1) return;

        const cat     = document.getElementById('board-data').dataset.category || '';
        const ctx     = document.getElementById('board-data').dataset.contextPath;
        const keyword = encodeURIComponent('${keyword}');
        const type    = '${searchType}';
        const wrap    = document.getElementById('pagination');

        function makeBtn(label, page, disabled, active) {
            var btn = document.createElement('button');
            btn.className = 'page-btn' + (active ? ' active' : '');
            btn.textContent = label;
            btn.disabled = disabled;
            if (!disabled && !active) {
                btn.addEventListener('click', function() {
                    window.location.href = ctx + '/board/boardList?category=' + cat
                        + '&searchType=' + type + '&keyword=' + keyword + '&page=' + page;
                });
            }
            return btn;
        }

        var groupSize  = 10;
        var groupStart = Math.floor((currentPage - 1) / groupSize) * groupSize + 1;
        var groupEnd   = Math.min(groupStart + groupSize - 1, totalPages);

        wrap.appendChild(makeBtn('‹', currentPage - 1, currentPage === 1, false));
        if (groupStart > 1) {
            var eb1 = makeBtn('...', groupStart - 1, false, false);
            eb1.classList.add('ellipsis');
            wrap.appendChild(eb1);
        }
        for (var p = groupStart; p <= groupEnd; p++) {
            wrap.appendChild(makeBtn(p, p, false, p === currentPage));
        }
        if (groupEnd < totalPages) {
            var eb2 = makeBtn('...', groupEnd + 1, false, false);
            eb2.classList.add('ellipsis');
            wrap.appendChild(eb2);
        }
        wrap.appendChild(makeBtn('›', currentPage + 1, currentPage === totalPages, false));
    })();
</script>

</body>
</html>
