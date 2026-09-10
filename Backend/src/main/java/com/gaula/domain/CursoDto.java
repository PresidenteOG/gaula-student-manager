package com.gaula.domain;

import com.gaula.entity.Curso;
import com.gaula.entity.CursoPlantilla;
import com.gaula.entity.AnioEscolar;
import lombok.Builder;

import java.util.List;

/**
 * DTO de dominio de Curso (grupo clase real: "1º DAM Mañana 24/25").
 */
@Builder
public record CursoDto(

    Long id,
    String codigoGrupo,

    /** ID del AnioEscolar al que pertenece. */
    Long anioEscolarId,
    String denominacionEscolar,   // "24/25"
    String turno,                 // "MANANA" / "TARDE"
    int etapaCurso,
    String desdoblamiento,

    /** Datos del ciclo (CursoPlantilla): DAM, DAW... */
    Long   cursoPlantillaId,
    String codigoCiclo,
    String nombreCiclo,
    String colorCiclo,

    /** Tutor del grupo (puede ser null). */
    Long   tutorId,
    String tutorNombre,
    String tutorAvatar,

    /** Número de alumnos matriculados en este grupo. */
    int totalAlumnos,

    /** Número de materias del grupo. */
    int totalMaterias,

    /** Lista resumida de materias. */
    List<MateriaResumenDto> materias

) {

    /**
     * Convierte la entidad Curso en CursoDto.
     * Acepta un flag inicializarListas para controlar si se cargan
     * las colecciones (alumnos, materias) o solo los datos básicos.
     */
    public static CursoDto fromEntity(Curso curso) {
        AnioEscolar escolar      = curso.getAnioEscolar();
        CursoPlantilla plantilla = curso.getCursoPlantilla();
        var          tutor       = curso.getTutor();

        List<MateriaResumenDto> materias = curso.getMaterias() != null
            ? curso.getMaterias().stream()
                .map(m -> new MateriaResumenDto(m.getId(), m.getNombre(), m.getCodigo(), m.getHorasTotales()))
                .toList()
            : List.of();

        return CursoDto.builder()
            .id(curso.getId())
            .codigoGrupo(curso.getCodigoGrupo())
            .anioEscolarId(escolar       != null ? escolar.getId()              : null)
            .denominacionEscolar(escolar != null ? escolar.getDenominacion()    : null)
            .turno(curso.getTurno() != null ? curso.getTurno().name() : null)
            .desdoblamiento(curso.getDesdoblamiento())
            .etapaCurso(curso.getEtapaCurso())
            .cursoPlantillaId(plantilla.getId())
            .codigoCiclo(plantilla.getCodigo())
            .nombreCiclo(plantilla.getNombre())
            .colorCiclo(plantilla.getColor())
            .tutorId(tutor     != null ? tutor.getId()             : null)
            .tutorNombre(tutor != null ? tutor.getNombreCompleto() : null)
            .tutorAvatar(tutor != null ? tutor.getAvatar()         : null)
            .totalAlumnos(curso.getAlumnos() != null ? curso.getAlumnos().size() : 0)
            .totalMaterias(materias.size())
            .materias(materias)
            .build();
    }

    /** Resumen de materia para incluir dentro de CursoDto. */
    public record MateriaResumenDto(Long id, String nombre, String codigo, int horasTotales) {}
}
