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

    public UserEntity findByUsername(String username) {
        return this.userRepository.findByUsername(username).orElse(null);
    }
}
