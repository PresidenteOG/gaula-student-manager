package com.gaula.domain;

import com.gaula.entity.Horario;
import com.gaula.entity.Materia;
import com.gaula.entity.Asistencia.EstadoAsistencia;
import com.gaula.entity.Asistencia;
import com.gaula.entity.Clase;

import lombok.Builder;

import java.time.LocalDate;
import java.util.List;

/**
 * DTO de dominio de Curso (grupo clase real: "1º DAM Mañana 24/25").
 */
@Builder
public record ClaseDto(
    Long id,
    Long sesionId,
    LocalDate fecha,
    String materiaNombre,
    String codigoGrupo,
    String profesor,
    String horaInicio,
    String horaFin,
    String aula,
    int presentes,
    int ausentes,
    int retrasos,
    int totalAlumnos
) {

    /**
     * Convierte la entidad Clase en ClaseDto.
     */
    public static ClaseDto fromEntity(Clase clase) {
        Horario horario = clase.getHorario();
        Materia materia = clase.getMateria();
        int totalAlumnos = materia != null ? materia.getAlumnos().size() : 0;
        List<Asistencia> faltas = clase.getFaltas();
        int ausentes = (int)faltas.stream().filter(a -> a.getEstado() == EstadoAsistencia.AUSENTE || a.getEstado() == EstadoAsistencia.JUSTIFICADO).count();
        int retrasos = (int)faltas.stream().filter(a -> a.getEstado() == EstadoAsistencia.RETRASO).count();
        int presentes = totalAlumnos - ausentes;

        return ClaseDto.builder()
            .id(clase.getId())
            .sesionId(horario.getId())
            .fecha(clase.getFecha())
            .materiaNombre(materia != null ? materia.getNombre() : null)
            .codigoGrupo(materia != null && materia.getCurso() != null ? materia.getCurso().getCodigoGrupo() : null)
            .profesor(clase.getProfesor() != null ? clase.getProfesor().getNombreCompleto() : null)
            .horaInicio(horario != null ? horario.getHoraInicio().toString() : null)
            .horaFin(horario != null ? horario.getHoraFin().toString() : null)
            .aula(clase.getAula())
            .totalAlumnos(totalAlumnos)
            .presentes(presentes)
            .ausentes(ausentes)
            .retrasos(retrasos)
            .build();
    }
}
