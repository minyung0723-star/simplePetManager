
<%@ page contentType="text/html; charset=UTF-8" %>

<div id="popup" class="popup">
    <div class="popup-header">
        <div class="popup-handle"></div>
    </div>

    <div class="popup-title">
        <h3 id="storeName">${board.storeName}</h3>
        <a href="/review/reviewPage">[리뷰보기]</a>
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
            <span class="label">전화번호</span>
            <span id="storeAddress">${board.storePhone}</span>
            <button onclick="addBookmark(1, ${bookmark.storeId})">
                즐겨찾기
            </button>
        </div>

    </div>

    <%-- 첫 번째 데이터만 사용
    마커를 2개 이상 화면에 표기하고, 데이터를 많 이 가져올 때 사용
    <c:if test="${not empty boardLists}">
        <c:set var="store" value="${boardLists[0]}"/>
        <script>
            document.getElementById("storeName").innerText = "${store.storeName}";
            document.getElementById("storePhone").innerText = "${store.storePhone}";
            document.getElementById("storeAddress").innerText = "${store.storeAddress}";
        </script>
    </c:if>
    --%>
</div>

<button id="openBtn" class="open-btn" onclick="openPopup()" style="display: none;">
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-list-ul" viewBox="0 0 16 16">
        <path fill-rule="evenodd" d="M5 11.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5m-3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2m0 4a1 1 0 1 0 0-2 1 1 0 0 0 0 2m0 4a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
    </svg>

</button>
<script>
    // 페이지 로드 시 실행되는 부분
    window.onload = function () {
        // 처음엔 팝업이 열려있으므로 버튼을 확실히 숨깁니다.
        const openBtn = document.getElementById("openBtn");
        if (openBtn) openBtn.style.display = "none";

        document.getElementById("popup").classList.add("show");

        // 핸들 클릭 시 닫기
        document.querySelector(".popup-handle").addEventListener("click", function () {
            closePopup();
        });
    };

    function openPopup() {
        document.getElementById("popup").classList.add("show");
        // 팝업 열리면 버튼 숨기기
        document.getElementById("openBtn").style.display = "none";
    }

    function closePopup() {
        document.getElementById("popup").classList.remove("show");
        // 팝업 닫히면 버튼 보여주기
        const btn = document.getElementById("openBtn");
        if (btn) {
            btn.style.display = "block";
            console.log("버튼이 활성화되었습니다."); // 브라우저 F12 콘솔에서 확인용
        }
    }
</script>