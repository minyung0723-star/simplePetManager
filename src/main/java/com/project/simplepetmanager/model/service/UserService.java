package com.project.simplepetmanager.model.service;

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
}
