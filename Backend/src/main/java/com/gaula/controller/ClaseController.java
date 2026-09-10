package com.gaula.controller;

import com.gaula.domain.ClaseDto;
import com.gaula.dto.pasar_lista.PasarListaClaseRequest;
import com.gaula.entity.Clase;
import com.gaula.service.asistencia.AsistenciaService;
import com.gaula.service.clase.ClaseService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/clases")
@RequiredArgsConstructor
@Tag(name = "Asistencia", description = "Control de presencia de alumnos en clases")
public class ClaseController {

    private final ClaseService claseService;
    private final AsistenciaService asistenciaService;

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Registrar asistencia para una clase")
    public ResponseEntity<Void> guardarListaClase(
        @RequestBody
            PasarListaClaseRequest request,
        @RequestParam(required = false)
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecha
    ) {
        if (fecha == null) {
            fecha = LocalDate.now();
        }

        Clase clase = claseService.guardar(request, fecha);
        asistenciaService.guardarAsistenciaMasiva(clase, fecha, request.faltas());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/pendientes/{profesorId}")
    @PreAuthorize("hasRole('ADMIN') or #profesorId == authentication.principal.id")
    @Operation(summary = "Obtener sesiones de hoy que aún no tienen pasada de lista")
    public ResponseEntity<List<Map<String, Object>>> getPendientes(
        @PathVariable Long profesorId,
        @RequestParam(required = false, defaultValue = "activas") String filtroHoras,
        @RequestParam(required = false, defaultValue = "true") Boolean quitarHechos
    ) {
        return ResponseEntity.ok(claseService.getSesionesPendientesHoy(profesorId, filtroHoras, quitarHechos));
    }

    @GetMapping("/historial/profesor/{profesorId}")
    @PreAuthorize("hasRole('ADMIN') or #profesorId == authentication.principal.id")
    @Operation(summary = "Obtener historial de clases de un profesor")
    public ResponseEntity<List<ClaseDto>> getHistorialProfesor(@PathVariable Long profesorId) {
        return ResponseEntity.ok(claseService.getHistorialDeProfesor(profesorId));
    }

    @GetMapping("/historial/global")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener historial global de asistencia (Solo Admin)")
    public ResponseEntity<List<ClaseDto>> getHistorialGlobal() {
        return ResponseEntity.ok(claseService.getHistorialGlobal());
    }
}
