package com.example.ouroboros.service;

import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.WordsRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Random;

@Service
public class WordsService {
    private final WordsRepository wordsRepository;

    public WordsService(WordsRepository wordsRepository) {
        this.wordsRepository = wordsRepository;
    }

    // 전체 단어 리스트 조회
    public List<WordsEntity> getAllWords() {
        return wordsRepository.findAll();
    }


}
