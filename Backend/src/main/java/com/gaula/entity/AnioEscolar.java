package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * CursoEscolar — Año académico e instancia de turno para un ciclo concreto.
 *
 * Representa una combinación de "curso escolar + turno" aplicada a
 * una CursoPlantilla. Por ejemplo:
 *   - "24/25 - Mañana" para DAM
 *   - "24/25 - Tarde" para DAM
 *   - "25/26 - Mañana" para DAW
 *
 * Relaciones (según el esquema del dominio):
 *   - N:1 con CursoPlantilla (múltiples CursoEscolar del mismo ciclo)
 *   - 1:N con Curso (cada instancia tiene 1º y 2º grupos concretos)
 */
@Entity
@Table(name = "anio_escolar",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_anio_escolar_denominacion",
           columnNames = {"denominacion"}
       ))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AnioEscolar {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Denominación del año académico en formato "AA/AA".
     * Ejemplo: "24/25", "25/26"
     */
    @Column(nullable = false, length = 10)
    private String denominacion;

    /**
     * Indica si este curso escolar está activo actualmente.
     * Solo debería haber un CursoEscolar activo por ciclo y turno.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @Column(length = 500)
    private String descripcion;

    @Column(name = "fecha_inicio")
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    /**
     * Cursos de este año escolar.
     * Relación inversa — el dueño de la FK es Curso.cursoEscolar.
     */
    @OneToMany(mappedBy = "anioEscolar", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Curso> cursos = new ArrayList<>();
}
