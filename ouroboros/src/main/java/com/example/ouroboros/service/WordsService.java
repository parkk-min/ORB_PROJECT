package com.example.ouroboros.service;

import com.example.ouroboros.data.dao.WordsDAO;
import com.example.ouroboros.data.dto.WordsDTO;
import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.WordsRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WordsService {
    private final WordsRepository wordsRepository;
    private final WordsDAO wordsDAO;

    public WordsService(WordsRepository wordsRepository, WordsDAO wordsDAO) {
        this.wordsRepository = wordsRepository;
        this.wordsDAO = wordsDAO;
    }

    public List<WordsEntity> getAllWords() {
        return wordsRepository.findAll();
    }

    public WordsDTO getRandomStartWord() {
        WordsEntity randomWord = wordsDAO.findRandomStartWord();

        if (randomWord == null) {
            return null;
        }

        return WordsDTO.builder()
                .id(randomWord.getId())
                .word(randomWord.getWord())
                .firstChar(randomWord.getFirstChar())
                .lastChar(randomWord.getLastChar())
                .build();
    }

    public List<String> getValidWordsList() {
        // DB에서 단어 리스트 조회 (예: JPA repository 활용)
        return wordsRepository.findAllWords(); // 예시 메서드
    }
}
