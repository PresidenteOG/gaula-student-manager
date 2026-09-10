package com.gaula.repository;

import com.gaula.entity.Incidencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface IncidenciaRepository extends JpaRepository<Incidencia, Long> {
    List<Incidencia> findByAlumnoIdOrderByFechaIncidenciaDesc(Long alumnoId);
    List<Incidencia> findByProfesorUsernameOrderByFechaIncidenciaDesc(String username);
    org.springframework.data.domain.Page<Incidencia> findByProfesorUsernameOrderByFechaIncidenciaDesc(String username, org.springframework.data.domain.Pageable pageable);
    org.springframework.data.domain.Page<Incidencia> findAllByOrderByFechaIncidenciaDesc(org.springframework.data.domain.Pageable pageable);
    long countByEstado(Incidencia.EstadoIncidencia estado);
    List<Incidencia> findByEstadoOrderByFechaIncidenciaDesc(Incidencia.EstadoIncidencia estado);
    long countByProfesorIdAndFechaIncidenciaGreaterThanEqual(Long profesorId, java.time.LocalDateTime fecha);
    long countByAlumnoCursoId(Long cursoId);

    // Admin: ve TODAS las incidencias — sin filtro de propiedad
    @Query("SELECT i FROM Incidencia i WHERE " +
           "(:alumnoId IS NULL OR i.alumno.id = :alumnoId) AND " +
           "(:profesorId IS NULL OR i.profesor.id = :profesorId) AND " +
           "(:cursoId IS NULL OR i.alumno.curso.id = :cursoId) AND " +
           "(:estado IS NULL OR i.estado = :estado) AND " +
           "(:resolucion IS NULL OR i.resolucion = :resolucion) " +
           "ORDER BY i.fechaIncidencia DESC")
    org.springframework.data.domain.Page<Incidencia> buscarAvanzadoAdmin(
        @Param("alumnoId") Long alumnoId,
        @Param("profesorId") Long profesorId,
        @Param("cursoId") Long cursoId,
        @Param("estado") com.gaula.entity.Incidencia.EstadoIncidencia estado,
        @Param("resolucion") com.gaula.entity.Incidencia.ResolucionIncidencia resolucion,
        org.springframework.data.domain.Pageable pageable
    );

    // Teacher/Tutor: solo ve las que ha creado o donde es tutor del curso
    @Query("SELECT i FROM Incidencia i WHERE " +
           "(i.profesor.username = :username OR " +
           "i.alumno.curso.tutor.username = :username) AND " +
           "(:alumnoId IS NULL OR i.alumno.id = :alumnoId) AND " +
           "(:profesorId IS NULL OR i.profesor.id = :profesorId) AND " +
           "(:cursoId IS NULL OR i.alumno.curso.id = :cursoId) AND " +
           "(:estado IS NULL OR i.estado = :estado) AND " +
           "(:resolucion IS NULL OR i.resolucion = :resolucion) " +
           "ORDER BY i.fechaIncidencia DESC")
    org.springframework.data.domain.Page<Incidencia> buscarAvanzadoProfesor(
        @Param("username") String username,
        @Param("alumnoId") Long alumnoId,
        @Param("profesorId") Long profesorId,
        @Param("cursoId") Long cursoId,
        @Param("estado") com.gaula.entity.Incidencia.EstadoIncidencia estado,
        @Param("resolucion") com.gaula.entity.Incidencia.ResolucionIncidencia resolucion,
        org.springframework.data.domain.Pageable pageable
    );

    // Alumno: solo ve las suyas
    @Query("SELECT i FROM Incidencia i WHERE " +
           "i.alumno.username = :username AND " +
           "(:estado IS NULL OR i.estado = :estado) AND " +
           "(:resolucion IS NULL OR i.resolucion = :resolucion) " +
           "ORDER BY i.fechaIncidencia DESC")
    org.springframework.data.domain.Page<Incidencia> buscarAvanzadoAlumno(
        @Param("username") String username,
        @Param("estado") com.gaula.entity.Incidencia.EstadoIncidencia estado,
        @Param("resolucion") com.gaula.entity.Incidencia.ResolucionIncidencia resolucion,
        org.springframework.data.domain.Pageable pageable
    );
}

