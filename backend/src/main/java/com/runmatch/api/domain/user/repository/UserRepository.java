package com.runmatch.api.domain.user.repository;

import com.runmatch.api.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // "select * from users where apple_user_id = ?" 쿼리랑 동일
    Optional<User> findByAppleUserId(String appleUserId);

    // 닉네임 중복 체크용
    boolean existsBynickname(String nickname);
}
