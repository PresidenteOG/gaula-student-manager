package com.gaula.config;

import com.gaula.security.JwtAuthenticationFilter;
import com.gaula.security.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

/**
 * Configuración principal de Spring Security para GAULA.
 * REFACTORIZACIÓN: Se ha eliminado Lombok para evitar errores de compilación con JDK 25.
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final UserDetailsServiceImpl userDetailsService;

    @Value("${gaula.cors.allowed-origins:http://*,https://*}")
    private List<String> allowedOrigins;

    // Inyección por constructor manual para total independencia de Lombok en el núcleo
    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter, 
                          UserDetailsServiceImpl userDetailsService) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        
        // setAllowedOriginPatterns admite patrones glob (http://* cubre cualquier IP/host).
        // Nunca mezclar setAllowedOrigins("*") con setAllowCredentials(true) — Spring lo rechaza.
        if (this.allowedOrigins != null && !this.allowedOrigins.isEmpty()) {
            config.setAllowedOriginPatterns(this.allowedOrigins);
        } else {
            // Fallback seguro: cualquier origen HTTP/HTTPS en dev
            config.setAllowedOriginPatterns(List.of("http://*", "https://*"));
        }
        config.setAllowCredentials(true);
        
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        config.setAllowedHeaders(List.of("Authorization", "Content-Type", "Accept", "X-Requested-With"));
        config.setExposedHeaders(List.of("Authorization"));
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", config);
        source.registerCorsConfiguration("/uploads/**", config);
        return source;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authenticationProvider(authenticationProvider())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/uploads/**").permitAll()
                .requestMatchers("/profiles/**").permitAll()
                .requestMatchers("/error").permitAll()  // Prevent 403 cascade on Spring error dispatch
                .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**").permitAll()
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                // ── Reglamento ─────────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/reglamento/**").authenticated()
                .requestMatchers("/api/reglamento/**").hasRole("ADMIN")
                // ── Admin ──────────────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/admin/configuracion/**").authenticated()
                .requestMatchers(HttpMethod.GET, "/api/admin/anios-escolares/**").hasAnyRole("ADMIN", "TEACHER", "STUDENT")
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                // ── Profesores ─────────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/profesores/**").hasAnyRole("ADMIN", "TEACHER", "STUDENT")
                .requestMatchers("/api/profesores/**").hasAnyRole("ADMIN", "TEACHER")
                // ── Alumnos ────────────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/alumnos/**").hasAnyRole("ADMIN", "TEACHER", "STUDENT")
                .requestMatchers("/api/alumnos/**").hasRole("ADMIN")
                // ── Cursos ─────────────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/cursos/**").hasAnyRole("ADMIN", "TEACHER", "STUDENT")
                .requestMatchers(HttpMethod.POST, "/api/cursos/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.PUT, "/api/cursos/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/api/cursos/**").hasRole("ADMIN")
                // ── Clases (horario) ────────────────────────────────────────────────────────
                .requestMatchers(HttpMethod.GET, "/api/horario/**").hasAnyRole("ADMIN", "TEACHER", "STUDENT")
                .requestMatchers(HttpMethod.POST, "/api/horario/**").hasAnyRole("ADMIN")
                .requestMatchers(HttpMethod.PATCH, "/api/horario/**").hasAnyRole("ADMIN")
                // ── Resto ──────────────────────────────────────────────────────────────────
                .requestMatchers("/api/notificaciones/**").authenticated()
                .requestMatchers("/api/festivos/**").authenticated()
                .requestMatchers("/api/configuracion/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .headers(headers -> headers
                .frameOptions(frame -> frame.sameOrigin()) // Protege contra Clickjacking pero permite H2 console
                .contentSecurityPolicy(csp -> csp.policyDirectives("default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; connect-src 'self' *;"))
                .addHeaderWriter((request, response) -> {
                    response.setHeader("X-Content-Type-Options", "nosniff");
                    response.setHeader("X-XSS-Protection", "1; mode=block");
                    response.setHeader("Strict-Transport-Security", "max-age=31536000 ; includeSubDomains");
                    response.setHeader("Cross-Origin-Resource-Policy", "cross-origin");
                })
            )
            .exceptionHandling(ex -> ex
                // Token caducado/ausente/inválido → 401 (no 403). El interceptor
                // del cliente trata el 401 como sesión muerta y redirige al login.
                .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
