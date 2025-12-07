package com.runmatch.api.domain.auth.service;

import lombok.RequiredArgsConstructor;
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
        // 인증번호 생성 (100000 ~ 999999)
        String code = createCode();

        // Redis에 저장 (Key : "AUTH : 이메일 ", Value: "123456", 유효시간 : 3분)
        redisTemplate.opsForValue().set("Auth:"+ email, code, Duration.ofMinutes(3));

        // 이메일 전송
        sendEmail(email, code);

    }

    /**
     * 인증번호 검증
     */
    public boolean verfiyCode(String email, String inputCode) {
        String savedCode = redisTemplate.opsForValue().get("AUTH:" + email);

        // 코드가 존재하고 입력값과 일치하면 통과
        if (savedCode != null && savedCode.equals(inputCode)) {
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
        mailSender.send(message);
    }

    // (내부 메소드) 난수 생성
    private String createCode() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }
}
