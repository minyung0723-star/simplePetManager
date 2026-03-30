package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserApiController {

    private final UserService userService;
    private final JwtUtil     jwtUtil;
    private final CookieUtil  cookieUtil;

    /**
     * 회원가입
     * POST /user/register
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody User user) {
        //
        return ResponseEntity.ok(userService.register(user));
    }

    /**
     * 로그인
     * POST /user/login
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, Object> body,
            HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        String userEmail = (String) body.get("userEmail");
        String rawPw     = (String) body.get("userPassword");

        //
        if (userEmail == null || rawPw == null) {
            result.put("success", false);
            result.put("message", "이메일과 비밀번호를 입력해주세요.");
            return ResponseEntity.ok(result);
        }

        User user = userService.login(userEmail, rawPw);
        if (user == null) {
            result.put("success", false);
            result.put("message", "이메일 또는 비밀번호가 올바르지 않습니다.");
            return ResponseEntity.ok(result);
        }

        // 수정: JwtUtil의 createAccessToken 메서드 호출
        String token = jwtUtil.createAccessToken(user.getUserEmail());

        // 수정: CookieUtil의 add 메서드 호출 (24시간 = 86400초)
        cookieUtil.add(response, "access_token", token, 60 * 60 * 24);

        result.put("success", true);
        result.put("message", "로그인되었습니다.");
        return ResponseEntity.ok(result);
    }

    /**
     * 로그아웃 (쿠키 삭제)
     * POST /user/logout
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpServletResponse response) {
        // 수정: CookieUtil의 remove 메서드 호출
        cookieUtil.remove(response, "access_token");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "로그아웃되었습니다.");
        return ResponseEntity.ok(result);
    }

    /**
     * 로그인 상태 확인
     * GET /user/profile-info
     */
    @GetMapping("/profile-info")
    public ResponseEntity<Map<String, Object>> profileInfo(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        // 수정: CookieUtil의 get 메서드 호출
        String token = cookieUtil.get(request, "access_token");

        if (token == null || !jwtUtil.isValidToken(token)) {
            result.put("loggedIn", false);
            return ResponseEntity.ok(result);
        }

        User user = userService.getUserByEmail(jwtUtil.getEmail(token));
        if (user == null) {
            result.put("loggedIn", false);
            return ResponseEntity.ok(result);
        }

        result.put("loggedIn",   true);
        result.put("userNumber", user.getUserNumber());
        result.put("userName",   user.getUserName());
        result.put("userEmail",  user.getUserEmail());
        return ResponseEntity.ok(result);
    }

    /**
     * 이메일 중복 확인
     */
    @GetMapping("/check-email")
    public ResponseEntity<Map<String, Object>> checkEmail(@RequestParam String userEmail) {
        Map<String, Object> result = new HashMap<>();
        boolean exists = userService.getUserByEmail(userEmail) != null;
        result.put("exists",  exists);
        result.put("message", exists ? "이미 사용 중인 이메일입니다." : "사용 가능한 이메일입니다.");
        return ResponseEntity.ok(result);
    }
}