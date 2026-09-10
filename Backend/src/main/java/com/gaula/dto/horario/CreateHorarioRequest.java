package com.gaula.dto.horario;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/** DTO para crear una nueva Clase (sesión semanal en el horario). */
public record CreateHorarioRequest(

    /** Día de la semana en inglés: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY */
    @NotBlank String diaSemana,

    /** Hora de inicio en formato HH:MM. Ej: "08:00" */
    @NotBlank String horaInicio,

    /** Hora de fin en formato HH:MM. Ej: "09:30" */
    @NotBlank String horaFin,

    /** Aula o espacio donde se imparte. Ej: "Aula 201", "Lab A102" */
    String aula,

    @NotNull(message = "El ID de la materia es obligatorio")
    Long materiaId,

    @NotNull(message = "El ID del profesor es obligatorio")
    Long profesorId
) {}
