package com.gaula.controller;

import com.gaula.domain.AlumnoDto;
import com.gaula.domain.HorarioDto;
import com.gaula.dto.horario.CreateHorarioRequest;
import com.gaula.service.horario.HorarioService;

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
 * Controlador REST de Horario (sesiones del horario semanal).
 */
@RestController
@RequestMapping("/api/horarios")
@RequiredArgsConstructor
@Tag(name = "Horario", description = "Gestión del horario semanal de clases")
public class HorarioController {

    private final HorarioService horarioService;

    @GetMapping("/profesor/{profesorId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Horario completo de un profesor")
    public ResponseEntity<List<HorarioDto>> horarioProfesor(@PathVariable Long profesorId) {
        return ResponseEntity.ok(horarioService.findHorarioProfesor(profesorId));
    }

    @GetMapping("/alumno/{alumnoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Horario semanal completo de un alumno")
    public ResponseEntity<List<HorarioDto>> horarioAlumno(@PathVariable Long alumnoId) {
        return ResponseEntity.ok(horarioService.findHorarioAlumno(alumnoId));
    }

    @GetMapping("/materia/{materiaId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Todas las sesiones de una materia")
    public ResponseEntity<List<HorarioDto>> findByMateria(@PathVariable Long materiaId) {
        return ResponseEntity.ok(horarioService.findByMateriaId(materiaId));
    }

    @GetMapping("/curso/{cursoId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Todas las sesiones de un curso (Horario del curso)")
    public ResponseEntity<List<HorarioDto>> findByCurso(@PathVariable Long cursoId) {
        return ResponseEntity.ok(horarioService.findByCursoId(cursoId));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER', 'STUDENT')")
    @Operation(summary = "Obtener la información de esta sesión")
    public ResponseEntity<HorarioDto> findSesion(@PathVariable Long id) {
        return ResponseEntity.ok(horarioService.buscarSesion(id));
    }

    @GetMapping("/{id}/alumnos")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Listar alumnos matriculados en la materia de esta sesión")
    public ResponseEntity<List<AlumnoDto>> findAlumnosBySesion(@PathVariable Long id) {
        return ResponseEntity.ok(horarioService.findAlumnosBySesionId(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Crear una sesión en el horario")
    public ResponseEntity<HorarioDto> create(@Valid @RequestBody CreateHorarioRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(horarioService.create(request));
    }

    @PatchMapping("/{id}/hide")
    @PreAuthorize("hasAnyRole('ADMIN', 'TEACHER')")
    @Operation(summary = "Ocultar una sesión del horario (Soft Delete)")
    public ResponseEntity<Void> hide(@PathVariable Long id) {
        horarioService.hide(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/proxima-clase/{profesorId}")
    @PreAuthorize("hasRole('ADMIN') or #profesorId == authentication.principal.id")
    @Operation(summary = "Obtener la próxima sesión del profesor para hoy")
    public ResponseEntity<HorarioDto> findProximaClase(@PathVariable Long profesorId) {
        return ResponseEntity.ok(horarioService.findProximaSesion(profesorId));
    }
}
