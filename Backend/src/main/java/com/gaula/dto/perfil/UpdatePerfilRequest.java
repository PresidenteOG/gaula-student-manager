package com.gaula.dto.perfil;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

/**
 * Petición de actualización del perfil propio (alumno o profesor autenticado).
 *
 * Validación total a nivel de campo mediante Bean Validation. Los errores
 * los captura {@code GlobalExceptionHandler.handleValidationErrors()} y se
 * devuelven como {@code ValidationErrorResponse { errores: Map<campo,msg> }}.
 *
 * Campos opcionales (dni, telefono, direccion, fechaNacimiento) toleran null.
 * Los @Pattern solo se evalúan cuando el valor no es null/vacío; el service
 * normaliza cadenas vacías a null antes de persistir.
 */
public record UpdatePerfilRequest(

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 80, message = "El nombre no puede superar 80 caracteres")
    String nombre,

    @NotBlank(message = "Los apellidos son obligatorios")
    @Size(max = 150, message = "Los apellidos no pueden superar 150 caracteres")
    String apellidos,

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email no tiene un formato válido")
    @Size(max = 150, message = "El email no puede superar 150 caracteres")
    String email,

    @Size(max = 20, message = "El DNI no puede superar 20 caracteres")
    @Pattern(regexp = "^$|^[0-9XYZ][0-9]{7}[A-Za-z]$", message = "DNI/NIE inválido (ej: 12345678A)")
    String dni,

    @Size(max = 20, message = "El teléfono no puede superar 20 caracteres")
    @Pattern(regexp = "^$|^[+]?[0-9 ]{6,20}$", message = "Teléfono inválido")
    String telefono,

    @Size(max = 255, message = "La dirección no puede superar 255 caracteres")
    String direccion,

    @Past(message = "La fecha de nacimiento debe ser una fecha pasada")
    LocalDate fechaNacimiento

) {}
