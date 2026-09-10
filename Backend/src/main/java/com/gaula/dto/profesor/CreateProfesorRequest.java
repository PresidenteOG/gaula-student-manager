package com.gaula.dto.profesor;

import jakarta.validation.constraints.*;

/** DTO de petición para crear un nuevo Profesor. */
public record CreateProfesorRequest(

    @NotBlank @Size(max = 80)  String nombre,
    @NotBlank @Size(max = 150) String apellidos,

    @NotBlank @Size(min = 3, max = 50)
    @Pattern(regexp = "^[a-z0-9._-]+$", message = "El username solo puede contener letras minúsculas, números, puntos, guiones y subrayados")
    String username,

    @NotBlank @Size(min = 6, max = 100) String password,

    @NotBlank @Email String email,

    /**
     * Rol del profesor: "TEACHER" o "ADMIN".
     * Por defecto se asigna "TEACHER" si no se especifica.
     */
    String rol,

    /** Especialidades separadas por comas. Ej: "Programación, Bases de Datos" */
    @Size(max = 500) String especialidades,

    String avatar
) {}
