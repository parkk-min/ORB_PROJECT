package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.UsedWordsDTO;
import com.example.ouroboros.data.entity.UsedWordsEntity;
import com.example.ouroboros.service.UsedWordsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/game")
public class UsedWordsController {
    private final UsedWordsService usedWordsService;

    // 끝말잇기 게임 플레이
    @PostMapping("/play")
    public ResponseEntity<Map<String, Object>> playWordGame(@RequestBody UsedWordsDTO request) {
        if (request.getWord() == null || request.getUsername() == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "단어 정보와 유저 정보가 없습니다.."));
        }
        Map<String, Object> response = usedWordsService.playWordGame(
                request.getWord(),
                request.getUsername()
        );
        return ResponseEntity.ok(response);
    }

    // 게임 결과 저장 (승패 기록)
    @PostMapping("/result")
    public ResponseEntity<Map<String, String>> recordGameResult(@RequestBody UsedWordsDTO request) {
        // 입력 유효성 검사
        if (request.getUsername() == null || request.getResult() == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "username or result is missing"));
        }

        try {
            UsedWordsEntity.WinStatus result = UsedWordsEntity.WinStatus.valueOf(String.valueOf(request.getResult()));
            usedWordsService.recordGameResult(request.getUsername(), result);
            return ResponseEntity.ok(Map.of("message", "승패 결과: " + result));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Invalid result: " + request.getResult()));
        }
    }

    // 사용자 단어 사용 기록 전체 조회
    @PostMapping("/history")
    public ResponseEntity<?> getGameHistory(@RequestBody UsedWordsDTO request) {
        // 입력 유효성 검사
        if (request.getUsername() == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "유저 정보가 없습니다."));
        }

        List<UsedWordsDTO> history = usedWordsService.getGameResult(request.getUsername());
        if (history == null || history.isEmpty()) {
            return ResponseEntity.ok(Map.of("message", "게임기록이 없습니다: " + request.getUsername()));
        }

        return ResponseEntity.ok(history);
    }

    // 4) 게임 기록 초기화
    @PostMapping("/reset")
    public ResponseEntity<Void> resetGame(@RequestBody UsedWordsDTO request) {
        usedWordsService.resetGame(request.getUsername());
        return ResponseEntity.ok().build();
    }


}
