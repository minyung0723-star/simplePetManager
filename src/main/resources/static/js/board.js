/**
 * board.js  (v4 – 목록 페이지 디자인)
 *
 * - 중앙 카드 리스트 UI
 * - 검색 / 카테고리 필터 / 페이지네이션
 * - 글 상세 모달 (수정·삭제 포함)
 * - 글쓰기 / 수정 모달
 */

/* =====================================================
   상태
   ===================================================== */

const state = {
    page:         1,
    pageSize:     10,
    totalPages:   1,
    total:        0,
    keyword:      '',
    searchType:   'all',
    category:     '',
    myUserNumber: null,
    ctx:          '',          // contextPath
    editMode:     false,
    editNumber:   null
};

/* =====================================================
   카테고리 한글 매핑
   ===================================================== */

const CAT_LABEL = {
    hospital: '동물병원',
    hotel:    '동물호텔',
    pharmacy: '동물약국',
    '자유': '자유', '질문': '질문', '정보': '정보', '자랑': '자랑'
};

/* =====================================================
   게시글 목록 로드
   ===================================================== */

async function loadBoard() {
    const p = new URLSearchParams({
        keyword:    state.keyword,
        searchType: state.searchType,
        category:   state.category,
        page:       state.page,
        pageSize:   state.pageSize
    });

    try {
        const res  = await fetch(state.ctx + '/board/list?' + p);
        const data = await res.json();

        state.totalPages = data.totalPages || 1;
        state.total      = data.total      || 0;

        renderCards(data.list || []);
        renderPagination();
        updateMeta();
    } catch (e) {
        console.warn('Board API error:', e.message);
        renderCards([]);
    }
}

function goPage(p) {
    if (p < 1 || p > state.totalPages) return;
    state.page = p;
    loadBoard();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* =====================================================
   카드 렌더링
   ===================================================== */

function renderCards(list) {
    const container = document.getElementById('post-list');
    container.replaceChildren();

    if (!list.length) {
        const empty = document.createElement('div');
        empty.className = 'bl-empty';
        empty.textContent = '게시글이 없습니다.';
        container.appendChild(empty);
        return;
    }

    list.forEach(function (b) {
        const boardNum  = b.board_number;
        const title     = b.board_title    || '';
        const category  = b.board_category || '';
        const userName  = b.user_name      || '익명';
        const viewCount = b.view_count     || 0;
        const dateStr   = b.created_date   ? String(b.created_date).slice(0, 10) : '';

        const card = document.createElement('div');
        card.className = 'bl-post-card';
        card.dataset.num = boardNum;
        card.addEventListener('click', function () { openDetail(boardNum); });

        // 왼쪽 영역
        const left = document.createElement('div');
        left.className = 'bl-card-left';

        // 상단 (배지 + 날짜)
        const top = document.createElement('div');
        top.className = 'bl-card-top';

        const badge = document.createElement('span');
        badge.className = 'bl-badge badge-' + category;
        badge.textContent = CAT_LABEL[category] || category;

        const date = document.createElement('span');
        date.className = 'bl-date';
        date.textContent = dateStr;

        top.appendChild(badge);
        top.appendChild(date);

        // 제목
        const titleEl = document.createElement('div');
        titleEl.className = 'bl-title';
        titleEl.textContent = title;

        // 하단 (작성자 + 조회수)
        const bottom = document.createElement('div');
        bottom.className = 'bl-card-bottom';

        bottom.innerHTML =
            '<span class="bl-writer">' +
            '<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">' +
            '<path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>' +
            escHtml(userName) +
            '</span>' +
            '<span class="bl-views">' +
            '<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">' +
            '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>' +
            viewCount +
            '</span>';

        left.appendChild(top);
        left.appendChild(titleEl);
        left.appendChild(bottom);

        // 화살표
        const arrow = document.createElement('div');
        arrow.className = 'bl-card-arrow';
        arrow.textContent = '›';

        card.appendChild(left);
        card.appendChild(arrow);
        container.appendChild(card);
    });
}

/* =====================================================
   페이지네이션
   ===================================================== */

function renderPagination() {
    const pg = document.getElementById('pagination');
    pg.replaceChildren();
    if (state.totalPages <= 1) return;

    const cur = state.page, tot = state.totalPages;
    const blockSize = 5;
    const block = Math.ceil(cur / blockSize);
    const start = (block - 1) * blockSize + 1;
    const end   = Math.min(start + blockSize - 1, tot);

    function makeBtn(label, page, disabled, active) {
        const btn = document.createElement('button');
        btn.className = 'page-btn' + (active ? ' active' : '');
        btn.textContent = label;
        btn.disabled = disabled;
        if (!disabled) btn.addEventListener('click', function () { goPage(page); });
        return btn;
    }

    pg.appendChild(makeBtn('«', 1,       cur === 1,   false));
    pg.appendChild(makeBtn('‹', cur - 1, cur === 1,   false));
    for (let i = start; i <= end; i++) {
        pg.appendChild(makeBtn(i, i, false, i === cur));
    }
    pg.appendChild(makeBtn('›', cur + 1, cur === tot, false));
    pg.appendChild(makeBtn('»', tot,     cur === tot, false));
}

function updateMeta() {
    const info = document.getElementById('result-info');
    if (info) info.innerHTML = '총 <strong>' + state.total + '</strong>건';
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
   카테고리 탭
   ===================================================== */

function initCategoryTabs() {
    document.querySelectorAll('.bl-cat-tab').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.bl-cat-tab').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            state.category = btn.dataset.cat;
            state.page     = 1;
            loadBoard();
        });
    });
}

/* =====================================================
   글 상세 모달
   ===================================================== */

async function openDetail(boardNumber) {
    if (!boardNumber) return;

    try {
        const res  = await fetch(state.ctx + '/board/' + boardNumber);
        const data = await res.json();

        if (!data.success || !data.board) {
            alert('게시글을 불러올 수 없습니다.');
            return;
        }

        const b = data.board;

        // 배지
        const badgeEl = document.getElementById('dm-badge');
        const cat = b.board_category || '';
        badgeEl.textContent = CAT_LABEL[cat] || cat;
        badgeEl.className = 'bl-badge badge-' + cat;

        // 제목
        document.getElementById('dm-title').textContent = b.board_title || '';

        // 메타 (작성자 · 날짜 · 조회수)
        const dateStr = b.created_date ? String(b.created_date).slice(0, 16).replace('T', ' ') : '';
        document.getElementById('dm-meta').innerHTML =
            '<span>✍️ ' + escHtml(b.user_name || '익명') + '</span>' +
            '<span>📅 ' + dateStr + '</span>' +
            '<span>👁 ' + (b.view_count || 0) + '</span>';

        // 내용
        document.getElementById('dm-content').textContent = b.board_content || '';

        // 수정·삭제 버튼 (본인만)
        const footer = document.getElementById('dm-footer');
        footer.replaceChildren();

        if (state.myUserNumber && Number(b.user_number) === Number(state.myUserNumber)) {
            const editBtn = document.createElement('button');
            editBtn.className = 'bl-btn-edit';
            editBtn.textContent = '수정';
            editBtn.addEventListener('click', function () {
                location.href = state.ctx + '/review/reviewPage';
            });

            const delBtn = document.createElement('button');
            delBtn.className = 'bl-btn-delete';
            delBtn.textContent = '삭제';
            delBtn.addEventListener('click', function () { deletePost(boardNumber); });

            footer.appendChild(editBtn);
            footer.appendChild(delBtn);
        }

        // 모달 오픈
        document.getElementById('detail-backdrop').classList.add('open');
        document.getElementById('detail-modal').classList.add('open');

    } catch (e) {
        console.warn('Detail error:', e.message);
        alert('게시글을 불러오는 중 오류가 발생했습니다.');
    }
}

function closeDetail() {
    document.getElementById('detail-backdrop').classList.remove('open');
    document.getElementById('detail-modal').classList.remove('open');
}

function initDetailClose() {
    document.getElementById('btn-detail-close').addEventListener('click', closeDetail);
    document.getElementById('detail-backdrop').addEventListener('click', closeDetail);
}

/* =====================================================
   게시글 삭제
   ===================================================== */

async function deletePost(boardNumber) {
    if (!confirm('게시글을 삭제하시겠습니까?')) return;

    try {
        const res  = await fetch(state.ctx + '/board/' + boardNumber, { method: 'DELETE' });
        const data = await res.json();
        alert(data.message);
        if (data.success) {
            closeDetail();
            // 현재 페이지 카드가 1개였으면 이전 페이지로
            if (state.page > 1 && document.querySelectorAll('.bl-post-card').length <= 1) {
                state.page--;
            }
            loadBoard();
        }
    } catch (e) {
        console.warn('Delete error:', e.message);
        alert('서버 오류가 발생했습니다.');
    }
}

/* =====================================================
   유틸
   ===================================================== */

function escHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

/* =====================================================
   초기 실행
   ===================================================== */

document.addEventListener('DOMContentLoaded', function () {
    const container    = document.getElementById('board-data');
    state.myUserNumber = container.dataset.myUserNumber
        ? Number(container.dataset.myUserNumber) : null;
    state.category     = container.dataset.category  || '';
    state.ctx          = container.dataset.contextPath || '';

    // 검색 파라미터 URL에서 읽기
    const params = new URLSearchParams(window.location.search);
    state.keyword    = params.get('keyword')    || '';
    state.searchType = params.get('searchType') || 'all';

    // 검색 입력창 초기화
    const inputEl = document.getElementById('search-input');
    if (inputEl && state.keyword) inputEl.value = state.keyword;
    const selectEl = document.getElementById('search-type');
    if (selectEl && state.searchType) selectEl.value = state.searchType;

    // 카테고리 탭 active 동기화
    document.querySelectorAll('.bl-cat-tab').forEach(function (btn) {
        btn.classList.toggle('active', btn.dataset.cat === state.category);
    });

    initSearch();
    initCategoryTabs();
    initDetailClose();

    // 초기 목록 로드
    loadBoard();
});