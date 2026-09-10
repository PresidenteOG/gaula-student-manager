package com.gaula.domain;

import com.gaula.entity.CursoPlantilla;
import lombok.Builder;
import jakarta.validation.constraints.NotBlank;
import java.util.List;

/**
 * DTO de dominio de Curso (grupo clase real: "1º DAM Mañana 24/25").
 */
@Builder
public record CursoPlantillaDto(

    Long   id,

    @NotBlank(message = "El código es obligatorio")
    String codigo, //nombre 'DAM', 'ESO'

    @NotBlank(message = "El nombre es obligatorio")
    String nombre, //nombre completo 'Desarrollo de Aplicaciones Multiplataforma'

    String descripcion, //descripción no obligatoria

    @NotBlank(message = "El color es obligatorio")
    String color,

    /** Número de materias del curso. */
    int totalMaterias,

    /** Lista resumida de materias. */
    List<MateriaPlantillaResumenDto> materias

) {

    /**
     * Convierte la entidad Curso en CursoDto.
     * Acepta un flag inicializarListas para controlar si se cargan
     * las colecciones (alumnos, materias) o solo los datos básicos.
     */
    public static CursoPlantillaDto fromEntity(CursoPlantilla curso) {
        List<MateriaPlantillaResumenDto> materias = curso.getMateriasPlantilla() != null
            ? curso.getMateriasPlantilla().stream()
                .map(m -> new MateriaPlantillaResumenDto(m.getId(), m.getNombre(), m.getCodigo(), m.getHorasTotales(), m.getTipo().name()))
                .toList()
            : List.of();

        return CursoPlantillaDto.builder()
            .id(curso.getId())
            .codigo(curso.getCodigo())
            .nombre(curso.getNombre())
            .descripcion(curso.getDescripcion())
            .color(curso.getColor())
            .totalMaterias(materias.size())
            .materias(materias)
            .build();
    }

    /** Resumen de materia para incluir dentro de CursoDto. */
    public record MateriaPlantillaResumenDto(Long id, String nombre, String codigo, Integer horasTotales, String tipo) {}
}
