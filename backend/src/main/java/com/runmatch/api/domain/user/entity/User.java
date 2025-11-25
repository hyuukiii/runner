package com.runmatch.api.domain.user.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "users")
@EntityListeners(AuditingEntityListener.class) // 생성일/수정일 자동 관리 리스너
public class Users {

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
    private Integer birthYear; // 나이 계산용

    @Column(length = 30)
    private String region; // 활동 지역

    // 헬스킷 정보를 종합하여 점수를 매김 -> 유저의 러닝 티어
    @Enumerated(EnumType.STRING)
    private UserTier tier;

    // --- 프로필 이미지 리스트 (JPA 표준)
    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "user_profile_image", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "image_url")
    private List<String> profileImages = new ArrayList<>();

    // ======== 타임스탬프 자동관리 =======
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    // 생성자
    public Users(String appleUserId, String nickname, String email) {
        this.appleUserId = appleUserId;
        this.nickname = nickname;
        this.email = email;
        this.tier = UserTier.STARTER;
    }
}

