package com.runmatch.api.domain.candidate.controller;

import com.runmatch.api.domain.candidate.service.CandidateService;
import com.runmatch.api.domain.candidate.dto.CandidateResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/matches")
public class CandidateController {

    private final CandidateService candidateService;

    /**
     * 후보 추천 API
     *
     * @param userId
     * @GET /matches/candidates?userId = ?
     **/
    @GetMapping("/candidates")
    public List<CandidateResponse> getCandidates(@RequestParam Long userId) {
        return candidateService.getCandidates(userId);
    }
}
