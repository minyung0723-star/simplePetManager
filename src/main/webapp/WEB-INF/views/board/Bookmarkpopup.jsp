<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>


<div class="bookmark-panel">
    <div class="bookmark-panel-header">
        <span>내 즐겨찾기</span>
        <button onclick="closeBookmarkPanel()">✕</button>
    </div>

    <div class="bookmark-list" id="bookmarkList">
        <c:forEach var="bookmark" items="${bookmarkList}">
            <div class="bookmark-card" onclick="moveToStore(${board.latitude}, ${board.longitude})">
                <div class="bookmark-card-name">${board.storeName}</div>
                <div class="bookmark-card-address">${board.storeAddress}</div>
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

    function closeBookmarkPanel() {
        document.querySelector('.bookmark-panel').style.display = 'none';
    }
</script>