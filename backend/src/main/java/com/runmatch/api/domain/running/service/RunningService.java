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
     * @param userId, distance, duration, calories
     * 러닝 기록 저장 및 티어 업데이트
     */
    @Transactional
    public Long saveRecord(Long userId, Double distance, Integer duration, Double calories) {

        // 1. 유저 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 2. 기록 저장
        RunningRecord record = new RunningRecord(user, distance, duration, calories);
        runningRepository.save(record);

        // 3. 티어 심사 (이번 기록 포함해서 총 거리 계산)
        updateUserTier(user);

        return record.getId();
    }


    /**
     * 티어 업데이트 로직
     * @param user
     */
    private void updateUserTier(User user) {

        // [Refactor] 2025.11.26 성능 최적화
        // 기존: Java 메모리에서 전체 리스트를 조회 후 계산 (데이터 많아지면 메모리 부족 위험)
        // 변경: DB에서 SUM 쿼리로 결과만 가져오도록 변경 (네트워크/메모리 절약)

        /* --- Legacy Code (Java 계산 방식) ---
        List<RunningRecord> records = runningRecordRepository.findByUserId(user.getId());
        double totalDistance = records.stream()
                .mapToDouble(RunningRecord::getDistance)
                .sum();
        ----------------------------------- */

        // DB가 계산한 숫자 하나만 받아옴
        Double totalDistance = runningRepository.sumDistnaceByUserId(user.getId());

        // 티어 기준 (임시 : 50, 100 km )
        if(totalDistance >= 100) {
            user.updateTier(UserTier.ELITE);
        } else if (totalDistance >= 50) {
            user.updateTier(UserTier.PRO_JOGGER);
        } else {
            user.updateTier(UserTier.STARTER);
        }
    }
}
