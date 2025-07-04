package com.example.ouroboros.websocket;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class GameWebSocketHandler extends TextWebSocketHandler {
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    @Autowired
    private MatchAndQuestionService matchService;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String query = session.getUri().getQuery();
        if (query != null && query.contains("playerId=")) {
            String playerId = query.split("playerId=")[1];
            sessions.put(playerId, session);
            matchService.registerSession(playerId, session);
            matchService.queueForMatch(playerId);
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        JSONObject payload = new JSONObject(message.getPayload());
        String to = payload.getString("to");
        WebSocketSession opponentSession = sessions.get(to);

        if (opponentSession != null && opponentSession.isOpen()) {
            opponentSession.sendMessage(new TextMessage(message.getPayload()));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.values().remove(session);
    }
}
