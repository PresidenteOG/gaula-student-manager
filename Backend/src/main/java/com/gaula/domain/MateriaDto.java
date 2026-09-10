package com.gaula.domain;

import com.gaula.entity.Materia;
import lombok.Builder;

/**
 * DTO de dominio de Materia (módulo instanciado en un Curso).
 */
@Builder
public record MateriaDto(

    Long id,
    String nombre,
    String codigo,
    int horasTotales,

    /** Curso al que pertenece esta materia. */
    Long   cursoId,
    String codigoGrupo,

    /** Plantilla de origen (puede ser null si se creó manualmente). */
    Long   materiaPlantillaId,
    String codigoPlantilla,

    /** Total de sesiones (clases) registradas para esta materia. */
    int totalClases,

    /** Total de alumnos matriculados en esta materia. */
    int totalAlumnos

) {

    public static MateriaDto fromEntity(Materia materia) {
        return MateriaDto.builder()
            .id(materia.getId())
            .nombre(materia.getNombre())
            .codigo(materia.getCodigo())
            .horasTotales(materia.getHorasTotales())
            .cursoId(materia.getCurso() != null ? materia.getCurso().getId() : null)
            .codigoGrupo(materia.getCurso() != null ? materia.getCurso().getCodigoGrupo() : null)
            .materiaPlantillaId(materia.getMateriaPlantilla() != null ? materia.getMateriaPlantilla().getId() : null)
            .codigoPlantilla(materia.getMateriaPlantilla() != null ? materia.getMateriaPlantilla().getCodigo() : null)
            .totalClases(materia.getClases() != null ? materia.getClases().size() : 0)
            .totalAlumnos(materia.getAlumnos() != null ? materia.getAlumnos().size() : 0)
            .build();
    }
}
