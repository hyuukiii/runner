package com.runmatch.api.domain.match.controller;

import com.runmatch.api.domain.match.dto.CandidateResponse;
import com.runmatch.api.domain.match.service.MatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/matches")
public class MatchController {

    private final MatchService matchService;

    /**
     * 후보 추천 API
     * @param userId
     * @get /matches/candidates?userId = ?
    **/
    @GetMapping("/candidates")
    public List<CandidateResponse> getCandidates(@RequestParam Long userId) {
        return matchService.getCandidates(userId);
    }

}
