package com.gaula.controller;

import com.gaula.domain.AlumnoDto;
import com.gaula.dto.alumno.CreateAlumnoRequest;
import com.gaula.dto.alumno.UpdateAlumnoRequest;
import com.gaula.service.alumno.AlumnoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controlador REST de Alumnos.
 */
@RestController
@RequestMapping("/api/alumnos")
@RequiredArgsConstructor
@Tag(name = "Alumnos", description = "Gestión de alumnos matriculados")
public class AlumnoController {

    private final AlumnoService alumnoService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar todos los alumnos con paginación")
    public ResponseEntity<org.springframework.data.domain.Page<AlumnoDto>> findAll(
        @RequestParam(required = false) String busqueda,
        @RequestParam(required = false) Long cursoId,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
        return ResponseEntity.ok(alumnoService.findAllPaginated(busqueda, cursoId, pageable));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER') or #id == authentication.principal.id")
    @Operation(summary = "Obtener alumno por ID")
    public ResponseEntity<AlumnoDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(alumnoService.findById(id));
    }

    @GetMapping("/curso/{cursoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar alumnos activos de un curso")
    public ResponseEntity<List<AlumnoDto>> findByCurso(@PathVariable Long cursoId) {
        return ResponseEntity.ok(alumnoService.findByCursoId(cursoId));
    }

    @GetMapping("/sin-matricular")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar alumnos sin curso asignado (para selector de matriculación)")
    public ResponseEntity<List<AlumnoDto>> getAlumnosSinMatricular() {
        return ResponseEntity.ok(alumnoService.getAlumnosSinMatricular());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear un nuevo alumno (Admin)")
    public ResponseEntity<AlumnoDto> create(@Valid @RequestBody CreateAlumnoRequest request) {
        AlumnoDto creado = alumnoService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(creado);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar datos del alumno (Admin)")
    public ResponseEntity<AlumnoDto> update(
        @PathVariable Long id,
        @Valid @RequestBody UpdateAlumnoRequest request
    ) {
        return ResponseEntity.ok(alumnoService.update(id, request));
    }

    @PatchMapping("/{id}/estado")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Cambiar el estado del alumno: ACTIVO, INACTIVO, DE_BAJA (Admin)")
    public ResponseEntity<AlumnoDto> cambiarEstado(
        @PathVariable Long id,
        @RequestParam String estado
    ) {
        return ResponseEntity.ok(alumnoService.cambiarEstado(id, estado));
    }

    @PutMapping("/{id}/materias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar lista de materias matriculadas del alumno (Admin)")
    public ResponseEntity<AlumnoDto> actualizarMaterias(
        @PathVariable Long id,
        @RequestBody List<Long> materiaIds
    ) {
        return ResponseEntity.ok(alumnoService.actualizarMaterias(id, materiaIds));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un alumno (Admin)")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        alumnoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/password")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")

    @Operation(summary = "Cambiar contraseña del alumno")
    public ResponseEntity<Map<String, String>> cambiarPassword(
        @PathVariable Long id,
        @RequestBody ChangePasswordRequest request
    ) {
        alumnoService.cambiarPassword(id, request.passwordNueva());
        return ResponseEntity.ok(Map.of("mensaje", "Contraseña actualizada correctamente"));
    }

    /** Records auxiliares para body de requests especiales */
    public record ChangePasswordRequest(String passwordNueva) {}
}
