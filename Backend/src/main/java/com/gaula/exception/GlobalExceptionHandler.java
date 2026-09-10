package com.gaula.exception;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.security.SignatureException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Manejador global de excepciones REST.
 * Intercepta todas las excepciones no controladas y devuelve
 * respuestas JSON consistentes con el formato ErrorResponse.
 */
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // ──────────────────────────────────────────────────
    // 404 — Recurso no encontrado
    // ──────────────────────────────────────────────────
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        log.warn("Recurso no encontrado: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage()));
    }

    // ──────────────────────────────────────────────────
    // 400 — Validación de campos del request body
    // ──────────────────────────────────────────────────
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ValidationErrorResponse> handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> errores = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            errores.put(error.getField(), error.getDefaultMessage());
        }
        log.warn("Error de validación: {}", errores);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(new ValidationErrorResponse(HttpStatus.BAD_REQUEST.value(), "Error de validación", errores));
    }

    // ──────────────────────────────────────────────────
    // 401 — Credenciales incorrectas en el login
    // ──────────────────────────────────────────────────
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ErrorResponse> handleBadCredentials(BadCredentialsException ex) {
        log.warn("Credenciales inválidas en intento de login");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), "Usuario o contraseña incorrectos"));
    }

    // ──────────────────────────────────────────────────
    // 401 — Token JWT caducado
    // ──────────────────────────────────────────────────
    @ExceptionHandler(ExpiredJwtException.class)
    public ResponseEntity<ErrorResponse> handleExpiredJwt(ExpiredJwtException ex) {
        log.warn("Token JWT caducado");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), "La sesión ha caducado. Por favor, vuelve a iniciar sesión."));
    }

    // ──────────────────────────────────────────────────
    // 401 — Token JWT mal formado o firma inválida
    // ──────────────────────────────────────────────────
    @ExceptionHandler({MalformedJwtException.class, SignatureException.class})
    public ResponseEntity<ErrorResponse> handleInvalidJwt(RuntimeException ex) {
        log.warn("Token JWT inválido: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(new ErrorResponse(HttpStatus.UNAUTHORIZED.value(), "Token de autenticación inválido"));
    }

    // ──────────────────────────────────────────────────
    // 403 — Acceso denegado (rol insuficiente)
    // ──────────────────────────────────────────────────
    @ExceptionHandler(AuthorizationDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(AuthorizationDeniedException ex) {
        log.warn("Acceso denegado: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(new ErrorResponse(HttpStatus.FORBIDDEN.value(), "No tienes permisos para acceder a este recurso"));
    }

    // ──────────────────────────────────────────────────
    // 400 — IllegalArgumentException genérica (lógica de negocio)
    // ──────────────────────────────────────────────────
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgument(IllegalArgumentException ex) {
        log.warn("Argumento inválido: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(new ErrorResponse(HttpStatus.BAD_REQUEST.value(), ex.getMessage()));
    }

    @ExceptionHandler(org.springframework.web.servlet.resource.NoResourceFoundException.class)
    public ResponseEntity<?> handleNoResourceFound(org.springframework.web.servlet.resource.NoResourceFoundException ex) {
        // Silencio para recursos estáticos faltantes (evita inundar logs en modo mobile)
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    // ──────────────────────────────────────────────────
    // 500 — Cualquier otra excepción no controlada
    // ──────────────────────────────────────────────────
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        // Ignorar errores de conexión abortada (broken pipe) que ensucian los logs
        if (ex.getMessage() != null && (ex.getMessage().contains("ServletOutputStream failed to flush") || 
                                      ex.getMessage().contains("anulado una conexión") ||
                                      ex.getMessage().contains("Connection reset by peer") ||
                                      ex.getMessage().contains("No static resource") ||
                                      ex.getMessage().contains("Broken pipe"))) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        
        log.error("Error interno del servidor: {}", ex.getMessage(), ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Se ha producido un error inesperado en el servidor. Por favor, contacte con soporte."));
    }

    // ──────────────────────────────────────────────────
    // Clases de respuesta de error (records de Java 17+)
    // ──────────────────────────────────────────────────

    /** Respuesta de error estándar con timestamp. */
    public record ErrorResponse(
        int status,
        String mensaje,
        LocalDateTime timestamp
    ) {
        public ErrorResponse(int status, String mensaje) {
            this(status, mensaje, LocalDateTime.now());
        }
    }

    /** Respuesta de error de validación con detalle de campos. */
    public record ValidationErrorResponse(
        int status,
        String mensaje,
        Map<String, String> errores,
        LocalDateTime timestamp
    ) {
        public ValidationErrorResponse(int status, String mensaje, Map<String, String> errores) {
            this(status, mensaje, errores, LocalDateTime.now());
        }
    }
}
