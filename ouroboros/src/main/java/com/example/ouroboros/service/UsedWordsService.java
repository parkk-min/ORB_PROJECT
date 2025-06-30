package com.example.ouroboros.service;

import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.UsedWordsRepository;
import com.example.ouroboros.data.repository.UserRepository;
import com.example.ouroboros.data.repository.WordsRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UsedWordsService {
    final WordsRepository wordsRepository;
    final UsedWordsRepository usedWordsRepository;
    final UserRepository userRepository;

    public UsedWordsService(WordsRepository wordsRepository, UsedWordsRepository usedWordsRepository, UserRepository userRepository) {
        this.wordsRepository = wordsRepository;
        this.usedWordsRepository = usedWordsRepository;
        this.userRepository = userRepository;
    }


    public Map<String, Object> playWordGame(String word, String username) {
        Map<String, Object> response = new HashMap<>();

        // 1. 단어 존재 확인
        WordsRepository wordsRepository;
        WordsEntity input = wordsRepository.findByWord(word);
        if (input == null) {
            response.put("error", "존재하지 않는 단어: " + word);
            return response;
        }

        // 2. 중복 단어 확인
        if (usedWordsRepository.existsByWordAndUser_Username(inputWord, username)) {
            response.put("error", "이미 사용된 단어: " + inputWord);
            return response;
        }

        // 3. 끝말잇기 규칙 확인
        UsedWordsEntity lastUsed = usedWordsRepository.findTopByUser_UsernameOrderByIdDesc(username);
        if (lastUsed != null) {
            WordsEntity lastWord = wordsRepository.findByWord(lastUsed.getWord());
            if (!lastWord.getLastChar().equals(input.getFirstChar())) {
                response.put("error", "끝말잇기 규칙에 맞지 않음: " + inputWord);
                return response;
            }
        }

        // 4. 사용된 단어 기록
        UsedWordsEntity usedWord = new UsedWordsEntity();
        usedWord.setUser(userRepository.findByUsername(username));
        usedWord.setWord(inputWord);
        usedWord.setLog("사용자: " + inputWord);
        usedWord.setWin(false);
        usedWordsRepository.save(usedWord);

        // 5. 봇의 다음 단어
        WordsEntity botWord = wordsRepository.findNextWord(input.getLastChar());
        if (botWord == null) {
            response.put("error", "이어질 단어가 없음: " + input.getLastChar());
            response.put("gameOver", true);
            return response;
        }

        // 6. 봇 단어 기록
        UsedWordsEntity botUsedWord = new UsedWordsEntity();
        botUsedWord.setUser(userRepository.findByUsername(username));
        botUsedWord.setWord(botWord.getWord());
        botUsedWord.setLog("봇: " + botWord.getWord());
        botUsedWord.setWin(false);
        usedWordsRepository.save(botUsedWord);

        response.put("nextWord", botWord.getWord());
        return response;
    }

    // 게임 종료 시 초기화
    public void resetGame(String username) {
        usedWordsRepository.deleteByUser_Username(username);
    }

}



