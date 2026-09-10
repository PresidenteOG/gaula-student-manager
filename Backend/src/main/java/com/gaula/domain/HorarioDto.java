package com.gaula.domain;

import com.gaula.entity.Horario;
import lombok.Builder;

/**
 * DTO de dominio de Sesión de Horario (sesión semanal en el horario).
 */
@Builder
public record HorarioDto(

    Long id,
    String diaSemana,      // "MONDAY", "TUESDAY"... nombre del enum DayOfWeek
    String diaEspanol,     // "Lunes", "Martes"... para la UI
    String horaInicio,     // "08:00"
    String horaFin,        // "09:30"
    String aula,
    Long   cursoId,

    /** Datos de la materia que se imparte. */
    Long   materiaId,
    String materiaNombre,
    String materiaCodigo,

    /** Datos del profesor que imparte la sesión (o su sustituto). */
    Long   profesorId,
    String profesorNombre,
    String profesorAvatar,

    /** Datos del sustituto (si el profesor está de baja). */
    Long   sustitutoId,
    String sustitutoNombre,
    String sustitutoAvatar,

    /** Código del grupo al que pertenece esta sesión (via materia → curso). */
    String codigoGrupo,

    /** Color del ciclo para el código de colores en el horario. */
    String colorCiclo

) {

    /** Mapa español de nombres de días de la semana. */
    private static final java.util.Map<String, String> DIAS_ES = java.util.Map.of(
        "MONDAY",    "Lunes",
        "TUESDAY",   "Martes",
        "WEDNESDAY", "Miércoles",
        "THURSDAY",  "Jueves",
        "FRIDAY",    "Viernes",
        "SATURDAY",  "Sábado",
        "SUNDAY",    "Domingo"
    );

    public static HorarioDto fromEntity(Horario clase) {
        String dia       = clase.getDiaSemana() != null ? clase.getDiaSemana().name() : null;
        String diaEs     = dia != null ? DIAS_ES.getOrDefault(dia, dia) : null;
        var    materia   = clase.getMateria();
        var    profesor  = clase.getProfesor();
        var    sustituto = profesor != null ? profesor.getSustituto() : null;
        var    curso     = materia  != null ? materia.getCurso()       : null;
        var    plantilla = curso  != null ? curso.getCursoPlantilla() : null;

        return HorarioDto.builder()
            .id(clase.getId())
            .diaSemana(dia)
            .diaEspanol(diaEs)
            .horaInicio(clase.getHoraInicio()  != null ? clase.getHoraInicio().toString()  : null)
            .horaFin(clase.getHoraFin()        != null ? clase.getHoraFin().toString()     : null)
            .aula(clase.getAula())
            .cursoId(curso     != null ? curso.getId()      : null)
            .materiaId(materia    != null ? materia.getId()     : null)
            .materiaNombre(materia != null ? materia.getNombre() : null)
            .materiaCodigo(materia != null ? materia.getCodigo() : null)
            .profesorId(profesor    != null ? profesor.getId()             : null)
            .profesorNombre(profesor != null ? profesor.getNombreCompleto() : null)
            .profesorAvatar(profesor != null ? profesor.getAvatar()         : null)
            .sustitutoId(sustituto    != null ? sustituto.getId()             : null)
            .sustitutoNombre(sustituto != null ? sustituto.getNombreCompleto() : null)
            .sustitutoAvatar(sustituto != null ? sustituto.getAvatar()         : null)
            .codigoGrupo(curso     != null ? curso.getCodigoGrupo()      : null)
            .colorCiclo(materia != null && materia.getColor() != null ? materia.getColor() : (plantilla != null ? plantilla.getColor() : null))
            .build();
    }
}
