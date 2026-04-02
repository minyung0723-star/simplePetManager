package com.project.simplepetmanager.common;

import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class LoginInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;
    private final CookieUtil cookieUtil;
    private final UserMapper userMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 쿠키에서 access_token 꺼내기
        String token = cookieUtil.get(request, "access_token");
        // 2. 토큰이 존재하고 유효한지 검증
        if (token != null && jwtUtil.isValidToken(token)) {
            // 3. 토큰에서 이메일 정보 추출
            String email = jwtUtil.getEmail(token);
            // 4. 이메일을 기반으로 DB에서 사용자 정보 조회
            User loginUser = userMapper.login(email);

            if (loginUser != null) {
                request.setAttribute("loginUser", loginUser);
            }
        }
        return true;
    }
}