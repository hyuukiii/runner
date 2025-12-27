package com.runmatch.api.domain.user.controller;

import com.runmatch.api.domain.user.dto.UserJoinRequest;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.awt.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    // 회원가입 API
    @PostMapping(value = "/join", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String join(
            // JSON 데이터 ( IOS 에서 name = " request "로 보낸 것 )
            @RequestPart(value = "request") @Valid UserJoinRequest request,
            // 이미지 파일 ( IOS 에서 name = "profileImage"로 보낸 것 )
            @RequestPart(value = "profileImage", required = false) MultipartFile profileImage
    ) {
        Long userId = userService.join(request, profileImage);

       return "회원가입 성공" + userId;
    }

    // 임시) 내 정보 조회 API
    // TODO : User엔티티를 그대로 리턴 중임.
    //        조회용DTO(Useresponse)를 만들어서 필요한 정보만 건내주기
    @GetMapping("/{userId}")
    public User getUser(@PathVariable Long userId) {
        return userService.getUser(userId);
    }

}
