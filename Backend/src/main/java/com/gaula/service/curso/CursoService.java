package com.gaula.service.curso;

import com.gaula.domain.CursoDto;
import com.gaula.dto.curso.CreateCursoRequest;

import java.util.List;

/**
 * Contrato del servicio de Cursos (grupos clase instanciados).
 */
public interface CursoService {

    /** Lista todos los cursos activos del año escolar activo. */
    List<CursoDto> findAllActivos();

    /** Lista todos los cursos de un CursoEscolar concreto. */
    List<CursoDto> findByCursoEscolarId(Long cursoEscolarId);

    /** Obtiene un curso por ID con todos sus datos. */
    CursoDto findById(Long id);

    /** Crea un nuevo grupo clase. */
    CursoDto create(CreateCursoRequest request);

    /** Asigna o cambia el tutor de un curso. */
    CursoDto asignarTutor(Long cursoId, Long profesorId);

    /** Elimina un curso (solo si no tiene alumnos matriculados). */
    void delete(Long id);
}
