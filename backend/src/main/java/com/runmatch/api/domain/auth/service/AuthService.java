package com.runmatch.api.domain.auth.service;

import lombok.RequiredArgsConstructor;
import com.runmatch.api.global.util.StringUtil;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final JavaMailSender mailSender;
    private final StringRedisTemplate redisTemplate;

    /**
     * 인증번호 발송
     */
    public void sendVerficationCode(String email) {
        //공백제거 & 소문자 변환
        String safeEmail = StringUtil.sanitizeEmail(email);
        // 인증번호 생성 (100000 ~ 999999)
        String code = createCode();

        // Redis에 저장 (Key : "AUTH : 이메일 ", Value: "123456", 유효시간 : 3분)
        redisTemplate.opsForValue().set("AUTH:"+ safeEmail, code, Duration.ofMinutes(3));
        // 로그 확인용
        System.out.println("✅ [Redis 저장] 키: AUTH:" + safeEmail + ", 코드: " + code);

        // 이메일 전송
        sendEmail(safeEmail, code);

    }

    /**
     * 인증번호 검증
     */
    public boolean verfiyCode(String email, String inputCode) {
        // 공백제거 & 소문자 변환
        String safeEmail = StringUtil.sanitizeEmail(email);
        String safeCode = StringUtil.sanitizeCode(inputCode);

        String redisKey = "AUTH:" + safeEmail;
        String savedCode = redisTemplate.opsForValue().get(redisKey);

        // 로그 확인용
        System.out.println("🔎 [Redis 조회] 키: " + redisKey + " -> 값: " + savedCode);

        // 코드가 존재하고 입력값과 일치하면 통과
        if (savedCode != null && savedCode.equals(safeCode)) {
            redisTemplate.delete("AUTH:" + email);
            return true;
        }
        return false;
    }

    /**
     *(내부 메소드) 메일 보내기
     */
    private void sendEmail(String to, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("[RunMatch] 로그인 인증번호 입니다.");
        message.setText("인증번호: " + code + "\n3분 안에 입력해주세요.");

        // 🚨🚨🚨서버 부하 테스트 할 때 해당 코드는 꼭 주석 할 것
        mailSender.send(message);

        // 테스트 시 해당 코드 주석 풀기
        //System.out.println("🚀🚀 [TEST] 메일 발송된 척함: " + to);
    }

    // (내부 메소드) 난수 생성
    private String createCode() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }
}
