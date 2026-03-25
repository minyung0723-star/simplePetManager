<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@include file="common/header.jsp"%>
<div class="container mt-4">

    <div id="carouselExample" class="carousel slide">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="../images/pethospital.png" class="d-block w-100" alt="애완동물병원">
            </div>
            <div class="carousel-item">
                <img src="../images/pethotel.png" class="d-block w-100" alt="애완동물호텔">
            </div>
            <div class="carousel-item">
                <img src="../images/petpharmacy.png" class="d-block w-100" alt="애완동물약국">
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

</div>
<%@include file="common/footer.jsp"%>
