package com.example.ouroboros.data.repository;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsedWordsRepository extends JpaRepository<UsedWordsEntity, Integer> {
    boolean existsByWordAndUser_Username(String word, String userUsername);

    UsedWordsEntity findTopByUser_UsernameOrderByIdDesc(String username);

    void deleteByUser_Username(String username);

    List<UsedWordsEntity> findAllByUser_Username(String username);

    void deleteByUser_UsernameAndResultAndIdNot(String username, UsedWordsEntity.WinStatus result, int excludeId);

}
