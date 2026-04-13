<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<c:choose>
    <c:when test="${not empty loginUser}">
        <div class="bookmark-panel" id="bookmarkPanel">
            <div class="bookmark-panel-header">
                <span>내 즐겨찾기</span>
                <button onclick="closeBookmarkPanel()" title="닫기">✕</button>
            </div>
            <div class="bookmark-list" id="bookmarkList">
                <c:choose>
                    <c:when test="${not empty bookmarkList}">
                        <c:forEach var="bookmark" items="${bookmarkList}">
                            <div class="bookmark-card"
                                 data-store-id="${bookmark.storeId}"
                                 data-store-name="${bookmark.storeName}"
                                 onclick="moveToStore(${bookmark.latitude}, ${bookmark.longitude})">
                                <div class="bookmark-card-name">${bookmark.storeName}</div>
                                <div class="bookmark-card-address">${bookmark.storeAddress}</div>
                                <div class="bookmark-card-footer"
                                     onclick="event.stopPropagation(); deleteBookmarkFromPanel(${loginUser.userNumber}, ${bookmark.storeId}, this)">
                                    삭제하기
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div id="emptyBookmark" style="text-align:center; padding:32px 0; color:#bbb; font-size:13px;">
                            <i class="bi bi-star" style="font-size:28px; display:block; margin-bottom:8px;"></i>
                            즐겨찾기한 곳이 없어요
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 패널 닫혔을 때 열기 버튼 --%>
        <button id="openBookmarkBtn" class="open-bookmark-btn" onclick="openBookmarkPanel()" title="즐겨찾기 열기">
            <i class="bi bi-star-fill"></i>
        </button>
    </c:when>

    <c:otherwise>
        <div class="bookmark-panel" id="bookmarkPanel">
            <div class="bookmark-panel-header">
                <span>내 즐겨찾기</span>
                <button onclick="closeBookmarkPanel()" title="닫기">✕</button>
            </div>
            <div style="text-align:center; padding:40px 20px; color:#999; font-size:13px; line-height:1.8;">
                <i class="bi bi-lock" style="font-size:32px; display:block; margin-bottom:12px; color:#ccc;"></i>
                로그인 후 즐겨찾기를<br>이용할 수 있어요<br><br>
                <a href="/login"
                   style="display:inline-block; padding:8px 24px; background:#b5c8e8;
                          color:#fff; border-radius:20px; text-decoration:none;
                          font-size:13px; font-weight:600;">
                    로그인하기
                </a>
            </div>
        </div>

        <button id="openBookmarkBtn" class="open-bookmark-btn" onclick="openBookmarkPanel()" title="즐겨찾기 열기">
            <i class="bi bi-star"></i>
        </button>
    </c:otherwise>
</c:choose>

<script>
    /* ── 패널 열기 / 닫기 ─────────────────────────── */
    function closeBookmarkPanel() {
        document.getElementById("bookmarkPanel").style.display = "none";
        document.getElementById("openBookmarkBtn").style.display = "flex"; // ← flex 로 보여야 동그라미 정렬
    }

    function openBookmarkPanel() {
        document.getElementById("bookmarkPanel").style.display = "flex";
        document.getElementById("openBookmarkBtn").style.display = "none";
    }

    /* ── 지도 이동 ────────────────────────────────── */
    function moveToStore(lat, lng) {
        if (typeof map === "undefined") return;
        var moveLatLng = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLng);
        map.setLevel(3);
    }

    /* ── 즐겨찾기 추가 시 패널에 카드 실시간 추가 ── */
    function addBookmarkCard(storeName, storeAddress, lat, lng) {
        const list = document.getElementById("bookmarkList");
        if (!list) return;

        // 빈 상태 메시지 제거
        const empty = document.getElementById("emptyBookmark");
        if (empty) empty.remove();

        // 이미 같은 카드가 있으면 중복 추가 방지
        const exists = Array.from(list.querySelectorAll(".bookmark-card-name"))
            .some(el => el.innerText === storeName);
        if (exists) return;

        const card = document.createElement("div");
        card.className = "bookmark-card";
        card.setAttribute("data-store-name", storeName);
        card.onclick = () => moveToStore(lat, lng);

        // JSP EL이 ${변수}를 렌더링 시점에 치환하므로 템플릿 리터럴 사용 금지
        // DOM API로 직접 노드 생성해야 JS 런타임 변수값이 정상 반영됨
        const nameEl    = document.createElement("div");
        nameEl.className = "bookmark-card-name";
        nameEl.textContent = storeName;

        const addrEl    = document.createElement("div");
        addrEl.className = "bookmark-card-address";
        addrEl.textContent = storeAddress;

        const footerEl  = document.createElement("div");
        footerEl.className = "bookmark-card-footer";
        footerEl.textContent = "삭제하기";
        footerEl.onclick = function(e) {
            e.stopPropagation();
            removeBookmarkCard(storeName);
        };

        card.appendChild(nameEl);
        card.appendChild(addrEl);
        card.appendChild(footerEl);
        list.appendChild(card);
    }

    /* ── 즐겨찾기 해제 시 패널에서 카드 실시간 제거 + 별 아이콘 동기화 ── */
    function removeBookmarkCard(storeName) {
        const list = document.getElementById("bookmarkList");
        if (!list) return;

        list.querySelectorAll(".bookmark-card").forEach(card => {
            if (card.querySelector(".bookmark-card-name")?.innerText === storeName) {
                card.remove();
            }
        });

        // 현재 상세 페이지의 가게와 같으면 별 아이콘도 해제
        const currentName = document.getElementById("storeName")?.innerText || "";
        if (storeName === currentName) {
            const icon = document.getElementById("bookmarkIcon");
            const btn  = document.getElementById("bookmarkBtn");
            if (icon) { icon.className = "bi bi-star"; icon.style.color = ""; }
            if (btn)  { btn.classList.remove("active"); }
        }

        // 카드가 없으면 빈 상태 메시지 표시
        if (list.querySelectorAll(".bookmark-card").length === 0) {
            list.innerHTML = '<div id="emptyBookmark" style="text-align:center; padding:32px 0; color:#bbb; font-size:13px;"><i class="bi bi-star" style="font-size:28px; display:block; margin-bottom:8px;"></i>즐겨찾기한 곳이 없어요</div>';
        }
    }

    /* ── 패널의 "삭제하기" 버튼 클릭 시 API 호출 후 카드 제거 ── */
    function deleteBookmarkFromPanel(userNumber, storeId, el) {
        fetch("/api/bookmark/delete?userNumber=" + userNumber + "&storeId=" + storeId, {
            method: "DELETE"
        })
            .then(res => {
                if (res.ok) {
                    // 카드 DOM 제거
                    const card = el.closest(".bookmark-card");
                    const storeName = card?.querySelector(".bookmark-card-name")?.innerText || "";
                    card?.remove();

                    // 현재 보고 있는 가게와 같으면 별 아이콘도 비움
                    const currentName = document.getElementById("storeName")?.innerText || "";
                    if (storeName === currentName) {
                        const icon = document.getElementById("bookmarkIcon");
                        const btn  = document.getElementById("bookmarkBtn");
                        if (icon) { icon.className = "bi bi-star"; icon.style.color = ""; }
                        if (btn)  { btn.classList.remove("active"); }
                    }

                    // 카드가 없으면 빈 상태 메시지 표시
                    const list = document.getElementById("bookmarkList");
                    if (list && list.querySelectorAll(".bookmark-card").length === 0) {
                        list.innerHTML = `
                        <div id="emptyBookmark" style="text-align:center; padding:32px 0; color:#bbb; font-size:13px;">
                            <i class="bi bi-star" style="font-size:28px; display:block; margin-bottom:8px;"></i>
                            즐겨찾기한 곳이 없어요
                        </div>`;
                    }
                }
            })
            .catch(err => console.error("즐겨찾기 삭제 오류:", err));
    }
</script>
