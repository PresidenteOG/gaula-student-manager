package com.gaula.dto.plantilla;

import java.util.List;

import com.gaula.domain.CursoPlantillaDto.MateriaPlantillaResumenDto;

import jakarta.validation.constraints.NotBlank;

/** DTO para crear un nuevo Curso (grupo clase real). */
public record CreateCursoPlantillaRequest(

    @NotBlank(message = "El código es obligatorio")
    String codigo,

    @NotBlank(message = "El nombre es obligatorio")
    String nombre,

    String descripcion,

    @NotBlank(message = "El color es obligatorio")
    String color,

    /** Lista resumida de materias. */
    List<MateriaPlantillaResumenDto> materias
) {}
