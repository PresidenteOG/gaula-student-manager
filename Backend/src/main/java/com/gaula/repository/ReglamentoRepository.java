package com.gaula.repository;

import com.gaula.entity.Reglamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReglamentoRepository extends JpaRepository<Reglamento, Long> {
    Optional<Reglamento> findByActivoTrue();
    List<Reglamento> findAllByOrderByFechaCreacionDesc();
}
