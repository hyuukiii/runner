package com.runmatch.api.domain.match.controller;

import com.runmatch.api.domain.match.dto.ActionRequest;
import com.runmatch.api.domain.match.service.MatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/matches")
public class MatchController {

    private final MatchService matchService;

    /**
     * 액션 API
     * @param request (ActionRequest)
     * @POST  /matches/action
     *
     */
    @PostMapping("/action")
    public String doAction(@RequestBody ActionRequest request) {

        boolean isMatched = matchService.performAction(
                request.getSenderId(),
                request.getReceiverId(),
                request.getType()
        );

        if(isMatched) {
            return "매칭이 성사 됐어요";
        } else {
            return "액션이 저장되었습니다.";
        }
    }

}
