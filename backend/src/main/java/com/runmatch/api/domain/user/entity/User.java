package com.runmatch.api.domain.user.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;


@Entity
@Table(name = "user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    // 애플 고유 ID TODO : 추후에 생성 아이디 길이 보고 가변길이 조절
    @Column(nullable = false, unique = true)
    private String appleUserId;

    @Column(length = 50)
    private String email;

    @Column(nullable = false, length = 50)
    private String nickname;

    // 헬스킷 정보를 종합하여 점수를 매김 -> 유저의 러닝 티어
    @Enumerated(EnumType.STRING)
    private UserTier tier;

    private LocalDateTime createdAt;

//TODO ====================  Getter, 기본 생성자, 생성자 롬북으로 처리하기 ====================

    //기본 생성자 (JPA 필수)
    protected User() {}

    //생성자
    public User(String appleUserId, String nickname, String email) {
        this.appleUserId = appleUserId;
        this.nickname = nickname;
        this.email = email;
        this.tier = UserTier.STARTER;
        this.createdAt = LocalDateTime.now();
    }

    // Getter
    public Long getId() {return id;}
    public String getNickname(){return nickname;}
    public UserTier gettier(){return tier;}

}
