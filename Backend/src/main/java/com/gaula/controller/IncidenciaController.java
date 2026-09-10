package com.gaula.controller;

import com.gaula.domain.IncidenciaDto;
import com.gaula.dto.incidencia.CreateIncidenciaRequest;
import com.gaula.service.incidencia.IncidenciaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/incidencias")
@RequiredArgsConstructor
@Tag(name = "Incidencias", description = "Gestión de incidencias disciplinarias")
public class IncidenciaController {

    private final IncidenciaService incidenciaService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todas las incidencias con paginación avanzada")
    public ResponseEntity<org.springframework.data.domain.Page<IncidenciaDto>> findAll(
        java.security.Principal principal,
        @RequestParam(required = false) Long alumnoId,
        @RequestParam(required = false) Long profesorId,
        @RequestParam(required = false) Long cursoId,
        @RequestParam(required = false) String estado,
        @RequestParam(required = false) String resolucion,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
        org.springframework.security.core.Authentication auth = (org.springframework.security.core.Authentication) principal;
        
        String role = auth.getAuthorities().stream()
            .map(a -> a.getAuthority())
            .findFirst().orElse("ROLE_STUDENT");

        return ResponseEntity.ok(incidenciaService.findAvanzado(principal.getName(), role, alumnoId, profesorId, cursoId, estado, resolucion, pageable));
    }


    @GetMapping("/alumno/{alumnoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar incidencias de un alumno")
    public ResponseEntity<List<IncidenciaDto>> findByAlumno(@PathVariable Long alumnoId) {
        return ResponseEntity.ok(incidenciaService.findByAlumnoId(alumnoId));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Crear una nueva incidencia")

    public ResponseEntity<IncidenciaDto> create(@Valid @RequestBody CreateIncidenciaRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(incidenciaService.create(request));
    }

    @PatchMapping("/{id}/estado")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Cambiar el estado de una incidencia")
    public ResponseEntity<IncidenciaDto> updateEstado(
        @PathVariable Long id,
        @RequestParam String estado,
        @RequestParam(required = false) String resolucion
    ) {
        return ResponseEntity.ok(incidenciaService.updateEstado(id, estado, resolucion));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una incidencia (Solo Admin)")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        incidenciaService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
