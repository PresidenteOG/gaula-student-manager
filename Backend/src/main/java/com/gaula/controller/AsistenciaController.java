package com.gaula.controller;

import com.gaula.domain.AsistenciaDto;
import com.gaula.service.asistencia.AsistenciaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/asistencia")
@RequiredArgsConstructor
@Tag(name = "Asistencia", description = "Control de presencia de alumnos en clases")
public class AsistenciaController {

    private final AsistenciaService asistenciaService;

    @GetMapping("/sesion/{sessionId}/{fecha}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Obtener asistencia de una sesión de horario en una fecha (alternativa de usar clase id)")
    public ResponseEntity<List<AsistenciaDto>> getSesionDetalle(
        @PathVariable Long sessionId,
        @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha
    ) {
        return ResponseEntity.ok(asistenciaService.findBySessionIdAndFecha(sessionId, fecha));
    }


    @GetMapping("/alumno/{alumnoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER') or #alumnoId == authentication.principal.id")
    @Operation(summary = "Obtener historial de asistencia de un alumno")
    public ResponseEntity<List<AsistenciaDto>> findByAlumno(@PathVariable Long alumnoId) {
        return ResponseEntity.ok(asistenciaService.findByAlumnoId(alumnoId));
    }

    @GetMapping("/resumen/{alumnoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER') or #alumnoId == authentication.principal.id")
    @Operation(summary = "Resumen de asistencia del alumno: porcentaje, horas faltadas, totales")
    public ResponseEntity<Map<String, Object>> resumenAlumno(@PathVariable Long alumnoId) {
        return ResponseEntity.ok(asistenciaService.calcularResumenAlumno(alumnoId));
    }

    @DeleteMapping("/{asistenciaId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Eliminar un registro de asistencia (solo tutor del curso o admin)")
    public ResponseEntity<Void> eliminarAsistencia(
            @PathVariable Long asistenciaId,
            Authentication authentication) {
        Long profesorId = ((com.gaula.security.UserDetailsServiceImpl.GaulaUserPrincipal) authentication.getPrincipal()).getId();
        asistenciaService.eliminarAsistencia(asistenciaId, profesorId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{asistenciaId}/justificar")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Justificar una falta (solo tutor del curso o admin)")
    public ResponseEntity<Void> justificarAsistencia(
            @PathVariable Long asistenciaId,
            @RequestParam(required = false, defaultValue = "") String observaciones,
            Authentication authentication) {
        Long profesorId = ((com.gaula.security.UserDetailsServiceImpl.GaulaUserPrincipal) authentication.getPrincipal()).getId();
        asistenciaService.justificarAsistencia(asistenciaId, observaciones, profesorId);
        return ResponseEntity.noContent().build();
    }
}
