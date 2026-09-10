package com.gaula.dto.admin;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class UsuarioAdminDto {
    private Long id;
    private String nombre;
    private String apellidos;
    private String username;
    private String email;
    private String rol;
    private String estado;
    private LocalDateTime fechaCreacion;
    private LocalDateTime ultimaConexion;
    private String ipConexion;
    private String ultimoJwt;
}
