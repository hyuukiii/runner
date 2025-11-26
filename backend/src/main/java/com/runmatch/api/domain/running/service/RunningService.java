package com.runmatch.api.domain.running.service;

import com.runmatch.api.domain.running.entity.RunningRecord;
import com.runmatch.api.domain.running.repository.RunningRecordRepository;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.entity.UserTier;
import com.runmatch.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RunningService {

    private final RunningRecordRepository runningRepository;
    private final UserRepository userRepository;

    /**
     * 총 기록 저장 메서드
     * @param userId
     * @param distance
     * @param duration
     * @param calories
     * @return
     */
    @Transactional
    public Long saveRecord(Long userId, Double distance, Integer duration, Double calories) {

        User user = findUserById(userId);
        RunningRecord record = saveRunningRecord(user, distance, duration, calories);
        processTierUpdate(user);

        return record.getId();
    }

    /**
     * 사용자 조회 메서드
     * @param userId
     * @return
     */
    private User findUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("유저가 읍따"));
    }

    /**
     * 유저의 러닝 기록 저장 메서드
     * @param user
     * @param distance
     * @param duration
     * @param calories
     * @return
     */
    private RunningRecord saveRunningRecord(User user, Double distance, Integer duration, Double calories) {
        RunningRecord record = new RunningRecord(user, distance, duration, calories);
        return runningRepository.save(record);
    }

    /**
     * 티어 선정 알고리즘 메서드 ( 임시 )
     * @param user
     */
    private void processTierUpdate(User user) {

        // DB가 계산한 숫자 하나만 받아옴
        Double totalDistance = runningRepository.sumDistnaceByUserId(user.getId());

        // 티어 기준 (임시 : 50, 100 km)
        // TODO : 티어 계산 로직 복잡 해지면 메서드나 도메인 객체로 분리 하기
        if(totalDistance >= 100) {
            user.updateTier(UserTier.ELITE);
        } else if (totalDistance >= 50) {
            user.updateTier(UserTier.PRO_JOGGER);
        } else {
            user.updateTier(UserTier.STARTER);
        }
    }

}
