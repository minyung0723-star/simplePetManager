package com.project.simplepetmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReviewController {

    // 병원 상세 정보 페이지 (로그인 안 해도 볼 수 있음!)
    @GetMapping("/api/hospital/detail")
    public String openDetailPage() {
        return "review/reviewPage";
    }

    // 리뷰 작성 페이지 (이건 로그인이 '필요')
    @GetMapping("/review/create")
    public String openCreatePage() {
        // 여기서 세션 체크해서 비로그인이면 /user/login으로 보낼 거야!
        return "review/createreviewPage";
    }

}
