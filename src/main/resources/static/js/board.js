/**
 * board.js
 * 게시판 (boardList.jsp) 전용 스크립트
 *
 * ※ innerHTML 사용 금지 → DOM API(createElement, textContent, appendChild 등)만 사용
 *
 * 초기 목록 렌더링 → BoardViewController + JSTL (서버사이드)
 * 검색/페이지 변경 → fetch 후 tbody 행만 교체
 * 글쓰기/상세/수정/삭제 → 모달 이벤트 (모달 구조는 HTML에 선언, JS는 값만 채움)
 */

/* =====================================================
   상태
   ===================================================== */

const state = {
    page:       1,
    pageSize:   10,
    totalPages: 1,
    total:      0,
    keyword:    '',
    searchType: 'all',
    category:   '',
    myUserNumber: null   // JSP data 속성에서 주입
};

/* =====================================================
   유틸
   ===================================================== */

function fmtDate(str) {
    return str ? String(str).substring(0, 10) : '';
}

/* =====================================================
   tbody 교체 (검색/페이지 변경 시에만 호출)
   초기 렌더링은 JSTL 이 담당
   ===================================================== */

function renderRows(list) {
    const tbody = document.getElementById('board-tbody');
    tbody.replaceChildren();

    if (!list || !list.length) {
        const tr = document.createElement('tr');
        tr.className = 'empty-row';
        const td = document.createElement('td');
        td.colSpan = 6;
        td.textContent = '게시글이 없습니다.';
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
    }

    list.forEach(function (b, i) {
        const num      = (state.page - 1) * state.pageSize + i + 1;
        const category = b.board_category || b.boardCategory || '';
        const title    = b.board_title    || b.boardTitle    || '';
        const writer   = b.user_name      || b.userName      || '';
        const date     = fmtDate(b.created_date || b.createdDate);
        const views    = b.view_count     || b.viewCount     || 0;
        const boardNum = b.board_number   || b.boardNumber;

        const tr = document.createElement('tr');

        // 번호
        const tdNum = document.createElement('td');
        tdNum.className = 'col-num';
        tdNum.style.textAlign = 'center';
        tdNum.style.color = '#aaa';
        tdNum.textContent = num;

        // 카테고리
        const tdCat = document.createElement('td');
        tdCat.className = 'col-category';
        const badge = document.createElement('span');
        badge.className = 'badge';
        badge.textContent = category;
        tdCat.appendChild(badge);

        // 제목 (클릭 → 상세 모달)
        const tdTitle = document.createElement('td');
        tdTitle.className = 'col-title td-title';
        tdTitle.dataset.num = boardNum;
        tdTitle.textContent = title;
        tdTitle.addEventListener('click', function () { openDetail(boardNum); });

        // 작성자
        const tdWriter = document.createElement('td');
        tdWriter.className = 'col-writer';
        tdWriter.textContent = writer;

        // 날짜
        const tdDate = document.createElement('td');
        tdDate.className = 'col-date';
        tdDate.style.color = '#aaa';
        tdDate.textContent = date;

        // 조회수
        const tdViews = document.createElement('td');
        tdViews.className = 'col-views';
        tdViews.textContent = views;

        tr.append(tdNum, tdCat, tdTitle, tdWriter, tdDate, tdViews);
        tbody.appendChild(tr);
    });
}

/* =====================================================
   페이지네이션 버튼 교체
   ===================================================== */

function renderPagination() {
    const pg = document.getElementById('pagination');
    pg.replaceChildren();

    if (state.totalPages <= 1) return;

    const cur       = state.page;
    const tot       = state.totalPages;
    const blockSize = 5;
    const block     = Math.ceil(cur / blockSize);
    const start     = (block - 1) * blockSize + 1;
    const end       = Math.min(start + blockSize - 1, tot);

    function makeBtn(label, page, disabled, active) {
        const btn = document.createElement('button');
        btn.className = 'page-btn' + (active ? ' active' : '');
        btn.textContent = label;
        btn.disabled = disabled;
        if (!disabled) {
            btn.addEventListener('click', function () { goPage(page); });
        }
        return btn;
    }

    pg.appendChild(makeBtn('«', 1,       cur === 1,   false));
    pg.appendChild(makeBtn('‹', cur - 1, cur === 1,   false));
    for (var p = start; p <= end; p++) {
        pg.appendChild(makeBtn(p, p, false, p === cur));
    }
    pg.appendChild(makeBtn('›', cur + 1, cur === tot, false));
    pg.appendChild(makeBtn('»', tot,     cur === tot, false));
}

/* =====================================================
   요약 텍스트 갱신
   ===================================================== */

function updateMeta() {
    document.getElementById('result-info').textContent = '게시글 ' + state.total + '건';
    document.getElementById('page-info').textContent =
        state.total > 0 ? (state.page + ' / ' + state.totalPages + ' 페이지') : '';
}

/* =====================================================
   목록 fetch (검색/페이지 변경 시)
   ===================================================== */

async function loadBoard() {
    const p = new URLSearchParams({
        keyword:    state.keyword,
        searchType: state.searchType,
        category:   state.category,
        page:       state.page,
        pageSize:   state.pageSize
    });

    const res  = await fetch('/board/list?' + p);
    const data = await res.json();

    state.totalPages = data.totalPages || 1;
    state.total      = data.total      || 0;

    renderRows(data.list || []);
    renderPagination();
    updateMeta();
}

function goPage(p) {
    if (p < 1 || p > state.totalPages) return;
    state.page = p;
    loadBoard();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* =====================================================
   검색
   ===================================================== */

function initSearch() {
    document.getElementById('btn-search').addEventListener('click', function () {
        state.keyword    = document.getElementById('search-input').value.trim();
        state.searchType = document.getElementById('search-type').value;
        state.page       = 1;
        loadBoard();
    });

    document.getElementById('search-input').addEventListener('keydown', function (e) {
        if (e.key === 'Enter') document.getElementById('btn-search').click();
    });
}

/* =====================================================
   카테고리 필터
   ===================================================== */

function initCategoryFilter() {
    document.querySelectorAll('.cat-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.cat-btn').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            state.category = btn.dataset.cat;
            state.page     = 1;
            loadBoard();
        });
    });
}

/* =====================================================
   상세 모달
   모달 구조는 boardList.jsp에 미리 선언됨
   JS는 textContent 값 채우기 + 버튼 이벤트만 담당
   ===================================================== */

async function openDetail(boardNumber) {
    const res  = await fetch('/board/' + boardNumber);
    const data = await res.json();
    if (!data.success) { alert('게시글을 불러올 수 없습니다.'); return; }

    const b = data.board;

    document.getElementById('detail-title').textContent =
        b.board_title || b.boardTitle || '';
    document.getElementById('detail-meta').textContent =
        (b.user_name || b.userName || '') +
        ' · ' + fmtDate(b.created_date || b.createdDate) +
        ' · 조회 ' + (b.view_count || b.viewCount || 0);
    document.getElementById('detail-content').textContent =
        b.board_content || b.boardContent || '';

    // 수정/삭제 버튼: 본인 글일 때만 노출
    const writerNum     = b.user_number || b.userNumber;
    const detailActions = document.getElementById('detail-actions');

    if (state.myUserNumber && state.myUserNumber === writerNum) {
        detailActions.style.display = '';
        document.getElementById('btn-open-edit').onclick = function () { openEditModal(b); };
        document.getElementById('btn-del-board').onclick = function () { deleteBoard(boardNumber); };
    } else {
        detailActions.style.display = 'none';
    }

    document.getElementById('detail-modal').classList.add('open');
}

/* =====================================================
   글쓰기 / 수정 모달
   ===================================================== */

var editBoardNumber = null;

function initWriteModal() {
    document.getElementById('btn-write-open').addEventListener('click', function () {
        if (!state.myUserNumber) {
            alert('로그인이 필요합니다.');
            location.href = '/user/login';
            return;
        }
        editBoardNumber = null;
        document.getElementById('write-modal-title').textContent = '게시글 작성';
        document.getElementById('write-title').value             = '';
        document.getElementById('write-content').value           = '';
        document.getElementById('btn-write-submit').textContent  = '등록';
        document.getElementById('write-modal').classList.add('open');
    });

    document.getElementById('btn-write-cancel').addEventListener('click', function () {
        document.getElementById('write-modal').classList.remove('open');
    });

    document.getElementById('btn-write-submit').addEventListener('click', submitWrite);
}

function openEditModal(b) {
    document.getElementById('detail-modal').classList.remove('open');
    editBoardNumber = b.board_number || b.boardNumber;
    document.getElementById('write-modal-title').textContent = '게시글 수정';
    document.getElementById('write-category').value = b.board_category || b.boardCategory || '자유';
    document.getElementById('write-title').value    = b.board_title    || b.boardTitle    || '';
    document.getElementById('write-content').value  = b.board_content  || b.boardContent  || '';
    document.getElementById('btn-write-submit').textContent = '수정';
    document.getElementById('write-modal').classList.add('open');
}

async function submitWrite() {
    const title    = document.getElementById('write-title').value.trim();
    const content  = document.getElementById('write-content').value.trim();
    const category = document.getElementById('write-category').value;

    if (!title || !content) { alert('제목과 내용을 모두 입력해주세요.'); return; }

    const url    = editBoardNumber ? ('/board/' + editBoardNumber) : '/board/write';
    const method = editBoardNumber ? 'PUT' : 'POST';

    const res  = await fetch(url, {
        method:  method,
        headers: { 'Content-Type': 'application/json' },
        body:    JSON.stringify({ boardTitle: title, boardContent: content, boardCategory: category })
    });
    const data = await res.json();
    alert(data.message);

    if (data.success) {
        document.getElementById('write-modal').classList.remove('open');
        state.page = 1;
        loadBoard();
    }
}

/* =====================================================
   게시글 삭제
   ===================================================== */

async function deleteBoard(boardNumber) {
    if (!confirm('게시글을 삭제하시겠습니까?')) return;

    const res  = await fetch('/board/' + boardNumber, { method: 'DELETE' });
    const data = await res.json();
    alert(data.message);

    if (data.success) {
        document.getElementById('detail-modal').classList.remove('open');
        loadBoard();
    }
}

/* =====================================================
   모달 외부 클릭 닫기
   ===================================================== */

function initModalClose() {
    document.querySelectorAll('.board-modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) overlay.classList.remove('open');
        });
    });

    document.getElementById('btn-detail-close').addEventListener('click', function () {
        document.getElementById('detail-modal').classList.remove('open');
    });
}

/* =====================================================
   초기 실행
   ===================================================== */

document.addEventListener('DOMContentLoaded', function () {
    // JSP data 속성에서 서버 초기값 읽기
    const container    = document.getElementById('board-data');
    state.myUserNumber = container.dataset.myUserNumber ? Number(container.dataset.myUserNumber) : null;
    state.totalPages   = Number(container.dataset.totalPages)  || 1;
    state.total        = Number(container.dataset.total)       || 0;
    state.page         = Number(container.dataset.currentPage) || 1;

    // 초기 페이지네이션/메타 렌더 (서버 데이터 기반)
    updateMeta();
    renderPagination();

    initSearch();
    initCategoryFilter();
    initWriteModal();
    initModalClose();
});
