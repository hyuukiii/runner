package com.runmatch.api.domain.running.controller;

import com.runmatch.api.domain.running.dto.RunningRecordRequest;
import com.runmatch.api.domain.running.service.RunningService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/running")
public class RunningController {

    private final RunningService runningService;

    @RequestMapping("/record")
    public String uploadRecord(@RequestBody RunningRecordRequest request) {
        runningService.saveRecord(
                request.getUserId(),
                request.getDistance(),
                request.getDuration(),
                request.getCalories()
        );
        return "기록 저장 완료";
    }
}
