package com.project.simplepetmanager.model.service;

import com.project.simplepetmanager.common.EmailCodeService;
import com.project.simplepetmanager.common.JwtUtil;
import com.project.simplepetmanager.model.dto.User;
import com.project.simplepetmanager.model.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper userMapper;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final Map<String, String> refreshTokenStorage = new ConcurrentHashMap<>();

    // 비밀번호 정책 상수: 8자 이상, 대문자, 소문자, 숫자, 특수문자(!@#$) 필수 포함
    private static final String PW_PATTERN = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$])[A-Za-z\\d!@#$]{8,}$";
    /**
     * 회원가입 처리
     * 1. 이메일 중복 체크
     * 2. 비밀번호 암호화
     * 3. DB 저장
     */
    public void register(User user){

        int count = userMapper.checkEmail(user.getUserEmail());
        if(count > 0){
            throw new RuntimeException("이미 사용중인 이메일입니다.");
        }
        if (user.getUserPassword() == null || !user.getUserPassword().matches(PW_PATTERN)) {
            throw new RuntimeException("비밀번호는 8자 이상이며 영문 대/소문자, 숫자, 특수문자(!@#$)를 모두 포함해야 합니다.");
        }
        // 비밀번호 암호화
        user.setUserPassword(passwordEncoder.encode(user.getUserPassword()));
        userMapper.register(user);
    }
    // 로그인
    public Map<String, String> login(String userId, String inputPassword) {
        // 1. DB에서 아이디로 유저 정보 조회
        User user = userMapper.findByUserId(userId);

        // 2. 유저가 없거나 비밀번호가 일치하지 않으면 null 반환 (또는 예외 발생)
        if (user == null || !passwordEncoder.matches(inputPassword, user.getUserPassword())) {
            return null;
        }

        // 3. 인증 성공 시 이메일(또는 아이디) 기반 토큰 생성
        String email = user.getUserEmail();
        String accessToken = jwtUtil.createAccessToken(email);
        String refreshToken = jwtUtil.createRefreshToken(email);

        // 4. 리프레시 토큰 보관함에 저장
        refreshTokenStorage.put(email, refreshToken);

        // 5. 생성된 토큰들을 Map에 담아 반환
        Map<String, String> tokens = new HashMap<>();
        tokens.put("accessToken", accessToken);
        tokens.put("refreshToken", refreshToken);

        return tokens;
    }
    // 로그아웃
    public void logout(String email) {
        // 서버 보관함에서 리프레시 토큰 삭제
        refreshTokenStorage.remove(email);
    }

    /**
     * 리프레시 토큰을 이용한 액세스 토큰 재발급
     */
    public String tokenRefresh(String refreshToken) {
        // 1. 전달받은 리프레시 토큰 자체가 유효한지 확인 (만료일자 등)
        if (!jwtUtil.isValidToken(refreshToken)) {
            return null;
        }

        // 2. 토큰에서 이메일 추출
        String email = jwtUtil.getEmail(refreshToken);

        // 3. 서버 보관함(Map)에 저장된 해당 이메일의 토큰과 일치하는지 확인 (보안 강화)
        String storedToken = refreshTokenStorage.get(email);
        if (storedToken == null || !storedToken.equals(refreshToken)) {
            return null;
        }

        // 4. 모든 검증이 끝나면 새로운 '액세스 토큰'을 생성하여 반환
        // (수업 코드에서는 리프레시를 다시 만들었지만, 보통은 액세스를 새로 만듭니다.)
        return jwtUtil.createAccessToken(email);
    }

    /**
     * 이름과 이메일로 아이디 조회
     */
    public String findUserId(String userName, String userEmail) {
        return userMapper.findId(userName, userEmail);
    }

    /**
     * 아이디와 이메일 일치 여부 확인
     */
    public boolean verifyUser(String userId, String userEmail) {
        return userMapper.verifyPw(userId, userEmail) > 0;
    }

    /**
     * 비밀번호 재설정 (암호화 처리 포함)
     */
    public boolean updatePassword(String userId, String newPassword) {
        if (newPassword == null || !newPassword.matches(PW_PATTERN)) {
            // 이 경우 false를 반환하여 컨트롤러에서 사용자에게 알림을 줄 수 있게 합니다.
            return false;
        }
        User user = userMapper.findByUserId(userId);

        if (user != null && passwordEncoder.matches(newPassword, user.getUserPassword())) {
            // 기존 비밀번호와 같으면 업데이트를 하지 않고 false를 반환합니다.
            return false;
        }
        // 1. 새 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(newPassword);

        // 2. DB 업데이트 실행 (영향을 받은 행의 수가 1이면 성공)
        int result = userMapper.updatePassword(userId, encodedPassword);

        return result > 0;
    }

    /**
     * 이메일 중복 여부 확인
     * @return 존재하면 true, 없으면 false
     */
    public boolean isEmailDuplicate(String email) {
        return userMapper.checkEmail(email) > 0;
    }

    /**
     * 아이디 중복 여부 확인 [추가]
     * @param userId 검사할 아이디
     * @return 이미 존재하면 true, 없으면 false
     */
    public boolean isIdDuplicate(String userId) {
        // findByUserId로 조회했을 때 결과가 null이 아니면 이미 가입된 아이디입니다.
        return userMapper.findByUserId(userId) != null;
    }
}
