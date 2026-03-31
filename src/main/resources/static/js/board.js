/**
 * board.js  (v3 – 가게 목록 / 상세 오버레이)
 *
 * - 왼쪽 패널 : 가게 카드 (이름·주소·전화번호·카테고리·별점)
 * - 오른쪽    : 카카오 지도 (가게 마커)
 * - 카드 클릭 : 지도 위 오버레이 (이름·주소·전화·영업시간·진료동물·리뷰 목록·리뷰쓰기)
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
    category:     '',          // hospital | hotel | pharmacy
    myUserNumber: null,
    currentStoreNumber: null
};

/* =====================================================
   카테고리 한글 매핑
   ===================================================== */

const CAT_LABEL = {
    hospital: '동물병원',
    hotel:    '동물호텔',
    pharmacy: '동물약국'
};

const PANEL_TITLE = {
    hospital: '동물병원 찾기',
    hotel:    '동물호텔 찾기',
    pharmacy: '동물약국 찾기'
};

/* =====================================================
   카카오 지도
   ===================================================== */

let kakaoMap    = null;
let storeMarkers = [];

function initKakaoMap() {
    if (typeof kakao === 'undefined' || !kakao.maps) {
        const mapEl = document.getElementById('kakao-map');
        mapEl.style.cssText = 'background:#e8eaed;display:flex;align-items:center;justify-content:center;';
        const msg = document.createElement('span');
        msg.style.cssText = 'color:#999;font-size:13px;';
        msg.textContent = '지도를 불러오는 중...';
        mapEl.appendChild(msg);
        return;
    }

    const container = document.getElementById('kakao-map');
    kakaoMap = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 6
    });
    kakaoMap.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
}

function clearMarkers() {
    storeMarkers.forEach(function (m) { m.setMap(null); });
    storeMarkers = [];
}

function addMarker(store) {
    if (!kakaoMap) return;
    const lat = store.latitude  || store.lat;
    const lng = store.longitude || store.lng;
    if (!lat || !lng) return;

    const marker = new kakao.maps.Marker({
        position: new kakao.maps.LatLng(lat, lng),
        map: kakaoMap
    });

    kakao.maps.event.addListener(marker, 'click', function () {
        openDetail(store.store_number || store.storeNumber);
    });

    storeMarkers.push(marker);
}

function panToStore(store) {
    if (!kakaoMap) return;
    const lat = store.latitude  || store.lat;
    const lng = store.longitude || store.lng;
    if (lat && lng) {
        kakaoMap.panTo(new kakao.maps.LatLng(lat, lng));
    }
}

/* =====================================================
   가게 목록 로드
   ===================================================== */

async function loadStores() {
    const p = new URLSearchParams({
        keyword:  state.keyword,
        category: state.category,
        page:     state.page,
        pageSize: state.pageSize
    });

    try {
        const res  = await fetch('/store/list?' + p);
        const data = await res.json();

        state.totalPages = data.totalPages || 1;
        state.total      = data.total      || 0;

        const list = data.list || data || [];
        renderCards(list);
        renderPagination();
        updateMeta();

        // 지도 마커 갱신
        clearMarkers();
        list.forEach(addMarker);

    } catch (e) {
        console.warn('Store API error:', e.message);
        renderCards([]);
    }
}

function goPage(p) {
    if (p < 1 || p > state.totalPages) return;
    state.page = p;
    loadStores();
}

/* =====================================================
   왼쪽 패널 카드 렌더
   ===================================================== */

function renderCards(list) {
    const container = document.getElementById('post-list');
    container.replaceChildren();

    if (!list || !list.length) {
        const empty = document.createElement('div');
        empty.className = 'post-empty';
        empty.textContent = '검색 결과가 없습니다.';
        container.appendChild(empty);
        return;
    }

    list.forEach(function (s) {
        const storeNum  = s.store_number  || s.storeNumber;
        const name      = s.store_name    || s.storeName    || '';
        const address   = s.store_address || s.storeAddress || '';
        const phone     = s.store_phone   || s.storePhone   || '';
        const category  = s.store_category|| s.storeCategory|| state.category;
        const rating    = s.avg_rating    || s.avgRating;

        /* 카드 루트 */
        const card = document.createElement('div');
        card.className  = 'post-card';
        card.dataset.num = storeNum;

        /* 상단: 배지 + 별점 */
        const top = document.createElement('div');
        top.className = 'post-card-top';

        const badge = document.createElement('span');
        badge.className = 'post-badge badge-' + category;
        badge.textContent = CAT_LABEL[category] || category;

        const ratingEl = document.createElement('span');
        ratingEl.className = 'post-rating';
        if (rating != null) {
            ratingEl.textContent = '★ ' + Number(rating).toFixed(1);
        }

        top.appendChild(badge);
        top.appendChild(ratingEl);

        /* 가게 이름 */
        const nameEl = document.createElement('div');
        nameEl.className = 'post-title';
        nameEl.textContent = name;

        /* 주소 */
        const addrEl = document.createElement('div');
        addrEl.className = 'post-addr';
        addrEl.textContent = address;

        /* 전화번호 */
        const phoneEl = document.createElement('div');
        phoneEl.className = 'post-phone';
        if (phone) phoneEl.textContent = '📞 ' + phone;

        card.appendChild(top);
        card.appendChild(nameEl);
        card.appendChild(addrEl);
        if (phone) card.appendChild(phoneEl);

        card.addEventListener('click', function () { openDetail(storeNum); });

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
    if (info) info.textContent = '검색 결과 ' + state.total + '건';
}

/* =====================================================
   검색
   ===================================================== */

function initSearch() {
    document.getElementById('btn-search').addEventListener('click', function () {
        state.keyword = document.getElementById('search-input').value.trim();
        state.page    = 1;
        loadStores();
    });

    document.getElementById('search-input').addEventListener('keydown', function (e) {
        if (e.key === 'Enter') document.getElementById('btn-search').click();
    });
}

/* =====================================================
   카테고리 필터
   ===================================================== */

function initCategoryFilter() {
    document.querySelectorAll('.cat-chip').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.cat-chip').forEach(function (b) { b.classList.remove('active'); });
            btn.classList.add('active');
            state.category = btn.dataset.cat;
            state.page     = 1;

            // 패널 타이틀 변경
            const titleEl = document.getElementById('panel-title');
            if (titleEl) titleEl.textContent = PANEL_TITLE[state.category] || '찾기';

            loadStores();
        });
    });
}

/* =====================================================
   가게 상세 오버레이
   ===================================================== */

async function openDetail(storeNumber) {
    if (!storeNumber) return;
    state.currentStoreNumber = storeNumber;

    try {
        // 가게 상세 + 리뷰 목록 병렬 요청
        const [storeRes, reviewRes] = await Promise.all([
            fetch('/store/' + storeNumber),
            fetch('/review/list?storeNumber=' + storeNumber)
        ]);
        const storeData  = await storeRes.json();
        const reviewData = await reviewRes.json();

        const store   = storeData.store  || storeData;
        const reviews = reviewData.list  || reviewData || [];

        if (!store) { alert('가게 정보를 불러올 수 없습니다.'); return; }

        // 카드 active
        document.querySelectorAll('.post-card').forEach(function (c) { c.classList.remove('active'); });
        const activeCard = document.querySelector('.post-card[data-num="' + storeNumber + '"]');
        if (activeCard) activeCard.classList.add('active');

        // 지도 이동
        panToStore(store);

        // ── 오버레이 채우기 ──────────────────────────────

        // 배지
        const cat   = store.store_category || store.storeCategory || state.category;
        const badge = document.getElementById('do-badge');
        badge.textContent = CAT_LABEL[cat] || cat;
        badge.className   = 'do-badge badge-' + cat;

        // 가게명
        document.getElementById('do-title').textContent =
            store.store_name || store.storeName || '';

        // 주소 / 전화 / 영업시간
        const infoList = document.getElementById('do-info-list');
        infoList.replaceChildren();

        const infoItems = [
            { icon: '📍', value: store.store_address  || store.storeAddress  || '' },
            { icon: '📞', value: store.store_phone    || store.storePhone    || '' },
            { icon: '🕐', value: store.store_hours    || store.storeHours    || store.operating_hours || '' }
        ];
        infoItems.forEach(function (item) {
            if (!item.value) return;
            const row = document.createElement('div');
            row.className = 'do-info-row';
            row.textContent = item.icon + ' ' + item.value;
            infoList.appendChild(row);
        });

        // 진료 가능 동물
        const animalsEl = document.getElementById('do-animals');
        animalsEl.replaceChildren();
        const animals = store.animals || store.pet_types || store.petTypes || '';
        if (animals) {
            const label = document.createElement('div');
            label.className = 'do-animals-label';
            label.textContent = '진료 가능 동물';
            const tags = document.createElement('div');
            tags.className = 'do-animals-tags';
            String(animals).split(/[,，]/).forEach(function (a) {
                const tag = document.createElement('span');
                tag.className = 'animal-tag';
                tag.textContent = a.trim();
                tags.appendChild(tag);
            });
            animalsEl.appendChild(label);
            animalsEl.appendChild(tags);
        }

        // 리뷰 목록
        const reviewList  = document.getElementById('do-review-list');
        const reviewCount = document.getElementById('do-review-count');
        reviewList.replaceChildren();
        reviewCount.textContent = reviews.length ? reviews.length + '건' : '';

        if (!reviews.length) {
            const empty = document.createElement('div');
            empty.className = 'review-empty';
            empty.textContent = '아직 리뷰가 없습니다.';
            reviewList.appendChild(empty);
        } else {
            reviews.slice(0, 5).forEach(function (r) {
                const item = document.createElement('div');
                item.className = 'review-item';

                const top = document.createElement('div');
                top.className = 'review-top';

                const writer = document.createElement('span');
                writer.className = 'review-writer';
                writer.textContent = r.user_name || r.userName || '익명';

                const stars = document.createElement('span');
                stars.className = 'review-stars';
                const score = Number(r.rating || r.review_rating || 0);
                stars.textContent = '★'.repeat(score) + '☆'.repeat(5 - score);

                top.appendChild(writer);
                top.appendChild(stars);

                const content = document.createElement('div');
                content.className = 'review-content';
                content.textContent = r.review_content || r.reviewContent || '';

                item.appendChild(top);
                item.appendChild(content);
                reviewList.appendChild(item);
            });
        }

        // 리뷰쓰기 버튼 – storeNumber 담아서 이동
        document.getElementById('btn-write-review').onclick = function () {
            location.href = '/review/write?storeNumber=' + storeNumber;
        };

        document.getElementById('detail-overlay').classList.add('open');

    } catch (e) {
        console.warn('Detail load error:', e.message);
        alert('가게 정보를 불러오는 중 오류가 발생했습니다.');
    }
}

/* =====================================================
   오버레이 닫기
   ===================================================== */

function initCloseHandlers() {
    document.getElementById('btn-detail-close').addEventListener('click', function () {
        document.getElementById('detail-overlay').classList.remove('open');
        document.querySelectorAll('.post-card').forEach(function (c) { c.classList.remove('active'); });
    });
}

/* =====================================================
   초기 실행
   ===================================================== */

document.addEventListener('DOMContentLoaded', function () {
    const container    = document.getElementById('board-data');
    state.myUserNumber = container.dataset.myUserNumber
        ? Number(container.dataset.myUserNumber) : null;
    state.category     = container.dataset.category || 'hospital';

    // 초기 패널 타이틀
    const titleEl = document.getElementById('panel-title');
    if (titleEl) titleEl.textContent = PANEL_TITLE[state.category] || '찾기';

    // 초기 칩 active 동기화
    document.querySelectorAll('.cat-chip').forEach(function (btn) {
        btn.classList.toggle('active', btn.dataset.cat === state.category);
    });

    initSearch();
    initCategoryFilter();
    initCloseHandlers();

    // 초기 목록 로드
    loadStores();

    // 카카오 지도
    if (typeof kakao !== 'undefined' && kakao.maps) {
        kakao.maps.load(initKakaoMap);
    } else {
        window.kakaoMapReady = initKakaoMap;
        initKakaoMap();
    }
});