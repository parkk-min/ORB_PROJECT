package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.UserDTO;
import com.example.ouroboros.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    // 회원가입
    @PostMapping("/signup")
    public ResponseEntity<String> addUser(@RequestBody UserDTO userDTO) {
        this.userService.addUser(userDTO);
        return ResponseEntity.ok("User added. 가입성공");
    }

}
