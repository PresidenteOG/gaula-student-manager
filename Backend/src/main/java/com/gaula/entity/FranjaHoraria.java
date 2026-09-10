package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalTime;

/**
 * HorarioTemplate — Define las franjas horarias estándar del centro.
 * Ejemplo: 1ª hora (08:00-09:00), Recreo (11:00-11:30), etc.
 */
@Entity
@Table(name = "franja_horaria")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FranjaHoraria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String nombre; // Ej: "1ª Hora", "Recreo"

    @Column(nullable = false)
    private LocalTime horaInicio;

    @Column(nullable = false)
    private LocalTime horaFin;

    @Column(nullable = false)
    private Integer orden; // Para ordenar las franjas

    @Column(nullable = false)
    private boolean esLectiva; // Si es una hora de clase o un descanso
}
