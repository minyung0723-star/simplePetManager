<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <title>상세보기</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/detailUI.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/BookmarkUI.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="../common/header.jsp"%>

<%-- 3컬럼: 왼쪽패널 | 지도 | 오른쪽패널 --%>
<div id="detailLayout">

    <%-- 왼쪽: 상세 팝업 --%>
    <div id="leftPanel">
        <%@ include file="../board/Detailpopup.jsp" %>
    </div>

    <%-- 가운데: 카카오 지도 --%>
    <div id="map"></div>

    <%-- 오른쪽: 즐겨찾기 패널 --%>
    <div id="rightPanel">
        <%@ include file="../board/Bookmarkpopup.jsp" %>
    </div>

</div>

<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=695388472b1552749308a93b8da89e82"></script>
<style>
    #detailLayout {
        display: flex;
        width: 100%;
        height: calc(100vh - 100px); /* 헤더/푸터 높이를 제외한 나머지 전체 */
    }
</style>
<script>
    var lat = ${board.latitude != null ? board.latitude : 37.5665};
    var lng = ${board.longitude != null ? board.longitude : 126.9780};

    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);

    var markerPosition = new kakao.maps.LatLng(lat, lng);
    var marker = new kakao.maps.Marker({ position: markerPosition });
    marker.setMap(map);

    const isLogin = ${not empty loginUser};
</script>

<%@ include file="../common/footer.jsp"%>
</body>
