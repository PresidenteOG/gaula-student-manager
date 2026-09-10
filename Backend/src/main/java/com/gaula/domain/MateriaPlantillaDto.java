package com.gaula.domain;

import com.gaula.entity.MateriaPlantilla;
import lombok.Builder;

/**
 * DTO de dominio de Materia (módulo instanciado en un Curso).
 */
@Builder
public record MateriaPlantillaDto(

    Long id,
    String codigo,
    String nombre,
    String tipo,
    int horasTotales,

    /** Plantilla del curso (puede ser null si se creó manualmente). */
    Long   cursoPlantillaId

) {

    public static MateriaPlantillaDto fromEntity(MateriaPlantilla materia) {
        return MateriaPlantillaDto.builder()
            .id(materia.getId())
            .codigo(materia.getCodigo())
            .nombre(materia.getNombre())
            .tipo(materia.getTipo().name())
            .horasTotales(materia.getHorasTotales())
            .cursoPlantillaId(materia.getCursoPlantilla() != null ? materia.getCursoPlantilla().getId() : null)
            .build();
    }
}
