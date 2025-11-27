package com.runmatch.api.domain.match.service;

import com.runmatch.api.domain.match.dto.CandidateResponse;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MatchService {
    private final UserRepository userRepository;

    /**
     * 매칭 후보 추천
     * < 임시 > 나와 같은 티어인 사람들을 무작위로 보여주는 로직 (일단은 전체 조회)
     * TODO : 1. 추후 사용자 임의로 필터 기능 추가
     *        2. 초기 프로덕션에선 위치 기반으로 매칭 후보 추천 해줄거임
     */
    public List<CandidateResponse> getCandidates(Long myUserId) {

        // 1. 내 정보 조회(나의 티어를 알아야 하니깐)
        User me = userRepository.findById(myUserId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없음"));

        // 2. 나와 같은 티어면서, 나 자신은 아닌 사람들 조회
        List<User> candidates = userRepository.findByIdNotAndTier(myUserId, me.getTier());

        // 3. DTO로 변환해서 반환
        return candidates.stream()
                .map(CandidateResponse::from)
                .collect(Collectors.toList());
    }
}
