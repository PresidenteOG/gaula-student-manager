package com.gaula.controller;

import com.gaula.dto.auth.LoginRequest;
import com.gaula.dto.auth.LoginResponse;
import com.gaula.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

/**
 * Controlador de autenticación — endpoint público para login JWT.
 * No requiere autenticación previa (permitAll en SecurityConfig).
 *
 * POST /api/auth/login  → Autentica y devuelve JWT
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Autenticación", description = "Endpoints para login y gestión de sesión JWT")
public class AuthController {

    private final AuthService authService;

    /**
     * Autentica al usuario con username y password.
     * Devuelve el JWT, roles y datos del usuario para que Flutter
     * pueda inicializar la sesión y mostrar la pantalla correcta.
     *
     * @param loginRequest body JSON con username y password
     * @return 200 OK con LoginResponse si las credenciales son válidas
     *         401 Unauthorized si son incorrectas (via GlobalExceptionHandler)
     */
    @PostMapping("/login")
    @Operation(
        summary = "Iniciar sesión",
        description = "Autentica al usuario y devuelve un token JWT para usarlo en sesiones posteriores. " +
                      "Credenciales de demo: admin/admin123, igarcia/igarcia123, clopez/clopez123"
    )
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        LoginResponse response = authService.login(loginRequest);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    @Operation(summary = "Cerrar sesión", description = "Invalida el JWT en el servidor para que no pueda reutilizarse.")
    public ResponseEntity<Void> logout(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            authService.logout(authHeader.substring(7));
        }
        return ResponseEntity.ok().build();
    }

    @PostMapping("/forgot-password")
    @Operation(summary = "Solicitar recuperación de contraseña")
    public ResponseEntity<Void> forgotPassword(@RequestParam String email) {
        authService.sendPasswordResetCode(email);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reset-password")
    @Operation(summary = "Restablecer contraseña usando código")
    public ResponseEntity<Void> resetPassword(@RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request.code(), request.newPassword());
        return ResponseEntity.ok().build();
    }

    public record ResetPasswordRequest(String code, String newPassword) {}
}
