package com.gaula.dto.plantilla;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

/** DTO para crear o actualizar una Materia en un Curso. */
public record CreateMateriaPlantillaRequest(

    @NotBlank String codigo,
    @NotBlank String nombre,

    @Positive(message = "Las horas totales deben ser un número positivo")
    int horasTotales,

    /** ID de la CursoPlantilla de origen. */
    @NotNull(message = "El ID del curso plantilla es obligatorio")
    Long cursoPlantillaId
) {}
