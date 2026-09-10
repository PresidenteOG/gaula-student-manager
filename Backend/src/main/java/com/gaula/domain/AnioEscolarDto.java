package com.gaula.domain;

import com.gaula.entity.AnioEscolar;
import lombok.Builder;

import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * DTO de dominio de CursoEscolar (año académico + turno + ciclo).
 */
@Builder
public record AnioEscolarDto(

    Long id,
    String nombre,        // Mapped from denominacion for frontend compatibility
    String denominacion,  // "24/25"
    String descripcion,
    boolean activo,
    String fechaInicio,
    String fechaFin,

    /** Grupos (cursos) dentro de este año escolar. */
    List<GrupoResumenDto> grupos,
    int totalGrupos

) {

    public static AnioEscolarDto fromEntity(AnioEscolar ae) {
        List<GrupoResumenDto> grupos = ae.getCursos() != null
            ? ae.getCursos().stream()
                .map(c -> new GrupoResumenDto(
                    c.getId(),
                    c.getCodigoGrupo(),
                    c.getAlumnos() != null ? c.getAlumnos().size() : 0
                ))
                .toList()
            : List.of();

        return AnioEscolarDto.builder()
            .id(ae.getId())
            .nombre(ae.getDenominacion())
            .denominacion(ae.getDenominacion())
            .descripcion(ae.getDescripcion())
            .activo(Boolean.TRUE.equals(ae.getActivo()))
            .fechaInicio(ae.getFechaInicio() != null ? ae.getFechaInicio().format(DateTimeFormatter.ISO_LOCAL_DATE) : null)
            .fechaFin(ae.getFechaFin() != null ? ae.getFechaFin().format(DateTimeFormatter.ISO_LOCAL_DATE) : null)
            .grupos(grupos)
            .totalGrupos(grupos.size())
            .build();
    }

    /** Resumen de grupo dentro de CursoEscolarDto. */
    public record GrupoResumenDto(Long id, String codigoGrupo, int totalAlumnos) {}
}
