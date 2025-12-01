package com.runmatch.api.domain.user.repository;

import com.runmatch.api.domain.candidate.dto.CandidateResponse;
import com.runmatch.api.domain.user.entity.User;
import com.runmatch.api.domain.user.entity.UserTier;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // "select * from users where apple_user_id = ?" 쿼리랑 동일
    Optional<User> findByAppleUserId(String appleUserId);

    // 닉네임 중복 체크
    boolean existsBynickname(String nickname);

    // [최적화] 엔티티 대신 DTO 리스트를 바로 반환
    @Query ("SELECT new com.runmatch.api.domain.candidate.dto.candidateResponse(u.id, u.nickname, u.tier, u.region)" +
             "FROM User u " +
             "WHERE u.id != :myId AND u.tier = :tier")
    List<CandidateResponse> findCandidatesByTier(@Param("myId") Long myId, @Param("tier") UserTier tier);

}
