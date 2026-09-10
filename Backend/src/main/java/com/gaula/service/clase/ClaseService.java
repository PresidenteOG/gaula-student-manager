package com.gaula.service.clase;

import com.gaula.entity.Clase;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.gaula.domain.ClaseDto;
import com.gaula.dto.pasar_lista.PasarListaClaseRequest;

public interface ClaseService {
    Clase guardar(PasarListaClaseRequest request, LocalDate fecha);

    // Sesiones pendientes de hoy
    List<Map<String, Object>> getSesionesPendientesHoy(Long profesorId, String filtroHoras, boolean quitarHechos);

    List<ClaseDto> getHistorialDeProfesor(Long profesorId);

    List<ClaseDto> getHistorialGlobal();
}
