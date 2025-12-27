package com.runmatch.api.domain.user.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "users")
@EntityListeners(AuditingEntityListener.class) // 생성일/수정일 자동 관리 리스너
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    // ========= 인증 정보 ==========
    // 애플 고유 ID TODO : 추후에 생성 아이디 길이 보고 가변길이 조절
    @Column(nullable = false, unique = true)
    private String appleUserId;

    @Column(length = 50)
    private String email;

    // ========== 프로필 정보 ==========
    @Column(nullable = false, length = 30)
    private String nickname;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Gender gender;

    @Column(nullable = false)
    private LocalDate birthDate; // 나이 계산용

    @Column(length = 30)
    private String region; // 활동 지역

    // 헬스킷 정보를 종합하여 점수를 매김 -> 유저의 러닝 티어
    @Enumerated(EnumType.STRING)
    private UserTier tier;

    // 가입 시 사진 한장을 받으므로 List 형식이 아닌 단일 형식
    // TODO : 여러 사진 저장이 필요 하다면 나중에 별도 테이블로 분리
    @Column(name = "profile_image_url")
    private String profileImageURL;

    // ======== 타임스탬프 자동관리 =======
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    // 러닝 기록 업데이트 후 티어 변경시 저장 되는 생성자 메서드
    public void updateTier(UserTier newtier){
        this.tier = newtier;
    }

    // 생성자 메서드
    public User(String appleUserId, String nickname, String email, Gender gender, LocalDate birthDate, String region, String profileImageURL) {
        this.appleUserId = appleUserId;
        this.nickname = nickname;
        this.profileImageURL = profileImageURL;
        this.email = email;
        this.gender = gender;
        this.birthDate = birthDate;
        this.region = region;
        this.tier = UserTier.STARTER;
    }
}

