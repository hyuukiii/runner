package com.runmatch.api.domain.auth.service.controller;


import com.runmatch.api.domain.auth.service.AuthService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * 인증번호 요청 API
     */
    @PostMapping("/send-code")
    public String sendCode(@RequestBody EmailRequest request) {
        authService.sendVerficationCode(request.getEmail());
        return "인증번호가 발송되었습니다.";
    }

    // 인증번호 검증 및 로그인 API
    @PostMapping("/verify")
    public String verify(@RequestBody VerifyRequest request) {
        boolean isValid = authService.verfiyCode(request.getEmail(), request.getCode());
        if (isValid) {
            // TODO: 여기서 JWT 토큰 발급 로직 연결
            return "인증 성공! (로그인 처리 됨)";
        } else {
            throw new IllegalArgumentException("인증번호가 틀렸거나 만료되었습니다.");
        }
    }

    //DTO들 (내부에 선언)
    @Data static class EmailRequest { private String email; }
    @Data static class VerifyRequest { private String email; private String code; }

}
