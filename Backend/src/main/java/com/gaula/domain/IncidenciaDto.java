package com.gaula.domain;

import com.gaula.entity.Incidencia;
import java.time.LocalDateTime;

public record IncidenciaDto(
    Long id,
    Long alumnoId,
    String alumnoNombre,
    Long cursoId,
    String cursoCodigo,
    Long profesorId,
    String profesorNombre,
    String titulo,
    String descripcion,
    String gravedad,
    String estado,
    String resolucion,
    LocalDateTime fechaIncidencia
) {
    public static IncidenciaDto fromEntity(Incidencia incidencia) {
        var alumno   = incidencia.getAlumno();
        var curso    = alumno != null ? alumno.getCurso() : null;
        var profesor = incidencia.getProfesor();

        return new IncidenciaDto(
            incidencia.getId(),
            alumno   != null ? alumno.getId()             : null,
            alumno   != null ? alumno.getNombreCompleto() : null,
            curso    != null ? curso.getId()              : null,
            curso    != null ? curso.getCodigoGrupo()     : null,
            profesor != null ? profesor.getId()             : null,
            profesor != null ? profesor.getNombreCompleto() : null,
            incidencia.getTitulo(),
            incidencia.getDescripcion(),
            incidencia.getGravedad() != null ? incidencia.getGravedad().name() : null,
            incidencia.getEstado()   != null ? incidencia.getEstado().name()   : null,
            incidencia.getResolucion() != null ? incidencia.getResolucion().name() : null,
            incidencia.getFechaIncidencia()
        );
    }
}
