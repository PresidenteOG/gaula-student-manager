package com.gaula.dto.alumno;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

import java.util.List;

/**
 * DTO de petición para actualizar un Alumno existente.
 * Todos los campos son opcionales (patch semántico):
 * si un campo es null, no se modifica.
 */
public record UpdateAlumnoRequest(

    @Size(max = 80)
    String nombre,

    @Size(max = 150)
    String apellidos,

    @Email(message = "El email no tiene un formato válido")
    @Size(max = 150)
    String email,

    /** Nuevo estado: "ACTIVO", "INACTIVO" o "DE_BAJA". */
    String estado,

    /** Nuevo ID de curso si el alumno cambia de grupo. */
    Long cursoId,

    /**
     * IDs de las materias en las que está matriculado el alumno.
     * Si no se especifica, se matricula automáticamente en todas las materias del curso, si hay.
     */
    List<Long> materiaIds,

    /** Nueva contraseña (si se quiere cambiar). Debe enviarse sin hashear. */
    @Size(min = 6, max = 100)
    String password,

    String avatar
) {}
