package com.example.ouroboros.data.repository;

import com.example.ouroboros.data.entity.WordsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface WordsRepository extends JpaRepository<WordsEntity, Integer> {
    WordsEntity findByWord(String word);

    // ORDER BY RAND() 이 함수가 랜덤 단어 출력
    @Query(value = """
        SELECT * FROM words w 
        WHERE w.firstchar = :firstchar
        AND w.word NOT IN (SELECT uw.word FROM used_words uw)
        ORDER BY RAND()
        LIMIT 1
        """, nativeQuery = true)
    WordsEntity findNextWord(@Param("firstchar") String firstchar);
}
