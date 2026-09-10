package com.gaula.service.profesor;

import com.gaula.domain.ProfesorDto;
import com.gaula.dto.profesor.CreateProfesorRequest;
import com.gaula.dto.profesor.UpdateProfesorRequest;
import com.gaula.dto.perfil.UpdatePerfilRequest;
import com.gaula.entity.Profesor;

import java.util.List;

/**
 * Contrato del servicio de Profesores.
 */
public interface ProfesorService {

    /** Lista todos los profesores. */
    List<ProfesorDto> findAll();
    
    org.springframework.data.domain.Page<ProfesorDto> findAllPaginated(String query, String rol, Long cursoId, org.springframework.data.domain.Pageable pageable);

    /** Obtiene un profesor por ID. */
    ProfesorDto findById(Long id);

    /** Lista profesores filtrados por rol (TEACHER / ADMIN). */
    List<ProfesorDto> findByRol(Profesor.RolProfesor rol);

    /** Busca profesores por nombre o apellidos. */
    List<ProfesorDto> buscar(String query);

    /** Busca un profesor por su username de login. */
    ProfesorDto findByUsername(String username);

    /** Crea un nuevo profesor en el sistema. */
    ProfesorDto create(CreateProfesorRequest request);

    /** Actualiza los datos de un profesor. */
    ProfesorDto update(Long id, UpdateProfesorRequest request);

    /** Actualiza el perfil propio del profesor autenticado (por username). */
    ProfesorDto updatePerfilPropio(String username, UpdatePerfilRequest request);

    /** Cambia el estado del profesor (ACTIVO / INACTIVO / DE_BAJA). */
    ProfesorDto cambiarEstado(Long id, String nuevoEstado);

    /**
     * Asigna un profesor sustituto a un profesor de baja.
     * Si sustitutoId es null, elimina la sustitución actual.
     *
     * @param profesorId  ID del profesor de baja
     * @param sustitutoId ID del profesor sustituto (o null para borrar)
     */
    ProfesorDto asignarSustituto(Long profesorId, Long sustitutoId);

    /** Cambia la contraseña del profesor. */
    void cambiarPassword(Long id, String nuevaPassword);

    /** Cambia el avatar del profesor. */
    void updateAvatar(String username, String avatar);

    /** Cambia la preferencia de tema del profesor ("light" o "dark"). */
    void updateTheme(String username, String theme);

    /** Elimina un profesor del sistema. */
    void delete(Long id);

    /** Obtiene estadísticas para el dashboard del profesor. */
    java.util.Map<String, Object> getDashboardStats(Long id);
}
