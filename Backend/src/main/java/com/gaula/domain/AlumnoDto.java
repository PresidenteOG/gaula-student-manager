package com.gaula.domain;

import com.gaula.entity.Alumno;
import lombok.Builder;

import java.util.List;
import java.time.LocalDate;

/**
 * DTO de dominio de Alumno.
 * Representa la vista del alumno que devuelve la API REST.
 * Se construye mapeando la entidad JPA Alumno mediante el método estático fromEntity().
 *
 * DECISIÓN: Nunca exponemos la entidad JPA directamente al controller
 * ni la enviamos por la red. El DTO es el contrato público de la API.
 */
@Builder
public record AlumnoDto(

    Long id,
    String nombre,
    String apellidos,
    String nombreCompleto,
    String username,
    String email,
    String estado,
    String avatar,
    String dni,
    String telefono,
    String direccion,
    LocalDate fechaNacimiento,

    /** ID del curso al que pertenece el alumno. */
    Long cursoId,

    /** Código del grupo clase (ej: "1DAM-M"). */
    String codigoGrupo,

    /** Nombre completo del ciclo (ej: "DAM Mañana 24/25"). */
    String nombreCurso,

    /** IDs de las materias en las que está matriculado (no exento). */
    List<Long> materiaIds,

    /** Nombres de las materias para mostrar en la UI con su respectivo código. */
    List<String> nombresMaterias

) {

    /**
     * Convierte una entidad Alumno de JPA en un AlumnoDto para la API.
     * Evita exponer la entidad JPA y los campos sensibles (password).
     *
     * @param alumno entidad Alumno cargada desde la BBDD
     * @return AlumnoDto listo para serializar como JSON
     */
    public static AlumnoDto fromEntity(Alumno alumno) {
        String codigoGrupo = alumno.getCurso() != null ? alumno.getCurso().getCodigoGrupo() : "Sin grupo";
        String nombreCurso = alumno.getCurso() != null && alumno.getCurso().getCursoPlantilla() != null 
            ? alumno.getCurso().getCursoPlantilla().getNombre() 
            : "";

        // Materias: IDs y nombres (solo las inicializadas, evita LazyInitializationException)
        List<Long>   materiaIds    = alumno.getMaterias() != null
            ? alumno.getMaterias().stream().map(com.gaula.entity.Materia::getId).toList()
            : List.of();
        List<String> nombresMat   = alumno.getMaterias() != null
            ? alumno.getMaterias().stream().map((mat) -> {
                return mat.getCodigo() + " - " + mat.getNombre();
            }).toList()
            : List.of();

        return AlumnoDto.builder()
            .id(alumno.getId())
            .nombre(alumno.getNombre())
            .apellidos(alumno.getApellidos())
            .nombreCompleto(alumno.getNombreCompleto())
            .username(alumno.getUsername())
            .email(alumno.getEmail())
            .estado(alumno.getEstado().name())
            .avatar(alumno.getAvatar())
            .dni(alumno.getDni())
            .telefono(alumno.getTelefono())
            .direccion(alumno.getDireccion())
            .fechaNacimiento(alumno.getFechaNacimiento())
            .cursoId(alumno.getCurso() != null ? alumno.getCurso().getId() : null)
            .codigoGrupo(codigoGrupo)
            .nombreCurso(nombreCurso)
            .materiaIds(materiaIds)
            .nombresMaterias(nombresMat)
            .build();
    }
}
