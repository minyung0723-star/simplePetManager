package com.project.simplepetmanager.common;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 1. CSRF 방어 비활성화 (JWT는 무상태성이므로 불필요)
                .csrf(csrf -> csrf.disable())

                // 2. 세션 관리: STATELESS 설정 (서버에 세션을 생성하지 않음)
                .sessionManagement(sm -> sm
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // 3. 경로별 접근 권한 설정 (로그인 없이 허용할 항목들)
                .authorizeHttpRequests(auth -> auth
                        // [A] 공통 페이지 및 뷰(JSP) 컨트롤러 경로
                        .requestMatchers(
                                "/",                // 메인 페이지
                                "/login",           // 로그인 페이지
                                "/register",        // 회원가입 페이지
                                "/findUser",        // 아이디/비밀번호 찾기 페이지
                                "/board/**",        // 게시판 목록 및 상세 페이지 뷰
                                "/api/hospital/detail" // 병원 상세 정보 페이지 뷰
                        ).permitAll()

                        // [B] 회원 관련 API (비로그인 상태에서 수행되는 기능)
                        .requestMatchers(
                                "/api/login",           // 로그인 처리
                                "/api/register",        // 회원가입 처리
                                "/api/check-id",        // 아이디 중복 확인
                                "/api/email-auth",      // 인증번호 발송 (가입/비번찾기 공용)
                                "/api/email-verify",    // 인증번호 검증
                                "/api/find-id",         // 아이디 찾기 로직
                                "/api/verify-for-pw",   // 비밀번호 재설정 전 사용자 검증
                                "/api/token/refresh"    // 토큰 만료 시 재발급 API
                        ).permitAll()

                        // [C] 게시판 및 리뷰 데이터 조회 API (비로그인 열람 허용)
                        .requestMatchers(
                                "/api/review/list",      // 특정 가게의 리뷰 목록 조회
                                "/api/review/store/info" // 특정 가게 상세 데이터 조회
                        ).permitAll()

                        // [D] 정적 리소스 및 파일 업로드 경로
                        .requestMatchers(
                                "/css/**",
                                "/js/**",
                                "/images/**",
                                "/favicon.ico",
                                "/uploads/**"           // 사용자가 업로드한 프로필 및 리뷰 이미지
                        ).permitAll()

                        // [E] 그 외 모든 요청
                        // 현재 컨트롤러 내부에서 직접 로그인 체크를 하고 있으므로 .permitAll() 유지
                        // 보안을 극대화하려면 나중에 .authenticated()로 변경 검토
                        .anyRequest().permitAll()
                )

                // 4. JWT 필터를 ID/PW 인증 필터보다 앞에 배치
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // 비밀번호 암호화 빈 등록
    // SecurityConfig.java 내부

    @Bean
    public BCryptPasswordEncoder passwordEncoder() { // 리턴 타입을 구체적으로 지정
        return new BCryptPasswordEncoder();
    }
}