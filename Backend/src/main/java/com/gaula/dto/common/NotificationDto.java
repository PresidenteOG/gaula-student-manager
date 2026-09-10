package com.gaula.dto.common;

public record NotificationDto(
    Long id,
    String titulo,
    String mensaje,
    String fecha,
    String tipo,
    boolean leida
) {}
