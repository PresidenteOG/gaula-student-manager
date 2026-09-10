package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


import java.util.ArrayList;
import java.util.List;

/**
 * Profesor — Docente del sistema GAULA.
 *
 * Relaciones (según el esquema del dominio):
 *   - 1:N con Clase (un profesor imparte varias clases)
 *   - 1:0/N con Curso (puede ser tutor de cero o varios grupos)
 *   - 1:1 con Profesor (self-reference: cuando está de baja, se asigna
 *     el ID del profesor sustituto. En cualquier otro caso queda NULL)
 *
 * Roles de Spring Security:
 *   ROLE_TEACHER → profesor normal
 *   ROLE_ADMIN   → jefe de estudios / administrador
 */
@Entity
@Table(name = "profesor",
       uniqueConstraints = {
           @UniqueConstraint(name = "uq_profesor_username", columnNames = "username"),
           @UniqueConstraint(name = "uq_profesor_email",    columnNames = "email")
       })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Profesor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Nombre de pila del profesor. Ejemplo: "Isabel" */
    @Column(nullable = false, length = 80)
    private String nombre;

    /** Apellidos completos. Ejemplo: "Fernández Ruiz" */
    @Column(nullable = false, length = 150)
    private String apellidos;

    /**
     * Nombre de usuario para el login JWT.
     * Convenio: inicial + primer apellido en minúsculas. (ifernandez)
     */
    @Column(nullable = false, unique = true, length = 50)
    private String username;

    /**
     * Contraseña en hash BCrypt.
     * NUNCA se almacena en texto plano.
     */
    @Column(nullable = false, length = 255)
    private String password;

    /** Correo electrónico institucional del profesor. */
    @Column(nullable = false, unique = true, length = 150)
    private String email;

    /**
     * Estado laboral del profesor:
     *   ACTIVO   → da clases normalmente
     *   INACTIVO → baja temporal (se asigna sustituto en campo `sustituto`)
     *   DE_BAJA  → baja definitiva
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    @Builder.Default
    private EstadoProfesor estado = EstadoProfesor.ACTIVO;

    /**
     * Rol de acceso al sistema.
     * TEACHER → acceso a sus clases y alumnos
     * ADMIN   → acceso total (jefe de estudios / administrador)
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    @Builder.Default
    private RolProfesor rol = RolProfesor.TEACHER;

    /**
     * Emoji o URL de avatar para la interfaz.
     * Valor por defecto: "👨‍🏫" o "👩‍🏫"
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

    /** Especialidades / departamentos del profesor. */
    @Column(length = 500)
    private String especialidades;

    /** DNI, NIE o Pasaporte del profesor. */
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
     * Relación de sustitución (self-reference 1:1).
     *
     * REGLA DE NEGOCIO:
     *   Cuando un profesor está de baja (estado = INACTIVO),
     *   este campo apunta al profesor que lo sustituye.
     *   En cualquier otra situación debe ser NULL.
     *
     * FK: sustituto_id → profesor.id (self-reference)
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "sustituto_id", nullable = true)
    @JsonIgnore
    private Profesor sustituto;

    /**
     * Clases que imparte este profesor.
     * Relación inversa — el dueño de la FK es Clase.profesor.
     */
    @OneToMany(mappedBy = "profesor", fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Horario> clases = new ArrayList<>();

    /**
     * Grupos de los que es tutor.
     * Relación inversa — el dueño de la FK es Curso.tutor.
     */
    @OneToMany(mappedBy = "tutor", fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Curso> cursosTutor = new ArrayList<>();

    // ----------------------------------------
    // Enums de estado y rol
    // ----------------------------------------
    public enum EstadoProfesor {
        ACTIVO,
        INACTIVO,
        DE_BAJA
    }

    public enum RolProfesor {
        TEACHER,
        ADMIN
    }

    /** Nombre completo para mostrar en la UI: "Isabel Fernández Ruiz" */
    @Transient
    public String getNombreCompleto() {
        return nombre + " " + apellidos;
    }
}
