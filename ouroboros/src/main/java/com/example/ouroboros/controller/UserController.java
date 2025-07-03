package com.example.ouroboros.controller;

import com.example.ouroboros.data.dto.UserDTO;
import com.example.ouroboros.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    // 회원정보
    @GetMapping("/user")
    public ResponseEntity<UserDTO> getUser(@RequestParam String username) {
        UserDTO userDTO = this.userService.findUserByUsername(username);
        return ResponseEntity.status(HttpStatus.OK).body(userDTO);
    }
}
