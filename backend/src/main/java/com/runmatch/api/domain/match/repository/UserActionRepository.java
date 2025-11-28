package com.runmatch.api.domain.match.repository;

import com.runmatch.api.domain.match.entity.UserAction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserActionRepository extends JpaRepository<UserAction, Long> {

    // receiver   sender
    //  상대방이     나      에게 한 액션 찾기 (Like 확인용)
    Optional<UserAction> findBySenderIdAndReceiverId(Long senderId, Long receiverId);

}
