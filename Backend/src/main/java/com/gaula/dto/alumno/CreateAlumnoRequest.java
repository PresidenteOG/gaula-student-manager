package com.gaula.dto.alumno;

import jakarta.validation.constraints.*;

/**
 * DTO de petición para crear un nuevo Alumno.
 * Validado con Jakarta Validation en el Controller con @Valid.
 */
public record CreateAlumnoRequest(

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 80, message = "El nombre no puede superar 80 caracteres")
    String nombre,

    @NotBlank(message = "Los apellidos son obligatorios")
    @Size(max = 150, message = "Los apellidos no pueden superar 150 caracteres")
    String apellidos,

    @NotBlank(message = "El username es obligatorio")
    @Size(min = 3, max = 50, message = "El username debe tener entre 3 y 50 caracteres")
    @Pattern(regexp = "^[a-z0-9._-]+$", message = "El username solo puede contener letras minúsculas, números, puntos, guiones y subrayados")
    String username,

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 6, max = 100, message = "La contraseña debe tener entre 6 y 100 caracteres")
    String password,

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email no tiene un formato válido")
    String email,

    /**
     * Emoji o texto de avatar. Si no se especifica, se usará "👨‍🎓" por defecto.
     */
    String avatar,

    String dni,
    String telefono,
    String direccion,
    java.time.LocalDate fechaNacimiento
) {}
