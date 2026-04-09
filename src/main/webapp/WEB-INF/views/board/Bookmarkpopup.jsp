<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>


<div class="bookmark-panel">
    <div class="bookmark-panel-header">
        <span>내 즐겨찾기</span>
        <button onclick="closeBookmarkPanel()">✕</button>
    </div>

    <div class="bookmark-list" id="bookmarkList">
        <c:forEach var="bookmark" items="${bookmarkList}">
            <div class="bookmark-card" onclick="moveToStore(${bookmark.latitude}, ${bookmark.longitude})">
                <div class="bookmark-card-name">${bookmark.storeName}</div>
                <div class="bookmark-card-address">${bookmark.storeAddress}</div>
                <div class="bookmark-card-footer">삭제하기</div>
            </div>
        </c:forEach>
    </div>
</div>
<button id="openBookmarkBtn" class="open-bookmark-btn" onclick="openBookmarkPanel()" style="display: none;">
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star-fill" viewBox="0 0 16 16">
        <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/>
    </svg>
</button>
<script>
    function moveToStore(lat, lng) {
        var moveLatLng = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLng);
        map.setLevel(3);
    }

    function closeBookmarkPanel() {
        // 1. 즐겨찾기 패널 숨기기
        document.querySelector('.bookmark-panel').style.display = 'none';

        // 2. 별 버튼 보이기
        const openBtn = document.getElementById("openBookmarkBtn");
        if (openBtn) {
            openBtn.style.display = "flex"; // CSS에서 flex를 썼으므로 flex로 설정
        }
    }

    function openBookmarkPanel() {
        // 1. 즐겨찾기 패널 보이기
        document.querySelector('.bookmark-panel').style.display = 'block';

        // 2. 별 버튼 숨기기
        const openBtn = document.getElementById("openBookmarkBtn");
        if (openBtn) {
            openBtn.style.display = "none";
        }
    }
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