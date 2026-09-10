package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;
import java.util.List;

/**
 * Alumno — Estudiante matriculado en el sistema GAULA.
 *
 * Un alumno pertenece a UN Curso (su grupo clase) pero puede estar
 * matriculado en un subconjunto de las materias de ese curso
 * (puede estar exento de algunas).
 *
 * Relaciones (según el esquema del dominio):
 *   - N:1 con Curso (pertenece a un grupo clase)
 *   - N:N con Materia (materias en las que está matriculado, no exento)
 *
 * Herencia de seguridad:
 *   El campo `username` y `password` se usan para el login JWT.
 *   El rol siempre es ROLE_STUDENT en Spring Security.
 */
@Entity
@Table(name = "alumno",
       uniqueConstraints = {
           @UniqueConstraint(name = "uq_alumno_username", columnNames = "username"),
           @UniqueConstraint(name = "uq_alumno_email",    columnNames = "email")
       })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Alumno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Nombre de pila del alumno. Ejemplo: "Carlos" */
    @Column(nullable = false, length = 80)
    private String nombre;

    /** Apellidos completos. Ejemplo: "García Martínez" */
    @Column(nullable = false, length = 150)
    private String apellidos;

    /**
     * Nombre de usuario para el login.
     * Generado automáticamente: inicial + apellido (cgarcia)
     */
    @Column(nullable = false, unique = true, length = 50)
    private String username;

    /**
     * Contraseña almacenada como hash BCrypt.
     * NUNCA se almacena en texto plano.
     */
    @Column(nullable = false, length = 255)
    private String password;

    /** Correo electrónico institucional del alumno. */
    @Column(nullable = false, unique = true, length = 150)
    private String email;

    /**
     * Estado de la matrícula del alumno:
     *   ACTIVO   → matriculado y asistiendo
     *   INACTIVO → matriculado pero de baja temporal
     *   DE_BAJA  → baja definitiva (no aparece en listas activas)
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    @Builder.Default
    private EstadoAlumno estado = EstadoAlumno.ACTIVO;

    /**
     * Emoji o URL de avatar para la interfaz.
     * Valores por defecto: "👨‍🎓" o "👩‍🎓"
     */
    @Column(length = 255)
    @Builder.Default
    private String avatar = "";


    /**
     * Preferencia de tema de la interfaz: "light" o "dark".
     * Se persiste en BBDD para mantener la consistencia entre dispositivos.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private AppTheme theme = AppTheme.dark;

    /** Modalidad de asistencia del alumno. Influye en el cálculo de faltas. */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private ModalidadAlumno modalidad = ModalidadAlumno.PRESENCIAL;

    /** DNI, NIE o Pasaporte del alumno. */
    @Column(length = 20)
    private String dni;

    /** Teléfono de contacto. */
    @Column(length = 20)
    private String telefono;

    /** Dirección de residencia. */
    @Column(length = 255)
    private String direccion;

    /** Fecha de nacimiento. */
    private java.time.LocalDate fechaNacimiento;

    // ──────────────────────────────────────────────────
    // Seguimiento de Actividad (Auditoría)
    // ──────────────────────────────────────────────────

    @Column(name = "fecha_creacion", updatable = false)
    @Builder.Default
    private java.time.LocalDateTime fechaCreacion = java.time.LocalDateTime.now();

    @Column(name = "ultima_conexion")
    private java.time.LocalDateTime ultimaConexion;

    @Column(name = "ip_conexion", length = 45)
    private String ipConexion;

    @Column(name = "ultimo_jwt", columnDefinition = "TEXT")
    private String ultimoJwt;

    /**
     * Curso (grupo) al que pertenece el alumno.
     * Relación: Alumno <N:1> Curso
     * FK: curso_id
     *
     * DECISIÓN: Un alumno pertenece a UN solo curso a la vez.
     * Si cambia de grupo, se actualiza este campo.
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "curso_id", nullable = false)
    private Curso curso;

    /**
     * Materias en las que el alumno está efectivamente matriculado.
     * Es un subconjunto de las materias de su Curso.
     * Las materias no incluidas implican exención o pendiente.
     *
     * Relación: Alumno <N:N> Materia
     * Tabla de unión: alumno_materia (alumno_id, materia_id)
     *
     * DECISIÓN ARQUITECTÓNICA:
     * El dueño de la relación es Alumno (tiene el @JoinTable).
     * Esto simplifica las consultas "¿en qué materias está este alumno?"
     */
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "alumno_materia",
        joinColumns        = @JoinColumn(name = "alumno_id"),
        inverseJoinColumns = @JoinColumn(name = "materia_id")
    )
    @Builder.Default
    @JsonIgnore
    private List<Materia> materias = new ArrayList<>();

    // ────────────────────────────────────────
    // Enum: estado de la matrícula
    // ────────────────────────────────────────
    public enum EstadoAlumno {
        ACTIVO,
        INACTIVO,
        DE_BAJA
    }

    public enum ModalidadAlumno {
        PRESENCIAL,
        SEMIPRESENCIAL
    }

    /** Nombre completo para mostrar en la UI: "Carlos García Martínez" */
    @Transient
    public String getNombreCompleto() {
        return nombre + " " + apellidos;
    }
}
