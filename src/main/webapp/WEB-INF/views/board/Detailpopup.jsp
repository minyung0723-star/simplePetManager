<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<div id="popup" class="popup">
    <div class="popup-title">
        <h3 id="storeName">${board.storeName}</h3>
        <a href="/review/reviewPage?storeId=${board.storeId}">[리뷰보기]</a>
    </div>

    <img id="storeImg" class="popup-img" src="${board.storeImage}" alt="가게 이미지">

    <div class="popup-info">
        <div class="popup-row">
            <span class="label">전화</span>
            <span id="storePhone">${board.storePhone}</span>
        </div>
        <div class="popup-row">
            <span class="label">주소</span>
            <span id="storeAddress">${board.storeAddress}</span>
        </div>
        <div class="popup-bookmark-row">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <button class="btn-bookmark ${isBookmarked ? 'active' : ''}"
                            id="bookmarkBtn"
                            data-user-number="${loginUser.userNumber}"
                            data-store-id="${board.storeId}"
                            data-lat="${board.latitude  != null ? board.latitude  : 0}"
                            data-lng="${board.longitude != null ? board.longitude : 0}"
                            onclick="toggleBookmark(this)"
                            title="즐겨찾기">
                        <i id="bookmarkIcon"
                           class="bi ${isBookmarked ? 'bi-star-fill' : 'bi-star'}"
                           style="${isBookmarked ? 'color:gold;' : ''}"></i>
                        <span class="bookmark-label">즐겨찾기</span>
                    </button>
                </c:when>
                <c:otherwise>
                    <button class="btn-bookmark" id="bookmarkBtn" onclick="goLogin()">
                        <i id="bookmarkIcon" class="bi bi-star" style="color:#ddd;"></i>
                        <span class="bookmark-label" style="color:#bbb;">
                            <a href="/login" style="color:#7a9fdb; text-decoration:none;">로그인</a>하면 즐겨찾기 가능
                        </span>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function goLogin() {
        if (confirm("즐겨찾기는 로그인 후 이용할 수 있습니다.\n로그인 페이지로 이동할까요?")) {
            location.href = "/login";
        }
    }

    async function toggleBookmark(btn) {
        const userNumber = btn.dataset.userNumber;
        const storeId    = btn.dataset.storeId;
        const lat        = parseFloat(btn.dataset.lat) || 0;
        const lng        = parseFloat(btn.dataset.lng) || 0;

        if (!userNumber || !storeId) {
            console.error("즐겨찾기 오류: userNumber 또는 storeId 값이 없습니다.");
            return;
        }

        <%-- 핵심: JSP는 <script> 안의 ${변수}도 EL로 해석한다 --%>
        <%-- 반드시 문자열 연결(+) 방식으로 작성해야 JS 변수가 런타임에 평가됨 --%>
        try {
            const res  = await fetch("/api/bookmark/add", {
                method:  "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body:    "userNumber=" + userNumber + "&storeId=" + storeId
            });
            const data = await res.json();

            const icon = document.getElementById("bookmarkIcon");
            const bookmarkBtn = document.getElementById("bookmarkBtn");

            if (data.bookmarked) {
                icon.className   = "bi bi-star-fill";
                icon.style.color = "gold";
                bookmarkBtn.classList.add("active");

                const storeName    = document.getElementById("storeName")?.innerText    || "";
                const storeAddress = document.getElementById("storeAddress")?.innerText || "";
                if (typeof addBookmarkCard === "function") {
                    addBookmarkCard(storeName, storeAddress, lat, lng);
                }
            } else {
                icon.className   = "bi bi-star";
                icon.style.color = "";
                bookmarkBtn.classList.remove("active");

                const storeName = document.getElementById("storeName")?.innerText || "";
                if (typeof removeBookmarkCard === "function") {
                    removeBookmarkCard(storeName);
                }
            }
        } catch (err) {
            console.error("즐겨찾기 오류:", err);
        }
    }
</script>
