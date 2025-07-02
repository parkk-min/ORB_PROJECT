package com.example.ouroboros.service;

import com.example.ouroboros.data.dao.UserDAO;
import com.example.ouroboros.data.dto.UserDTO;
import com.example.ouroboros.data.entity.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserDAO userDAO;

    // 인증처리 - 사용자정보 DB에서 로딩
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserEntity userEntity = this.userDAO.findByUsername(username);
        if (userEntity == null) {
            throw new UsernameNotFoundException(username);
        }
        // role 권한 셋팅
        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        grantedAuthorities.add(new SimpleGrantedAuthority(userEntity.getRole()));
        return new User(userEntity.getUsername(), userEntity.getPassword(), grantedAuthorities);
    }

    // 회원가입
    public UserDTO addUser(UserDTO userDTO) {
        if (isNullOrBlank(userDTO.getUsername()) || isNullOrBlank(userDTO.getPassword()) || isNullOrBlank(userDTO.getName())) {
            throw new IllegalArgumentException("필수값 누락");
        }
        if (this.userDAO.findByUsername(userDTO.getUsername()) != null) {
            throw new IllegalArgumentException("Username already exists 동일아이디 존재");
        }
        UserEntity userEntity = UserEntity.builder()
                .username(userDTO.getUsername())
                .password(userDTO.getPassword())
                .name(userDTO.getName())
                .phone(userDTO.getPhone())
                .build();
        this.userDAO.addUser(userEntity); // 저장
        UserDTO saveUserDTO = UserDTO.builder() // 비밀번호 제외
                .username(userDTO.getUsername())
                .name(userDTO.getName())
                .phone(userDTO.getPhone())
                .build();
        return saveUserDTO;
    }
    private boolean isNullOrBlank(String str) {
        return str == null || str.isBlank();
    }

    // 회원정보
    public UserDTO findUserByUsername(String username) {
        UserEntity userEntity = this.userDAO.findByUsername(username);
        return UserDTO.builder()
                .username(userEntity.getUsername())
                .name(userEntity.getName())
                .phone(userEntity.getPhone())
                .build();
    }



}
