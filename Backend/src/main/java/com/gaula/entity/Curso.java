package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;
import java.util.List;



/**
 * Curso — Grupo real de un ciclo para un año escolar concreto.
 *
 * Representa un grupo clase instanciado: "1º DAM Mañana 24/25" o "2º DAW Tarde 24/25".
 * Contiene sus materias reales, sus alumnos matriculados y su tutor.
 *
 * Relaciones:
 *   - N:1 con CursoEscolar (pertenece a un año académico y turno)
 *   - 1:N con Materia (tiene múltiples materias/módulos instanciados)
 *   - 1:N con Alumno (varios alumnos pertenecen a este grupo)
 *   - N:1 con Profesor (un tutor, opcional)
 */
@Entity
@Table(name = "curso",
       uniqueConstraints = @UniqueConstraint(
           name = "uq_grupo_anio_escolar",
           columnNames = {"codigoGrupo", "anio_escolar_id"}
       ))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Curso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Turno del ciclo: MANANA o TARDE.
     * Permite tener el mismo ciclo en ambos turnos.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = true)
    private Turno turno;

    @Column(name = "etapa_curso")
    private int etapaCurso;

    @Column(nullable = true, length = 1)
    private String desdoblamiento;

    /**
     * CursoPlantilla sobre la que se basa este año académico.
     * FK: curso_plantilla_id
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "curso_plantilla_id", nullable = true)
    @JsonIgnore
    private CursoPlantilla cursoPlantilla;

    /**
     * Código identificador del aula o grupo.
     * Ejemplo: "1DAM-M", "2DAW-T"
     * Generado automáticamente si no se especifica.
     */
    @Column(name = "codigo_grupo", length = 20)
    private String codigoGrupo;

    /**
     * CursoEscolar al que pertenece este grupo.
     * Determina el año académico (24/25) y el turno (mañana/tarde).
     * FK: curso_escolar_id
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "anio_escolar_id", nullable = false)
    @JsonIgnore
    private AnioEscolar anioEscolar;

    /**
     * Tutor/a del grupo. Puede ser nulo si aún no se ha asignado tutor.
     * FK: tutor_id → profesor.id
     *
     * Relación: Profesor <1---0/N> Curso (un profe puede ser tutor de varios grupos)
        */
        @ManyToOne(fetch = FetchType.LAZY, optional = true)
        @JoinColumn(name = "tutor_id", nullable = true)
    private Profesor tutor;

    /**
     * Materias instanciadas para este grupo.
     * La relación es N:1 desde Materia hacia Curso (Materia tiene la FK).
     * cascade = ALL: al borrar el curso se borran sus materias.
     */
    @OneToMany(mappedBy = "curso", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Materia> materias = new ArrayList<>();

    /**
     * Alumnos matriculados en este grupo.
     * Relación inversa — el dueño de la FK es Alumno.curso.
     * NOTA: Un alumno pertenece a UN solo curso (simplifica consultas),
     * pero puede estar exento de materias específicas (via la tabla N:N Alumno-Materia).
     */
    @OneToMany(mappedBy = "curso", fetch = FetchType.LAZY)
    @Builder.Default
    @JsonIgnore
    private List<Alumno> alumnos = new ArrayList<>();

    // ────────────────────────────────────────
    // Enum: turno del ciclo
    // ────────────────────────────────────────
    public enum Turno {
        PARTIDO,
        MANANA,
        TARDE,
        NOCTURNO;
    }
}
