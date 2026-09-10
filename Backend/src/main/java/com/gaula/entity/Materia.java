package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

/**
 * Materia — Módulo/asignatura instanciado en un Curso concreto.
 *
 * Es la materialización de una MateriaPlantilla dentro de un Curso real.
 * Por ejemplo: "Programación" en "1º DAM Mañana 24/25".
 *
 * Relaciones (según esquema del dominio):
 *   - N:1 con Curso (pertenece a un grupo concreto)
 *   - N:1 con MateriaPlantilla (basada en la plantilla del ciclo)
 *   - N:N con Alumno (los alumnos del curso pueden matricularse o estar exentos)
 *   - 1:N con Clase (una materia tiene múltiples sesiones de clase)
 */
@Entity
@Table(name = "materia",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_materia_codigo_curso",
           columnNames = {"codigo", "curso_id"}
       ))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Materia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Nombre completo de la materia instanciada.
     * Se copia de MateriaPlantilla.nombre al crear el Curso,
     * pero puede editarse independientemente.
     */
    @Column(nullable = false, length = 150)
    private String nombre;

    /**
     * Código del módulo instanciado. Ejm: "M-01", "M-02".
     */
    @Column(nullable = false, length = 20)
    private String codigo;

    /**
     * Horas totales del módulo en este curso concreto.
     * Puede diferir de MateriaPlantilla si hay adaptaciones.
     */
    @Column(nullable = false)
    private Integer horasTotales;

    /**
     * Color personalizado para la materia en el horario.
     * Almacenado como código HEX. Ej: "#60A5FA".
     */
    @Column(length = 10)
    private String color;

    /**
     * Curso al que pertenece esta materia.
     * FK: curso_id
     * Relación: Materia <N:1> Curso
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "curso_id", nullable = false)
    @JsonIgnore
    private Curso curso;

    /**
     * Plantilla de la que se originó esta materia.
     * Permite rastrear el módulo original del ciclo.
     * FK: materia_plantilla_id (puede ser null si se creó manualmente)
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "materia_plantilla_id", nullable = true)
    private MateriaPlantilla materiaPlantilla;

    /**
     * Sesiones de clase de esta materia.
     * cascade = ALL: al borrar la materia se borran sus clases.
     * Relación: Materia <1:N> Clase
     */
    @OneToMany(mappedBy = "materia", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Horario> clases = new ArrayList<>();

    /**
     * Alumnos matriculados en esta materia.
     * Tabla de unión: alumno_materia (alumno_id, materia_id)
     * Relación: Alumno <N:N> Materia
     *
     * DECISIÓN ARQUITECTÓNICA:
     * El dueño de la relación N:N es Alumno (tiene el @JoinTable).
     * Aquí usamos mappedBy para la relación inversa.
     */
    @ManyToMany(mappedBy = "materias", fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Alumno> alumnos = new ArrayList<>();
}
