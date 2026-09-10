package com.gaula.dto.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * DTO de petición de login.
 * Recibido en POST /api/auth/login con body JSON:
 * { "username": "ifernandez", "password": "micontrasena" }
 *
 * Las validaciones de Jakarta Validation se activan con @Valid en el Controller.
 */
public record LoginRequest(

    @NotBlank(message = "El nombre de usuario no puede estar vacío")
    @Size(min = 3, max = 50, message = "El usuario debe tener entre 3 y 50 caracteres")
    String username,

    @NotBlank(message = "La contraseña no puede estar vacía")
    @Size(min = 4, max = 100, message = "La contraseña debe tener entre 4 y 100 caracteres")
    String password
) {}
