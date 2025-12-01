package com.runmatch.api.domain.user.dto;

import com.runmatch.api.domain.user.entity.Gender;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserJoinRequest {

    @NotBlank(message = "Apple ID는 필수입니다.")
    private String appleUserId;

    @NotBlank(message = "닉네임은 필수입니다.")
    private String nickname;

    // 이메일이 필요할까?
    private String email;

    /**
     * 성별, 출생연도, 지역은 애플ID 받아오면서 자동으로 받아 올 수 있을 듯
     */

    @NotNull(message = "성별은 필수입니다.")
    private Gender gender;

    @NotNull(message = "출생연도는 필수입니다.")
    private Integer birthYear;

    private String region;
}
