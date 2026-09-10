package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.DayOfWeek;
import java.time.LocalTime;

/**
 * Horario — Sesión de clase de una Materia impartida por un Profesor.
 *
 * Representa una franja horaria recurrente en el horario semanal:
 * "Programación (M-01) los Lunes y Miércoles de 08:00 a 09:30 en el Aula 101,
 *  impartida por el Profesor Sánchez".
 *
 * REGLA DE NEGOCIO: Las sesiones NO se eliminan físicamente.
 * Cuando se desea "eliminar" una sesión, se establece activo=false (soft delete).
 * Todas las consultas filtran por activo=true. Una sesión oculta puede reactivarse.
 *
 * Relaciones (según el esquema del dominio):
 *   - N:1 con Materia (una clase pertenece a una materia)
 *   - N:1 con Profesor (una clase es impartida por un profesor)
 */
@Entity
@Table(name = "horario_sesion")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Horario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Flag de visibilidad (soft delete).
     * true  = sesión activa y visible en horarios y en pasar lista.
     * false = sesión oculta; nunca se borra físicamente de la BD.
     *
     * REGLA: Nunca usar deleteById(). Siempre setActivo(false) + save().
     */
    @Builder.Default
    @Column(nullable = false)
    private boolean activo = true;

    /**
     * Día de la semana en que se imparte la clase.
     * Ejemplo: MONDAY (Lunes), WEDNESDAY (Miércoles).
     * Se usa java.time.DayOfWeek que Hibernate mapea como ordinal/string.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private DayOfWeek diaSemana;

    /**
     * Hora de inicio de la sesión.
     * Formato: HH:MM UTC / hora local de la institución.
     * Ejemplo: 08:00, 11:30
     */
    @Column(nullable = false)
    private LocalTime horaInicio;

    /**
     * Hora de fin de la sesión.
     * Ejemplo: 09:30, 13:00
     */
    @Column(nullable = false)
    private LocalTime horaFin;

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
}
