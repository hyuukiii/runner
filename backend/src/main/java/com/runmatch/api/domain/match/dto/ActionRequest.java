package com.runmatch.api.domain.match.dto;

import com.runmatch.api.domain.match.entity.ActionType;
import lombok.Data;

@Data
public class ActionRequest {

    private Long senderId; // me
    private Long receiverId; // you
    private ActionType type; // LIKE or SKIP ?
}
