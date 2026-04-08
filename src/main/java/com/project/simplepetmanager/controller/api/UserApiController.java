package com.project.simplepetmanager.controller.api;

import com.project.simplepetmanager.common.CookieUtil;
import com.project.simplepetmanager.common.EmailCodeService;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import com.project.simplepetmanager.model.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class UserApiController {

    private final UserService userService;
    private final CookieUtil cookieUtil;
    private final UserMapper userMapper;
    private final EmailCodeService emailCodeService;

    /**
     * 회원가입
     * register.jsp에서 fetch로 호출
     */
    @PostMapping("/api/register")
    public ResponseEntity<?> register(@RequestBody User user) {

        userService.register(user);

        return ResponseEntity.ok().build();
    }

    /**
     * 로그인
     * 클라이언트로부터 아이디와 비밀번호를 받아 UserService에서 검증합니다.
     * 인증 성공 시 Access Token과 Refresh Token을 생성하며,
     * 보안을 위해 두 토큰 모두 HttpOnly 쿠키에 저장하여 클라이언트에 전달합니다.
     */
    @PostMapping("/api/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body,
                                   HttpServletResponse response) {
        String userId = body.get("userId");
        String userPassword = body.get("userPassword");

        //  서비스 로직을 통해 토큰 생성 (인증 확인)
        Map<String, String> tokens = userService.login(userId, userPassword);

        if (tokens == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "아이디 또는 비밀번호가 올바르지 않습니다."));
        }

        // 이름(userName)을 가져오기 위해 DB에서 유저 정보 조회
        // (만약 userService.login에서 이미 User 객체를 리턴하게 수정했다면 그 객체를 써도 됩니다)
        User loginUser = userMapper.findByUserId(userId);

        //  토큰 쿠키 저장
        cookieUtil.add(response, "access_token", tokens.get("accessToken"), 60 * 30);
        cookieUtil.add(response, "refresh_token", tokens.get("refreshToken"), 60 * 30 * 24 * 14);

        //  응답 데이터에 userName 추가 (핵심!)
        Map<String, Object> responseBody = new HashMap<>();
        responseBody.put("message", "로그인 성공");
        responseBody.put("userName", loginUser.getUserName()); // JSP에서 data.userName으로 읽게 됨

        return ResponseEntity.ok(responseBody);
    }

    /**
     * 로그아웃
     * 서버 측 보관함(Map 또는 Redis)에서 해당 유저의 리프레시 토큰을 제거합니다.
     * 브라우저에 저장된 액세스 토큰과 리프레시 토큰 쿠키를 삭제하여 세션을 종료합니다.
     */
    @PostMapping("/api/logout")
    public ResponseEntity<?> logout(@AuthenticationPrincipal String email, HttpServletResponse response) {
        // 서버 메모리에서 리프레시 토큰 삭제
        userService.logout(email);

        // 클라이언트 쿠키 삭제
        cookieUtil.delete(response, "access_token");
        cookieUtil.delete(response, "refresh_token");

        return ResponseEntity.ok(Map.of("message", "로그아웃 완료"));
    }

    /**
     * 토큰 재발급
     * 액세스 토큰이 만료되었을 때, 쿠키에 담긴 리프레시 토큰을 확인합니다.
     * 리프레시 토큰이 유효하다면 사용자가 다시 로그인할 필요 없이
     * 새로운 액세스 토큰을 발급하여 흐름을 유지합니다.
     */
    @PostMapping("/api/token/refresh")
    public ResponseEntity<?> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        // 쿠키에서 리프레시 토큰 추출
        String refreshToken = cookieUtil.get(request, "refresh_token");

        if (refreshToken == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "다시 로그인해주세요."));
        }

        // 서비스 로직을 통해 새로운 액세스 토큰 생성 시도
        String newAccessToken = userService.tokenRefresh(refreshToken);

        if (newAccessToken == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("message", "세션이 만료되었습니다. 다시 로그인해주세요."));
        }

        // 새롭게 발급된 액세스 토큰을 쿠키에 업데이트
        cookieUtil.add(response, "access_token", newAccessToken, 60 * 30);

        return ResponseEntity.ok(Map.of("message", "토큰 재발급 완료"));
    }

    /**
     * 아이디 찾기
     */
    @PostMapping("/api/find-id")
    public ResponseEntity<?> findId(@RequestBody Map<String, String> body) {
        String userName = body.get("userName");
        String userEmail = body.get("userEmail");

        String foundId = userService.findUserId(userName, userEmail);

        if (foundId == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "일치하는 정보가 없습니다."));
        }

        return ResponseEntity.ok(Map.of("userId", foundId));
    }

    /**
     * 비밀번호 찾기 전 사용자 검증
     */
    @PostMapping("/api/verify-for-pw")
    public ResponseEntity<?> verifyForPw(@RequestBody Map<String, String> body, HttpSession session) {
        String userId = body.get("userId");
        String userEmail = body.get("userEmail");

        boolean isValid = userService.verifyUser(userId, userEmail);

        if (!isValid) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "정보가 일치하지 않습니다."));
        }

        // [핵심 추가] 인증 성공 시 세션에 아이디 저장!!
        // 이 코드가 있어야 인터셉터가 verifiedUserId를 찾을 수 있습니다.
        session.setAttribute("verifiedUserId", userId);
        session.setMaxInactiveInterval(300); // 5분간 허용

        return ResponseEntity.ok().build();
    }

    /**
     * 비밀번호 재설정
     */
    @PostMapping("/api/update-password")
    public ResponseEntity<?> updatePassword(@RequestBody Map<String, String> body) {
        String userId = body.get("userId");
        String userPassword = body.get("userPassword");

        if (userId == null || userPassword == null || userPassword.trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "유효하지 않은 요청입니다."));
        }

        boolean isUpdated = userService.updatePassword(userId, userPassword);

        if (!isUpdated) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "비밀번호 변경 중 오류가 발생했습니다."));
        }

        return ResponseEntity.ok(Map.of("message", "비밀번호가 변경되었습니다."));
    }

    /**
     * 이메일 인증번호 발송
     */
    @PostMapping("/api/email-auth")
    public ResponseEntity<?> sendEmailCode(@RequestBody Map<String, String> body) {
        String email = body.get("userEmail");
        String mode = body.get("mode"); // 프론트에서 보낸 mode 값 확인

        // 회원가입일 때만 중복 체크 실행
        if (!"findPw".equals(mode)) {
            if (userService.isEmailDuplicate(email)) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "이미 사용 중인 이메일입니다."));
            }
        }

        // 2. 중복이 아닐 때만 메일 발송
        emailCodeService.sendVerificationCode(email);
        return ResponseEntity.ok(Map.of("message", "인증번호 발송 완료"));
    }

    /**
     * 이메일 인증번호 검증
     */
    @PostMapping("/api/email-verify")
    public ResponseEntity<?> verifyEmailCode(@RequestBody Map<String, String> body, HttpSession session) {
        String email = body.get("userEmail");
        String code = body.get("emailCode");
        String userId = body.get("userId"); // 프론트에서 userId도 같이 보내주도록 수정 필요

        boolean isMatch = emailCodeService.verifyCode(email, code);

        if (isMatch) {
            // [핵심] 세션에 비밀번호 변경 권한을 임시 저장 (3분 정도만 유효)
            session.setAttribute("verifiedUserId", userId);
            session.setMaxInactiveInterval(180); // 3분 후 자동 만료

            return ResponseEntity.ok(Map.of("message", "인증 성공"));
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "인증번호 불일치"));
        }
    }

    /**
     * 아이디 중복 체크 [추가]
     */
    @GetMapping("/api/check-id")
    public ResponseEntity<?> checkId(@RequestParam("userId") String userId) {
        boolean isDuplicate = userService.isIdDuplicate(userId);
        return ResponseEntity.ok(Map.of("isDuplicate", isDuplicate));
    }

}