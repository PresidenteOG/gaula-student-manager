package com.gaula.controller;

import com.gaula.domain.ProfesorDto;
import com.gaula.dto.profesor.CreateProfesorRequest;
import com.gaula.dto.profesor.UpdateProfesorRequest;
import com.gaula.service.profesor.ProfesorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

/**
 * Controlador REST de Profesores.
 */
@RestController
@RequestMapping("/api/profesores")
@RequiredArgsConstructor
@Tag(name = "Profesores", description = "Gestión de profesores y sustituciones")
public class ProfesorController {

    private final ProfesorService profesorService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar todos los profesores con paginación")
    public ResponseEntity<org.springframework.data.domain.Page<ProfesorDto>> findAll(
        @RequestParam(required = false) String busqueda,
        @RequestParam(required = false) String rol,
        @RequestParam(required = false) Long cursoId,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
        return ResponseEntity.ok(profesorService.findAllPaginated(busqueda, rol, cursoId, pageable));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Obtener profesor por ID")
    public ResponseEntity<ProfesorDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(profesorService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear un nuevo profesor (Admin)")
    public ResponseEntity<ProfesorDto> create(@Valid @RequestBody CreateProfesorRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(profesorService.create(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar datos del profesor (Admin)")
    public ResponseEntity<ProfesorDto> update(
        @PathVariable Long id,
        @Valid @RequestBody UpdateProfesorRequest request
    ) {
        return ResponseEntity.ok(profesorService.update(id, request));
    }

    @PatchMapping("/{id}/estado")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Cambiar el estado del profesor: ACTIVO, INACTIVO, DE_BAJA (Admin)")
    public ResponseEntity<ProfesorDto> cambiarEstado(
        @PathVariable Long id,
        @RequestParam String estado
    ) {
        return ResponseEntity.ok(profesorService.cambiarEstado(id, estado));
    }

    /**
     * Asigna o elimina el sustituto de un profesor de baja.
     * Si sustitutoId es null o 0, elimina la sustitución.
     */
    @PatchMapping("/{id}/sustituto")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Asignar sustituto a un profesor de baja (Admin)",
        description = "El profesor debe estar en estado INACTIVO. El sustituto debe estar ACTIVO. " +
                      "Para eliminar la sustitución, envía sustitutoId = null."
    )
    public ResponseEntity<ProfesorDto> asignarSustituto(
        @PathVariable Long id,
        @RequestParam(required = false) Long sustitutoId
    ) {
        return ResponseEntity.ok(profesorService.asignarSustituto(id, sustitutoId));
    }

    @PatchMapping("/{id}/password")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    @Operation(summary = "Cambiar contraseña del profesor")
    public ResponseEntity<Map<String, String>> cambiarPassword(
        @PathVariable Long id,
        @RequestBody ChangePasswordRequest request
    ) {
        profesorService.cambiarPassword(id, request.passwordNueva());
        return ResponseEntity.ok(Map.of("mensaje", "Contraseña actualizada correctamente"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un profesor (Admin)")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        profesorService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/dashboard")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")

    @Operation(summary = "Obtener métricas para el dashboard del profesor")
    public ResponseEntity<Map<String, Object>> getDashboard(@PathVariable Long id) {
        // En un caso real esto iría al Service
        return ResponseEntity.ok(profesorService.getDashboardStats(id));
    }

    /** Record auxiliar para body de requests especiales */
    public record ChangePasswordRequest(String passwordNueva) {}
}
