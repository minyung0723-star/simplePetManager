package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper      userMapper;
    private final PasswordEncoder passwordEncoder;

    /* =====================================================
       조회
       ===================================================== */

    public User getUserByEmail(String userEmail) {
        return userMapper.selectUserByEmail(userEmail);
    }

    public User getUserByUserId(String userId) {
        return userMapper.selectUserByUserId(userId);
    }

    public User getUserByUserNumber(int userNumber) {
        return userMapper.selectUserByUserNumber(userNumber);
    }

    /* =====================================================
       회원가입
       ===================================================== */

    public Map<String, Object> register(User user) {
        Map<String, Object> result = new HashMap<>();

        // 이메일 중복 확인
        if (userMapper.selectUserByEmail(user.getUserEmail()) != null) {
            result.put("success", false);
            result.put("message", "이미 사용 중인 이메일입니다.");
            return result;
        }

        // 아이디 중복 확인
        if (userMapper.selectUserByUserId(user.getUserId()) != null) {
            result.put("success", false);
            result.put("message", "이미 사용 중인 아이디입니다.");
            return result;
        }

        // 비밀번호 암호화
        user.setUserPassword(passwordEncoder.encode(user.getUserPassword()));

        int rows = userMapper.insertUser(user);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "회원가입이 완료되었습니다." : "회원가입에 실패했습니다.");
        return result;
    }

    /* =====================================================
       로그인 검증 (비밀번호 매칭)
       ===================================================== */

    /**
     * @param userEmail    로그인 이메일
     * @param rawPassword  평문 비밀번호
     * @return 일치하면 User 객체, 불일치면 null
     */
    public User login(String userEmail, String rawPassword) {
        User user = userMapper.selectUserByEmail(userEmail);
        if (user == null) return null;
        if (!passwordEncoder.matches(rawPassword, user.getUserPassword())) return null;
        return user;
    }

    /* =====================================================
       기본 정보 수정
       ===================================================== */

    public Map<String, Object> updateUserInfo(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        int rows = userMapper.updateUserInfo(param);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "정보가 수정되었습니다." : "수정에 실패했습니다.");
        return result;
    }

    /* =====================================================
       비밀번호 변경
       ===================================================== */

    public Map<String, Object> changePassword(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();

        int userNumber    = (int) param.get("userNumber");
        String currentPw  = (String) param.get("currentPassword");
        String newPw      = (String) param.get("newPassword");

        User user = userMapper.selectUserByUserNumber(userNumber);
        if (user == null) {
            result.put("success", false);
            result.put("message", "유저 정보를 찾을 수 없습니다.");
            return result;
        }

        // 현재 비밀번호 검증
        if (!passwordEncoder.matches(currentPw, user.getUserPassword())) {
            result.put("success", false);
            result.put("message", "현재 비밀번호가 일치하지 않습니다.");
            return result;
        }

        Map<String, Object> updateParam = new HashMap<>();
        updateParam.put("userNumber",  userNumber);
        updateParam.put("newPassword", passwordEncoder.encode(newPw));

        int rows = userMapper.updatePassword(updateParam);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "비밀번호가 변경되었습니다." : "비밀번호 변경에 실패했습니다.");
        return result;
    }

    /* =====================================================
       프로필 이미지 변경
       ===================================================== */

    public Map<String, Object> updateProfileImage(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        int rows = userMapper.updateProfileImage(param);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "프로필 사진이 변경되었습니다." : "사진 변경에 실패했습니다.");
        return result;
    }

    /* =====================================================
       회원 탈퇴
       ===================================================== */

    public Map<String, Object> withdraw(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();

        int userNumber   = (int) param.get("userNumber");
        String rawPw     = (String) param.get("userPassword");

        User user = userMapper.selectUserByUserNumber(userNumber);
        if (user == null) {
            result.put("success", false);
            result.put("message", "유저 정보를 찾을 수 없습니다.");
            return result;
        }

        // 비밀번호 검증
        if (!passwordEncoder.matches(rawPw, user.getUserPassword())) {
            result.put("success", false);
            result.put("message", "비밀번호가 일치하지 않습니다.");
            return result;
        }

        int rows = userMapper.deleteUser(userNumber);
        result.put("success", rows > 0);
        result.put("message", rows > 0 ? "탈퇴가 완료되었습니다." : "탈퇴에 실패했습니다.");
        return result;
    }
}