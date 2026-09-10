package com.gaula.controller;

import com.gaula.domain.CursoPlantillaDto;
import com.gaula.domain.MateriaPlantillaDto;
import com.gaula.dto.plantilla.CreateMateriaPlantillaRequest;
import com.gaula.service.plantilla_curso.CursoPlantillaService;
import com.gaula.service.plantilla_materia.MateriaPlantillaService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador REST de Cursos (grupos clase) y sus Materias.
 *
 * Los endpoints de Materia se agrupan aquí porque la materia
 * es un concepto ligado al curso y resulta más natural accederlo
 * como subrecurso: /api/cursos/{id}/materias
 */
@RestController
@RequestMapping("/api/curso-plantillas")
@RequiredArgsConstructor
@Tag(name = "Plantillas de Cursos y Materias", description = "Gestión de plantillas curso y materias plantillas")
public class CursoPlantillaController {

    private final CursoPlantillaService   cursoService;
    private final MateriaPlantillaService materiaService;

    // ──────────── CURSOS ────────────

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todos los cursos plantilla")
    public ResponseEntity<List<CursoPlantillaDto>> findAll() {
        return ResponseEntity.ok(cursoService.findAll());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Obtener un curso plantilla por ID con sus materias plantilla")
    public ResponseEntity<CursoPlantillaDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(cursoService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear un nuevo curso plantilla (Admin)")
    public ResponseEntity<CursoPlantillaDto> create(@Valid @RequestBody CursoPlantillaDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(cursoService.create(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar un curso plantilla (Admin)")
    public ResponseEntity<CursoPlantillaDto> update(
        @PathVariable Long id,
        @Valid @RequestBody CursoPlantillaDto request
    ) {
        return ResponseEntity.ok(cursoService.update(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un grupo curso plantilla (y sus materias consequentes) (Admin)")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        cursoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // ──────────── MATERIAS (subrecurso de Curso) ────────────

    @GetMapping("/{cursoId}/materias")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todas las materias plantilla de un curso plantilla")
    public ResponseEntity<List<MateriaPlantillaDto>> getMateriasByCurso(@PathVariable Long cursoId) {
        return ResponseEntity.ok(materiaService.findByCursoPlantillaId(cursoId));
    }

    @PostMapping("/{cursoId}/materias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear una nueva materia plantilla en un curso plantilla (Admin)")
    public ResponseEntity<MateriaPlantillaDto> createMateria(
        @PathVariable Long cursoPlantillaId,
        @Valid @RequestBody CreateMateriaPlantillaRequest request
    ) {
        // Garantizar que el cursoId del path coincide con el del body
        CreateMateriaPlantillaRequest req = new CreateMateriaPlantillaRequest(
            request.codigo(), request.nombre(), request.horasTotales(), cursoPlantillaId
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(materiaService.create(req));
    }

    @PutMapping("/materias/{materiaId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar una materia plantilla (Admin)")
    public ResponseEntity<MateriaPlantillaDto> updateMateria(
        @PathVariable Long materiaId,
        @Valid @RequestBody CreateMateriaPlantillaRequest request
    ) {
        return ResponseEntity.ok(materiaService.update(materiaId, request));
    }

    @DeleteMapping("/materias/{materiaId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una materia plantilla (Admin)")
    public ResponseEntity<Void> deleteMateria(@PathVariable Long materiaId) {
        materiaService.delete(materiaId);
        return ResponseEntity.noContent().build();
    }
}
