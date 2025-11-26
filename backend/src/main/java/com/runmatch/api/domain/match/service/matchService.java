package com.runmatch.api.domain.match.service;

import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class matchService {
    private final UserRepository userRepository;

    /**
     * 매칭 후보 추천
     * 나와 같은 티어인 사람들을 무작위로 보여주는 로직 (임시)
     * TODO : 추후 사용자 임의로 필터 기능 추가
     */
}
