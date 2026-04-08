<%@ page contentType="text/html; charset=UTF-8" language="java"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <title>상세보기</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/kakao-map.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/resources/css/detailUI.css">
    <link rel="stylesheet" href="/resources/css/BookmarkUI.css">
</head>
<body>
<%@ include file="../common/header.jsp"%>
<%@ include file="../board/Bookmarkpopup.jsp" %>

<div style="display:flex; justify-content:center; gap:32px; padding:80px 40px;;">
    <div style="display:flex; justify-content:center; max-width:1700px; margin:auto;">
        <div style="width:320px;">
        </div>
        <div id="map"style=" width:1000px; height:630px;"></div>
        <div style="width: 320px;"></div>
    </div>

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=695388472b1552749308a93b8da89e82"></script>
    <script>
        var container = document.getElementById('map');
        var lat = ${store.latitude != null ? store.latitude : 37.5665}; //위도
        var lng = ${store.longitude != null ? store.longitude : 126.9780}; //경도
        var options = {
            center: new kakao.maps.LatLng(lat,lng),
            level: 3
        };


        // 지도를 표시할 div와  지도 옵션으로 지도를 생성합니다

        window.onload = function() {
            document.getElementById("popup").classList.add("show");

            document.querySelector(".popup-header button").addEventListener("click", function() {
                document.getElementById("popup").classList.remove("show");
            });
        };

        var mapContainer = document.getElementById('map'); // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };

        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        // 마커가 표시될 위치입니다
        var markerPosition  = new kakao.maps.LatLng(lat,lng);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            position: markerPosition
        });

        // 마커가 지도 위에 표시되도록 설정합니다
        marker.setMap(map);


        const isLogin = ${not empty loginUser};
        /*
            if (!isLogin) { //연결할 때 살펴볼 것
                document.getElementById("bookmarkBtn")?.style.display = "none";
            }*/

    </script>

    <script>
        function addBookmark(userNumber, storeId) {
            fetch("/api/bookmark/add", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `userNumber=${userNumber}&storeId=${storeId}`
            })
                .then(res => res.text())
                .then(data => {
                    alert("즐겨찾기 추가됨");
                })
                .catch(err => console.error(err));
        }


    </script>

</div>

</body>
<%@include file="../common/footer.jsp"%>
<%@ include file="../board/Detailpopup.jsp" %>

