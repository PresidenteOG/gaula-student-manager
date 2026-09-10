package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * CursoPlantilla — Plantilla reutilizable de un tipo de ciclo formativo.
 *
 * Representa la "familia" del ciclo: DAM, DAW, ASIX, SMIX, etc.
 * Es la base sobre la que se crean instancias reales (CursoEscolar y Curso).
 *
 * Relaciones:
 *   - 1:N con MateriaPlantilla (un ciclo tiene múltiples módulos plantilla)
 *   - 1:N con CursoEscolar (el mismo ciclo puede tener instancias para
 *     distintos años y turnos: 24/25 Mañana, 24/25 Tarde, 25/26 Mañana...)
 */
@Entity
@Table(name = "curso_plantilla")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CursoPlantilla {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Código corto del ciclo. Ejemplos: DAM, DAW, ASIX, SMIX, SMR, ADG.
     * Único en la tabla para evitar duplicados de plantillas.
     */
    @Column(nullable = false, unique = true, length = 10)
    private String codigo;

    /**
     * Nombre completo del ciclo. Ejemplo:
     * "Desarrollo de Aplicaciones Multiplataforma"
     */
    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(nullable = true, length = 250)
    private String descripcion;

    /**
     * Color hexadecimal para la UI (#60a5fa, #34d399...).
     * Se usa para codificar visualmente cada familia de ciclo.
     */
    @Column(nullable = false, length = 9)
    private String color;

    /**
     * Lista de módulos/asignaturas plantilla asociados a este ciclo.
     * cascade = ALL: al eliminar la plantilla se eliminan sus módulos.
     * orphanRemoval = true: los módulos sin plantilla padre se borran solos.
     */
    @OneToMany(mappedBy = "cursoPlantilla", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MateriaPlantilla> materiasPlantilla = new ArrayList<>();

    /**
     * CursosEscolares asociados a esta plantilla.
     * Relación inversa — el dueño es CursoEscolar.cursoPlantilla.
     */
    @OneToMany(mappedBy = "cursoPlantilla", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Curso> cursosInstancias = new ArrayList<>();
}
