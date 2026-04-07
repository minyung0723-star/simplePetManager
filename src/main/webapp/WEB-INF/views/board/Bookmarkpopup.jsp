<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/resources/css/BookmarkUI.css">

<div class="bookmark-panel">
    <div class="bookmark-panel-header">
        <span>내 즐겨찾기</span>
        <button onclick="closeBookmarkPanel()">✕</button>
    </div>
    <div class="bookmark-tabs">
        <button class="tab-btn active" onclick="switchTab(this)">병원</button>
        <button class="tab-btn" onclick="switchTab(this)">호텔</button>
        <button class="tab-btn" onclick="switchTab(this)">약국</button>
    </div>
    <div class="bookmark-list" id="bookmarkList">
        <c:forEach var="bookmark" items="${bookmarkList}">
            <div class="bookmark-card" onclick="moveToStore(${store.latitude}, ${store.longitude})">
                <div class="bookmark-card-name">${store.storeName}</div>
                <div class="bookmark-card-address">${store.storeAddress}</div>
                <div class="bookmark-card-footer">삭제하기</div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    function moveToStore(lat, lng) {
        var moveLatLng = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLng);
        map.setLevel(3);
    }

    function switchTab(type) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        // 탭별 필터링 로직 추가
    }

    function closeBookmarkPanel() {
        document.querySelector('.bookmark-panel').style.display = 'none';
    }
</script>