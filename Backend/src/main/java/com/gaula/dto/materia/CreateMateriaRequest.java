package com.gaula.dto.materia;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

/** DTO para crear o actualizar una Materia en un Curso. */
public record CreateMateriaRequest(

    @NotBlank String nombre,
    @NotBlank String codigo,

    @Positive(message = "Las horas totales deben ser un número positivo")
    int horasTotales,

    @NotNull(message = "El ID del curso es obligatorio")
    Long cursoId,

    /** ID de la MateriaPlantilla de origen (puede ser null si es manual). */
    Long materiaPlantillaId
) {}
