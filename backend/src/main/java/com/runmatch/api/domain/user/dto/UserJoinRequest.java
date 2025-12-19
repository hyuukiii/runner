package com.runmatch.api.domain.user.dto;

import com.runmatch.api.domain.user.entity.Gender;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserJoinRequest {
    // NotBlank는 오직 String 타입에만 쓸 수 있음
    @NotBlank(message = "Apple ID는 필수입니다.")
    private String appleUserId;

    @NotBlank(message = "닉네임은 필수입니다.")
    private String nickname;

    @NotBlank(message = "이메일은 필수입니다.")
    private String email;

    @NotNull(message = "성별은 필수입니다.")
    private Gender gender;

    @NotNull(message = "출생연도는 필수입니다.")
    private Integer birthYear;

    @NotBlank(message = "지역은 필수 입니다.")
    private String region;
}
