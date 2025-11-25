package com.runmatch.api.domain.user.controller;

import com.runmatch.api.domain.user.dto.UserJoinRequest;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    // 회원가입 API
    @PostMapping("/join")
    public String join(@Valid @RequestBody UserJoinRequest request) {
        Long userId = userService.join(request);

        return "회원가입 성공 User Id" + userId;
    }

    // 임시) 내 정보 조회 API
    // TODO : User엔티티를 그대로 리턴 중임.
    //        조회용DTO(Useresponse)를 만들어서 필요한 정보만 건내주기
    @GetMapping("/{userId}")
    public User getUser(@PathVariable Long userId) {
        return userService.getUser(userId);
    }
}
