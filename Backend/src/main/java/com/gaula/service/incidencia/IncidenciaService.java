package com.gaula.service.incidencia;

import com.gaula.domain.IncidenciaDto;
import com.gaula.dto.incidencia.CreateIncidenciaRequest;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface IncidenciaService {
    List<IncidenciaDto> findAll();
    Page<IncidenciaDto> findAllPaginated(Pageable pageable);
    List<IncidenciaDto> findByAlumnoId(Long alumnoId);
    List<IncidenciaDto> findByProfesor(String username);
    Page<IncidenciaDto> findAvanzado(String username, String role, Long alumnoId, Long profesorId, Long cursoId, String estado, String resolucion, Pageable pageable);

    Page<IncidenciaDto> findByProfesorPaginated(String username, Pageable pageable);
    IncidenciaDto create(CreateIncidenciaRequest request);
    IncidenciaDto updateEstado(Long id, String nuevoEstado, String resolucion);
    void delete(Long id);
}
