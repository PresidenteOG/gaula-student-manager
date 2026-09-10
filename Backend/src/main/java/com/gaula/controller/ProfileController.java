package com.gaula.controller;

import com.gaula.domain.AlumnoDto;
import com.gaula.domain.ProfesorDto;
import com.gaula.dto.perfil.UpdatePerfilRequest;
import com.gaula.service.alumno.AlumnoService;
import com.gaula.service.file.FileStorageService;
import com.gaula.service.profesor.ProfesorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
@Tag(name = "Profile", description = "Gestión del perfil del usuario autenticado")
public class ProfileController {

    private final AlumnoService alumnoService;
    private final ProfesorService profesorService;
    private final FileStorageService fileStorageService;

    @GetMapping
    @Operation(summary = "Obtener datos del perfil del usuario actual")
    public ResponseEntity<?> getProfile(Principal principal) {
        String username = principal.getName();
        
        try {
            ProfesorDto profesor = profesorService.findByUsername(username);
            return ResponseEntity.ok(profesor);
        } catch (Exception e) {
            try {
                AlumnoDto alumno = alumnoService.findByUsername(username);
                return ResponseEntity.ok(alumno);
            } catch (Exception e2) {
                return ResponseEntity.status(404).body(Map.of("error", "Perfil no encontrado"));
            }
        }
    }

    @PutMapping
    @Operation(summary = "Actualizar datos del perfil propio del usuario autenticado")
    public ResponseEntity<?> updatePerfil(
            @Valid @RequestBody UpdatePerfilRequest req,
            Principal principal,
            Authentication auth) {

        String username = principal.getName();
        boolean isTeacher = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_TEACHER"));

        return ResponseEntity.ok(isTeacher
                ? profesorService.updatePerfilPropio(username, req)
                : alumnoService.updatePerfilPropio(username, req));
    }

    @PostMapping("/avatar")
    @Operation(summary = "Subir foto de perfil")
    public ResponseEntity<?> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            Principal principal,
            Authentication auth) {
        
        String username = principal.getName();
        String currentAvatar = null;
        boolean isTeacher = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_TEACHER"));

        if (isTeacher) {
            currentAvatar = profesorService.findByUsername(username).avatar();
        } else {
            currentAvatar = alumnoService.findByUsername(username).avatar();
        }

        // Si el avatar actual es una foto (no un emoji), la borramos
        if (currentAvatar != null && !isEmoji(currentAvatar)) {
            fileStorageService.deleteFile(currentAvatar, "profiles");
        }

        // Guardamos la nueva foto
        String fileName = fileStorageService.storeFile(file, "profiles");

        // Actualizamos en BD
        if (isTeacher) {
            profesorService.updateAvatar(username, fileName);
        } else {
            alumnoService.updateAvatar(username, fileName);
        }

        return ResponseEntity.ok(Map.of(
            "mensaje", "Foto de perfil actualizada",
            "avatar", fileName
        ));
    }

    @DeleteMapping("/avatar")
    @Operation(summary = "Eliminar foto de perfil (vuelve al avatar por defecto)")
    public ResponseEntity<?> deleteAvatar(
            Principal principal,
            Authentication auth) {

        String username = principal.getName();
        boolean isTeacher = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_TEACHER"));

        String currentAvatar;
        if (isTeacher) {
            currentAvatar = profesorService.findByUsername(username).avatar();
        } else {
            currentAvatar = alumnoService.findByUsername(username).avatar();
        }

        // Borrar archivo físico si existe y no es un emoji/avatar por defecto
        if (currentAvatar != null && !isEmoji(currentAvatar)) {
            fileStorageService.deleteFile(currentAvatar, "profiles");
        }

        // Limpiar campo en BD (null = avatar por defecto)
        if (isTeacher) {
            profesorService.updateAvatar(username, null);
        } else {
            alumnoService.updateAvatar(username, null);
        }

        return ResponseEntity.ok(Map.of("mensaje", "Foto de perfil eliminada correctamente"));
    }

    @PatchMapping("/theme")
    @Operation(summary = "Actualizar preferencia de tema (light/dark)")
    public ResponseEntity<?> updateTheme(
            @RequestParam("theme") String theme,
            Principal principal,
            Authentication auth) {
        
        String username = principal.getName();
        boolean isTeacher = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_TEACHER"));

        if (isTeacher) {
            profesorService.updateTheme(username, theme);
        } else {
            alumnoService.updateTheme(username, theme);
        }

        return ResponseEntity.ok(Map.of("mensaje", "Tema actualizado correctamente", "theme", theme));
    }

    private boolean isEmoji(String avatar) {
        // Un heurístico simple: si es muy corto o no tiene punto (extensión), asumimos emoji
        return avatar.length() < 10 || !avatar.contains(".");
    }
}
