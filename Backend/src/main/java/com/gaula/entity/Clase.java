package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * Clase — Sesión de clase de una Materia impartida por un Profesor.
 *
 * Representa una franja horaria recurrente en el horario semanal:
 * "Programación (M-01) los Lunes y Miércoles de 08:00 a 09:30 en el Aula 101,
 *  impartida por el Profesor Sánchez".
 *
 * Relaciones (según el esquema del dominio):
 *   - N:1 con Materia (una clase pertenece a una materia)
 *   - N:1 con Profesor (una clase es impartida por un profesor)
 */
@Entity
@Table(name = "clase")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Clase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "horario_sesion_id", nullable = false)
    private Horario horario;

    @Column(name = "fecha", nullable = false, updatable = false)
    @Builder.Default
    private LocalDate fecha = LocalDate.now();

    /**
     * Aula o espacio donde se imparte la clase.
     * Ejemplo: "Aula 101", "Lab A", "Taller FP"
     */
    @Column(length = 50)
    private String aula;

    /**
     * Materia a la que pertenece esta clase.
     * FK: materia_id
     * Relación: Clase <N:1> Materia
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "materia_id", nullable = false)
    private Materia materia;

    /**
     * Profesor que imparte esta clase.
     * FK: profesor_id
     * Relación: Clase <N:1> Profesor
     *
     * NOTA: Si el profesor está de baja, el campo Profesor.sustituto
     * indica quién lo reemplaza, sin modificar este campo.
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "profesor_id", nullable = false)
    private Profesor profesor;

    /**
     * Faltas registradas en esta clase.
     * Relación inversa — el dueño de la FK es Asistencia.clase.
     * NOTA: Una falta pertenece a UNA sola clase (simplifica consultas).
     */
    @OneToMany(mappedBy = "clase", fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Asistencia> faltas = new ArrayList<>();
}
