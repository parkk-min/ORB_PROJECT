package com.example.ouroboros.data.dao;

import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.WordsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WordsDAO {
    private final WordsRepository wordsRepository;

    public WordsEntity findByWord(String word) {
        return wordsRepository.findByWord(word);
    }

    public WordsEntity findNextWord(String lastChar) {
        return wordsRepository.findNextWord(lastChar);
    }

    public WordsEntity findRandomStartWord() {
        return wordsRepository.findRandomStartWord();
    }
}
