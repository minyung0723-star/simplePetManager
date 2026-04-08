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
    즐겨찾기
</button>
<script>
    function moveToStore(lat, lng) {
        var moveLatLng = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLng);
        map.setLevel(3);
    }

    function closeBookmarkPanel() {
        // 1. 즐겨찾기 패널을 숨깁니다.
        document.querySelector('.bookmark-panel').style.display = 'none';

        // 2. 숨겨져 있던 '즐겨찾기 열기' 버튼을 보이게 합니다.
        const openBookmarkBtn = document.getElementById("openBookmarkBtn"); // 버튼 ID 확인!
        if (openBookmarkBtn) {
            openBookmarkBtn.style.display = "block";
        }
    }

    // 반대로 버튼을 눌러서 팝업을 열 때의 함수도 필요합니다.
    function openBookmarkPanel() {
        document.querySelector('.bookmark-panel').style.display = 'block';
        document.getElementById("openBookmarkBtn").style.display = "none";
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