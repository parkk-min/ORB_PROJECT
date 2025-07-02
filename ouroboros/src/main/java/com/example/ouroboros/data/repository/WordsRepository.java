package com.example.ouroboros.data.repository;

import com.example.ouroboros.data.entity.WordsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WordsRepository extends JpaRepository<WordsEntity, Integer> {
    WordsEntity findByWord(String word);


    // ORDER BY RAND() 이 함수가 랜덤 단어 출력
    // 특정 글자로 시작하는 단어 중 사용되지 않은 단어를 랜덤으로 하나 조회
    @Query(value = """
            SELECT * FROM words w 
            WHERE w.firstchar = :firstchar
            AND w.word NOT IN (SELECT uw.word FROM used_words uw)
            ORDER BY RAND()
            LIMIT 1
            """, nativeQuery = true)
    WordsEntity findNextWord(@Param("firstchar") String firstchar);

    @Query(value = """
            SELECT * FROM words 
            ORDER BY RAND() 
            LIMIT 1
            """, nativeQuery = true)
    WordsEntity findRandomStartWord();

    @Query(value = "SELECT word FROM words", nativeQuery = true)
    List<String> findAllWords();

}
