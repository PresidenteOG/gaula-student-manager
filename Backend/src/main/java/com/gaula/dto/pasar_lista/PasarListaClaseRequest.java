package com.gaula.dto.pasar_lista;

import java.util.List;

import jakarta.validation.constraints.NotNull;

/** DTO para crear un nuevo Curso (grupo clase real). */
public record PasarListaClaseRequest(

    @NotNull(message = "El ID del Horario es obligatorio")
    Long horarioId,

    /* Si es el mismo que el de horario puede estar vacío, si no,
    ** aquí pondremos el de sustitución */
    Long profesorId,

    /* Igual que profesor, solo si es un aula diferente a la normal */
    String aula,

    List<RegistroDeFaltaRequest> faltas
) {}
