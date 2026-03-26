<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- ✅ Bootstrap CSS 합칠 때 에러나면 봐야할 곳-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header_design.css">

</head>


<body>

<header class="header">
    <!-- 이미지 경로 불안정, 에러나면 반드시 살펴볼 것 -->
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/petlogo.png">
        </a>
    </div>

    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/board/boardList">동물병원찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList">동물호텔찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList">동물약국찾기</a>
    </nav>

    <div class="header-actions">
        <div class="header-actions">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/login" class="btn-login">로그인</a>
                    <a href="${pageContext.request.contextPath}/user/register" class="btn-register">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</header>