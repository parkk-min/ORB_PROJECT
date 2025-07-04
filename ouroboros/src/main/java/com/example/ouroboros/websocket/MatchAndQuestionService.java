package com.example.ouroboros.websocket;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class MatchAndQuestionService {

    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();
    private final Set<String> waitingPlayers = new HashSet<>();

    // 세션 등록
    public void registerSession(String playerId, WebSocketSession session) {
        sessions.put(playerId, session);
    }

    // 세션 제거
    public void removeSession(String playerId) {
        sessions.remove(playerId);
        waitingPlayers.remove(playerId);
    }

    // 매칭 큐 등록 및 자동 매칭
    public void queueForMatch(String playerId) throws IOException {
        waitingPlayers.add(playerId);

        if (waitingPlayers.size() >= 2) {
            List<String> players = new ArrayList<>(waitingPlayers);
            String p1 = players.get(0);
            String p2 = players.get(1);

            waitingPlayers.remove(p1);
            waitingPlayers.remove(p2);

            sendToBoth(p1, p2, "question", "'사'로 시작하는 단어를 말하세요");
        }
    }

    // 양쪽 유저에게 문제 전송
    private void sendToBoth(String p1, String p2, String type, String data) throws IOException {
        String message1 = String.format(
                "{\"type\":\"%s\", \"data\":\"%s\", \"opponent\":\"%s\"}", type, data, p2
        );
        sessions.get(p1).sendMessage(new TextMessage(message1));

        String message2 = String.format(
                "{\"type\":\"%s\", \"data\":\"%s\", \"opponent\":\"%s\"}", type, data, p1
        );
        sessions.get(p2).sendMessage(new TextMessage(message2));
    }
}
