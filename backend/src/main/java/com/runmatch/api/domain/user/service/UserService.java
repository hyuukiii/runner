package com.runmatch.api.domain.user.service;



import com.runmatch.api.domain.user.dto.UserJoinRequest;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) // 기본적으로 읽기전용 (성능 최적화)
public class UserService {

    private final UserRepository userRepository;

    /**
     * 회원가입
     * TODO 실제론 apple 로그인 토큰 검증
     */
    @Transactional
    public Long join(UserJoinRequest request) {
        // 1. 중복 체크
        if (userRepository.findbyAppleUserId(request.getAppleUserId()).isPresent()) {
            throw new IllegalArgumentException("이미 가입된 사용자입니다.");
        }

        // 2. 엔티티생성
        User user =  new User(
                request.getAppleUserId(),
                request.getNickname(),
                request.getEmail(),
                request.getGender(),
                request.getBirthYear(),
                request.getRegion()
        );

        // 3. 저장
        userRepository.save(user);

        return user.getId();
    }

    public User getUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("없는 사용자 입니다."));
    }

}
