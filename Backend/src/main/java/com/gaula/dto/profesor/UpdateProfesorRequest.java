package com.gaula.dto.profesor;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

/** DTO de petición para actualizar un Profesor (campos opcionales). */
public record UpdateProfesorRequest(
    @Size(max = 80)  String nombre,
    @Size(max = 150) String apellidos,
    @Email @Size(max = 150) String email,
    String estado,
    String rol,
    @Size(max = 500) String especialidades,
    @Size(min = 6, max = 100) String password,
    String avatar
) {}
