package com.gaula.controller;

import com.gaula.domain.CursoDto;
import com.gaula.domain.MateriaDto;
import com.gaula.dto.curso.CreateCursoRequest;
import com.gaula.dto.materia.CreateMateriaRequest;
import com.gaula.service.curso.CursoService;
import com.gaula.service.materia.MateriaService;

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
@RequestMapping("/api/cursos")
@RequiredArgsConstructor
@Tag(name = "Cursos y Materias", description = "Gestión de grupos clase, materias instanciadas y tutorías")
public class CursoController {

    private final CursoService   cursoService;
    private final MateriaService materiaService;

    // ──────────── CURSOS ────────────

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todos los cursos activos del año escolar activo")
    public ResponseEntity<List<CursoDto>> findAllActivos() {
        return ResponseEntity.ok(cursoService.findAllActivos());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Obtener un curso por ID con sus materias y tutor")
    public ResponseEntity<CursoDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(cursoService.findById(id));
    }

    @GetMapping("/escolar/{cursoEscolarId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar todos los cursos de un año escolar")
    public ResponseEntity<List<CursoDto>> findByEscolar(@PathVariable Long cursoEscolarId) {
        return ResponseEntity.ok(cursoService.findByCursoEscolarId(cursoEscolarId));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear un nuevo grupo clase (Admin)")
    public ResponseEntity<CursoDto> create(@Valid @RequestBody CreateCursoRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(cursoService.create(request));
    }

    @PatchMapping("/{id}/tutor/{profesorId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Asignar o cambiar el tutor de un curso (Admin)")
    public ResponseEntity<CursoDto> asignarTutor(
        @PathVariable Long id,
        @PathVariable Long profesorId
    ) {
        return ResponseEntity.ok(cursoService.asignarTutor(id, profesorId));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un grupo clase (solo si no tiene alumnos) (Admin)")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        cursoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // ──────────── MATERIAS (subrecurso de Curso) ────────────

    @GetMapping("/{cursoId}/materias")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Listar todas las materias de un curso")
    public ResponseEntity<List<MateriaDto>> getMateriasByCurso(@PathVariable Long cursoId) {
        return ResponseEntity.ok(materiaService.findByCursoId(cursoId));
    }

    @PostMapping("/{cursoId}/materias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear una nueva materia en un curso (Admin)")
    public ResponseEntity<MateriaDto> createMateria(
        @PathVariable Long cursoId,
        @Valid @RequestBody CreateMateriaRequest request
    ) {
        // Garantizar que el cursoId del path coincide con el del body
        CreateMateriaRequest req = new CreateMateriaRequest(
            request.nombre(), request.codigo(), request.horasTotales(),
            cursoId, request.materiaPlantillaId()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(materiaService.create(req));
    }

    @PutMapping("/materias/{materiaId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar una materia (Admin)")
    public ResponseEntity<MateriaDto> updateMateria(
        @PathVariable Long materiaId,
        @Valid @RequestBody CreateMateriaRequest request
    ) {
        return ResponseEntity.ok(materiaService.update(materiaId, request));
    }

    @DeleteMapping("/materias/{materiaId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una materia y sus clases (Admin)")
    public ResponseEntity<Void> deleteMateria(@PathVariable Long materiaId) {
        materiaService.delete(materiaId);
        return ResponseEntity.noContent().build();
    }
}
