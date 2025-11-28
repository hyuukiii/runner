package com.runmatch.api.domain.candidate.dto;

import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.entity.UserTier;
import lombok.Data;

/**
 * 나와 같은 조건의 사용자
 */
@Data
public class CandidateResponse {

    private Long userId;
    private String nickname;
    private UserTier tier;
    private String region;

    // 엔티티 -> DTO 변환 메서드 (생성자 대신 스태틱 ** 팩토리 메서드 패턴 **)
    public static CandidateResponse from(User user) {
        CandidateResponse response = new CandidateResponse();
        response.userId = user.getId();
        response.nickname = user.getNickname();
        response.tier = user.getTier();
        response.region = user.getRegion();

        return response;
    }
}
