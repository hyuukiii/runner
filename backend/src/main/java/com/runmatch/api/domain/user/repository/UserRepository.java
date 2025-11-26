package com.runmatch.api.domain.user.repository;

import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.entity.UserTier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // "select * from users where apple_user_id = ?" 쿼리랑 동일
    Optional<User> findByAppleUserId(String appleUserId);

    // 닉네임 중복 체크
    boolean existsBynickname(String nickname);

    // 나(myId)를 뺴고, 특정 티어인 사람들을 찾음
    List<User> findByIdNotAndTier(Long id, UserTier tier);
}
