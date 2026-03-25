<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="../common/header.jsp"%>
<div class="container mt-4">
    <div class="container mt-5" style="max-width: 400px;">
        <!-- 프로필 -->
        <div class="text-center mb-4">
            <div class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center"
                 style="width:80px; height:80px; margin:auto;">
                김
            </div>
            <div class="mt-2">사진 변경</div>
        </div>

        <hr>

        <!-- 이름 -->
        <div class="mb-3">
            <label>이름</label>
            <input type="text" class="form-control" value="김민지">
        </div>

        <!-- 이메일 -->
        <div class="mb-3">
            <label>이메일</label>
            <input type="email" class="form-control" value="minji@example.com">
        </div>

        <!-- 비밀번호 -->
        <div class="mb-3">
            <label>새 비밀번호</label>
            <input type="password" class="form-control" placeholder="변경할 비밀번호 입력">
        </div>

        <!-- 비밀번호 확인 -->
        <div class="mb-3">
            <label>비밀번호 확인</label>
            <input type="password" class="form-control" placeholder="비밀번호 재입력">
        </div>

        <!-- 버튼 -->
        <div class="d-flex gap-2">
            <button class="btn btn-light w-50">취소</button>
            <button class="btn btn-dark w-50">저장</button>
        </div>

    </div>
</div>
<%@include file="../common/footer.jsp"%>