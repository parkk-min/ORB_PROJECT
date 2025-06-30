package com.example.ouroboros.service;

import com.example.ouroboros.data.entity.UserEntity;
import com.example.ouroboros.data.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserEntity getUserOrThrow(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException(username + "는 존재하지 않는 사용자입니다."));
    }


}
