package com.example.ouroboros.config;

import com.example.ouroboros.component.CustomAccessDeniedHandler;
import com.example.ouroboros.component.CustomAuthenticationEntryPoint;
import com.example.ouroboros.jwt.JwtFilter;
import com.example.ouroboros.jwt.JwtLoginFilter;
import com.example.ouroboros.jwt.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final AuthenticationConfiguration authenticationConfiguration;
    private final CustomAuthenticationEntryPoint customAuthenticationEntryPoint;
    private final CustomAccessDeniedHandler customAccessDeniedHandler;
    private final JwtUtil jwtUtil;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager(); // AuthenticationManager를 빈으로 등록해 인증에 사용
    }

    // 메인 인증로직 (JWT)
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csfr -> csfr.disable())
                .formLogin(formLogin -> formLogin.disable())
                .logout(logout -> logout.disable())
                .httpBasic(httpBasic -> httpBasic.disable())
                // 요청별 권한
                .authorizeHttpRequests(requests -> {
//                    requests.requestMatchers("**").permitAll(); // 임시
                    requests.requestMatchers("/", "/login", "/reissue","/signup","/**").permitAll(); // 누구나 접근가능
                    requests.requestMatchers("/admin/**").hasRole("ADMIN"); // 관리자만 접근가능
                    requests.anyRequest().authenticated(); // 그외는 인증필요
                })
                // CORS 설정
                .cors(cors -> cors.configurationSource(request -> {
                    CorsConfiguration corsConfiguration = new CorsConfiguration();
                    corsConfiguration.addAllowedOrigin("http://localhost:3000");
                    corsConfiguration.addAllowedHeader("*");
                    corsConfiguration.setExposedHeaders(List.of("Authorization")); // 브라우저가 응답헤더 중 Authorization 헤더 접근 허용
                    corsConfiguration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
                    corsConfiguration.setAllowCredentials(true); // 쿠키허용
                    return corsConfiguration;
                }))
                // 세션사용X (JWT인증 사용)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // 필터
                .addFilterBefore(new JwtFilter(this.jwtUtil), JwtLoginFilter.class)
                .addFilterAt(new JwtLoginFilter(authenticationManager(this.authenticationConfiguration), this.jwtUtil), UsernamePasswordAuthenticationFilter.class)
                // 예외처리
                .exceptionHandling(exception -> {
                    exception.authenticationEntryPoint(this.customAuthenticationEntryPoint);
                    exception.accessDeniedHandler(this.customAccessDeniedHandler);
                });
        return http.build();
    }


}
