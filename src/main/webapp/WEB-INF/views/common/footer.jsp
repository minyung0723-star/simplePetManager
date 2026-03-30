<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- Bootstrap JS는 footer에서 로드 (CSS는 header에서만 로드) --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<footer class="py-5">
    <div class="container footer-container">

        <div class="footer-left d-flex">
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/images/petlogo.png" alt="로고">
            </div>

            <div>
                <div class="footer-links">
                    <a href="#">서비스 이용약관</a>
                    <a href="#">개인정보 처리방침</a>
                </div>
                <div class="footer-info">
                    서울특별시 종로구 더조은 아카데미 대왕빌딩 9층 | 대표자: 김없음<br>
                    사업자등록번호: 123-45-67890 | 통신판매업 신고번호: 2026-아카데미-0310 | FAX: 012-3456-7890<br>
                    <strong>Copyright © petmanager.com. All rights reserved.</strong>
                </div>
            </div>
        </div>

        <div class="footer-right">
            <div>
                <span class="customer-title">고객센터</span>
                <span class="customer-phone">1234-5678</span>
            </div>
            <div class="operating-time">
                운영시간: 09:00 - 18:00 | 점심시간: 11:30 - 12:30<br>
                (주말, 공휴일 제외)
            </div>
        </div>

    </div>
</footer>

</body>
</html>
