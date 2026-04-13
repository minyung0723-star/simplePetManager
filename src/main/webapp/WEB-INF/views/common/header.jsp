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
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/images/petlogo.png">
        </a>
    </div>

    <div id="user-welcome" class="user-welcome-text">
    </div>

    <nav class="header-nav" id="main-nav">
        <a href="${pageContext.request.contextPath}/board/boardList">동물병원찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList">동물호텔찾기</a>
        <a href="${pageContext.request.contextPath}/board/boardList">동물약국찾기</a>
    </nav>

    <div class="header-actions">
        <div id="auth-menu" class="header-actions"></div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        renderHeader();
    });

    function renderHeader() {
        const authMenu = document.getElementById("auth-menu");
        const mainNav = document.getElementById("main-nav");
        const welcomeArea = document.getElementById("user-welcome");

        if (!authMenu || !mainNav || !welcomeArea) return;

        const isLoggedIn = localStorage.getItem("isLoggedIn");
        const userName = localStorage.getItem("userName");

        if (isLoggedIn === "true" && userName) {
            // 1. 환영 문구 표시
            welcomeArea.textContent = userName + "님 환영합니다";

            // 2. 마이페이지 메뉴 추가
            if (!document.getElementById("nav-mypage")) {
                const myPageLink = document.createElement("a");
                myPageLink.href = "${pageContext.request.contextPath}/mypage/myPage";
                myPageLink.id = "nav-mypage";
                myPageLink.textContent = "마이페이지";
                mainNav.appendChild(myPageLink);
            }

            // 3. 로그아웃 버튼
            authMenu.innerHTML = '<a href="javascript:void(0);" onclick="processLogout()" class="btn-logout">로그아웃</a>';
        } else {
            // 로그아웃 상태 시 초기화
            welcomeArea.textContent = "";
            const myPageLink = document.getElementById("nav-mypage");
            if (myPageLink) myPageLink.remove();

            authMenu.innerHTML =
                '<a href="${pageContext.request.contextPath}/login" class="btn-login">로그인</a>' +
                '<a href="${pageContext.request.contextPath}/register" class="btn-register">회원가입</a>';
        }
    }

    async function processLogout() {
        if (!confirm("로그아웃 하시겠습니까?")) return;

        try {

            const res = await fetch("${pageContext.request.contextPath}/api/logout", {
                method: "POST"
            });

            if (res.ok) {
                // localStorage 데이터 삭제
                localStorage.removeItem("isLoggedIn");
                localStorage.removeItem("userName");

                alert("로그아웃 되었습니다.");

                // 메인 페이지로 이동하며 새로고침
                location.href = "${pageContext.request.contextPath}/";
            } else {
                alert("로그아웃 처리 중 서버 오류가 발생했습니다.");
            }
        } catch (error) {
            console.error("Logout Error:", error);
            alert("서버와 통신할 수 없습니다.");
        }
    }
</script>