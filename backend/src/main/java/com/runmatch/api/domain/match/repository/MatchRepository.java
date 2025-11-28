package com.runmatch.api.domain.match.repository;

import com.runmatch.api.domain.match.entity.Match;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MatchRepository extends JpaRepository<Match, Long> {

    /**
     *  TODO :: 일단 저장만 할거라 쿼리 필요 X
     **/

}
