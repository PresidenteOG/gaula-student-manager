package com.gaula.dto.incidencia;

public record CreateIncidenciaRequest(

    Long alumnoId,

    Long profesorId,

    String titulo,

    String descripcion,

    String gravedad
) {}
