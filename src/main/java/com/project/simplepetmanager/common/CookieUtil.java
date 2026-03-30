package com.project.simplepetmanager.common;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Arrays;
@Slf4j
@Component
public class CookieUtil {
    // 쿠키 추가 (maxAgeSeconds: 초 단위)
    public void add(HttpServletResponse res, String name, String value, int maxAgeSeconds){
        Cookie cookie = new Cookie(name, value);
        cookie.setHttpOnly(true); // JS에서 접근 불가 (보안)
        cookie.setPath("/");      // 모든 경로에서 쿠키 유효
        cookie.setMaxAge(maxAgeSeconds);
        res.addCookie(cookie);
    }

    // 쿠키 삭제
    public void remove(HttpServletResponse res, String name){
        Cookie cookie = new Cookie(name, "");
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge(0); // 즉시 만료
        res.addCookie(cookie);
    }

    // 쿠키 가져오기
    public String get(HttpServletRequest req, String name){
        Cookie[] cookies = req.getCookies();
        if (cookies == null) return null;
        return Arrays.stream(cookies)
                .filter(c -> name.equals(c.getName()))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
    }
}