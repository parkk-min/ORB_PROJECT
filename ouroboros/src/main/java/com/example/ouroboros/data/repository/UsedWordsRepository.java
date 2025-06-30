package com.example.ouroboros.data.repository;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsedWordsRepository extends JpaRepository<UsedWordsEntity, Integer> {
    boolean existsByWordAndUser_Username(String word, String userUsername);

    UsedWordsEntity findTopByUser_UsernameOrderByIdDesc(String username);
}
