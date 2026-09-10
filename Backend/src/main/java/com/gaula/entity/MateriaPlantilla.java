package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * MateriaPlantilla — Módulo/asignatura reutilizable de una CursoPlantilla.
 *
 * Representa la definición abstracta de un módulo del ciclo,
 * por ejemplo: "Programación (M-01, 240h)" del ciclo DAM.
 * Cuando se instancia un Curso real, se crean objetos Materia
 * a partir de estas plantillas.
 *
 * Relaciones:
 *   - N:1 con CursoPlantilla (pertenece a un ciclo concreto)
 */
@Entity
@Table(name = "materia_plantilla",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_materia_plantilla_codigo_ciclo",
           columnNames = {"codigo", "curso_plantilla_id"}
       ))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MateriaPlantilla {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Nombre completo del módulo.
     * Ejemplos: "Programación", "Bases de Datos", "Entorno Cliente"
     */
    @Column(nullable = false, length = 150)
    private String nombre;

    /**
     * Código oficial del módulo.
     * Ejemplos: M-01, M-02, UF3, módulo específico de la normativa.
     */
    @Column(nullable = false, length = 20)
    private String codigo;

    /**
     * Horas totales del módulo según el currículo oficial.
     * Ejemplo: 240 horas para Programación en DAM.
     */
    @Column(nullable = false)
    private Integer horasTotales;

    /**
     * CursoPlantilla al que pertenece este módulo.
     * FK: curso_plantilla_id
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "curso_plantilla_id", nullable = false)
    @JsonIgnore
    private CursoPlantilla cursoPlantilla;

    /**
     * Tipo de unidad curricular del ciclo:
     *   MODULOS     → FP estándar (DAM, DAW, ASIX)
     *   ASIGNATURAS → Bachillerato / ESO
     *   PROYECTOS   → Formación dual / proyectos integrados
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoMateria tipo;

    // ────────────────────────────────────────
    // Enum anidado: tipo de unidad curricular
    // ────────────────────────────────────────
    public enum TipoMateria {
        MODULO,
        ASIGNATURA,
        PROYECTO
    }
}
