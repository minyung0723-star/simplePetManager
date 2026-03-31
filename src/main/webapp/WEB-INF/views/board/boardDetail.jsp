<%@ page contentType="text/html; charset=UTF-8" language="java"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <title>카카오맵 마커</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/kakao-map.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/detailUI.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">

</head>
<body>
<%@ include file="../common/header.jsp"%>

<div style="display:flex; justify-content:center; gap:32px; padding:80px 40px;;">

    <div style="width:320px;">
    </div>
    <div id="map" style="width:1000px; height:550px;"></div>
    <div style="width: 320px;"></div>
</div>

<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=695388472b1552749308a93b8da89e82"></script>
<script>
    var container = document.getElementById('map');
    var options = {
        center: new kakao.maps.LatLng(33.450701, 126.570667),
        level: 3
    };

    var map = new kakao.maps.Map(container, options);

    // 지도를 표시할 div와  지도 옵션으로 지도를 생성합니다

</script>

<script>
    window.onload = function() {
        const first = document.querySelector(".store-data");

        if (!first) {
            console.log("❌ 데이터 없음");
            return;
        }

        document.getElementById("name").innerText = first.dataset.name;
        document.getElementById("phone").innerText = first.dataset.phone;
        document.getElementById("address").innerText = first.dataset.address;
        document.getElementById("popup").classList.remove("hidden");

        document.getElementById("popup").classList.add("show");
    };
</script>
<c:forEach var="store" items="${stores}">  <%-- ✅ stores --%>

    <%-- 마커 --%>
    <script>
    window.onload = function() {
    const first = document.querySelector(".store-data");
    if (!first) return;
    // 나머지는 data-* 속성으로 읽으므로 그대로 유지
    };
    </script></c:forEach>
<%@ include file="../board/Detailpopup.jsp" %>
<%@include file="../common/footer.jsp"%>
</body>

