package com.project.simplepetmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReviewController {

      private final JwtUtil    jwtUtil;
      private final CookieUtil cookieUtil;

    /**
     * 병원 상세 + 리뷰 목록 페이지 (비로그인도 열람 가능)
     * 주소: /api/hospital/detail?storeId=1
     */
    @GetMapping("/api/hospital/detail")
    public String openDetailPage() {
        // 비로그인도 볼 수 있는 페이지 → 로그인 체크 없음 (현재 올바름)
        return "review/reviewPage";
    }

    /**
     * 리뷰 작성 페이지 (로그인 필수)
     * 주소: /review/create
     *
     * TODO_4 ___________________________________________
     * 현재는 비로그인 상태로도 이 URL 직접 입력 시 접근 가능한 보안 구멍 존재
     * 파라미터에 HttpServletRequest request 추가 후 아래 로직 적용:
     *
     * public String openCreatePage(HttpServletRequest request) {
     *     String token = cookieUtil.get(request, "access_token");
     *     if (token == null || !jwtUtil.isValidToken(token)) {
     *         return "redirect:/login"; // 비로그인 → 로그인 페이지로 강제 이동
     *     }
     *     return "review/createreviewPage";
     * }
     */
    @GetMapping("/review/create")
    public String openCreatePage(HttpServletRequest request) {
        String token = cookieUtil.get(request, "access_token");
        if(token == null || !jwtUtil.isValidToken(token)) {
            return "redirect:/login"; // 비로그인 -> 로그인 페이지로 강제 이동
        }
        return "review/createreviewPage";
    }



    // TODO_5 ___________________________________________
    //  /review/createreviewPage 경로도 추가 필요
    //  review-list.js 의 checkUserLogin() 에서
    //  location.href = `/review/createreviewPage?storeId=...` 로 이동하고 있음
    //  현재 매핑된 경로는 /review/create 이므로 경로 불일치 발생
    //  둘 중 하나로 통일:
    //  a) JS에서 /review/create 로 변경
    //  b) 여기에 @GetMapping("/review/createreviewPage") 추가
    // a로 변경!

}