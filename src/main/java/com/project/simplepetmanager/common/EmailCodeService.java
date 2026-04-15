package com.project.simplepetmanager.common;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j; // 로그 기록을 위해 추가
import org.springframework.mail.MailException; // 메일 예외 처리
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j // 로그를 편하게 찍기 위한 어노테이션
@Service
@RequiredArgsConstructor
public class EmailCodeService {

    private final JavaMailSender mailSender;
    private final Map<String, CodeInfo> storage = new ConcurrentHashMap<>();

    /**
     * 6자리 랜덤 인증번호를 생성하여 사용자의 이메일로 발송합니다.
     */
    @Async
    public void sendVerificationCode(String email) {
        try {
            // 1. 인증번호 생성 및 메모리 저장
            String code = String.format("%06d", new Random().nextInt(1000000));
            storage.put(email, new CodeInfo(code, LocalDateTime.now().plusMinutes(5)));

            // 2. 메일 메시지 구성
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("[PetManager] 이메일 인증번호 안내");
            message.setText("안녕하세요. 요청하신 인증번호는 다음과 같습니다.\n\n"
                    + "인증번호 : " + code + "\n\n"
                    + "5분 이내에 입력해 주세요.");

            // 3. 실제 메일 발송
            log.info("메일 발송 시도 중... 수신자: {}", email);
            mailSender.send(message);
            log.info("메일 발송 성공! 수신자: {}", email);

        } catch (MailException e) {
            // 메일 관련 예외 (인증 실패, 포트 막힘 등)
            log.error("메일 발송 실패 (SMTP 오류): {}", e.getMessage());
            storage.remove(email); // 실패 시 생성했던 코드 삭제
        } catch (Exception e) {
            // 기타 예상치 못한 예외
            log.error("메일 발송 중 알 수 없는 에러 발생: ", e);
            storage.remove(email);
        }
    }

    /**
     * 사용자가 입력한 인증번호 검증
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