package com.project.simplepetmanager.common;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Slf4j
@Component
public class JwtUtil {
    @Value("${jwt.secret}")
    private String secretKeyValue; // 시크릿 키 값

    @Value("1800000")
    private long accessTokenExpiry; // 액세스토큰 만료기간

    @Value("1209600000")
    private long refreshTokenExpiry; // 리프레시토큰 만료기간

    private SecretKey key;
    @PostConstruct
    public void init(){ // 초기화
        this.key = Keys.hmacShaKeyFor(secretKeyValue.getBytes());
    }

    // 토큰 만들기
    public String createAccessToken(String email) {
        return buildToken(email, accessTokenExpiry);
    } // 액세스토큰 만들기

    public String createRefreshToken(String email) {
        return buildToken(email, refreshTokenExpiry);
    } // 리프레시 토큰 만들기


    public String buildToken(String email, long expiryMs) { // 토큰빌드
        Date now = new Date();
        return Jwts.builder()
                .subject(email)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expiryMs))
                .signWith(key)
                .compact()
                ;
    }
    // 토큰 읽기
    public String getEmail(String token) {
        return parseClaims(token).getSubject();
    } // 이메일 가져오기

    public boolean isValidToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            log.debug("Token validation failed : {}", e.getMessage());
            return false;
        }
    }

    private Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
