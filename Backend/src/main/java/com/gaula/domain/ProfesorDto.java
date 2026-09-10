package com.gaula.domain;

import com.gaula.entity.Profesor;
import lombok.Builder;

import java.util.List;

/**
 * DTO de dominio de Profesor.
 * Expone los datos del profesor a la API REST sin exponer la entidad JPA
 * ni campos sensibles como el hash de contraseña.
 */
@Builder
public record ProfesorDto(

    Long id,
    String nombre,
    String apellidos,
    String nombreCompleto,
    String username,
    String email,
    String estado,
    String rol,
    String avatar,
    String especialidades,
    String dni,
    String telefono,
    String direccion,
    java.time.LocalDate fechaNacimiento,

    /**
     * Información del sustituto.
     * Si el profesor está INACTIVO (baja), este campo no es nulo.
     */
    SustitutoInfo sustituto,

    /** IDs de los cursos de los que es tutor. */
    List<Long> cursosTutorIds,

    /** Códigos de los grupos que tutoriza (ej: ["1DAM-M", "2DAM-M"]). */
    List<String> cursosTutorCodigos

) {

    /**
     * Convierte una entidad Profesor en ProfesorDto.
     *
     * @param profesor entidad JPA cargada desde repositorio
     * @return ProfesorDto listo para serializar
     */
    public static ProfesorDto fromEntity(Profesor profesor) {
        // Datos del sustituto si existe
        SustitutoInfo sustitutoInfo = null;
        if (profesor.getSustituto() != null) {
            sustitutoInfo = new SustitutoInfo(
                profesor.getSustituto().getId(),
                profesor.getSustituto().getNombreCompleto(),
                profesor.getSustituto().getAvatar()
            );
        }

        // Cursos de los que es tutor
        List<Long>   tutorIds     = profesor.getCursosTutor() != null
            ? profesor.getCursosTutor().stream().map(com.gaula.entity.Curso::getId).toList()
            : List.of();
        List<String> tutorCodigos = profesor.getCursosTutor() != null
            ? profesor.getCursosTutor().stream().map(com.gaula.entity.Curso::getCodigoGrupo).toList()
            : List.of();

        return ProfesorDto.builder()
            .id(profesor.getId())
            .nombre(profesor.getNombre())
            .apellidos(profesor.getApellidos())
            .nombreCompleto(profesor.getNombreCompleto())
            .username(profesor.getUsername())
            .email(profesor.getEmail())
            .estado(profesor.getEstado().name())
            .rol(profesor.getRol().name())
            .avatar(profesor.getAvatar())
            .especialidades(profesor.getEspecialidades())
            .dni(profesor.getDni())
            .telefono(profesor.getTelefono())
            .direccion(profesor.getDireccion())
            .fechaNacimiento(profesor.getFechaNacimiento())
            .sustituto(sustitutoInfo)
            .cursosTutorIds(tutorIds)
            .cursosTutorCodigos(tutorCodigos)
            .build();
    }

    /** Record anidado con la información mínima del sustituto. */
    public record SustitutoInfo(Long id, String nombreCompleto, String avatar) {}
}
