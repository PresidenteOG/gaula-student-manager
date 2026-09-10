package com.gaula.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "festivo", uniqueConstraints = {
    @UniqueConstraint(name = "uq_festivo_fecha_nombre", columnNames = {"fecha", "nombre"})
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Festivo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(length = 200)
    private String nombreLocal;

    @Column(nullable = false)
    private boolean esNacional;

    @ElementCollection(fetch = jakarta.persistence.FetchType.EAGER)
    @CollectionTable(name = "festivo_provincia", joinColumns = @JoinColumn(name = "festivo_id"))
    @Column(name = "provincia_codigo", length = 10)
    private List<String> provincias;

    @Column(nullable = false)
    private Integer anio;
}
