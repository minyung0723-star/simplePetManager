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

                // [추가된 로직] 로그인 상태인데 접근하면 안 되는 주소들 체크
                String uri = request.getRequestURI();
                if (uri.contains("/login") || uri.contains("/register") ||
                        uri.contains("/findUser") || uri.contains("/passwordEdit")) {

                    // 메인 페이지로 돌려보내고 메시지 전달 (선택사항)
                    response.sendRedirect(request.getContextPath() + "/?LoggedIn=true");
                    return false; // 컨트롤러 실행 중단
                }
            }
        }
        return true;
    }
}