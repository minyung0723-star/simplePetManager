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
    public void add(HttpServletResponse res, String name, String value, int maxAgeSeconds){ // 쿠키 추가
        Cookie cookie = new Cookie(name, value);
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge(maxAgeSeconds);
        res.addCookie(cookie);
    }

    public void delete(HttpServletResponse res, String name){ // 쿠키 삭제
        Cookie cookie = new Cookie(name,"");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        res.addCookie(cookie);
    }

    public String get(HttpServletRequest req, String name){ // 쿠키 요청해서 가져오기
        Cookie[] cookies = req.getCookies();
        if (cookies == null) return null;
        return Arrays.stream(cookies)
                .filter(c -> name.equals(c.getName()))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
    }
}
