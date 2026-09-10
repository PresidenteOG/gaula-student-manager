package com.gaula.service.notificacion;

import com.gaula.dto.common.NotificationDto;
import com.gaula.entity.Incidencia;
import com.gaula.repository.IncidenciaRepository;
import com.gaula.security.UserDetailsServiceImpl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Implementación del servicio de Cursos (grupos clase).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class NotificacionServiceImpl implements NotificacionService {

    private final IncidenciaRepository incidenciaRepo;

    @Override
    @Transactional(readOnly = true)
    public List<NotificationDto> getNotificaciones(UserDetailsServiceImpl.GaulaUserPrincipal principal) {
        boolean esAdmin = principal.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        List<Incidencia> incidencias;
        if (esAdmin) {
            incidencias = incidenciaRepo.findByEstadoOrderByFechaIncidenciaDesc(Incidencia.EstadoIncidencia.ABIERTA);
        } else {
            incidencias = incidenciaRepo.findByEstadoOrderByFechaIncidenciaDesc(Incidencia.EstadoIncidencia.ABIERTA)
                .stream()
                .filter(inc -> inc.getProfesor().getId().equals(principal.getId()) || 
                             (inc.getAlumno().getCurso() != null && inc.getAlumno().getCurso().getTutor() != null && 
                              inc.getAlumno().getCurso().getTutor().getId().equals(principal.getId())))
                .toList();
        }

        return incidencias.stream()
            .map(inc -> new NotificationDto(
                inc.getId(), 
                inc.getTitulo(),
                "Incidencia de " + inc.getAlumno().getNombre(), 
                inc.getFechaIncidencia().toString(),
                "INCIDENCIA",
                false
            ))
            .toList();
    }

    @Override
    @Transactional
    public void deleteNotificacion(Long id) {
        incidenciaRepo.findById(id).ifPresent(inc -> {
            inc.setEstado(Incidencia.EstadoIncidencia.EN_PROCESO);
            incidenciaRepo.save(inc);
        });
    }

    @Override
    @Transactional
    public void patchNotificacionesLeidasAll(UserDetailsServiceImpl.GaulaUserPrincipal principal) {
        boolean esAdmin = principal.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        List<Incidencia> incidencias;
        if (esAdmin) {
            incidencias = incidenciaRepo.findByEstadoOrderByFechaIncidenciaDesc(Incidencia.EstadoIncidencia.ABIERTA);
        } else {
            incidencias = incidenciaRepo.findByEstadoOrderByFechaIncidenciaDesc(Incidencia.EstadoIncidencia.ABIERTA)
                .stream()
                .filter(inc -> inc.getProfesor().getId().equals(principal.getId()) || 
                             (inc.getAlumno().getCurso() != null && inc.getAlumno().getCurso().getTutor() != null && 
                              inc.getAlumno().getCurso().getTutor().getId().equals(principal.getId())))
                .toList();
        }

        incidencias.forEach(inc -> {
            inc.setEstado(Incidencia.EstadoIncidencia.EN_PROCESO);
            incidenciaRepo.save(inc);
        });
    }
}
