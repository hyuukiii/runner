package com.runmatch.api.domain.running.dto;

import lombok.Data;

@Data
public class RunningRecordRequest {

    // 임시 : 테스트용 변수 ( 원래는 애플아이디의 실제 토큰 받아야 함 )
    private Long userId;

    private Double distance;
    private Integer duration;
    private Double calories;
}
