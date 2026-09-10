package com.gaula.dto.curso;

import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/** DTO para crear un nuevo Curso (grupo clase real). */
public record CreateCursoRequest(

    @NotBlank(message = "El código de grupo es obligatorio")
    String codigoGrupo,

    Long cursoPlantillaId,

    /** Turno: "MANANA" o "TARDE" */
    String turno,
    int etapaCurso,
    String desdoblamiento,

    @NotNull(message = "El ID del AnioEscolar es obligatorio")
    Long anioEscolarId,

    /** ID del profesor tutor (opcional). */
    Long tutorId,

    /** IDs de los alumnos a matricular (opcional). */
    List<Long> studentIds,

    /** IDs de las materias de la plantilla a instanciar (opcional). */
    List<Long> materiaPlantillaIds
) {}
