package com.gaula.dto.anio_escolar;

import java.time.LocalDate;

/** DTO para actualizar un AñoEscolar. */
public record UpdateAnioEscolarRequest(

    /** Denominación del año académico. Ej: "24/25", "25/26" */
    String denominacion,
    String nombre, // added mapping for frontend

    LocalDate fechaInicio,
    LocalDate fechaFin,
    String descripcion
) {}
