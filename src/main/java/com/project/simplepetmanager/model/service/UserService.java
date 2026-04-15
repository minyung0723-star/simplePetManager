package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.common.EmailCodeService;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper            userMapper;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil               jwtUtil;

    // 리프레시 토큰 인메모리 보관 (운영 환경에서는 Redis 권장)
    private final Map<String, String> refreshTokenStorage = new ConcurrentHashMap<>();

    // 비밀번호 정책: 8자 이상, 대문자·소문자·숫자·특수문자(!@#$) 필수
    private static final String PW_PATTERN =
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$])[A-Za-z\\d!@#$]{8,}$";

    // ──────────────────────────────────────────────
    // 회원가입
    // ──────────────────────────────────────────────

    @Transactional
    public void register(User user) {
        if (userMapper.checkEmail(user.getUserEmail()) > 0) {
            throw new RuntimeException("이미 사용중인 이메일입니다.");
        }
        if (user.getUserPassword() == null || !user.getUserPassword().matches(PW_PATTERN)) {
            throw new RuntimeException("비밀번호는 8자 이상이며 영문 대/소문자, 숫자, 특수문자(!@#$)를 모두 포함해야 합니다.");
        }
        user.setUserPassword(passwordEncoder.encode(user.getUserPassword()));
        userMapper.register(user);
    }

    // ──────────────────────────────────────────────
    // 로그인
    // ──────────────────────────────────────────────

    public Map<String, String> login(String userId, String inputPassword) {
        User user = userMapper.findByUserId(userId);
        if (user == null || !passwordEncoder.matches(inputPassword, user.getUserPassword())) {
            return null;
        }

        String email        = user.getUserEmail();
        String accessToken  = jwtUtil.createAccessToken(email);
        String refreshToken = jwtUtil.createRefreshToken(email);

        refreshTokenStorage.put(email, refreshToken);

        return Map.of("accessToken", accessToken, "refreshToken", refreshToken);
    }

    // ──────────────────────────────────────────────
    // 로그아웃
    // ──────────────────────────────────────────────

    public void logout(String email) {
        refreshTokenStorage.remove(email);
    }

    // ──────────────────────────────────────────────
    // 토큰 재발급
    // ──────────────────────────────────────────────

    public String tokenRefresh(String refreshToken) {
        if (!jwtUtil.isValidToken(refreshToken)) return null;
        String email = jwtUtil.getEmail(refreshToken);
        String stored = refreshTokenStorage.get(email);
        if (stored == null || !stored.equals(refreshToken)) return null;
        return jwtUtil.createAccessToken(email);
    }

    // ──────────────────────────────────────────────
    // 유저 조회
    // ──────────────────────────────────────────────

    /** 아이디로 유저 조회 — Controller에서 Mapper 직접 호출 대신 이 메서드 사용 */
    public User findByUserId(String userId) {
        return userMapper.findByUserId(userId);
    }

    /** 이메일로 유저 조회 (JWT → 이메일 → 유저) */
    public User getUserByEmail(String email) {
        return userMapper.findByUserEmail(email);
    }

    // ──────────────────────────────────────────────
    // 아이디·이메일 찾기 / 검증
    // ──────────────────────────────────────────────

    public String findUserId(String userName, String userEmail) {
        return userMapper.findId(userName, userEmail);
    }

    public boolean verifyUser(String userId, String userEmail) {
        return userMapper.verifyPw(userId, userEmail) > 0;
    }

    public boolean isEmailDuplicate(String email) {
        return userMapper.checkEmail(email) > 0;
    }

    public boolean isIdDuplicate(String userId) {
        return userMapper.findByUserId(userId) != null;
    }

    // ──────────────────────────────────────────────
    // 비밀번호 변경 (비밀번호 찾기 경로)
    // ──────────────────────────────────────────────

    @Transactional
    public boolean updatePassword(String userId, String newPassword) {
        if (newPassword == null || !newPassword.matches(PW_PATTERN)) return false;

        User user = userMapper.findByUserId(userId);
        if (user == null) return false;
        if (passwordEncoder.matches(newPassword, user.getUserPassword())) return false; // 기존과 동일

        return userMapper.updatePassword(userId, passwordEncoder.encode(newPassword)) > 0;
    }

    // ──────────────────────────────────────────────
    // 마이페이지 - 기본 정보 수정
    // ──────────────────────────────────────────────

    @Transactional
    public Map<String, Object> updateUserInfo(Map<String, Object> param) {
        int rows = userMapper.updateUserInfo(param);
        return Map.of("success", rows > 0, "message", rows > 0 ? "수정되었습니다." : "수정에 실패했습니다.");
    }

    // ──────────────────────────────────────────────
    // 마이페이지 - 프로필 이미지 수정
    // ──────────────────────────────────────────────

    @Transactional
    public Map<String, Object> updateProfileImage(Map<String, Object> param) {
        int rows = userMapper.updateProfileImage(param);
        return Map.of("success", rows > 0, "message", rows > 0 ? "이미지가 변경되었습니다." : "변경에 실패했습니다.");
    }

    // ──────────────────────────────────────────────
    // 마이페이지 - 회원 탈퇴
    // ──────────────────────────────────────────────

    @Transactional
    public Map<String, Object> withdraw(Map<String, Object> param) {
        long   userNumber = ((Number) param.get("userNumber")).longValue();
        String inputPw    = (String) param.get("userPassword");
        String email      = (String) param.get("userEmail");

        User user = userMapper.findByUserEmail(email);
        if (user == null || !passwordEncoder.matches(inputPw, user.getUserPassword())) {
            return Map.of("success", false, "message", "비밀번호가 올바르지 않습니다.");
        }

        int rows = userMapper.deleteUser(userNumber);
        if (rows > 0) refreshTokenStorage.remove(email);
        return Map.of("success", rows > 0, "message", rows > 0 ? "탈퇴되었습니다." : "탈퇴에 실패했습니다.");
    }

    // ──────────────────────────────────────────────
    // 마이페이지 - 비밀번호 변경
    // ──────────────────────────────────────────────

    @Transactional
    public Map<String, Object> changePassword(Map<String, Object> param) {
        String email     = (String) param.get("userEmail");
        String currentPw = (String) param.get("currentPassword");
        String newPw     = (String) param.get("newPassword");

        User user = userMapper.findByUserEmail(email);
        if (user == null) {
            return Map.of("success", false, "message", "유저 정보를 찾을 수 없습니다.");
        }
        if (!passwordEncoder.matches(currentPw, user.getUserPassword())) {
            return Map.of("success", false, "message", "현재 비밀번호가 올바르지 않습니다.");
        }
        if (newPw == null || !newPw.matches(PW_PATTERN)) {
            return Map.of("success", false, "message",
                    "비밀번호는 8자 이상이며 영문 대/소문자, 숫자, 특수문자(!@#$)를 모두 포함해야 합니다.");
        }
        if (passwordEncoder.matches(newPw, user.getUserPassword())) {
            return Map.of("success", false, "message", "새 비밀번호가 기존 비밀번호와 동일합니다.");
        }

        int rows = userMapper.updatePassword(user.getUserId(), passwordEncoder.encode(newPw));
        return Map.of("success", rows > 0, "message", rows > 0 ? "비밀번호가 변경되었습니다." : "변경에 실패했습니다.");
    }
}