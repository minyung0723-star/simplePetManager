package com.project.simplepetmanager.common;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
// [기존 SMTP 라이브러리 주석 처리]
// import org.springframework.mail.MailException;
// import org.springframework.mail.SimpleMailMessage;
// import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate; // [추가] API 호출용

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailCodeService {

    // [수정] Render의 SMTP 차단으로 인해 JavaMailSender 대신 RestTemplate을 사용
    // private final JavaMailSender mailSender;
    private final RestTemplate restTemplate;

    // [추가] application.yaml 및 config.yaml에서 가져올 설정값
    @Value("${api.brevo.key}")
    private String brevoApiKey;

    @Value("${api.brevo.url}")
    private String brevoApiUrl;

    @Value("${mail.username}")
    private String senderEmail;

    private final Map<String, CodeInfo> storage = new ConcurrentHashMap<>();

    /**
     * 6자리 랜덤 인증번호를 생성하여 Brevo REST API를 통해 발송 (포트 차단 우회)
     */
    @Async
    public void sendVerificationCode(String email) {
        try {
            // 1. 인증번호 생성 및 메모리 저장
            String code = String.format("%06d", new Random().nextInt(1000000));
            storage.put(email, new CodeInfo(code, LocalDateTime.now().plusMinutes(5)));

            // 2. [변경] SMTP 메시지 대신 API 요청 바디 구성
            /* 기존 SMTP 방식 주석 처리
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("onboarding@resend.dev");
            message.setTo(email);
            message.setSubject("[PetManager] 이메일 인증번호 안내");
            message.setText("안녕하세요. 요청하신 인증번호는 다음과 같습니다.\n\n"
                    + "인증번호 : " + code + "\n\n"
                    + "5분 이내에 입력해 주세요.");
            mailSender.send(message);
            */

            // 3. Brevo API를 통한 메일 발송 (HTTPS 443 포트 사용)
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("api-key", brevoApiKey);

            Map<String, Object> body = new HashMap<>();
            // sender는 반드시 Brevo에 등록(Verify)한 이메일 주소여야 한다.
            body.put("sender", Map.of("name", "PetManager", "email", senderEmail));
            body.put("to", List.of(Map.of("email", email)));
            body.put("subject", "[PetManager] 이메일 인증번호 안내");
            body.put("htmlContent",
                    "<div style='font-family: Arial, sans-serif;'>" +
                            "<h3>안녕하세요. PetManager입니다.</h3>" +
                            "<p>요청하신 인증번호는 다음과 같습니다.</p>" +
                            "<h2 style='color: #4A90E2;'>" + code + "</h2>" +
                            "<p>5분 이내에 입력해 주세요.</p></div>"
            );

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

            log.info("Brevo API 발송 시도 중... 수신자: {}", email);
            ResponseEntity<String> response = restTemplate.postForEntity(brevoApiUrl, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("메일 발송 성공! 수신자: {}", email);
            } else {
                log.error("메일 발송 실패 (API 응답): {}", response.getBody());
            }

        } catch (Exception e) {
            log.error("메일 발송 중 에러 발생: ", e);
            storage.remove(email);
        }
    }

    /**
     * 사용자가 입력한 인증번호 검증 (기존 로직 유지)
     */
    public boolean verifyCode(String email, String inputCode) {
        CodeInfo savedInfo = storage.get(email);

        if (savedInfo == null) return false;

        if (savedInfo.expiryTime().isBefore(LocalDateTime.now())) {
            storage.remove(email);
            return false;
        }

        if (!savedInfo.code().equals(inputCode)) {
            return false;
        }

        storage.remove(email);
        return true;
    }

    private record CodeInfo(String code, LocalDateTime expiryTime) {}
}