<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 - SimplePetManager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board-design.css">
</head>
<body>

<%@ include file="../common/header.jsp" %>

<%-- JS에서 초기 서버 데이터를 읽기 위한 data 속성 컨테이너 --%>
<div id="board-data"
     data-my-user-number="${myUserNumber}"
     data-total="${total}"
     data-total-pages="${totalPages}"
     data-current-page="${currentPage}"
     style="display:none;">
</div>

<div class="board-container">

    <div class="board-header">
        <h1>커뮤니티</h1>
        <button class="btn-write" id="btn-write-open">+ 글쓰기</button>
    </div>

    <!-- 카테고리 필터 -->
    <div class="category-bar">
        <button class="cat-btn ${empty category ? 'active' : ''}" data-cat="">전체</button>
        <button class="cat-btn ${'자유' eq category ? 'active' : ''}" data-cat="자유">자유</button>
        <button class="cat-btn ${'질문' eq category ? 'active' : ''}" data-cat="질문">질문</button>
        <button class="cat-btn ${'정보' eq category ? 'active' : ''}" data-cat="정보">정보</button>
        <button class="cat-btn ${'자랑' eq category ? 'active' : ''}" data-cat="자랑">자랑</button>
    </div>

    <!-- 검색창 -->
    <div class="search-bar">
        <select class="search-select" id="search-type">
            <option value="all"     ${searchType eq 'all'     ? 'selected' : ''}>전체</option>
            <option value="title"   ${searchType eq 'title'   ? 'selected' : ''}>제목</option>
            <option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
            <option value="writer"  ${searchType eq 'writer'  ? 'selected' : ''}>작성자</option>
        </select>
        <input type="text" class="search-input" id="search-input"
               value="${keyword}" placeholder="검색어를 입력하세요" maxlength="50">
        <button class="btn-search" id="btn-search">검색</button>
    </div>

    <!-- 요약 -->
    <div class="board-meta">
        <span id="result-info">게시글 ${total}건</span>
        <span id="page-info">
            <c:if test="${total > 0}">${currentPage} / ${totalPages} 페이지</c:if>
        </span>
    </div>

    <!-- 테이블: 초기 목록은 JSTL 렌더링, 검색/페이지 변경 시 board.js가 tbody 교체 -->
    <table class="board-table">
        <thead>
        <tr>
            <th class="col-num">번호</th>
            <th class="col-category">분류</th>
            <th>제목</th>
            <th class="col-writer">작성자</th>
            <th class="col-date">작성일</th>
            <th class="col-views">조회</th>
        </tr>
        </thead>
        <tbody id="board-tbody">
        <c:choose>
            <c:when test="${empty boardList}">
                <tr class="empty-row">
                    <td colspan="6">게시글이 없습니다.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="board" items="${boardList}" varStatus="vs">
                    <tr>
                        <td class="col-num" style="text-align:center; color:#aaa;">${vs.index + 1}</td>
                        <td class="col-category">
                            <span class="badge">${board.board_category}</span>
                        </td>
                        <td class="col-title td-title" data-num="${board.board_number}">
                                ${board.board_title}
                        </td>
                        <td class="col-writer">${board.user_name}</td>
                        <td class="col-date" style="color:#aaa;">
                                ${fn:substring(board.created_date, 0, 10)}
                        </td>
                        <td class="col-views">${board.view_count}</td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <!-- 페이지네이션 (board.js 가 data 속성 읽어서 렌더) -->
    <div class="pagination" id="pagination"></div>

</div>

<!-- 글쓰기 / 수정 모달 (구조는 HTML에 미리 선언, JS는 값만 채움) -->
<div class="board-modal-overlay" id="write-modal">
    <div class="board-modal-box">
        <div class="modal-title" id="write-modal-title">게시글 작성</div>
        <div class="form-group">
            <label for="write-category">분류</label>
            <select id="write-category">
                <option value="자유">자유</option>
                <option value="질문">질문</option>
                <option value="정보">정보</option>
                <option value="자랑">자랑</option>
            </select>
        </div>
        <div class="form-group">
            <label for="write-title">제목</label>
            <input type="text" id="write-title" placeholder="제목을 입력하세요" maxlength="100">
        </div>
        <div class="form-group">
            <label for="write-content">내용</label>
            <textarea id="write-content" placeholder="내용을 입력하세요"></textarea>
        </div>
        <div class="modal-actions">
            <button class="btn-cancel"  id="btn-write-cancel">취소</button>
            <button class="btn-primary" id="btn-write-submit">등록</button>
        </div>
    </div>
</div>

<!-- 상세 모달 (구조는 HTML에 미리 선언, JS는 값만 채움) -->
<div class="board-modal-overlay" id="detail-modal">
    <div class="board-modal-box">
        <div class="modal-title detail-title" id="detail-title"></div>
        <div class="detail-meta"    id="detail-meta"></div>
        <div class="detail-content" id="detail-content"></div>
        <div class="modal-actions" style="margin-top:28px; justify-content:space-between;">
            <%-- 수정/삭제 버튼: board.js 에서 본인 글일 때만 display:'' 로 노출, 아닐 때 display:none --%>
            <div class="detail-actions" id="detail-actions" style="display:none;">
                <button class="btn-edit" id="btn-open-edit">수정</button>
                <button class="btn-del"  id="btn-del-board">삭제</button>
            </div>
            <button class="btn-cancel" id="btn-detail-close">닫기</button>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/board.js"></script>

<%-- 초기 JSTL로 렌더링된 tbody 행에 클릭 이벤트 바인딩 --%>
<script>
    document.querySelectorAll('#board-tbody .td-title').forEach(function (td) {
        td.addEventListener('click', function () {
            openDetail(Number(td.dataset.num));
        });
    });
</script>

</body>
</html>
