package com.example.ouroboros.data.dao;

import com.example.ouroboros.data.entity.UserEntity;
import com.example.ouroboros.data.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDAO {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // 회원정보
    public UserEntity findByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    // 회원가입
    public UserEntity addUser(UserEntity user) {
        UserEntity userEntity = UserEntity.builder()
                .username(user.getUsername())
                .password(passwordEncoder.encode(user.getPassword()))
                .name(user.getName())
                .role("ROLE_USER")
                .phone(user.getPhone())
                .build();
        return userRepository.save(userEntity);
    }

}
