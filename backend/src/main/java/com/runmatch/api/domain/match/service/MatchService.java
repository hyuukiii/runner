package com.runmatch.api.domain.match.service;

import com.runmatch.api.domain.match.dto.CandidateResponse;
import com.runmatch.api.domain.match.entity.ActionType;
import com.runmatch.api.domain.match.entity.Match;
import com.runmatch.api.domain.match.entity.UserAction;
import com.runmatch.api.domain.match.repository.MatchRepository;
import com.runmatch.api.domain.match.repository.UserActionRepository;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MatchService {

    private final UserRepository userRepository;

    private final UserActionRepository userActionRepository;

    private final MatchRepository matchRepository;

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

    /**
     * 유저 액션 처리 (LIKE / SKIP)
     * @return : 매칭 성사 여부 (true/false)
     */
    @Transactional
    public boolean performAction(Long senderId, Long receiverId, ActionType type) {

        // 1. 먼저 좋아요를 보낸사람과, 받는 사람의 아이디를 찾는다.
        User sender = userRepository.findById(senderId).orElseThrow();
        User receiver = userRepository.findById(receiverId).orElseThrow();

        // 2. 액션 저장 ( 나 -> 상대방)
        // TODO: 11/28
        //  이미 액션을 했는지 중복 체크 로직 필요 (현재는 DB unique 조건이 막아줌)
        UserAction action = new UserAction(sender, receiver, type);
        userActionRepository.save(action);

        // 3. 만약 'SKIP' 이면 매칭 검사 필요 없음
        if (type == ActionType.SKIP) {
            return false;
        }

        // 4. 'LIKE'라면 쌍방 라이크인지 확인 ( 상대방 -> 나 )
        // 상대방이 나한테 보낸 액션이 있는지
        Optional<UserAction> opponentAction = userActionRepository
                    .findBySenderIdAndReceiverId(receiverId, senderId);

        // 5. 상대방도 나를 LIKE 했다면 -> 매칭 성사
        if(opponentAction.isPresent() && opponentAction.get().getType().equals(ActionType.LIKE)) {

            //매칭 저장
            Match match = new Match(sender, receiver);
            matchRepository.save(match);

            return true;
        }

        return false; // 둘 조건이 X ? --> 견우와 직녀..
    }

}
