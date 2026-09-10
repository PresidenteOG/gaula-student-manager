package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Asistencia — Registro de la presencia de un alumno en una clase específica.
 */
@Entity
@Table(name = "asistencia",
    uniqueConstraints = {
        @UniqueConstraint(name = "uq_clase_asistente", columnNames = { "clase_id", "alumno_id" })
    })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Asistencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "clase_id", nullable = false)
    private Clase clase;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "alumno_id", nullable = false)
    private Alumno alumno;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private EstadoAsistencia estado = EstadoAsistencia.PRESENTE;

    @Column(nullable = true)
    private String observaciones;

    /** Fecha de la sesión de clase a la que corresponde esta asistencia. */
    @Column(nullable = false)
    @Builder.Default
    private LocalDate fecha = LocalDate.now();

    @Column(name = "fecha_registro", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaRegistro = LocalDateTime.now();

    public enum EstadoAsistencia {
        PRESENTE,
        AUSENTE,
        FALTA,
        RETRASO,
        JUSTIFICADO
    }

}
