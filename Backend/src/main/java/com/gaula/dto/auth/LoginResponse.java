package com.gaula.dto.auth;

import java.util.List;

/**
 * DTO de respuesta al login exitoso.
 * Devuelto en POST /api/auth/login con status 200 OK:
 * {
 *   "token": "eyJhbGci...",
 *   "tipo": "Bearer",
 *   "username": "ifernandez",
 *   "nombre": "Isabel Fernández Ruiz",
 *   "roles": ["ROLE_TEACHER"],
 *   "avatar": "👩‍🏫"
 * }
 *
 * El cliente Flutter almacena `token` en flutter_secure_storage
 * y lo añade a cada request como "Authorization: Bearer <token>".
 */
public record LoginResponse(
    /** ID único del usuario en la base de datos (clave primaria). */
    long id,

    /** Token JWT para incluir en peticiones futuras. */
    String token,

    /** Tipo de token (siempre "Bearer"). */
    String tipo,

    /** Username del usuario autenticado. */
    String username,

    /** Nombre completo para mostrar en la UI. */
    String nombre,

    /**
     * Roles del usuario (ej: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]).
     * El cliente Flutter usa este campo para mostrar la navegación correcta.
     */
    List<String> roles,

    /** Emoji o URL de avatar para la cabecera de la app. */
    String avatar,

    /** Preferencia de tema: "light" o "dark". */
    String theme,

    /**
     * IDs de los cursos de los que este profesor es tutor.
     * Null o vacío para alumnos y admins.
     * Usado en Flutter para mostrar/ocultar acciones de tutor.
     */
    List<Long> cursosTutorIds
) {
    /** Constructor conveniente con tipo "Bearer" por defecto. */
    public static LoginResponse of(long id, String token, String username, String nombre,
                                   List<String> roles, String avatar, String theme) {
        return new LoginResponse(id, token, "Bearer", username, nombre, roles, avatar, theme, List.of());
    }

    /** Constructor con cursosTutorIds para profesores. */
    public static LoginResponse ofProfesor(long id, String token, String username, String nombre,
                                           List<String> roles, String avatar, String theme,
                                           List<Long> cursosTutorIds) {
        return new LoginResponse(id, token, "Bearer", username, nombre, roles, avatar, theme,
                                 cursosTutorIds != null ? cursosTutorIds : List.of());
    }
}
