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

    // JPQL이 사용할 생성자
    public CandidateResponse(Long userId, String nickname, UserTier tier, String region) {
        this.userId = userId;
        this.nickname = nickname;
        this.tier = tier;
        this.region = region;
    }

    // 엔티티 -> DTO 변환 메서드
    // (생성자 대신 스태틱 == 팩토리 메서드 패턴)
    // 생성자를 만들었으니 생성자를 활용해서 코드 단축하기 (현재는 안쓰이지만 만일에 대비해서 남겨두기)
    public static CandidateResponse from(User user) {
        return new CandidateResponse(
                user.getId(),
                user.getNickname(),
                user.getTier(),
                user.getRegion()
        );
    }
}
