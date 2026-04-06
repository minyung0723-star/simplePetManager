package com.project.simplepetmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReviewController {
    @GetMapping("/hospital/detail")
    public String openDetailPage() {
        return "review/hospitalDetail"; // 빈 껍데기 JSP만 보냅니다.
    }
}
