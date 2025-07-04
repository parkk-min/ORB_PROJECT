package com.example.ouroboros.service;

import com.example.ouroboros.data.dao.UsedWordsDAO;
import com.example.ouroboros.data.dao.UserDAO;
import com.example.ouroboros.data.dao.WordsDAO;
import com.example.ouroboros.data.dto.UsedWordsDTO;
import com.example.ouroboros.data.dto.WordsDTO;
import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.example.ouroboros.data.entity.UserEntity;
import com.example.ouroboros.data.entity.WordsEntity;
import com.example.ouroboros.data.repository.UserRepository;

import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Service
public class UsedWordsService {
    private final UsedWordsDAO usedWordsDAO;
    private final WordsDAO wordsDAO;
    private final UserDAO userDAO;
    private final UserRepository userRepository;


    public UsedWordsService(UsedWordsDAO usedWordsDAO, WordsDAO wordsDAO, UserDAO userDAO, UserRepository userRepository) {
        this.usedWordsDAO = usedWordsDAO;
        this.wordsDAO = wordsDAO;
        this.userDAO = userDAO;
        this.userRepository = userRepository;
    }

    // 실제 끝말잇기 게임 로직 메서드
    // 사용자가 입력한 단어가 word로 들어온다.
    public Map<String, Object> playWordGame(String word, String username) {Map<String, Object> response = new HashMap<>();

        // 유저가 존재하는지 DB에서 조회
        UserEntity user = userDAO.findByUsername(username);
        if (user == null) {
            response.put("error ", "존재하지 않는 사용자입니다.");
            return response;
        }

        // 입력 단어가 사전에 존재하는지 조회
        WordsEntity input = wordsDAO.findByWord(word);
        if (input == null) {
            response.put("error", "존재하지 않는 단어입니다.");
            return response;
        }

        // 이미 이 단어를 해당 유저가 사용했는지 중복 체크
        if (usedWordsDAO.existsByWordAndUser_Username(input.getWord(), username)) {
            response.put("error", "이미 사용된 단어입니다.");
            return response;
        }


        // 사용자 단어 기록 저장
        UsedWordsEntity usedWord = new UsedWordsEntity();
        usedWord.setUser(user);  // 누가 사용했는지 UserEntity로 연결
        usedWord.setWord(input.getWord());
        usedWord.setLog("사용자: " + input.getWord());  // 로그에 기록 남김
        usedWord.setResult(UsedWordsEntity.WinStatus.UNDECIDED);
        usedWordsDAO.save(usedWord);  // DB에 저장


        // 봇이 이어서 사용할 단어 찾기
        WordsEntity botWord = wordsDAO.findNextWord(input.getLastChar());
        if (botWord == null) {  // 다음 단어가 없으면 게임 종료 표시
            response.put("error", "이어질 단어가 없음: " + input.getLastChar());
            response.put("gameOver", true);
            response.put("winner", user.getUsername());
            response.put("nextWord", null);
            response.put("message", "봇이 단어를 찾지 못했습니다. 사용자가 승리했습니다!");
            return response;
        }

        // 봇 단어 기록 저장
        UsedWordsEntity botUsedWord = new UsedWordsEntity();
        botUsedWord.setUser(user);
        botUsedWord.setWord(botWord.getWord());
        botUsedWord.setLog("봇: " + botWord.getWord());
        botUsedWord.setResult(UsedWordsEntity.WinStatus.UNDECIDED);
        usedWordsDAO.save(botUsedWord);

        // DTO 변환
        WordsDTO botWordsDTO = WordsDTO.builder()
                .id(botWord.getId())
                .word(botWord.getWord())
                .firstChar(botWord.getFirstChar())
                .lastChar(botWord.getLastChar())
                .build();

        response.put("gameOver", false);
        // "nextWord"가 서버에 보낼 프론트 키
        response.put("nextWord", botWordsDTO);
        response.put("message", "봇의 단어: " + botWord.getWord());
        return response;

    }

    // 최신 단일 사용자가 낸 단어 기록에 승패 결과 저장
    public void recordGameResult(String username, UsedWordsEntity.WinStatus result) {
        UsedWordsEntity lastUsedWord = usedWordsDAO.findTopByUser_UsernameOrderByIdDesc(username);//유저네임 가장 마지막
        if(lastUsedWord == null || !lastUsedWord.getResult().equals(UsedWordsEntity.WinStatus.UNDECIDED)){
            UserEntity player= userRepository.findById(username).orElse(null);

            UsedWordsEntity usedWordsEntity= UsedWordsEntity.builder()
                    .user(player)
                    .word(null)
                    .log(null)
                    .result(result)
                    .build();
            usedWordsDAO.save(usedWordsEntity);
        }else{
            if (lastUsedWord != null) {
                lastUsedWord.setResult(result);
                usedWordsDAO.save(lastUsedWord);

                // UNDECIDED 삭제
                usedWordsDAO.deleteUndecidedExceptLast(username, lastUsedWord.getId());
            }
        }
    }

    // 특정 유저의 전체 게임 기록 리스트 조회 (DTO 리스트 반환)
    public List<UsedWordsDTO> getGameResult(String username) {
        List<UsedWordsEntity> usedWordsList = usedWordsDAO.findAllByUser_Username(username);
        if (usedWordsList == null || usedWordsList.isEmpty()) {
            return Collections.emptyList();
        }
        return usedWordsList.stream()
                .map(used -> UsedWordsDTO.builder()
                        .id(used.getId())
                        .username(used.getUser().getUsername())
                        .log(used.getLog())
                        .result(used.getResult() != null ? used.getResult() : UsedWordsEntity.WinStatus.UNDECIDED)
                        .build())
                .collect(Collectors.toList());
    }

    // 힌트 요청 시 특정 제시어 반환
    public WordsDTO getHintWord() {
        WordsEntity hint = wordsDAO.findByWord("바나나");

        return WordsDTO.builder()
                .id(hint.getId())
                .word(hint.getWord())
                .firstChar(hint.getFirstChar())
                .lastChar(hint.getLastChar())
                .build();
    }


    // 게임 종료 시 사용자의 사용 단어 기록 삭제
    public void resetGame(String username) {
        usedWordsDAO.deleteByUser_Username(username);
    }

    public Map<String, Object> findHintWord (String word) {
        Map<String, Object> response = new HashMap<>();

        WordsEntity input = wordsDAO.findByWord(word);

        WordsEntity botWord = wordsDAO.findNextWord(input.getLastChar());
        if (botWord == null) {  // 다음 단어가 없으면 게임 종료 표시
            response.put("error", "이어질 단어가 없음: " + input.getLastChar());
            response.put("nextWord", null);
            response.put("message", "봇이 단어를 찾지 못했습니다!");
            return response;
        }
        // DTO 변환
        WordsDTO botWordsDTO = WordsDTO.builder()
                .id(botWord.getId())
                .word(botWord.getWord())
                .firstChar(botWord.getFirstChar())
                .lastChar(botWord.getLastChar())
                .build();

        response.put("gameOver", false);
        // "nextWord"가 서버에 보낼 프론트 키
        response.put("nextWord", botWordsDTO);
        response.put("message", "봇의 단어: " + botWord.getWord());
        return response;
    }
}



