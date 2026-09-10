package com.gaula.service;

import com.gaula.dto.auth.LoginRequest;
import com.gaula.dto.auth.LoginResponse;
import com.gaula.entity.Alumno;
import com.gaula.entity.Profesor;
import com.gaula.repository.AlumnoRepository;
import com.gaula.repository.ProfesorRepository;
import com.gaula.security.JwtTokenProvider;
import com.gaula.security.TokenBlacklist;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import com.gaula.entity.PasswordResetToken;
import com.gaula.repository.PasswordResetTokenRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servicio de autenticación JWT para GAULA.
 *
 * FLUJO DE LOGIN:
 *   1. AuthenticationManager verifica credenciales contra la BBDD
 *      (usa UserDetailsServiceImpl + BCryptPasswordEncoder)
 *   2. Si las credenciales son correctas, generamos el JWT
 *   3. Buscamos el nombre completo y avatar según el tipo de usuario
 *   4. Devolvemos LoginResponse con todos los datos que necesita Flutter
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final AuthenticationManager   authenticationManager;
    private final JwtTokenProvider        jwtTokenProvider;
    private final TokenBlacklist          tokenBlacklist;
    private final ProfesorRepository      profesorRepository;
    private final AlumnoRepository        alumnoRepository;
    private final PasswordResetTokenRepository tokenRepository;
    private final PasswordEncoder         passwordEncoder;

    /**
     * Autentica al usuario y genera un token JWT.
     *
     * @param loginRequest DTO con username y password en texto plano
     * @return LoginResponse con el JWT y los datos del usuario autenticado
     * @throws org.springframework.security.authentication.BadCredentialsException
     *         si las credenciales son incorrectas (lo maneja GlobalExceptionHandler → 401)
     */
    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest loginRequest) {
        log.info("Intento de login para usuario: {}", loginRequest.username());

        // ── 1. Verificar credenciales (lanza BadCredentialsException si falla) ──
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                loginRequest.username(),
                loginRequest.password()
            )
        );

        // ── 2. Generar el token JWT con username + roles ──
        String jwt = jwtTokenProvider.generarToken(authentication);

        // ── 3. Extraer los roles del token generado ──
        List<String> roles = authentication.getAuthorities().stream()
            .map(GrantedAuthority::getAuthority)
            .collect(Collectors.toList());

        // ── 4. Obtener nombre completo, avatar, tema e ID según tipo de usuario ──
        String nombre = "";
        String avatar = "👤";
        String theme  = "light";
        long id = 0;

        // Buscar primero en profesores
        List<Long> cursosTutorIds = new java.util.ArrayList<>();
        var profesorOpt = profesorRepository.findByUsername(loginRequest.username());
        if (profesorOpt.isPresent()) {
            Profesor profesor = profesorOpt.get();
            nombre = profesor.getNombreCompleto();
            avatar = profesor.getAvatar();
            theme  = profesor.getTheme().name();
            id = profesor.getId();
            if (profesor.getCursosTutor() != null) {
                profesor.getCursosTutor().forEach(c -> cursosTutorIds.add(c.getId()));
            }
        } else {
            // Si no es profesor, buscar en alumnos
            var alumnoOpt = alumnoRepository.findByUsername(loginRequest.username());
            if (alumnoOpt.isPresent()) {
                Alumno alumno = alumnoOpt.get();
                nombre = alumno.getNombreCompleto();
                avatar = alumno.getAvatar();
                theme  = alumno.getTheme().name();
                id = alumno.getId();
            }
        }

        log.info("Login exitoso para '{}' con roles: {}", loginRequest.username(), roles);

        return LoginResponse.ofProfesor(id, jwt, loginRequest.username(), nombre, roles, avatar, theme, cursosTutorIds);
    }

    /**
     * Invalida el JWT en el servidor añadiéndolo a la blacklist en memoria.
     * Las peticiones posteriores con este token serán rechazadas con 401.
     */
    public void logout(String token) {
        if (token != null && !token.isBlank()) {
            tokenBlacklist.add(token);
            log.info("Token invalidado por logout");
        }
    }

    /**
     * Genera un código de 6 dígitos para recuperar contraseña y lo guarda.
     * En un entorno real, aquí se enviaría un email.
     */
    @Transactional
    public void sendPasswordResetCode(String email) {
        // Verificar si el email existe en Profesores o Alumnos
        boolean exists = profesorRepository.existsByEmail(email) || alumnoRepository.existsByEmail(email);
        if (!exists) {
            log.warn("Solicitud de recuperación para email inexistente: {}", email);
            // No lanzamos error por seguridad (evitar enumeración de emails)
            return;
        }

        // Generar código de 6 dígitos (SecureRandom — CWE-338)
        String code = String.format("%06d", new SecureRandom().nextInt(1000000));
        
        // Guardar token (validez 15 min)
        PasswordResetToken token = PasswordResetToken.builder()
            .email(email)
            .token(code)
            .expiryDate(LocalDateTime.now().plusMinutes(15))
            .build();
        
        tokenRepository.save(token);
        
        log.info("**********************************************************");
        log.info("CÓDIGO DE RECUPERACIÓN PARA {}: {}", email, code);
        log.info("**********************************************************");
    }

    /**
     * Valida el código y actualiza la contraseña del usuario.
     */
    @Transactional
    public void resetPassword(String code, String newPassword) {
        PasswordResetToken token = tokenRepository.findByToken(code)
            .filter(t -> !t.isUsed() && !t.isExpired())
            .orElseThrow(() -> new IllegalArgumentException("Código inválido o expirado"));

        String email = token.getEmail();
        String encodedPassword = passwordEncoder.encode(newPassword);

        // Actualizar en Profesor
        profesorRepository.findByEmail(email).ifPresent(p -> {
            p.setPassword(encodedPassword);
            profesorRepository.save(p);
        });

        // Actualizar en Alumno
        alumnoRepository.findByEmail(email).ifPresent(a -> {
            a.setPassword(encodedPassword);
            alumnoRepository.save(a);
        });

        token.setUsed(true);
        tokenRepository.save(token);
        log.info("Contraseña reseteada con éxito para el email: {}", email);
    }
}
