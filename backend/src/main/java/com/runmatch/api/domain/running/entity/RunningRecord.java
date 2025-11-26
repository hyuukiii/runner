package com.runmatch.api.domain.running.entity;

import com.runmatch.api.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
@Table(name = "running_records")
public class RunningRecord {

    // PK
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 어떤 사용자가 뛴 기록인지(FK)
    // User 객체의 @Id가 붙은 필드(PK)를 찾는다. === User 테이블의 Id컬럼을 외래키로 받아온다.
    // 지연로딩(Lazy) : 1. 기본적으로는 users의 모든 컬럼을 다 가져오는 게 JPA의 기본 동작
    //                 2. User 객체에 가짜객체(Froxy)를 넣어둔다.
    //                 3. 해당 데이터가 프록시가 초기화 되면서 DB를 접속 -> User의 엔티티로 채워버린다.
    //                 4. 즉 한번 로딩 해 놓으면 getEmail(), getRegion() 등등 호출 시 쿼리를 하지 않아도 됨.
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private Double distance; // 뛴 거리 단위 : (Km)
    private Integer durationSeconds; // 뛴 시간 단위 : (초)
    private Double calories;// 소모 칼로리

    @CreatedDate
    private LocalDateTime runAt; // 언제 뛰었는지 (기록 생성 시점)

    // 생성자
    public RunningRecord(User user, Double distance, Integer durationSeconds, Double calories) {
        this.user = user;
        this.distance = distance;
        this.durationSeconds = durationSeconds;
        this.calories = calories;
    }
}
