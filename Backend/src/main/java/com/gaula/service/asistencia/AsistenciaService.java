package com.gaula.service.asistencia;

import com.gaula.domain.AsistenciaDto;
import com.gaula.dto.pasar_lista.RegistroDeFaltaRequest;
import com.gaula.entity.Clase;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface AsistenciaService {

    List<AsistenciaDto> findByAlumnoId(Long alumnoId);

    List<AsistenciaDto> findBySessionIdAndFecha(Long sessionId, LocalDate fecha);

    void guardarAsistenciaMasiva(Clase clase, LocalDate fecha, List<RegistroDeFaltaRequest> registros);

    Map<String, Object> calcularResumenAlumno(Long alumnoId);

    // Tutor-restricted operations: only the tutor of the student's course (or admin) can modify
    void eliminarAsistencia(Long asistenciaId, Long profesorId);

    void justificarAsistencia(Long asistenciaId, String observaciones, Long profesorId);
}
