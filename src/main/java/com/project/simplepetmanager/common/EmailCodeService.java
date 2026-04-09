package com.project.simplepetmanager.common;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 이메일 인증번호 관리 서비스
 * * 1. 인증번호 생성 및 이메일 발송 (sendVerificationCode)
 * 2. 생성된 번호를 메모리에 5분간 저장 (storage)
 * 3. 사용자 입력 번호 검증 및 1회성 삭제 (verifyCode)
 */
@Service
@RequiredArgsConstructor
public class EmailCodeService {

    private final JavaMailSender mailSender;

    // 인증번호 임시 보관함 { 이메일 -> 코드정보(번호, 만료시각) }
    private final Map<String, CodeInfo> storage = new ConcurrentHashMap<>();

    /**
     * 6자리 랜덤 인증번호를 생성하여 사용자의 이메일로 발송합니다.
     * @param email 수신자 이메일 주소
     */
    @Async
    public void sendVerificationCode(String email) {
        // 6자리 랜덤 숫자 생성 (000000 ~ 999999)
        String code = String.format("%06d", new Random().nextInt(1000000));

        // 서버 메모리에 저장 (현재 시간으로부터 5분 후 만료)
        storage.put(email, new CodeInfo(code, LocalDateTime.now().plusMinutes(5)));

        // 메일 메시지 구성 및 발송
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("[PetManager] 이메일 인증번호 안내");
        message.setText("안녕하세요. 요청하신 인증번호는 다음과 같습니다.\n\n"
                + "인증번호 : " + code + "\n\n"
                + "5분 이내에 입력해 주세요.");

        mailSender.send(message);
    }

    /**
     * 사용자가 입력한 인증번호가 저장된 번호와 일치하는지 확인합니다.
     * @param email 사용자 이메일
     * @param inputCode 사용자가 입력한 인증번호
     * @return 일치 및 만료되지 않았을 경우 true, 그 외 false
     */
    public boolean verifyCode(String email, String inputCode) {
        CodeInfo savedInfo = storage.get(email);

        // 1. 발송 기록이 없는 경우
        if (savedInfo == null) return false;

        // 2. 만료 시간이 지난 경우 (5분 초과)
        if (savedInfo.expiryTime().isBefore(LocalDateTime.now())) {
            storage.remove(email);
            return false;
        }

        // 3. 입력한 번호가 일치하지 않는 경우
        if (!savedInfo.code().equals(inputCode)) {
            return false;
        }

        // 검증 성공 시 1회용이므로 보관함에서 삭제 후 성공 반환
        storage.remove(email);
        return true;
    }

    /**
     * 인증번호와 만료 시각을 함께 관리하기 위한 내부 레코드
     */
    private record CodeInfo(String code, LocalDateTime expiryTime) {}
}
