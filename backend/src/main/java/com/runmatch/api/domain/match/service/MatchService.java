package com.runmatch.api.domain.match.service;

import com.runmatch.api.domain.candidate.dto.CandidateResponse;
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
