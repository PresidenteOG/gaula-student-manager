package com.gaula.service.alumno;

import com.gaula.domain.AlumnoDto;
import com.gaula.dto.alumno.CreateAlumnoRequest;
import com.gaula.dto.alumno.UpdateAlumnoRequest;
import com.gaula.dto.perfil.UpdatePerfilRequest;

import java.util.List;

/**
 * Contrato del servicio de Alumnos.
 * Los controllers solo conocen esta interfaz, nunca la implementación.
 * Permite intercambiar la impl sin cambiar los controllers.
 */
public interface AlumnoService {

    /** Lista todos los alumnos del sistema. */
    List<AlumnoDto> findAll();
    
    org.springframework.data.domain.Page<AlumnoDto> findAllPaginated(String query, Long cursoId, org.springframework.data.domain.Pageable pageable);

    /** Obtiene un alumno por su ID. Lanza ResourceNotFoundException si no existe. */
    AlumnoDto findById(Long id);

    /** Lista todos los alumnos activos de un curso (grupo clase). */
    List<AlumnoDto> findByCursoId(Long cursoId);

    /** Busca un alumno por su username de login. */
    AlumnoDto findByUsername(String username);

    /** Busca alumnos por nombre o apellidos (búsqueda parcial case-insensitive). */
    List<AlumnoDto> buscar(String query);

    /** Crea un nuevo alumno y lo asigna a un curso. */
    AlumnoDto create(CreateAlumnoRequest request);

    /** Actualiza los datos de un alumno existente. */
    AlumnoDto update(Long id, UpdateAlumnoRequest request);

    /** Actualiza el perfil propio del alumno autenticado (por username). */
    AlumnoDto updatePerfilPropio(String username, UpdatePerfilRequest request);

    /** Cambia el estado de un alumno (ACTIVO / INACTIVO / DE_BAJA). */
    AlumnoDto cambiarEstado(Long id, String nuevoEstado);

    /**
     * Actualiza las materias en las que está matriculado el alumno.
     * Reemplaza la lista completa por las nuevas IDs.
     * Las materias no incluidas quedan como exentas.
     *
     * @param alumnoId  ID del alumno
     * @param materiaIds lista completa de IDs de materias a matricular
     * @return alumno actualizado con su nueva lista de materias
     */
    AlumnoDto actualizarMaterias(Long alumnoId, List<Long> materiaIds);

    /** Cambia la contraseña del alumno. */
    void cambiarPassword(Long id, String nuevaPassword);

    /** Cambia el avatar (foto o emoji) del alumno. */
    void updateAvatar(String username, String avatar);

    /** Cambia la preferencia de tema del alumno ("light" o "dark"). */
    void updateTheme(String username, String theme);

    /** Elimina un alumno del sistema. */
    void delete(Long id);

    /** Lista los alumnos sin curso asignado (para selector de matriculación). */
    List<AlumnoDto> getAlumnosSinMatricular();
}
