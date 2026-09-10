package com.gaula.dto.admin;

import lombok.Builder;
import lombok.Data;

/**
 * DTO para representar un elemento en el explorador de archivos del servidor.
 */
@Data
@Builder
public class DirectorioDto {
    private String nombre;
    private String ruta;
    private boolean esDirectorio;
}
