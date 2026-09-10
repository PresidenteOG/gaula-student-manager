package com.gaula.repository;

import com.gaula.entity.Evento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EventoRepository extends JpaRepository<Evento, Long> {
    List<Evento> findByCursoIdIsNull(); // Global events
    List<Evento> findByCursoId(Long cursoId);
    List<Evento> findByFecha(java.time.LocalDate fecha);
}
