package com.gaula.domain;

import com.gaula.entity.Asistencia;
import java.time.LocalDateTime;
import java.time.LocalDate;

public record AsistenciaDto(
    Long id,
    Long claseId,
    Long alumnoId,
    String alumnoAvatar,
    String alumnoNombre,
    String estado,
    String observaciones,
    LocalDateTime fechaRegistro,
    LocalDate fecha,
    // Extended fields for the new attendance UI
    Long materiaId,
    String materiaNombre,
    String materiaCodigo,
    String profesorNombre,
    String horaInicio,
    String horaFin
) {
    public static AsistenciaDto fromEntity(Asistencia asistencia) {
        var clase = asistencia.getClase();
        var materia = clase != null ? clase.getMateria() : null;
        var profesor = clase != null ? clase.getProfesor() : null;
        var horario = clase != null ? clase.getHorario() : null;
        return new AsistenciaDto(
            asistencia.getId(),
            clase != null ? clase.getId() : null,
            asistencia.getAlumno().getId(),
            asistencia.getAlumno().getAvatar(),
            asistencia.getAlumno().getNombreCompleto(),
            asistencia.getEstado().name(),
            asistencia.getObservaciones(),
            asistencia.getFechaRegistro(),
            asistencia.getFecha(),
            materia != null ? materia.getId() : null,
            materia != null ? materia.getNombre() : null,
            materia != null ? materia.getCodigo() : null,
            profesor != null ? profesor.getNombreCompleto() : null,
            horario != null && horario.getHoraInicio() != null ? horario.getHoraInicio().toString() : null,
            horario != null && horario.getHoraFin() != null ? horario.getHoraFin().toString() : null
        );
    }

}
