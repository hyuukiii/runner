package com.runmatch.api.domain.running.repository;

import com.runmatch.api.domain.running.entity.RunningRecord;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RunningRecordRepository extends JpaRepository<RunningRecord, Long> {

    // 기존 사용자 목록 조회
    List<RunningRecord> findByUserId(Long userId);

    // 총 거리 합계만 계산 --> 결과 DB에게 전달 (자바 메모리와 DB 역할 분리로 최적화)
    // COALESCE : NULL을 0으로 바꿔줌 ( 기록이 없을 떄)
    @Query("SELECT COALESCE(SUM(r.distance), 0) FROM RunningRecord r WHERE r.user.id = :userId")
    Double sumDistnaceByUserId(@Param("userId") Long userId);

}
