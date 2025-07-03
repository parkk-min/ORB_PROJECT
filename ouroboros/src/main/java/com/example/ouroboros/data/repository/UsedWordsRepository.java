package com.example.ouroboros.data.repository;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;


import java.util.List;

@Repository
public interface UsedWordsRepository extends JpaRepository<UsedWordsEntity, Integer> {
    @Modifying
    @Transactional
    @Query("""
    DELETE FROM UsedWordsEntity u
    WHERE u.user.username = :username
      AND u.result = :result
      AND u.id <> :excludeId
""")
    void deleteUndecidedExceptLast(
            @Param("username") String username,
            @Param("result") UsedWordsEntity.WinStatus result,
            @Param("excludeId") int excludeId
    );

    boolean existsByWordAndUser_Username(String word, String userUsername);

    UsedWordsEntity findTopByUser_UsernameOrderByIdDesc(String username);

    void deleteByUser_Username(String username);

    List<UsedWordsEntity> findAllByUser_Username(String username);

    void deleteByUser_UsernameAndResultAndIdNot(String username, UsedWordsEntity.WinStatus result, int excludeId);

}
