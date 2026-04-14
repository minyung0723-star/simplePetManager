<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

    <%--
         추가 팁: 헤더 디자인 CSS 파일에 아래 내용을 넣어도 되지만,
         여기에 바로 스타일을 살짝 추가해서 레이아웃을 잡아줄 수도 있어!
    --%>
    <style>
        /* 모든 페이지의 기본 레이아웃을 Flexbox로 설정 */
        body {
            display: flex !important;
            flex-direction: column !important;
            min-height: 100vh !important;
            margin: 0;
        }
    </style>
</head>

<%--
     ✅ 핵심 수정: body 태그에 부트스트랩 클래스 추가
     d-flex: 플렉스 박스 사용
     flex-column: 위에서 아래로 쌓기
     min-vh-100: 최소 높이를 화면 꽉 차게
--%>
<body class="d-flex flex-column min-vh-100">

<header class="header">
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/petlogo.png">
        </a>
    </div>

    <div id="user-welcome" class="user-welcome-text">
    </div>

    <nav class="header-nav" id="main-nav">
        <a href="${pageContext.request.contextPath}/board/boardList?category=hospital">동물병원찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList?category=hotel">동물호텔찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList?category=pharmacy">동물약국찾기</a>
    </nav>

    <div class="header-actions">
        <div id="auth-menu" class="header-actions"></div>
    </div>
</header>