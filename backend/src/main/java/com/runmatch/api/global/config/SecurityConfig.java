package com.runmatch.api.global.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 1. CSRF 보안 끄기 (POST 요청을 보낼 떄 토큰 검사 제외)
                .csrf(AbstractHttpConfigurer::disable)

                // 2. 모든 주소(/**)에 대해 누구나 들어와도 됨(permitAll)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/**").permitAll()

                );

        return http.build();
    }
}
