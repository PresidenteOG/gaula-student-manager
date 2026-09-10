package com.gaula.dto.anio_escolar;


/** DTO para crear un nuevo CursoEscolar (año académico + turno). */
public record CreateAnioEscolarRequest(

    /** Denominación del año académico. Ej: "24/25", "25/26" */
    String denominacion,
    String nombre, // added mapping for frontend

    /** Si true, desactiva el CursoEscolar anterior del mismo ciclo y turno. */
    boolean activarComoActual,

    java.time.LocalDate fechaInicio,
    java.time.LocalDate fechaFin,
    String descripcion
) {}
