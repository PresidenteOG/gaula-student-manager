package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * Incidencia — Registro de comportamiento o suceso disciplinario de un alumno.
 */
@Entity
@Table(name = "incidencia")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Incidencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "alumno_id", nullable = false)
    private Alumno alumno;

    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "profesor_id", nullable = true)
    private Profesor profesor;


    @Column(nullable = false, length = 100)
    private String titulo;

    @Column(nullable = false)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private GravedadIncidencia gravedad = GravedadIncidencia.BAJA;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private EstadoIncidencia estado = EstadoIncidencia.ABIERTA;

    @Enumerated(EnumType.STRING)
    @Column(name = "resolucion")
    private ResolucionIncidencia resolucion;

    @Column(name = "fecha_incidencia", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaIncidencia = LocalDateTime.now();

    public enum GravedadIncidencia {
        BAJA,
        MEDIA,
        ALTA,
        LEVE,
        GRAVE,
        MUY_GRAVE
    }

    public enum EstadoIncidencia {
        ABIERTA,
        EN_PROCESO,
        CERRADA
    }

    public enum ResolucionIncidencia {
        VALIDA,
        INVALIDA
    }
}
 

