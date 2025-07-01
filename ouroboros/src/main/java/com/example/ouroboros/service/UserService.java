package com.example.ouroboros.service;

import com.example.ouroboros.data.dao.UserDAO;
import com.example.ouroboros.data.entity.UserEntity;
import com.example.ouroboros.data.repository.UserRepository;
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


}
