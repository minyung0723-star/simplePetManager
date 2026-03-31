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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board-design.css">
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7b3c1268686dba44c21ed3c821eabf30&libraries=services"></script>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<%-- JS 초기값 --%>
<div id="board-data"
     data-my-user-number="${myUserNumber}"
     data-category="${category}"
     style="display:none;"></div>

<!-- ===================== 메인 레이아웃 ===================== -->
<div class="community-layout">

    <!-- ========== 왼쪽 패널 ========== -->
    <div class="left-panel" id="left-panel">

        <!-- 패널 헤더 -->
        <div class="panel-header">
            <span class="panel-title" id="panel-title">동물병원 찾기</span>
        </div>

        <!-- 검색창 -->
        <div class="panel-search">
            <div class="search-row">
                <input type="text" class="ps-input" id="search-input"
                       placeholder="가게명 또는 주소 검색" maxlength="50">
                <button class="ps-btn" id="btn-search">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </button>
            </div>
        </div>

        <!-- 카테고리 칩 -->
        <div class="panel-cats">
            <button class="cat-chip ${'hospital' eq category ? 'active' : ''}" data-cat="hospital">동물병원</button>
            <button class="cat-chip ${'hotel'    eq category ? 'active' : ''}" data-cat="hotel">동물호텔</button>
            <button class="cat-chip ${'pharmacy' eq category ? 'active' : ''}" data-cat="pharmacy">동물약국</button>
        </div>

        <!-- 요약 -->
        <div class="panel-meta">
            <span id="result-info">검색 결과 0건</span>
        </div>

        <!-- 가게 목록 -->
        <div class="post-list" id="post-list">
            <div class="post-empty">카테고리를 선택하거나 검색해주세요.</div>
        </div>

        <!-- 페이지네이션 -->
        <div class="panel-pagination" id="pagination"></div>

    </div><!-- /left-panel -->

    <!-- ========== 오른쪽: 지도 ========== -->
    <div class="map-area">
        <div id="kakao-map"></div>

        <!-- 가게 상세 오버레이 -->
        <div class="detail-overlay" id="detail-overlay">
            <div class="detail-overlay-inner">
                <button class="detail-close" id="btn-detail-close">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>

                <!-- 카테고리 배지 -->
                <div class="do-badge-wrap"><span class="do-badge" id="do-badge"></span></div>

                <!-- 가게명 -->
                <div class="do-title" id="do-title"></div>

                <!-- 주소 / 전화 / 영업시간 -->
                <div class="do-info-list" id="do-info-list"></div>

                <!-- 진료 가능 동물 -->
                <div class="do-animals" id="do-animals"></div>

                <!-- 구분선 -->
                <div class="do-divider"></div>

                <!-- 리뷰 목록 -->
                <div class="do-review-section">
                    <div class="do-review-header">
                        <span class="do-review-title">리뷰</span>
                        <span class="do-review-count" id="do-review-count"></span>
                    </div>
                    <div class="do-review-list" id="do-review-list"></div>
                </div>

                <!-- 리뷰쓰기 버튼 -->
                <div class="do-actions">
                    <button class="do-btn-review" id="btn-write-review">리뷰 작성하기</button>
                </div>

            </div>
        </div>

    </div><!-- /map-area -->

</div><!-- /community-layout -->

<%@ include file="../common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/board.js"></script>

</body>
</html>
