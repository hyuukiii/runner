package com.runmatch.api.domain.candidate.controller;

import com.runmatch.api.domain.candidate.dto.CandidateResponse;
import com.runmatch.api.domain.match.service.MatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/matches")
public class CandidateController {

    private final MatchService matchService;

    /**
     * 후보 추천 API
     *
     * @param userId
     * @GET /matches/candidates?userId = ?
     **/
    @GetMapping("/candidates")
    public List<CandidateResponse> getCandidates(@RequestParam Long userId) {
        return matchService.getCandidates(userId);
    }
}
