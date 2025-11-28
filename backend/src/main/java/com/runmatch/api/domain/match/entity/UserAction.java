package com.runmatch.api.domain.match.entity;

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
@Table(name = "user_action",
   uniqueConstraints = @UniqueConstraint(columnNames = {"sender_id", "receiver_id"}) // 중복 액션 방지
)
public class UserAction {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender; // 보낸 사람 ( 나 )

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver; // 받은 사람 ( 상대방 )

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ActionType type;

    @CreatedDate
    private LocalDateTime createdAt;

    public UserAction(User sender, User reciever, ActionType type) {
        this.sender = sender;
        this.receiver = reciever;
        this.type = type;
    }

}
