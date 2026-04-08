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

// 만약에 @Configuration 이아니라 application.yml 에 쓴다면
// 키이름은 SecurityConfig : 한 줄로 모든 세팅을 다해야하는데... 한 줄로는 세팅하는데 한계가 있을 때 사용하는 방법

@Configuration // 설정 파일 세팅 = application.yml 비슷한 효과 application 처럼 한 줄로 설정이 되지 않아
// 코드를 길 게 작성하여 프로젝트 환경 설정을 해야할 때 작성하는 어노테이션
@EnableWebSecurity  // Spring Security 기능을 활성화 밑에 작성한 설정을 진짜로 사용하게끔 활성화 해줘
// 회사와 개발자가 보안설정을 다수 할 수 있다. 어느 순간에는 잠시 보안을 비활성화 처리해야할 때는 @EnableWebSecurity  작성 안함
@RequiredArgsConstructor
public class SecurityConfig {
    // 파일 같은 경우 -> common 에서 수제 제작해서 사용할 것

    private final JwtFilter jwtFilter;

    // 스프링 컨테이너에 보안팀으로 등록하는 역할
    // SecurityFilterChain @Bean 설정을 하면 스프링에 기존 존재하는 보안팀과 우리 회사에서 만든 보안팀이 한 팀이되어
    // 나의 프로젝트 지키겠다. 설정
    @Bean
    public SecurityFilterChain 보안설정(HttpSecurity http) throws Exception {
        http
                // CSRF = 보호 기능 끄기
                // CSRF = 다른 사이트에서 몰래 요청 보내는 공격
                // Spring Security 팀에는 CSRF 기본 세팅 -> JWT 방식은 쿠키 세션을 안쓰기 때문에 CSRF 자체가 의미 없으므로 끔
                .csrf(csrf -> csrf.disable())
                .sessionManagement(sm -> sm
                        // 세션을 안만들고,
                        // 기존 방식 : 로그인하면 서버가 세션 생성하여 기억 -> 서버 에서도 모든 유저 기억 -> 메모리 소모 보안 위험
                        // 페스티벌에서 스태프들이 우리를 모두 외우지 않고
                        // JWT 방식 : 서버가 아무것도 기억 안 함, 토큰으로만 판단
                        // 입장 팔찌 기준으로 페스티벌에 접근 가능한 사람인지 판단하겠다.
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                /*  .authorizeHttpRequests(auth -> auth
                          .requestMatchers( // 아래 주소는 로그인 토큰 없이 누구나 접근 가능한 경로
                                  "/",
                                  "/user/login",
                                  "/user/register",
                                  "/user/check-email",
                                  "/user/send-code",
                                  "/user/verify-code",
                                  "/user/token/refresh",
                                  "/user/profile-info",
                                  "/board/**",
                                  "/product/**",
                                  "/css/**", "/js/**", "/images/**", "/uploads/**"

                          ).permitAll()

                 */
                .authorizeHttpRequests(auth -> auth // ㅇㅇㅇ
                        .anyRequest().permitAll() // 일단 모두 전체 허용
                )
                // Controller 에서 클라이언트의 접근이 들어오면
                // 무조건 로그인을 해야하는 경우에는 로그인 검증 필터를 최 우선으로 실행시키겠다 환경설정
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        // 위에서 작성한 설정 내용을 최종적으로 완성한 모습을 반환하겠다.
        return http.build();
    }

    // 클라이언트가 작성한 비밀번호를 스프링에서 만든 비밀번호 암호화 파일을 이용해서 읽을 수 없는 암호화처리 변환
    @Bean
    public PasswordEncoder 비밀번호인코더() {
        return new BCryptPasswordEncoder();
    }
}